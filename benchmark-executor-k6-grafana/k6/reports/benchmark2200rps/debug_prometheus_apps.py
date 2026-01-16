import requests
import json

PROMETHEUS_URL = "http://localhost:9091"

def query_prometheus(query):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={"query": query})
        return response.json()
    except Exception as e:
        return str(e)

print("Checking for Spring Boot http_server_requests metrics...")
# Check for any metric starting with http_server_requests
query = 'topk(10, http_server_requests_seconds_count)'
result = query_prometheus(query)
print(json.dumps(result, indent=2))

print("\nChecking for any histogram buckets for direct comparison...")
query = 'http_server_requests_seconds_bucket{uri="/bonus", method="POST"}'
result = query_prometheus(query)
# specific to java apps
print(json.dumps(result, indent=2))
