# CI/CD Pipeline Setup

## GitHub Secrets Required

For the CI/CD pipeline to work, configure these secrets in your GitHub repository:

### Required Secrets

| Secret | Description | Where to Get It |
|--------|-------------|-----------------|
| `DOCKER_USERNAME` | Docker Hub username | [hub.docker.com](https://hub.docker.com) |
| `DOCKER_PASSWORD` | Docker Hub password/token | Docker Hub → Account Settings → Security |
| `RENDER_API_KEY` | Render API key | Render Dashboard → Account Settings → API Keys |
| `RENDER_SERVICE_ID` | Render service ID | Render Dashboard → Your Service → Settings |

## Branch Strategy

```
prod (production - auto-deployed to Render)
  ↑
staging (pre-production testing - auto-deployed to Render staging)
  ↑
dev (development - built & tested only)
  ↑
feature/* (feature branches - built & tested on PR)
```

## Manual Triggers

You can also manually trigger workflows from the GitHub Actions tab.
