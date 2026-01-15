#!/usr/bin/env python3
"""
Script to query Prometheus metrics for benchmark analysis.
Queries container CPU and memory usage for each stack during their test windows.
"""

import requests
import json
from datetime import datetime, timedelta
import sys

# Prometheus endpoint
PROMETHEUS_URL = "http://localhost:9091"

# Test timestamps (from K6 reports - adjusted to today's actual test time)
# Reports show times like 20:08:03 but tests were run today after 16h
TEST_WINDOWS = {
    "node": {
        "start": "2026-01-13T17:01:33-03:00",  # 6m30s before 17:08:03
        "port": 3005,
        "stack": "node",
        "name": "Node.js (NestJS)"
    },
    "java-webflux": {
        "start": "2026-01-13T17:08:54-03:00",  # 6m30s before 17:15:24
        "port": 3006,
        "stack": "java-webflux",
        "name": "Java WebFlux"
    },
    "java-mvc-vt": {
        "start": "2026-01-13T17:17:24-03:00",  # 6m30s before 17:23:54
        "port": 3007,
        "stack": "java-mvc-vt",
        "name": "Java MVC VT"
    },
    "python": {
        "start": "2026-01-13T17:25:19-03:00",  # 6m30s before 17:31:49
        "port": 3008,
        "stack": "python",
        "name": "Python (FastAPI)"
    },
    "php": {
        "start": "2026-01-13T17:34:40-03:00",  # 6m30s before 17:41:10
        "port": 3009,
        "stack": "php",
        "name": "PHP CLI"
    },
    "php-fpm": {
        "start": "2026-01-13T17:43:31-03:00",  # 6m30s before 17:50:01
        "port": 3011,
        "stack": "php-fpm",
        "name": "PHP FPM"
    },
    "php-octane": {
        "start": "2026-01-13T17:54:57-03:00",  # 6m30s before 18:01:27
        "port": 3014,
        "stack": "php-octane",
        "name": "PHP Octane"
    },
    "java-mvc": {
        "start": "2026-01-13T18:03:05-03:00",  # 6m30s before 18:09:35
        "port": 3016,
        "stack": "java-mvc",
        "name": "Java MVC"
    }
}

def parse_timestamp(ts_str):
    """Parse ISO timestamp with timezone to Unix timestamp"""
    dt = datetime.fromisoformat(ts_str)
    return int(dt.timestamp())

def query_prometheus(query, start_time, end_time, step="15s"):
    """Query Prometheus range API"""
    url = f"{PROMETHEUS_URL}/api/v1/query_range"
    params = {
        "query": query,
        "start": start_time,
        "end": end_time,
        "step": step
    }
    
    try:
        response = requests.get(url, params=params, timeout=30)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error querying Prometheus: {e}", file=sys.stderr)
        return None

def calculate_stats(values):
    """Calculate min, max, avg, p95 from list of values"""
    if not values:
        return {"min": 0, "max": 0, "avg": 0, "p95": 0}
    
    sorted_values = sorted(values)
    n = len(sorted_values)
    p95_idx = int(n * 0.95)
    
    return {
        "min": min(values),
        "max": max(values),
        "avg": sum(values) / len(values),
        "p95": sorted_values[p95_idx] if p95_idx < n else sorted_values[-1]
    }

def get_container_metrics(stack_key, test_info):
    """Get container CPU and memory metrics for a specific test window"""
    start_ts = parse_timestamp(test_info["start"])
    # Test duration is 7 minutes
    end_ts = start_ts + 420
    
    stack_label = test_info["stack"]
    
    print(f"\n{'='*60}")
    print(f"Querying metrics for {test_info['name']}")
    print(f"Stack: {stack_label}, Port: {test_info['port']}")
    print(f"Time window: {datetime.fromtimestamp(start_ts).isoformat()} to {datetime.fromtimestamp(end_ts).isoformat()}")
    print(f"{'='*60}")
    
    results = {
        "stack": test_info["name"],
        "stack_label": stack_label,
        "port": test_info["port"],
        "start_time": test_info["start"],
        "duration_seconds": 420
    }
    
    # Query CPU usage (rate of cpu usage)
    # Use container name pattern: benchmark-{stack}-gateway or {stack}-gateway
    cpu_query = f'rate(container_cpu_usage_seconds_total{{name=~".*{stack_label}.*gateway.*"}}[1m])'
    print(f"\nCPU Query: {cpu_query}")
    cpu_data = query_prometheus(cpu_query, start_ts, end_ts)
    
    if cpu_data and cpu_data.get("status") == "success":
        cpu_values = []
        for result in cpu_data["data"]["result"]:
            for value in result["values"]:
                cpu_values.append(float(value[1]))
        
        if cpu_values:
            cpu_stats = calculate_stats(cpu_values)
            results["cpu_cores"] = cpu_stats
            print(f"CPU Stats (cores): {cpu_stats}")
        else:
            print("No CPU data found")
            results["cpu_cores"] = {"min": 0, "max": 0, "avg": 0, "p95": 0}
    else:
        print(f"CPU query failed: {cpu_data}")
        results["cpu_cores"] = {"min": 0, "max": 0, "avg": 0, "p95": 0}
    
    # Query Memory usage (in bytes, convert to MB)
    # Use container name pattern: benchmark-{stack}-gateway or {stack}-gateway
    mem_query = f'container_memory_usage_bytes{{name=~".*{stack_label}.*gateway.*"}}'
    print(f"\nMemory Query: {mem_query}")
    mem_data = query_prometheus(mem_query, start_ts, end_ts)
    
    if mem_data and mem_data.get("status") == "success":
        mem_values = []
        for result in mem_data["data"]["result"]:
            for value in result["values"]:
                # Convert bytes to MB
                mem_values.append(float(value[1]) / (1024 * 1024))
        
        if mem_values:
            mem_stats = calculate_stats(mem_values)
            results["memory_mb"] = mem_stats
            print(f"Memory Stats (MB): {mem_stats}")
        else:
            print("No memory data found")
            results["memory_mb"] = {"min": 0, "max": 0, "avg": 0, "p95": 0}
    else:
        print(f"Memory query failed: {mem_data}")
        results["memory_mb"] = {"min": 0, "max": 0, "avg": 0, "p95": 0}
    
    # Query RPS from Prometheus (http_requests_total)
    rps_query = f'rate(http_requests_total{{stack="{stack_label}", component="gateway"}}[1m])'
    print(f"\nRPS Query: {rps_query}")
    rps_data = query_prometheus(rps_query, start_ts, end_ts)
    
    if rps_data and rps_data.get("status") == "success":
        rps_values = []
        for result in rps_data["data"]["result"]:
            for value in result["values"]:
                rps_values.append(float(value[1]))
        
        if rps_values:
            rps_stats = calculate_stats(rps_values)
            results["rps_prometheus"] = rps_stats
            print(f"RPS Stats (from Prometheus): {rps_stats}")
        else:
            print("No RPS data found in Prometheus")
            results["rps_prometheus"] = {"min": 0, "max": 0, "avg": 0, "p95": 0}
    else:
        print(f"RPS query failed: {rps_data}")
        results["rps_prometheus"] = {"min": 0, "max": 0, "avg": 0, "p95": 0}
    
    return results

def main():
    print("Starting Prometheus metrics collection for benchmark analysis...")
    print(f"Prometheus URL: {PROMETHEUS_URL}")
    
    all_results = []
    
    for stack_key, test_info in TEST_WINDOWS.items():
        try:
            metrics = get_container_metrics(stack_key, test_info)
            all_results.append(metrics)
        except Exception as e:
            print(f"Error processing {stack_key}: {e}", file=sys.stderr)
    
    # Save results to JSON
    output_file = "prometheus_metrics_results.json"
    with open(output_file, "w") as f:
        json.dump(all_results, f, indent=2)
    
    print(f"\n{'='*60}")
    print(f"Results saved to {output_file}")
    print(f"{'='*60}")
    
    # Print summary table
    print("\n\n📊 SUMMARY TABLE - Container Metrics\n")
    print(f"{'Stack':<20} {'CPU Avg (cores)':<15} {'CPU P95 (cores)':<15} {'Memory Avg (MB)':<15} {'Memory P95 (MB)':<15}")
    print("="*80)
    
    for result in all_results:
        stack = result["stack"]
        cpu_avg = result["cpu_cores"]["avg"]
        cpu_p95 = result["cpu_cores"]["p95"]
        mem_avg = result["memory_mb"]["avg"]
        mem_p95 = result["memory_mb"]["p95"]
        
        print(f"{stack:<20} {cpu_avg:<15.4f} {cpu_p95:<15.4f} {mem_avg:<15.2f} {mem_p95:<15.2f}")

if __name__ == "__main__":
    main()
