function jwt {
    local usage="jwt header.json payload.json private.key"

    if [[ $# < 2 || -n "${*[(r)--help]}" ]]; then
        echo "$usage"
        return 1
    fi

    if [[ $(jq -r '.alg' header.json) != "RS256" ]]; then
        echo "only RS256 is supported at the moment"
        return 1
    fi

    local headerJSON="$1"
    local payloadJSON="$2"
    local privateKEY="$3"
    shift 3

    local headerBase64url=$(jq -rc '' "$headerJSON" | base64 | tr '+/' '-_' | tr -d '=')
    local payloadBase64url=$(jq -rc '' "$payloadJSON" | base64 | tr '+/' '-_' | tr -d '=')
    
    local claim="$headerBase64url.$payloadBase64url"

    local sigBase64url=$(echo -n "$claim" | openssl dgst -sha256 -sign "$privateKEY" | openssl enc -base64 | tr -- '+/' '-_' | tr -d '\n=')

    echo "$headerBase64url.$payloadBase64url.$sigBase64url"
}
