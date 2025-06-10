# with Terraform

![AWS](../images/aws-terraform.png)

## Install

Refer how to install [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) base on your OS.

## How to use

### Initialization

#### I. Create environments & services

- Create environment folders and services folders in environment. Examples:
  - [x] STG
  - [x] PROD

- Symlink variables.tf file of environment to each service folder of it and add this symlink file to gitignore with two method

  *1. Symlink specific service*

  - Excute `make symlink e=<environment-name> s=<service-name>`. Example:

    ```bash
    make symlink e=stg s=general
    ```

  *2. Symlink all services*

  - Excute `make symlink_all e=<environment-name>`. Example:

    ```bash
    make symlink_all e=stg
    ```

  *3. Unsymlink specific service*

  - Excute `make unsymlink e=<environment-name> s=<service-name>`. Example:

    ```bash
    make unsymlink e=stg s=general
    ```

  *4. Unsymlink all services*

  - Excute `make unsymlink_all e=<environment-name>`. Example:

    ```bash
    make unsymlink_all e=stg
    ```

#### [II. Terraform init](https://www.terraform.io/cli/commands/init)

*1. Init specific service*

- Excute `make init e=<environment-name> s=<service-name>`. Example:

    ```bash
    make init e=stg s=general
    ```

*2. Init all services*

- Excute `make init_all e=<environment-name>`. Example:

    ```bash
    make init_all e=stg
    ```

### Deployment

#### [I. Terraform plan](https://www.terraform.io/cli/commands/plan)

*1. Plan specific service*

- Excute `make plan e=<environment-name> s=<service-name>` (If you want to plan before destroy, excute `make plan_destroy e=<environment-name> s=<service-name>` instead). Example:

    ```bash
    make plan e=stg s=general
    ```

*2. Plan specific service with module target*

- Excute `make plan_target e=<environment-name> s=<service-name> t=<module-name>` (If you want to plan before destroy target, excute `make plan_destroy_target e=<environment-name> s=<service-name> t=<module-name>` instead). Example:

    ```bash
    make plan_target e=stg s=general t=module.vpc
    ```

*3. Plan all services*

- Excute `make plan_all e=<environment-name>`(If you want to plan before destroy all, excute `make plan_destroy_all e=<environment-name>` instead). Example:

    ```bash
    make plan_all e=stg
    ```

#### [II. Terraform apply](https://www.terraform.io/cli/commands/apply)

*1. Apply specific service*

- Excute `make apply e=<environment-name> s=<service-name>`. Example:

    ```bash
    make apply e=stg s=general
    ```

*2. Apply specific service with module target*

- Excute `make apply_target e=<environment-name> s=<service-name> t=<module-name>`. Example:

    ```bash
    make apply_target e=stg s=general t=module.vpc
    ```

*3. Apply all services*

- Excute `make apply_all e=<environment-name>`. Example:

    ```bash
    make apply_all e=stg
    ```

#### [III. Terraform destroy](https://www.terraform.io/cli/commands/apply)

*1. Destroy specific service*

- Excute `make destroy e=<environment-name> s=<service-name>`. Example:

    ```bash
    make destroy e=stg s=general
    ```

*2. Destroy specific service with module target*

- Excute `make destroy_target e=<environment-name> s=<service-name> t=<module-name>`. Example:

    ```bash
    make destroy_target e=stg s=general t=module.vpc
    ```

*3. Destroy all services*

- Excute `make destroy_all e=<environment-name>`. Example:

    ```bash
    make destroy_all e=stg
    ```

## Structure

### Example

```
├── terraform
    ├── envs
    │   └── stg
    │   └── prod
    ├── modules
    │    ├── vpc
    │    │   ├── output.tf
    │    │   ├── variables.tf
    │    │   └── vpc.tf
    │    ├── sg
    │    │   ├── output.tf
    │    │   ├── variables.tf
    │    │   └── sg.tf
    └── README.md
```

### Vars

- Create variables for main
  - [x] variables.tf
- Values of variables for each environment
  - [x] terraform.stg.tfvars
  - [x] terraform.prod.tfvars

### Main

- Using **Modules** method
  - containers for multiple resources that are used together
  - the main way to package and reuse resource configurations with Terraform.
- [**Module Blocks**](https://www.terraform.io/language/modules/syntax#module-blocks)
- [**Module Sources from Github**](https://www.terraform.io/language/modules/sources#github) are tagged and released here <https://github.com/framgia/cable-installation-watcher-infra/terraform/modules>

Example:

```bash
module "example" {
  source = "../modules/example"
  ...
}
```

### Backend

- Backends primarily determine where Terraform stores its state. Terraform uses this persisted state data to keep track of the resources it manages. Since it needs the state in order to know which real-world infrastructure objects correspond to the resources in a configuration, everyone working with a given collection of infrastructure resources must be able to access the same state data.

### Outputs

- Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use. Output values are similar to return values in programming languages.

## Naming & Coding Conventions

1. Name of the service and `Name` tag you will create following format

   ```
   Name = "${var.project}-${var.env}-${var.service-type}-<service-name>"
   ```

Besides `${var.name}`, you can use `${var.type}`, `${var.region}`...depends on how many resources in a module or the way you create it.

2. `Resource and data source arguments`

- The name of a resource should be more descriptive. Examples:

  ```terraform
  resource "aws_subnet" "private" {}
  resource "aws_route_table" "private" {}
  ```

- If not, the name of a resource can be the same as the resource name that the provider defined. Examples:

  ```terraform
  resource "aws_ssm_parameter" "example" {}
  ```

- Notes:
  - Always use singular nouns for names.
  - Use _ (underscore) instead of - (dash) everywhere (in resource names, data source names, variable names, outputs, etc).
  - Prefer to use lowercase letters and numbers (even though UTF-8 is supported)

3. Usage of `count`/`for_each`

- Include argument `count`/`for_each` inside resource or data source block as the first argument at the top and separate by newline after it. Example:

  ```terraform
  resource "aws_route_table" "public" {
    count = 2

    vpc_id = "vpc-12345678"
    # ... remaining arguments omitted
  }

  resource "aws_route_table" "private" {
    for_each = toset(["one", "two"])

    vpc_id = "vpc-12345678"
    # ... remaining arguments omitted
  }
  ```

- When using conditions in an argument `count`/`for_each` prefer boolean values instead of using `length` or other expressions.

4. Placement of `tags`

- Include argument `tags`, if supported by resource, as the last real argument, following by depends_on and lifecycle, if necessary. All of these should be separated by a single empty line.

   ```terraform
   resource "aws_nat_gateway" "nat_gw" {
     count = 2

     allocation_id = "..."
     subnet_id     = "..."

     tags = {
       Name = "${var.project}--${var.env}-..."
     }

     depends_on = [aws_internet_gateway.internet_gw]

     lifecycle {
       create_before_destroy = true
     }
   }   
   ```

- Do not add `Project` & `Environment` tags in resources because we add it by default tag at `provider` function in `backend.tf` file.

5. Variables

- Use the plural form in a variable name when type is list(...) or map(...).
- Order keys in a variable block like this: description , default, type, validation.
- Always include description on all variables even if you think it is obvious (**Prefer write it from [Terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)**).

6. Outputs

- Good structure for the name of output looks like {name}_{attribute} , where:
  - {name} is a name of resource or data source.
  - {attribute} is an attribute returned by the output.
- If the returned value is a list it should have a plural name. See example.
- Always include description for all outputs even if you think it is obvious.
- Example: `resource "aws_rds_cluster_instance" "aurora" {}` ->

```terraform
output "rds_cluster_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = aws_rds_cluster_instance.aurora.*.endpoint
}
```

- **Note:** Describe your module in README.md at root folder.
