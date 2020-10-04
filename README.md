# Terraform a Web App on AWS

This Terraform module deploys a web application to AWS.
It uses S3, CloudFront, and Route53 services. The only
requirements are a domain and a distribution directory.
It hosts all static assets found in the directory on S3.
Those assets get added to a CloudFront distribution.
Then all traffic to the domain get routed to CloudFront.

## Getting started

Start by adding Terraform to the `.gitignore` file:

    npx gitignore terraform

Next define a Terraform configuration in `terraform.tf`:

```terraform
terraform {
  required_version = "~> 0.13"
}
```

Next define the Terraform module in `web-app.tf`:

```terraform
module "web-app" {
  source  = "wurde/web-app/aws"
  version = "1.3.0"

  dist_dir      = "./dist"
  domain        = "example.com"
  alias_domains = ["www.example.com"]
}
```

Next initialize the Terraform working directory:

    terraform init

Next run the plan and apply commands.
    
    terraform plan    #=> generates an execution plan.
    terraform apply   #=> builds infrastructure on AWS.

Finally verify domain ownership between AWS and the domain
name provider. Route53 generates custom DNS name servers
to set within the domain name provider. Example name
servers provided via Route53:

    ns-111.awsdns-32.net. 
    ns-1211.awsdns-9.co.uk.
    ns-153.awsdns-10.com.
    ns-1138.awsdns-14.org.

## Variables

Required:

- **dist_dir**

      type: string
      description: The distribution directory to serve via static asset host

- **domain**

      type: string
      description: The primary domain name.

Optional:

- **alias_domains**

      type: list(string)
      description: The other alias domain names (www.example.com).
      default: []

- **default_ttl**

      type: number
      description: The default TTL in seconds (default is 1 day).
      default: 86400

- **country_blacklist**

      type: list(string)
      description: List of countries (ISO 3166-1-alpha-2 codes) to blacklist.
      default: ["IR", "KP"]

## Cost Estimates

**$2 dollars a month.**
Primary charges are Route53 Hosted Zone and S3 storage.
(If the website receives zero traffic then at most you'll be
charged $0.55 cents for Route53.)

## Terraform 0.13

This module requires a Terraform version between `v0.13 and v1.0`.

Terraform is a DevOps tool that enables Infrastructure as Code (IaC).
[Learn more about it here](https://www.terraform.io).

## License

This project is __FREE__ to use, reuse, remix, and resell.
This is made possible by the [MIT license](/LICENSE).
