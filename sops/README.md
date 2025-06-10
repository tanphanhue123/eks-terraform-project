# with SOPS

Ref: https://github.com/mozilla/sops

## Install

Refer how to install [sops](https://github.com/mozilla/sops/releases) base on your OS.

## How to use

Your AWS credentials must be present in ~/.aws/credentials. sops uses aws-sdk-go.

```bash
$ cat ~/.aws/credentials
[default]
aws_access_key_id = AKI.....
aws_secret_access_key = mw......
```

Create file with sops encrypt:

```bash
sops --kms "arn-kms-encrypt-sops" sops/secrets.stg.yaml 
```

If edit file on sops, use:

```bash 
sops ../sops/secrets.stg.yaml
```
