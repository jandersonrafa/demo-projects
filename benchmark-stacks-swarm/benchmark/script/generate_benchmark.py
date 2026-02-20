#!/usr/bin/env python3
"""
Benchmark Report Generator

This script generates a comprehensive benchmark report by querying Prometheus metrics
for K6 load tests, Nomad infrastructure, and Traefik proxy performance.

Prerequisites:
    - Python 3.7+
    - Prometheus running at http://localhost:9091
    - K6 test reports in JSON format (summary-*.json files)

Usage:
    python3 generate_benchmark.py

Configuration:
    Edit the constants below to customize:
    - PROMETHEUS_URL: Prometheus server address
    - REPORTS_ROOT_DIR: Directory containing K6 JSON reports
    - LOAD_SECONDS: Duration of the load phase (default: 600s = 10 minutes)

Output:
    - benchmark-gerado.md: Markdown file with three tables (Nomad, K6, Traefik metrics)
"""

import glob
import re
import os
import requests
import datetime
from pathlib import Path
from statistics import mean

# ============================================================================
# CONFIGURATION
# ============================================================================

# Diretório onde este arquivo .py está localizado
# Diretório do arquivo atual
BASE_DIR = Path(__file__).resolve().parent

# Prometheus server URL
PROMETHEUS_URL = os.getenv('PROMETHEUS_URL', 'http://localhost:9091')

# Directory containing K6 benchmark reports (JSON files)
REPORTS_ROOT_DIR = Path(
    os.getenv("REPORTS_ROOT_DIR", BASE_DIR / "../reports")
).resolve()

# Load test duration in seconds (excludes warmup phase)
LOAD_SECONDS = 600  # 10 minutes

# ============================================================================
# STACK CONFIGURATION
# ============================================================================
# Maps port numbers (as strings) to stack names, Nomad job names, and Traefik service names
STACK_MAP = {
    '9101': {'name': 'Java MVC VT', 'job': 'java-mvc-vt', 'traefik_service': 'mvc-vt-monolith'},
    '9102': {'name': 'Java WebFlux', 'job': 'java-webflux', 'traefik_service': 'webflux-monolith'},
    '9103': {'name': 'Node.js (Express)', 'job': 'node-nestjs-express', 'traefik_service': 'nestjs-express-monolith'},
    '9104': {'name': '.NET Core', 'job': 'dotnet', 'traefik_service': 'dotnet-monolith'},
    '9105': {'name': 'Golang Gin', 'job': 'golang', 'traefik_service': 'golang-monolith'},
    '9106': {'name': 'PHP FPM', 'job': 'php-laravel-fpm', 'traefik_service': 'fpm-monolith'},
    '9107': {'name': 'PHP Octane', 'job': 'php-laravel-octane', 'traefik_service': 'octane-monolith'},
    '9108': {'name': 'Python', 'job': 'python-fastapi', 'traefik_service': 'python-monolith'},
    '9109': {'name': 'Rust Axum', 'job': 'rust', 'traefik_service': 'rust-monolith'},
    '9110': {'name': 'Java Quarkus', 'job': 'java-quarkus', 'traefik_service': 'quarkus-monolith'},
}

# ============================================================================
# PROMETHEUS QUERY FUNCTIONS
# ============================================================================

def query_prometheus(query, time=None):
    """
    Execute an instant Prometheus query.
    
    Args:
        query (str): PromQL query string
        time (float, optional): Unix timestamp for the query evaluation time
        
    Returns:
        list: Query results or empty list on error
    """
    try:
        url = f"{PROMETHEUS_URL}/api/v1/query"
        params = {'query': query}
        if time:
            params['time'] = time
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        if data['status'] == 'success':
            return data['data']['result']
        else:
            print(f"Prometheus query error: {data.get('error', 'Unknown error')}")
            return []
    except Exception as e:
        print(f"Exception querying Prometheus: {e}")
        return []

def query_prometheus_range(query, start, end, step='15s'):
    """
    Execute a range Prometheus query.
    
    Args:
        query (str): PromQL query string
        start (float): Start time (Unix timestamp)
        end (float): End time (Unix timestamp)
        step (str): Query resolution step (default: 15s)
        
    Returns:
        list: Query results or empty list on error
    """
    try:
        url = f"{PROMETHEUS_URL}/api/v1/query_range"
        params = {
            'query': query,
            'start': start,
            'end': end,
            'step': step
        }
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        if data['status'] == 'success':
            return data['data']['result']
        else:
            print(f"Prometheus range query error: {data.get('error', 'Unknown error')}")
            return []
    except Exception as e:
        print(f"Exception querying Prometheus range: {e}")
        return []

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def get_timestamp_from_filename(filename):
    """
    Extract timestamp from K6 report filename.
    
    Expected format: summary-YYYY-MM-DD_HH-MM-SS-BR-PORT.json
    Example: summary-2026-02-11_10-06-08-BR-8101.json
    
    Args:
        filename (str): K6 report filename
        
    Returns:
        datetime: Parsed datetime object or None if parsing fails
    """
    match = re.search(r'summary-(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})', filename)
    if match:
        date_str = match.group(1)
        parts = date_str.split('_')
        date_part = parts[0]
        time_part = parts[1].replace('-', ':')
        dt_str = f"{date_part}T{time_part}"
        try:
            dt = datetime.datetime.fromisoformat(dt_str)
            return dt
        except ValueError:
            return None
    return None

# ============================================================================
# MAIN PROCESSING FUNCTION
# ============================================================================

def main():
    """
    Main function to process K6 reports and generate benchmark metrics.
    
    Process:
        1. Find all K6 JSON report files
        2. Extract test metadata (stack, port, timestamps)
        3. Query Prometheus for Nomad, K6, and Traefik metrics
        4. Generate benchmark-gerado.md with three tables
    """
    print(f"Searching for reports in {REPORTS_ROOT_DIR}...")
    files = glob.glob(os.path.join(REPORTS_ROOT_DIR, '**', '*.json'), recursive=True)
    
    results_data = []

    print(f"Found {len(files)} JSON files.")

    for file_path in files:
        # Extract port number from filename (e.g., -BR-9103.json)
        match = re.search(r'-BR-(\d+)\.json$', file_path)
        if not match:
            continue
        
        port = match.group(1)  # Keep as string to match STACK_MAP keys
        if port not in STACK_MAP:
            print(f"Skipping unknown port: {port}")
            continue
        
        stack_info = STACK_MAP[port]
        stack_name = stack_info['name']
        nomad_job = stack_info['job']
        traefik_service = stack_info.get('traefik_service')
        
        # Extract test end time from filename
        test_end_dt = get_timestamp_from_filename(os.path.basename(file_path))
        if not test_end_dt:
            print(f"Could not parse timestamp from {file_path}")
            continue
        
        # Calculate load phase time window (last 10 minutes of test)
        prom_end_ts = test_end_dt.timestamp()
        prom_start_ts = prom_end_ts - LOAD_SECONDS
        
        start_time_str = datetime.datetime.fromtimestamp(prom_start_ts).strftime('%H:%M:%S')
        end_time_str = datetime.datetime.fromtimestamp(prom_end_ts).strftime('%H:%M:%S')
        date_str = test_end_dt.strftime('%d/%m/%Y')
        
        print(f"Processing {stack_name} ({port}) - {start_time_str} to {end_time_str}")
        
        # ====================================================================
        # 1. K6 METRICS (from Prometheus)
        # ====================================================================
        
        # Total requests (excluding warmup) - filter by port
        q_k6_reqs = f"sum(increase(k6_http_reqs_total{{scenario=~'load_.*{port}'}}[{LOAD_SECONDS}s]))"
        prom_k6_reqs_data = query_prometheus(q_k6_reqs, time=prom_end_ts)
        k6_reqs = float(prom_k6_reqs_data[0]['value'][1]) if prom_k6_reqs_data else 0

        # HTTP errors (4xx, 5xx)
        q_k6_errors = f"sum(increase(k6_http_reqs_total{{scenario=~'load_.*{port}', status=~'[45]..'}}[{LOAD_SECONDS}s]))"
        prom_k6_errs_data = query_prometheus(q_k6_errors, time=prom_end_ts)
        http_errors = float(prom_k6_errs_data[0]['value'][1]) if prom_k6_errs_data else 0
        
        # Dropped iterations
        q_dropped = f"sum(increase(k6_dropped_iterations_total{{scenario=~'load_.*{port}'}}[{LOAD_SECONDS}s]))"
        prom_dropped_data = query_prometheus(q_dropped, time=prom_end_ts)
        dropped_iterations = float(prom_dropped_data[0]['value'][1]) if prom_dropped_data else 0
        
        k6_errors = http_errors + dropped_iterations
        
        # Success rate
        total_attempts = k6_reqs + dropped_iterations
        k6_success_rate = ((k6_reqs - http_errors) / total_attempts * 100) if total_attempts > 0 else 0

        # RPS (derived from total requests)
        k6_rps_avg = k6_reqs / LOAD_SECONDS
        
        # P95 and Average latency (grouped by method: GET/POST) - filter by port
        # Uses last_over_time to get final values, then averages across methods
        q_k6_p95 = f"avg by (method) (last_over_time(k6_http_req_duration_p95{{scenario=~'load_.*{port}'}}[{LOAD_SECONDS}s]))"
        prom_k6_p95_data = query_prometheus(q_k6_p95, time=prom_end_ts)
        if prom_k6_p95_data:
            vals = [float(x['value'][1]) for x in prom_k6_p95_data]
            k6_p95_avg = mean(vals) * 1000  # Convert to milliseconds
        else:
            k6_p95_avg = 0
        
        q_k6_avg = f"avg by (method) (last_over_time(k6_http_req_duration_avg{{scenario=~'load_.*{port}'}}[{LOAD_SECONDS}s]))"
        prom_k6_avg_data = query_prometheus(q_k6_avg, time=prom_end_ts)
        if prom_k6_avg_data:
             vals = [float(x['value'][1]) for x in prom_k6_avg_data]
             k6_avg_mean = mean(vals) * 1000  # Convert to milliseconds
        else:
             k6_avg_mean = 0

        # ====================================================================
        # 2. NOMAD METRICS (from Prometheus)
        # ====================================================================
        
        # Instance count (unique allocation IDs)
        q_instances = f"count(count(nomad_client_allocs_cpu_total_ticks{{exported_job='{nomad_job}'}}) by (alloc_id))"
        prom_inst_data = query_prometheus(q_instances, time=prom_end_ts)
        nomad_instances = int(float(prom_inst_data[0]['value'][1])) if prom_inst_data else 0
        
        # CPU allocation (MHz)
        q_cpu_alloc = f"sum(nomad_client_allocs_cpu_allocated{{exported_job='{nomad_job}'}})"
        prom_cpu_alloc_data = query_prometheus(q_cpu_alloc, time=prom_end_ts)
        nomad_cpu_alloc = float(prom_cpu_alloc_data[0]['value'][1]) if prom_cpu_alloc_data else 0
        
        # CPU usage (average and max over time)
        q_cpu_usage_gauge = f"sum(nomad_client_allocs_cpu_total_ticks{{exported_job='{nomad_job}'}})"
        prom_cpu_usage_data = query_prometheus_range(q_cpu_usage_gauge, prom_start_ts, prom_end_ts, step='15s')
        cpu_usage_vals = [float(x[1]) for r in prom_cpu_usage_data for x in r['values']]
        nomad_cpu_avg = mean(cpu_usage_vals) if cpu_usage_vals else 0
        nomad_cpu_max = max(cpu_usage_vals) if cpu_usage_vals else 0
        
        # Memory allocation (bytes)
        q_mem_alloc = f"sum(nomad_client_allocs_memory_allocated{{exported_job='{nomad_job}'}})"
        prom_mem_alloc_data = query_prometheus(q_mem_alloc, time=prom_end_ts)
        nomad_mem_alloc = float(prom_mem_alloc_data[0]['value'][1]) if prom_mem_alloc_data else 0
        
        # Memory usage (average and max over time)
        q_mem_usage = f"sum(nomad_client_allocs_memory_usage{{exported_job='{nomad_job}'}})"
        prom_mem_usage_data = query_prometheus_range(q_mem_usage, prom_start_ts, prom_end_ts, step='15s')
        mem_usage_vals = [float(x[1]) for r in prom_mem_usage_data for x in r['values']]
        nomad_mem_avg = mean(mem_usage_vals) if mem_usage_vals else 0
        nomad_mem_max = max(mem_usage_vals) if mem_usage_vals else 0

        # ====================================================================
        # 3. TRAEFIK METRICS (from Prometheus)
        # ====================================================================
        
        traefik_reqs = 0
        traefik_errors = 0
        traefik_rps_avg = 0
        traefik_p95 = 0
        traefik_avg = 0
        traefik_success_pct = 0

        if traefik_service:
            t_service_regex = f"{traefik_service}.*"

            # Total requests (2xx, 3xx)
            q_traefik_reqs = f"sum(increase(traefik_service_requests_total{{service=~'{t_service_regex}', code=~'[23]..'}}[{LOAD_SECONDS}s]))"
            prom_treqs_data = query_prometheus(q_traefik_reqs, time=prom_end_ts)
            if prom_treqs_data:
                traefik_reqs = float(prom_treqs_data[0]['value'][1])

            # Errors (4xx, 5xx)
            q_traefik_errs = f"sum(increase(traefik_service_requests_total{{service=~'{t_service_regex}', code=~'[45]..'}}[{LOAD_SECONDS}s]))"
            prom_terrs_data = query_prometheus(q_traefik_errs, time=prom_end_ts)
            if prom_terrs_data:
                traefik_errors = float(prom_terrs_data[0]['value'][1])

            # RPS (derived from total)
            traefik_rps_avg = traefik_reqs / LOAD_SECONDS

            # P95 latency (histogram quantile)
            q_traefik_p95 = f"histogram_quantile(0.95, sum(rate(traefik_service_request_duration_seconds_bucket{{service=~'{t_service_regex}'}}[{LOAD_SECONDS}s])) by (le))"
            prom_tp95_data = query_prometheus(q_traefik_p95, time=prom_end_ts)
            traefik_p95 = float(prom_tp95_data[0]['value'][1]) * 1000 if prom_tp95_data else 0

            # Average latency
            q_traefik_avg = f"(sum(rate(traefik_service_request_duration_seconds_sum{{service=~'{t_service_regex}'}}[{LOAD_SECONDS}s])) / sum(rate(traefik_service_request_duration_seconds_count{{service=~'{t_service_regex}'}}[{LOAD_SECONDS}s])))"
            prom_tavg_data = query_prometheus(q_traefik_avg, time=prom_end_ts)
            traefik_avg = float(prom_tavg_data[0]['value'][1]) * 1000 if prom_tavg_data else 0

            # Success rate
            total_traefik = traefik_reqs + traefik_errors
            traefik_success_pct = (traefik_reqs / total_traefik * 100) if total_traefik > 0 else 0

        # ====================================================================
        # STORE RESULTS
        # ====================================================================
        
        results_data.append({
            'date': date_str,
            'start_time': start_time_str,
            'end_time': end_time_str,
            'stack': stack_name,
            'nomad_instances': nomad_instances,
            'nomad_cpu_alloc': nomad_cpu_alloc,
            'nomad_cpu_avg': nomad_cpu_avg,
            'nomad_cpu_max': nomad_cpu_max,
            'nomad_mem_alloc': nomad_mem_alloc,
            'nomad_mem_avg': nomad_mem_avg,
            'nomad_mem_max': nomad_mem_max,
            'k6_reqs': k6_reqs,
            'k6_errors': k6_errors,
            'k6_rps_avg': k6_rps_avg,
            'k6_p95_avg': k6_p95_avg,
            'k6_avg_mean': k6_avg_mean,
            'k6_success_rate': k6_success_rate,
            'traefik_reqs': traefik_reqs,
            'traefik_errors': traefik_errors,
            'traefik_rps_avg': traefik_rps_avg,
            'traefik_p95': traefik_p95,
            'traefik_avg': traefik_avg,
            'traefik_success_pct': traefik_success_pct
        })
        
    # Sort by CPU allocation, then memory allocation (ascending)
    results_data.sort(key=lambda x: (x['nomad_cpu_alloc'], x['nomad_mem_alloc']))
    
    # ========================================================================
    # GENERATE MARKDOWN REPORT
    # ========================================================================
    
    output_file = os.path.join(REPORTS_ROOT_DIR, "benchmark-gerado.md")
    
    with open(output_file, "w") as f:
        f.write(f"# Benchmark Report\n")
        f.write(f"Generated on {datetime.datetime.now().isoformat()}\n\n")

        # Helper function to format floats with comma decimal separator
        def fmt(val):
            return f"{val:.2f}".replace('.', ',')

        # ====================================================================
        # TABLE 1: NOMAD METRICS
        # ====================================================================
        
        f.write("## Nomad Metrics - Infraestrutura\n\n")
        f.write("| Date | Start Time | End Time | Stack | Nomad Inst | Total - CPU Alloc | Total - CPU Avg | Total - CPU Max | Total - Mem Alloc (MiB) | Total - Mem Avg (MiB) | Total - Mem Max (MiB) |\n")
        f.write("| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |\n")
        
        for r in results_data:
            # Convert MHz to cores (1024 MHz = 1 core)
            cpu_alloc_core = r['nomad_cpu_alloc'] / 1024
            cpu_avg_core = r['nomad_cpu_avg'] / 1024
            cpu_max_core = r['nomad_cpu_max'] / 1024
            
            # Convert bytes to MiB
            mem_alloc_mib = r['nomad_mem_alloc'] / 1024 / 1024
            mem_avg_mib = r['nomad_mem_avg'] / 1024 / 1024
            mem_max_mib = r['nomad_mem_max'] / 1024 / 1024
            
            row = [
                r['date'], r['start_time'], r['end_time'], r['stack'],
                f"{int(r['nomad_instances'])}",
                f"{fmt(cpu_alloc_core)} core",
                f"{fmt(cpu_avg_core)} core",
                f"{fmt(cpu_max_core)} core",
                f"{int(mem_alloc_mib)} MiB",
                f"{int(mem_avg_mib)} MiB",
                f"{int(mem_max_mib)} MiB"
            ]
            f.write("| " + " | ".join(row) + " |\n")
        
        f.write("\n")

        # ====================================================================
        # TABLE 2: K6 METRICS
        # ====================================================================
        
        f.write("## K6 Metrics\n\n")
        f.write("| Stack | K6 Reqs | K6 Erros | K6 RPS Avg | K6 P95 (ms) | K6 Avg (ms) | Success % | Threshold |\n")
        f.write("| --- | --- | --- | --- | --- | --- | --- | --- |\n")
        
        for r in results_data:
            threshold = "✅" if r['k6_success_rate'] >= 95 else "❌"
            row = [
                r['stack'],
                f"{int(r['k6_reqs'])}",
                f"{int(r['k6_errors'])}",
                f"{fmt(r['k6_rps_avg'])}",
                f"{fmt(r['k6_p95_avg'])}",
                f"{fmt(r['k6_avg_mean'])}",
                f"{r['k6_success_rate']:.2f}%".replace('.', ','),
                threshold
            ]
            f.write("| " + " | ".join(row) + " |\n")
        
        f.write("\n")

        # ====================================================================
        # TABLE 3: TRAEFIK METRICS
        # ====================================================================
        
        f.write("## Traefik Metrics\n\n")
        f.write("| Stack | Traefik Reqs | Traefik Erros | Traefik RPS Avg | Traefik P95 (ms) | Traefik Avg (ms) | Success % | Threshold |\n")
        f.write("| --- | --- | --- | --- | --- | --- | --- | --- |\n")
        
        for r in results_data:
            threshold = "✅" if r['traefik_success_pct'] >= 95 else "❌"
            row = [
                r['stack'],
                f"{int(r['traefik_reqs'])}",
                f"{int(r['traefik_errors'])}",
                f"{fmt(r['traefik_rps_avg'])}",
                f"{fmt(r['traefik_p95'])}",
                f"{fmt(r['traefik_avg'])}",
                f"{r['traefik_success_pct']:.2f}%".replace('.', ','),
                threshold
            ]
            f.write("| " + " | ".join(row) + " |\n")
        
        f.write("\n")

    print(f"Report generated at: {output_file}")

if __name__ == "__main__":
    main()
