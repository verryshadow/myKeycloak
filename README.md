# Keycloak for CODEX

## Purpose
Both for backend as well as frontend development an instance of Keycloak is mandatory.
This projects provides an easy way to start a Docker container running an instance of a Keycloak server with a configuration suitable for development.

## Configuration

| User | Password | Role |
|---|---|---|
| admin | admin | Administrator of Keycloak |
| codex-developer | codex | CODEX_USER | 
| user1 | codex | CODEX_USER | 
| user2 | codex | CODEX_USER | 

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

## Change realm
Chose a local directory (e.g. 'c:/Users/Hans/docker/tmp') and copy file .docker/keycloak-dump.json into directory.

Run Docker container with chosen directory mapped to '/tmp' (anonymous volume) 
```
docker run -d -p 8180:8080 -v c:/Users/Hans/docker/tmp:/tmp --name kc codexkeycloak
```
Open browser, login (User: admin / Password: admin) and start configuring
```
http://localhost:8180/auth/admin/
```
Start export using Docker run command
```
docker exec -it kc /opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=/tmp/keycloak-dump.json
```
Inside the chosen directory (e.g. 'c:/Users/Hans/docker/tmp') we have a new database dumb of keycloak. Copy it to ./docker

Create new Docker image (described above)
