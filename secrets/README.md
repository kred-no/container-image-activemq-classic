# README

Encrypted secrets.

```bash
# Encrypt file
sops -e example.yml > secrets/example.enc.yml

# Decrypt file
sops -d secrets/example.enc.yml > example.yml

# Override encryption rules (e.g. unsupported yaml anchors)
sops -e --input-type=binary --filename-override=example.binary example.yml > secrets/example.yml.enc
sops -d secrets/example.yml.enc
```
