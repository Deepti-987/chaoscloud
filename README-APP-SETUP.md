# CHAOSCLOUD application starter

This starter provides a small Flask service with `/health` and Prometheus-compatible `/metrics` endpoints, a Dockerfile, Kubernetes manifests, tests, and a GitHub Actions test/build workflow.

## Important before deployment
1. Replace `REPLACE_WITH_GITHUB_OWNER` in `kubernetes/deployment.yaml` with your lowercase GitHub username or organization.
2. Build and publish the image to GHCR before applying the Kubernetes manifests.
3. Do not expose the Kubernetes API (6443) publicly.
4. Keep SSH restricted to the two administrators' current public IPs.
5. Add authentication and TLS before making dashboards public.

## Local tests
```bash
cd application
python -m pip install -r requirements.txt pytest
pytest -q
```

## Build image
From the repository root:
```bash
docker build -t chaoscloud:local application
```

## Kubernetes
After publishing the image and replacing the image owner:
```bash
sudo k3s kubectl apply -f kubernetes/namespace.yaml
sudo k3s kubectl apply -f kubernetes/deployment.yaml
sudo k3s kubectl apply -f kubernetes/service.yaml
sudo k3s kubectl -n chaoscloud get pods,services
```

The service uses NodePort 30080. The EC2 security group must allow TCP 30080 from the intended audience before it can be reached from outside. Prefer a restricted source range and HTTPS ingress for a real deployment.
