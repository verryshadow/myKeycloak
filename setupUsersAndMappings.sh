ADMIN_RES=$(curl -s --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=admin-cli')

TOKEN=$(echo "$ADMIN_RES" | grep -o '"access_token":"[^"]*' | grep -o '[^"]*$')

curl --location --request POST 'http://localhost:8080/auth/admin/realms/codex-develop/users' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $TOKEN" \
--data-raw '{"firstName":"Codex","lastName":"Developer", "email":"", "enabled":"true", "username":"codex-developer"}'

USERS_RES=$(curl -s --location --request GET 'http://localhost:8080/auth/admin/realms/codex-develop/users' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $TOKEN")

USER_ID=$(echo "$USERS_RES" | grep -o '"id":"[^"]*' | grep -o '[^"]*$')

GROUP_RES=$(curl -s --location --request GET 'http://localhost:8080/auth/admin/realms/codex-develop/groups' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $TOKEN")

GROUP_ID=$(echo "$GROUP_RES" | grep -o '"id":"[^"]*' | grep -o '[^"]*$')

curl --location --request PUT "http://localhost:8080/auth/admin/realms/codex-develop/users/$USER_ID/groups/$GROUP_ID" \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $TOKEN"

curl --location --request PUT "http://localhost:8080/auth/admin/realms/codex-develop/users/$USER_ID/reset-password" \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $TOKEN" \
--data-raw '{"type": "password", "value": "develop", "temporary": false}'