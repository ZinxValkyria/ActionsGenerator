name: "Terraform test GH actions"

on:
  workflow_dispatch:
    paths:
      - 'terraform/**'
env:
  TF_LOG: INFO
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
jobs:
  terraform:
    name: "Terraform Infrastructure Change Management"
    runs-on: ubuntu-latest

    defaults:
      run:
        shell: bash
        working-directory: ./terraform  # Ensure this points to your Terraform config directory

    steps:
      - name: Checkout the repository to the runner
        uses: actions/checkout@v2

      - name: Setup Terraform with specified version on the runner
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.3.0

      - name: populate secrets.auto.tfvars
        run: |
          cat <<EOF >> secrets.auto.tfvars
          cloudflare_api_token = "${{secrets.CLOUDFLARE_API_TOKEN}}"
          cloudflare_zone_id = "${{secrets.CLOUDFLARE_ZONE_ID}}"
          new_relic_license_key = "${{secrets.NEW_RELIC_LICENSE_KEY}}"
          EOF

      - name: Terraform format
        id: fmt
        run: terraform fmt

      - name: Terraform init
        id: init
        run: terraform init

      - name: Terraform validate
        id: validate
        run: terraform validate

      - name: Terraform apply
        id: apply
        run: terraform apply --auto-approve  # Correctly reference the environment variable

      - name: Terraform destroy
        id: destroy
        run: terraform destroy --auto-approve  # Correctly reference the environment variable
 
