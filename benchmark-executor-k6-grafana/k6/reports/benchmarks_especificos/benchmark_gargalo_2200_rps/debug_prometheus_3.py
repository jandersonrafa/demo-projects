import requests
import json
import time

PROMETHEUS_URL = "http://localhost:9091"

def query_prometheus(query):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={"query": query})
        return response.json()
    except Exception as e:
        return str(e)

print("Checking historical data (last 6h)...")
# Check if there was ANY cpu usage recorded in the last 6h
query = 'max_over_time(container_cpu_usage_seconds_total{name=~".*gateway.*"}[6h])'
result = query_prometheus(query)

if result.get('status') == 'success':
    results = result['data']['result']
    print(f"Found {len(results)} series.")
    for res in results[:10]: # Print first 10
         print(f"Name: {res['metric'].get('name', 'N/A')}")
else:
    print(result)
