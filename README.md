# Keycloak for CODEX

## Purpose
Both for backend and frontend development an instance of Keycloak is mandatory.
This projects provides an easy way to start a Docker container running an instance of a Keycloak server with one configuration suitable for development and one for production use.

## Configuration

### Production and Development

Production and development system differ in means of security restrictions (dev allows any redirect uri and origin)
as well as preconfigured users (production does not supply any preconfigured users).

(TODO: there are still some open questions to be discussed for the production settings. Currently, the redirect/origin limits are **NOT** in place.)

To switch between the two, replace the env variable _KEYCLOAKIMPORTFILE_ (e.g. by providing a _.env_ file)
with either _./init/initial-realm-dev.json_ for develop (default setting) or _./init/initial-realm-prod.json_

### Users (dev only)

| User | Password | Role |
|---|---|---|
| admin | admin | Administrator of Keycloak |
| codex-developer | codex | CODEX_USER | 
| user1 | codex | CODEX_USER | 
| user2 | codex | CODEX_USER | 

### Clients

| Client Id | client-secret | site-name | site-id
|---|---|---|---|
| diz-uker | 4f390e12-487f-402f-9c63-86c1476ed462 |Universitätsklinikum Erlangen|uker|
| diz-umm | 8af3a619-13c3-4d15-8c7b-4670295b889e |Universitätsklinikum Mannheim|umm|
| diz-ukf | 0e1de709-6918-4c5a-a57d-1428ba73c21a |Universitätsklinikum Frankfurt|ukf|
| diz-uka | 7964b975-ad1b-491f-b2bc-833032289e9b |Universitätsklinikum Aachen|uka|
|middleware-broker|ae769d44-35b5-456c-a0b7-25add1059536||

Note: site-name and site-id are hardcoded claims configured for each client.

## Run Docker container
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
check if user 'codex-developer' is imported (dev only)
```
Manage > Users > View all users
```

## Example Workflow for Middleware Authentication

Request access token with client:

```
curl -X POST \
  http://<zars-keycloak>:8080/auth/realms/codex-develop/protocol/openid-connect/token \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=client_credentials&client_id=diz-uker&scope=openid&client_secret=4f390e12-487f-402f-9c63-86c1476ed462'
```

Introspect (check) access token of client with middleware broker client:

```
curl -X POST \
  http://<zars-keycloak>:8080/auth/realms/codex-develop/protocol/openid-connect/token/introspect \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'token=<PASTE-YOUR-TOKEN-RECEIVED-FROM-POST-ABOVE-HERE>&client_id=middleware-broker&client_secret=ae769d44-35b5-456c-a0b7-25add1059536'
```

