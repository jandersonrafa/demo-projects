import requests
import datetime

PROMETHEUS_URL = "http://localhost:9091"

def query_prometheus(query):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={"query": query})
        return response.json()
    except Exception as e:
        return str(e)

print("Checking Prometheus...")
# Get list of all container names in the last 1 hour
query = 'count by (name) (container_cpu_usage_seconds_total[1h])'
result = query_prometheus(query)
print(result)

# Check specific matches
print("\nChecking for gateway matches:")
query_match = 'container_cpu_usage_seconds_total{name=~".*gateway.*"}[1h]'
# Just get instant vector to see if anything exists
query_instant = 'container_cpu_usage_seconds_total{name=~".*gateway.*"}'
print(query_prometheus(query_instant))
