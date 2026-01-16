import requests
import json
import datetime

PROMETHEUS_URL = "http://localhost:9091"

def query_prometheus(query):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={"query": query})
        return response.json()
    except Exception as e:
        return str(e)

print("Finding labels for http_server_requests_seconds_bucket (last 6h)...")
# Look at the last 6 hours
query = 'http_server_requests_seconds_bucket[6h]' 
# Limiting output in case it's huge won't work well with range vector in python directly if I just print it.
# Better to use instant query with a lookback to just see labels
query = 'last_over_time(http_server_requests_seconds_bucket[6h])'

result = query_prometheus(query)

if result.get('status') == 'success':
    results = result['data']['result']
    print(f"Found {len(results)} series.")
    
    seen_instances = set()
    for res in results:
        metric = res['metric']
        instance = metric.get('instance', 'N/A')
        application = metric.get('application', 'N/A')
        uri = metric.get('uri', 'N/A')
        
        if instance not in seen_instances:
            print(f"Instance: {instance}, App: {application}, URI: {uri}")
            seen_instances.add(instance)
else:
    print(result)
