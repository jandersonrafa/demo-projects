import requests
import json
import datetime
from datetime import timezone

# Configuration
PROMETHEUS_URL = "http://localhost:9091"
OUTPUT_FILE = "prometheus_metrics_results.json"

# Test Windows (Start times calculated from K6 filenames - 27 min duration)
# Java MVC (3016): End 21:30:55 -> Start 21:03:55
# Java MVC VT (3007): End 22:01:58 -> Start 21:34:58
# Java WebFlux (3006): End 22:30:57 -> Start 22:03:57
TEST_WINDOWS = {
    "java-mvc": {
        "start": "2026-01-16T21:03:55+00:00",
        "port": 3016,
        "stack": "java-mvc",
        "name": "Java MVC"
    },
    "java-mvc-vt": {
        "start": "2026-01-16T21:34:58+00:00",
        "port": 3007,
        "stack": "java-mvc-vt",
        "name": "Java MVC VT"
    },
    "java-webflux": {
        "start": "2026-01-16T22:03:57+00:00",
        "port": 3006,
        "stack": "java-webflux",
        "name": "Java WebFlux"
    }
}

def parse_timestamp(iso_str):
    dt = datetime.datetime.fromisoformat(iso_str)
    return dt.timestamp()

def query_prometheus(query, start_ts, end_ts):
    params = {
        "query": query,
        "start": start_ts,
        "end": end_ts,
        "step": "15s"
    }
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query_range", params=params)
        return response.json()
    except Exception as e:
        print(f"Error querying Prometheus: {e}")
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
    # Test duration is 27 minutes (1620 seconds)
    end_ts = start_ts + 1620
    
    stack_label = test_info["stack"]
    
    print(f"\n{'='*60}")
    print(f"Querying metrics for {test_info['name']}")
    print(f"Stack: {stack_label}, Port: {test_info['port']}")
    dt_start = datetime.datetime.fromtimestamp(start_ts, tz=timezone.utc)
    dt_end = datetime.datetime.fromtimestamp(end_ts, tz=timezone.utc)
    print(f"Time window (UTC): {dt_start} to {dt_end}")
    print(f"{'='*60}")
    
    results = {
        "stack": test_info["name"],
        "stack_label": stack_label,
        "port": test_info["port"],
        "start_time": test_info["start"],
        "duration_seconds": 1620
    }
    
    # Query CPU usage (rate of cpu usage)
    # Use container name pattern
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
    
    return results

def main():
    print("Starting Prometheus metrics collection for benchmark analysis...")
    print(f"Prometheus URL: {PROMETHEUS_URL}")
    
    all_results = []
    
    for stack_key, test_info in TEST_WINDOWS.items():
        metrics = get_container_metrics(stack_key, test_info)
        all_results.append(metrics)
    
    # Save results to file
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(all_results, f, indent=2)
    
    print(f"\n{'='*60}")
    print(f"Results saved to {OUTPUT_FILE}")
    print(f"{'='*60}")
    
    # Print summary table
    print("\n📊 SUMMARY TABLE - Container Metrics\n")
    print(f"{'Stack':<20} {'CPU Avg (cores)':<15} {'CPU P95 (cores)':<15} {'Memory Avg (MB)':<15} {'Memory P95 (MB)':<15}")
    print("=" * 80)
    
    for r in all_results:
        print(f"{r['stack']:<20} {r['cpu_cores']['avg']:.4f}{'':<9} {r['cpu_cores']['p95']:.4f}{'':<9} {r['memory_mb']['avg']:.2f}{'':<9} {r['memory_mb']['p95']:.2f}")

if __name__ == "__main__":
    main()
