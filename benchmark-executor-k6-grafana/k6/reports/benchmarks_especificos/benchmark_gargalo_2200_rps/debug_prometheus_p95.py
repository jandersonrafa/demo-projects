import requests
import json
import datetime
from datetime import timezone

PROMETHEUS_URL = "http://localhost:9091"

def query_prometheus_at_time(query, timestamp):
    try:
        response = requests.get(f"{PROMETHEUS_URL}/api/v1/query", params={"query": query, "time": timestamp})
        return response.json()
    except Exception as e:
        return str(e)

# Timestamps (UTC)
# Java MVC VT (3007)
# End time: 14:33:26 + 24m = 14:57:26
end_ts_vt = datetime.datetime.fromisoformat("2026-01-16T14:57:26+00:00").timestamp()

# Java MVC (3016)
# End time: 15:46:15 + 24m = 16:10:15
end_ts_mvc = datetime.datetime.fromisoformat("2026-01-16T16:10:15+00:00").timestamp()

print("Calculating P95 for Java MVC VT (3007)...")
query_vt = 'histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket{instance=~".*:3007", uri="/bonus"}[24m])) by (le))'
result_vt = query_prometheus_at_time(query_vt, end_ts_vt)
print(json.dumps(result_vt, indent=2))

print("\nCalculating P95 for Java MVC (3016)...")
query_mvc = 'histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket{instance=~".*:3016", uri="/bonus"}[24m])) by (le))'
result_mvc = query_prometheus_at_time(query_mvc, end_ts_mvc)
print(json.dumps(result_mvc, indent=2))
