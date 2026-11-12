import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from app import app

def test_home():
    response = app.test_client().get("/")
    assert response.status_code == 200
    assert response.json["name"] == "CHAOSCLOUD"

def test_health():
    response = app.test_client().get("/health")
    assert response.status_code == 200
    assert response.json["status"] == "healthy"

def test_metrics():
    response = app.test_client().get("/metrics")
    assert response.status_code == 200
    assert "chaoscloud_up 1" in response.get_data(as_text=True)
