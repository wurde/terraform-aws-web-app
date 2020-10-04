# Terraform a Web App on AWS

This Terraform module deploys a web application to AWS.
It uses S3, CloudFront, and Route53 services. The only
requirements are a domain and distribution directory.
It hosts all static assets found in the directory on S3.
Those assets get added to a CloudFront distribution.
Then all traffic to the domain get routed to CloudFront.

## Consider this first

Prefer a managed solution over custom code. Before exploring
the Terraform option, consider the alternatives that'll
save time and money. Consider these solutions first:

- [Firebase](https://firebase.google.com) by Google.
- [Amplify](https://aws.amazon.com/amplify) by AWS.
- [Netlify](https://www.netlify.com)
- [GitHub Pages](https://pages.github.com)

Reasons why this module is a good candidate:

- Infrastructure is already managed by Terraform.
- Requirement for a cloud-agnostic IaC solution.

## Getting started

Example usage within a Terraform configuration:

```terraform
module "web-app" {
  source  = "wurde/web-app/aws"
  version = "1.2.0"

  dist_dir      = "./dist"
  domain        = "example.com"
  alias_domains = ["www.example.com"]
}
```

Next run `terraform apply`. Or automate via CI/CD pipelines
(GitHub Actions?).

A necessary manual step is adding the custom DNS name
servers to your domain name provider (Google Domains?).
This enables domain ownership verification.

Example name servers provided by AWS:

    ns-111.awsdns-32.net. 
    ns-1211.awsdns-9.co.uk.
    ns-153.awsdns-10.com.
    ns-1138.awsdns-14.org.

## Pricing Estimate

**~2 dollars a month.**
Primary charges are Route53 Hosted Zone and S3 storage.

## Why Terraform?

Terraform enables Infrastructure as Code.
[Learn more about it here](https://www.terraform.io).

## License

This project is __FREE__ to use, reuse, remix, and resell.
This is made possible by the [MIT license](/LICENSE).
