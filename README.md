# Keycloak for CODEX

## Purpose
Both for backend as well as frontend development an instance of Keycloak is mandatory.
This projects provides an easy way to start a Docker container running an instance of a Keycloak server with a configuration suitable for development.

## Configuration

| User | Password | Role |
|---|---|---|
| admin | admin | Administrator of Keycloak |
| codex-developer | codex | CODEX_DEVELOP | 

## Create Docker image
```
docker build -t codexkeycloak .
```

## Run Docker container
```
docker run -p 8080:8080 codexkeycloak
```
alternatively (use docker-compose)
```
docker-compose up
```
## Test Keycloak
After starting a Keycloak container open a browser
```
http://localhost:8080/auth/
```
login to Keycloak as admin
```
Administration Console >
```
check if user 'codex-developer' is imported
```
Manage > Users > View all users
```