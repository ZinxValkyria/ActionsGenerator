# YAML Template Generator Flask Application

## Project Overview

This Flask web application generates YAML files from templates, designed with a robust CI/CD pipeline and deployed on AWS using infrastructure as code (IaC) with Terraform.

![Project Architecture Diagram](/static/rm_images/infra_diagram.jpg)

## Workflow Diagram

![Workflow Diagram](/static/rm_images/flow%20chart.jpg)

## Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Infrastructure](#infrastructure)
- [CI/CD Pipeline](#cicd-pipeline)
- [Deployment](#deployment)
- [Monitoring](#monitoring)

## Features

- Dynamic YAML file generation from templates
- Secure, scalable web application
- Comprehensive CICD pipeline
- Infrastructure as Code (IaC) with Terraform
- AWS ECS deployment
- New Relic monitoring integration

## Technology Stack

- **Backend**: Python, Flask
- **Frontend**: HTML, CSS, JavaScript
- **Infrastructure**: Terraform
- **Containerization**: Docker, ECS
- **CI/CD**: GitHub Actions
- **Monitoring**: New Relic, Cloudwatch

## Infrastructure

### Terraform Resources and providers

- Cloudflare provider
- AWS provider
- VPC
- ECS Cluster
- Application Load Balancer
- SSL Certificates
- Security Groups
- Routes and tables
- IAM Roles and Policies

### Cloudflare API

- Using cloudflares provider, we can add a dns record to the domain which adds a new CNAME record(app.)
- The value for this CNAME record is assigned dynamically to the elastic IP of ther load balancer where SSL termination will occur which is retrieved from ACM(Amazon Secret manager)
- This ensures that a secure connection is made from the user to cloudflare and from cloudflare to the orgin server(ECS Cluster)

## CI/CD Pipeline

### GitHub Actions Workflow

### Staging Pipeline

1. Python Code Scanning
2. Dependency Vulnerability Scanning
3. Infrastructure Testing
4. Inject GitHub Secrets
5. Docker Image Build
6. Docker Image Push
7. Terraform Plan

### Production Pipeline

1. Repeat Staging Checks
2. Inject GitHub Secrets
3. Apply Terraform IaC
4. Deploy to ECS Cluster

## Deployment

### Architecture

- ECS Cluster running Docker containers
- Application Load Balancer
- SSL Termination at Load Balancer (443)
- Containers wrapped with New Relic for monitoring

## Security

- GitHub Secrets management
- Terraform state management
- ECS security groups
- SSL/TLS encryption
- Regular dependency scanning
- Implement client api tests

## Monitoring

### New Relic Integration

- Container-level performance tracking
- Logs
- Error tracking
- Performance metrics
