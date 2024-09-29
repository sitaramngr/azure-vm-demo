# Welcome

This codebase is a sample solution from the book [Mastering Terraform](https://amzn.to/3XNjHhx). This codebase is the solution from Chapter 10 where Soze Enterprises is deploying their solution using Azure Virtual Machine architecture. It includes infrastructure as code (IaC) using Terraform and configuration management with Packer. Here is a summary of the key components:

## Packer Code

The Packer code is stored in `src\packer` under directories for each of the two Packer templates. One for the `frontend` and another for the `backend`. These Packer templates ultimately deploy the code stored in `src\dotnet`.

## Terraform Code

The Terraform code is stored in `src\terraform`. There is only one root module and it resides within this directory. There is only the default input variables value file `terraform.tfvars` that is loaded by default.

After you build Virtual Machine Images with Packer you will need to update the input variables `frontend_image` and `backend_image` to reference the correct version and Packer Resource Group (if changed).

You may need to change the `primary_region` input variable value if you wish to deploy to a different region. The default is `westus2`.

If you want to provision more than one environment you may need to remove the `environment_name` input variable value and specify an additional environment `tfvar` file.

## GitHub Actions Workflows

### Packer Workflows
There are two GitHub Actions workflows that use Packer to build the Virtual Machine images.

### Terraform Workflows
The directory `.github/workflows/` contains GitHub Actions workflows that implement a CI/CD solution using Packer and Terraform. There are individual workflows for the three Terraform core workflow operations `plan`, `apply`, and `destroy`.

# Pre-Requisites

## Entra Setup

In order for GitHub Actions workflows to execute you need to have an identity that they can use to access Azure. Therefore you need to setup a new App Registrations in Entra for both the Terraform and Packer workflows. In addition, for each App Registration you should create a Client Secret to be used to authenticate.

The Entra App Registration's Application ID (i.e., the Client ID) needs to be set as Environment Variables in GitHub.

The App Registration for Packer should have it's Application ID stored in a GitHub environment Variable `PACKER_ARM_CLIENT_ID` and it's client Secret stored in `PACKER_ARM_CLIENT_SECRET`.

The App Registration for Terraform should have it's Application ID stored in a GitHub environment Variable `TERRAFORM_ARM_CLIENT_ID` and it's client Secret stored in `TERRAFORM_ARM_CLIENT_SECRET`.

## Azure Setup

### App Registration Subscription Role Assignments

Both of the Entra App Registrations created in the previous step need to be granted `Owner` access to your Azure Subscription.

### Resource Group for Packer

In order for Packer to be able to produce Virtual Machine images you need to create an Azure Resource Group named `rg-packer`. 

Both of the Packer configuration directories for the `backend` and `frontend` container a file called `variables.pkrvars.hcl`. This file contains configuration values that are passed into Packer by the GitHub Actions. Both the Packer templates contain two input variables `resource_group_name` and `azure_primary_location`.

If you want to change which resource group Packer images are stored upon successful completion then you should update the value for `resource_group_name`. The default is `rg-packer`.

If you want to change the Azure Region that the Packer images are stored upon successful completion then you should update the value for `azure_primary_location`. The default is `westus2`.

If you update these values ensure that the Azure Resource Group by that name exists in the specified Azure Region.

### Azure Storage Account for Terraform State

Lastly you need to setup an Azure Storage Account that can be used to store Terraform State. You need to create an Azure Resource Group called `rg-terraform-state` and an Azure Storage Account within this resource group called `ststate00000`. replace the five (5) zeros (i.e., `00000`) with a five (5) digit random number. Then inside the Azure Storage Account create a Blob Storage Container called `tfstate`.

The Resource Group Name, the Storage Account Name and the Blob Storage container Name will be used in the GitHub Configuration.

### GitHub Configuration

You need to add the following environment variables:

- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID
- PACKER_ARM_CLIENT_ID
- TERRAFORM_ARM_CLIENT_ID
- BACKEND_RESOURCE_GROUP_NAME
- BACKEND_STORAGE_ACCOUNT_NAME
- BACKEND_STORAGE_CONTAINER_NAME

You need to add the following secrets:

- PACKER_ARM_CLIENT_SECRET
- TERRAFORM_ARM_CLIENT_SECRET