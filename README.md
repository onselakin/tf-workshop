# Terraform Azure Load Balancer Example

This example shows how to run `n` number of virtual machines behind a load balancer, each hosting a simple Node.js web application.

The example demonstrates:

- Module usage (inputs/outputs)
- Remote backend usage
- Creating `n` number of virtual machines
- Bootstrapping virtual machines with `cloud-init`
- Creating a load balancer and connecting the VMs to it

## Steps to run the example

- Login to Azure:

  `az login`

- Get the subscription id for the subscription you would like to create the resources in:

  `az account list`

- Set the default value of the `azure_subscription_id` variable inside `./backend/variables.tf`

- Create the remote backend:

  ```bash
  cd backend
  terraform init
  terraform apply
  ```

- Get all the outputs after terraform finishes applying the configuration:

  ```bash
  terraform output -json
  ```

- Update the backend configuration in `main.tf` for the root module with the outputs above

  ```hcl
  backend "azurerm" {
    resource_group_name  = "vms-state"
    storage_account_name = "<STORAGE_ACCOUNT_NAME>"
    container_name       = "tfstatec"
    key                  = "vms-playground/terraform.tfstate"
    access_key           = "<ACCESS_KEY>"
  }
  ```

- Set the default value of the `azure_subscription_id` variable inside `variables.tf` for the root module

- Run terraform:

  ```bash
  # Run in the root folder
  terraform init
  terraform apply
  ```
