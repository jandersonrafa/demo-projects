import requests
import json

PROMETHEUS_URL = "http://localhost:9091"

def query_prometheus(query):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={"query": query})
        return response.json()
    except Exception as e:
        return str(e)

print("Listing metrics matching 'http'...")
# Use the metadata API or just query for a common prefix
try:
    response = requests.get(f"{PROMETHEUS_URL}/api/v1/label/__name__/values")
    all_metrics = response.json().get('data', [])
    http_metrics = [m for m in all_metrics if 'http' in m or 'request' in m]
    print(f"Found {len(http_metrics)} potential metrics. Top 20:")
    for m in http_metrics[:20]:
        print(m)
except Exception as e:
    print(f"Failed to list metrics: {e}")

print("\nTrying specific histogram query again with broader match...")
# Try to find ANY bucket for the bonus endpoint
query = 'http_server_requests_seconds_bucket'
result = query_prometheus(query)
if result.get('status') == 'success' and result['data']['result']:
    print("Found http_server_requests_seconds_bucket!")
    print(json.dumps(result['data']['result'][0]['metric'], indent=2))
else:
    print("Still did not find http_server_requests_seconds_bucket")
