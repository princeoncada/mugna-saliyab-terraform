# Terraform Infrastructure Deployment Documentation

This document explains how to deploy infrastructure using Terraform.

## Overview
Terraform is an open-source Infrastructure as Code (IaC) tool that allows you to define, preview, and deploy cloud infrastructure using simple configuration files. This guide provides a step-by-step approach to deploying infrastructure with Terraform.

## Prerequisites
- Terraform installed on your machine (version 0.12 or later recommended)
- Cloud provider credentials configured (e.g., AWS, Azure, GCP)
- Basic understanding of Cloud concepts and Infrastructure as Code

## Setting Up AWS Environment Variables

Before deploying your infrastructure or CI/CD pipelines, you need to configure your AWS credentials. Terraform and CI tools (e.g., GitHub Actions) expect the AWS access keys to be available as environment variables.

### Local Development

You can configure your AWS credentials on your local machine by setting two environment variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. For example:

**On Linux/MacOS:**

```bash
export AWS_ACCESS_KEY_ID=your_aws_access_key_id
export AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
```

**On Windows:**

```cmd
set AWS_ACCESS_KEY_ID=your_aws_access_key_id
set AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
```

For PowerShell:

```powershell
$env:AWS_ACCESS_KEY_ID="your_aws_access_key_id"
$env:AWS_SECRET_ACCESS_KEY="your_aws_secret_access_key"
```

## Steps to Deploy Infrastructure

### 1. Define Your Infrastructure
Create a Terraform configuration file (e.g., main.tf) where you define the provider and resources.

### 2. Initialize Terraform
Run the following command in your terminal to initialize the working directory. This will download the necessary provider plugins.
```
terraform init
```

### 3. Plan Your Deployment
Generate an execution plan to see the actions Terraform will take before making any changes.
```
terraform plan
```

### 4. Deploy Your Infrastructure
Apply your configuration to create or update the infrastructure.
```
terraform apply
```
Type "yes" when prompted to confirm the execution.

### 5. Verify and Manage Your Infrastructure
After applying, verify that your resources have been created successfully. Terraform maintains a state file that tracks your deployed infrastructure. Be sure to manage this state file carefully, possibly storing it remotely for team collaboration.

## Cleanup
When you no longer need the deployed infrastructure, you can destroy it with:
```
terraform destroy
```
Confirm by typing "yes" when prompted.

Happy Terraforming!
