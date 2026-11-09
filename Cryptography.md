# Cryptography

## Asymmetric cryptography

Create a new private key
```bash
openssl genpkey -algorithm rsa -out [private].key
```

Derive a public key from that private key
```bash
openssl rsa -pubout -in [private.key] -out [public].key
```

Encrypt a message
```bash
openssl pkeyutl -encrypt -inkey [public].key -pubin -in [filename].txt -out [filename].enc
```

Decrypt a message
```bash
openssl pkeyutl -decrypt -inkey [private].key -in [filename].enc -out [filename].txt
```
