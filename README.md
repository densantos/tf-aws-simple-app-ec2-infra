
---

## Pre Requisites 

This module deploys a Webserver into an EC2 and all required components to run and access a webapp.


## Pre Requisites 

- Configure your AWS Profile in your Terminal
- Generate a keypair in AWS Console as you will need to deploy the EC2

## Deployment code

```hcl
provider "aws" {
  region = "us-east-1"
}

module "webserver" {
    source = ""
    name = ""
    key_pair = ""
} 
```

## Resources

- Deploy a VPC with 1 subnet
- Deploy a NAT Gateway
- Deploy an Internet Gateway
- Deploy an EC2
- Deploy a Network Interface
- Deploy a Security Group
- Deploy an IAM role require for SSM

## Configuration

- Configures SSM Agent in the EC2
- Installs Nodejs
- Installs Nginx
- Installs Git

---