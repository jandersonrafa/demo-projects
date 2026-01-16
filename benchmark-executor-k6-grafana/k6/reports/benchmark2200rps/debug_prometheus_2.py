import requests
import json

PROMETHEUS_URL = "http://localhost:9091"

def query_prometheus(query):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={"query": query})
        return response.json()
    except Exception as e:
        return str(e)

print("Checking ALL container names...")
# Get top 20 container names
query = 'topk(20, container_cpu_usage_seconds_total)'
result = query_prometheus(query)

if result.get('status') == 'success':
    for res in result['data']['result']:
        print(f"Name: {res['metric'].get('name', 'N/A')}")
        print(f"Image: {res['metric'].get('image', 'N/A')}")
        print("-" * 20)
else:
    print(result)
