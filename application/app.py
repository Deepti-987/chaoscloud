import os
from datetime import datetime, timezone
from flask import Flask, jsonify, Response

app = Flask(__name__)
STARTED_AT = datetime.now(timezone.utc)

def metric_text():
    uptime = (datetime.now(timezone.utc) - STARTED_AT).total_seconds()
    return (
        "# HELP chaoscloud_up Whether the application is running.\n"
        "# TYPE chaoscloud_up gauge\n"
        "chaoscloud_up 1\n"
        "# HELP chaoscloud_uptime_seconds Application uptime in seconds.\n"
        "# TYPE chaoscloud_uptime_seconds gauge\n"
        f"chaoscloud_uptime_seconds {uptime:.2f}\n"
    )

@app.get("/")
def home():
    return jsonify(
        name="CHAOSCLOUD",
        description="Cloud resilience testing and recovery platform",
        endpoints=["/health", "/metrics"]
    )

@app.get("/health")
def health():
    return jsonify(status="healthy", service="chaoscloud"), 200

@app.get("/metrics")
def metrics():
    return Response(metric_text(), mimetype="text/plain; version=0.0.4")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8000")))
