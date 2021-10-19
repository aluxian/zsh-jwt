# zsh-jwt

ZSH plugin for generating a JSON Web Token (JWT) using RS256.

## Example

```sh
openssl genrsa -out private.key 1024
jwt header.json payload.json private.key
```
