# GitHub Actions YAML Generator

## Project Overview

This project aims to develop a web application that enables users to generate YAML files tailored for GitHub Actions. Users will be able to customize templates by entering specific variables on the website. The application focuses on scalability and security, utilizing Infrastructure as Code (IaC) for consistent deployments. It also features monitoring and alerting to ensure reliable performance.

The application will save users time and effort by simplifying the creation and customization of GitHub Actions workflows, even for those with minimal coding experience.

## Key Objectives

1. **User Interface**:
   - **Intuitive Workflow Generation**: Build an easy-to-use interface for generating GitHub workflows by allowing users to define:
     - **name**: The name of the workflow.
     - **on (triggers)**: Specify events that trigger the workflow.
     - **jobs**: Define the jobs that will run.
     - **runs-on (runner)**: Specify the environment for the jobs.
     - **steps**: Outline the steps that make up each job.
     - **uses**: Specify actions to be used in the steps.
     - **run**: Define commands to execute.

2. **Infrastructure as Code (IaC)**:
   - **Scalable and Consistent Infrastructure**: Utilize Terraform to manage the application's infrastructure, ensuring consistency and scalability across environments.

3. **Monitoring and Alerting**:
   - **Performance Monitoring and Alerting**: Set up monitoring and observability to track application performance and address any issues promptly.

## Features

- User-friendly interface for creating GitHub Actions YAML files.
- Ability to customize various elements of the workflow.
- Scalable infrastructure managed by Terraform.
- Integrated monitoring and alerting for performance and reliability.

## Technologies

- **Frontend**: HTML,CSS,Javascript
- **Backend**: Flask server (python)
- **Infrastructure**: Terraform
- **Monitoring**: New Relic
- **Terraform state**: S3 backend with DynamoDB state locking


## Local development

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export S3_BUCKET_NAME=actions-template-bucket
export AWS_REGION=eu-west-1
flask --app app run
```

AWS credentials should be supplied through your normal AWS credential chain. Do not commit credentials, Terraform state, `.tfvars`, `.env`, or `newrelic.ini`.

## Production deployment

The production GitHub Actions workflow uses GitHub OIDC. Configure an `AWS_ROLE_ARN` repository secret containing a role that trusts this repository's GitHub OIDC subject. Long-lived `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secrets are no longer required by this workflow.

Terraform deployments should be protected with a GitHub Environment approval rule before this repository is treated as production. The NAT gateway and other AWS resources can incur ongoing charges.

## Configuration

- `S3_BUCKET_NAME`: bucket containing YAML templates
- `AWS_REGION`: AWS region; defaults to `eu-west-1`
- `AWS_ROLE_ARN`: GitHub Actions secret used for OIDC deployment
- `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ZONE_ID`, `NEW_RELIC_LICENSE_KEY`: deployment secrets
