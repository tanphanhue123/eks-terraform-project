# with Pre Terraform

## Install & Config tools

### 1. Install AWS CLI

- Refer how to install [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) base on your OS.

### 2. Config AWS profile

- Need to [create AMI User (Access & Secret Key)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) with Right Permission and enable MFA

- Config AWS profile:
  - Create AWS profile

  ```bash
  aws configure --profile {{ project }}-default
      AWS Access Key ID: <your-access-key>
      AWS Secret Access Key: <your-secret-access-key>
      Default region name: ap-northeast-1
      Default output format: json
  ```

  - Add this to `~/.aws/credentials`

  ```bash
  [{{ project }}-{{ env }}]
  aws_access_key_id =
  aws_secret_access_key =
  aws_session_token =
  ```

  - Add this to `~/.aws/config`

  ```bash
  [profile {{ project }}-{{ env }}]
  output = json
  region = ap-northeast-1
  ```

- Excuting `create-aws-sts.sh` for testing

  ```
  cd pre-terrafrom
  ./create-aws-sts.sh {{ project }}-default {{ project }}-{{ env }} {{ account_id }} {{ mfa_device_name }} {{ token_code }}
  ```

## Create manually AWS S3 bucket, Dynamodb to store/lock IaC state and KMS Key to encrypt

- Create [S3 bucket](https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html)

  ```bash
  aws s3api create-bucket --bucket {{ project }}-{{ env }}-iac-state --region ap-northeast-1 --create-bucket-configuration LocationConstraint=ap-northeast-1 --profile {{ project }}-{{ env }}
  aws s3api put-bucket-versioning --bucket {{ project }}-{{ env }}-iac-state --versioning-configuration Status=Enabled --region ap-northeast-1 --profile {{ project }}-{{ env }}
  aws s3api put-public-access-block \
    --bucket {{ project }}-{{ env }}-iac-state \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" \
    --region ap-northeast-1 --profile {{ project }}-{{ env }}
  ```

- Create [Dynamodb](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/create-table.html)

  ```bash
  aws dynamodb create-table \
    --table-name {{ project }}-{{ env }}-terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --tags Key=Name,Value={{ project }}-{{ env }}-terraform-state-lock Key=Environment,Value={{ env }} \
    --region ap-northeast-1 \
    --profile {{ project }}-{{ env }}
  ```

- Create [KMS Key](https://docs.aws.amazon.com/cli/latest/reference/kms/create-key.html) and [Alias](https://docs.aws.amazon.com/cli/latest/reference/kms/create-alias.html)

  ```bash
  KMS_KEY_ID=$(aws kms create-key --description "Encrypt tfstate in s3 backend" --query "KeyMetadata.KeyId" --output text --profile {{ project }}-{{ env }} --region ap-northeast-1)
  aws kms create-alias --alias-name alias/{{ project }}-{{ env }}-iac --target-key-id $KMS_KEY_ID --profile {{ project }}-{{ env }} --region ap-northeast-1
  KMS_KEY_ARN=$(aws kms describe-key --key-id $KMS_KEY_ID --query "KeyMetadata.Arn" --output text --profile {{ project }}-{{ env }} --region ap-northeast-1) | echo "Terraform KMS Key ARN: \n" $KMS_KEY_ARN
  ```

#### Notes: You can use `pre-build.sh` to automatically execute all commands above instead

## Create key pairs for project using EC2

- Create [EC2 key pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)

  ```bash
  aws ec2 create-key-pair \
    --key-name {{ project }}-{{ env }}-keypair \
    --key-type rsa \
    --query "KeyMaterial" \
    --profile {{ project }}-{{ env }} \
    --output text > ~/.ssh/{{ project }}-keypair-{{ env }}.pem
  ```
