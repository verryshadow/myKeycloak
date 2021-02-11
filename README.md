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


| Client Id | client-secret | site-name | site-id
|---|---|---|---|
| diz-uker | 4f390e12-487f-402f-9c63-86c1476ed462 |Universitätsklinikum Erlangen|uker|
| diz-umm | 8af3a619-13c3-4d15-8c7b-4670295b889e |Universitätsklinikum Mannheim|umm|
| diz-ukf | 0e1de709-6918-4c5a-a57d-1428ba73c21a |Universitätsklinikum Frankfurt|ukf|
| diz-uka | 7964b975-ad1b-491f-b2bc-833032289e9b |Universitätsklinikum Aachen|uka|
|middleware-broker|ae769d44-35b5-456c-a0b7-25add1059536||

Note: site-name and site-id are hardcoded claims configured for each client.

## Create Docker image
```
docker build -t codexkeycloak .
```

## Run Docker container
```
docker run -p 8080:8080 -d codexkeycloak
```
alternatively (use docker-compose)
```
docker-compose up -d
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
Start the current version of keycloak

```
docker-compose up -d --build
```

Open browser, login (User: admin / Password: admin) and start configuring
```
http://localhost:8080/auth/admin/
```
Start export using Docker run command (after exporting is completed abort the process)
```
docker exec -it --user root codexkeycloak /opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=/tmp/keycloak-dump.json
```
Copy the newly created keycloak-dump.json file to the ./docker folder of this repository
```
docker cp codexkeycloak:/tmp/keycloak-dump.json ./docker/keycloak-dump.json
```
Create new Docker image (described above)


## Example Workflow for Middleware Authentication

Request access token with client:

```
curl -X POST \
  http://localhost:8080/auth/realms/codex-develop/protocol/openid-connect/token \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=client_credentials&client_id=diz-uker&scope=openid&client_secret=4f390e12-487f-402f-9c63-86c1476ed462'
```

Introspect (check) access token of client with middleware broker client:

```
curl -X POST \
  http://localhost:8080/auth/realms/codex-develop/protocol/openid-connect/token/introspect \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'token=<PASTE-YOUR-TOKEN-RECIEVED-FROM-POST-ABOVE-HERE>&client_id=middleware-broker&client_secret=ae769d44-35b5-456c-a0b7-25add1059536'
```

