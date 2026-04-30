# GCP Terraform VPC Lab — Be A Man Week 5

## General Description

This repository contains a Terraform-based Google Cloud Platform (GCP) infrastructure lab focused on provider authentication, remote state configuration, API enablement, persistent disk provisioning, and custom VPC network creation.

The lab uses the following Terraform files:

- `0-authentication.tf`
- `1-backend.tf`
- `2-vpc.tf`

The repository also includes terminal execution evidence for the Terraform IVPAD workflow: **Init, Validate, Plan, Apply, and Destroy**. In addition, the Terraform plan output is exported to a `.txt` file and stored in a dated homework folder under `deliverables/`.

This lab is designed for technical audiences such as developers, DevOps engineers, DevSecOps engineers, cloud engineers, platform engineers, and site reliability engineers who need to understand how Terraform infrastructure workflows are structured, documented, executed, and verified in GCP.

---

## Purpose of the Repo

The purpose of this repository is to demonstrate a complete Terraform infrastructure workflow against GCP using a clean, evidence-driven lab structure.

The repo provides:

- Terraform configuration for authenticating to GCP.
- A GCS remote backend configuration for Terraform state management.
- A persistent disk resource managed through Terraform.
- GCP API enablement for Compute Engine and Kubernetes Engine.
- Custom VPC network creation using Terraform.
- Captured screenshots of each Terraform execution phase.
- An exported Terraform plan output file stored in a dated deliverables directory.
- Git-tracked infrastructure evidence suitable for review, audit, and instructional submission.

The repository is intended to show not only that Terraform commands were run, but that each step was executed, validated, documented, and preserved as part of an engineering deliverable.

---

## Overview of the Lab done on this Repo

This lab follows a Terraform infrastructure deployment lifecycle using GCP as the target cloud provider.

The workflow includes:

1. Creating Terraform configuration files for GCP authentication, backend state, and VPC infrastructure.
2. Initializing Terraform with a remote GCS backend.
3. Validating the Terraform syntax and provider configuration.
4. Generating a Terraform execution plan.
5. Exporting the Terraform plan output to a text file.
6. Creating a dated homework directory named `04_10_2026_weekB_hw`.
7. Moving or storing the Terraform plan output inside the dated homework directory.
8. Applying the Terraform configuration to create GCP infrastructure.
9. Destroying the Terraform-managed infrastructure.
10. Capturing screenshots of each major Terraform command output.
11. Committing and pushing the Terraform files, screenshots, and exported plan output to GitHub.

The main infrastructure components covered by this lab are:

- Google provider authentication.
- GCS backend configuration.
- Terraform remote state storage.
- Compute Engine persistent disk provisioning.
- Compute API enablement.
- Kubernetes Engine API enablement.
- Custom VPC network creation.
- Terraform resource teardown through `terraform destroy`.

---

## Necessary prerequisites before doing this lab

Before performing this lab, the following prerequisites should be in place:

### Local workstation prerequisites

- Git installed.
- Terraform installed.
- Google Cloud CLI installed.
- Git Bash for Windows, Terminal for macOS, or a Linux shell.
- A GitHub account.
- A local Git repository cloned or initialized for this lab.

### GCP prerequisites

- Access to a valid GCP project.
- Sufficient IAM permissions to manage the following:
  - GCS buckets.
  - Terraform state objects.
  - Compute Engine disks.
  - VPC networks.
  - GCP project services/APIs.
- A pre-created GCS bucket for the Terraform backend.
- Authenticated Google Cloud CLI session.

### Terraform prerequisites

- Terraform must be able to authenticate to GCP.
- The GCS backend bucket must already exist before running `terraform init`.
- The local Terraform working directory must contain:
  - `0-authentication.tf`
  - `1-backend.tf`
  - `2-vpc.tf`

### Authentication check

Authenticate to GCP before running Terraform:

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project class75-michaelanunda
```

Confirm the active account and project:

```bash
gcloud auth list
gcloud config list project
```

---

## Deployment Instructions for 0-authentication.tf

The `0-authentication.tf` file defines the required Google provider and configures the target GCP project and region.

Current configuration:

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "class75-michaelanunda"
  region  = "us-central1"
}
```

This file is responsible for telling Terraform which provider to use and which GCP project and region should be targeted.

Before deployment, verify the following values:

- `project` matches the intended GCP project ID.
- `region` matches the intended deployment region.
- Local GCP credentials are available through the Google Cloud CLI or application default credentials.

Recommended validation commands:

```bash
gcloud config get-value project
gcloud auth application-default print-access-token
```

If the access token command returns a token, Terraform should be able to authenticate using application default credentials.

---

## Deployment Instructions for 1-backend.tf

The `1-backend.tf` file configures Terraform to use a GCS backend for remote state storage. It also defines a persistent disk resource named `grafana-disk`.

Current backend configuration:

```hcl
terraform {
  backend "gcs" {
    bucket = "falcontf75"
    prefix = "terraform/state"
  }
}
```

Current disk resource:

```hcl
resource "google_compute_disk" "grafana_disk" {
  name = "grafana-disk"
  type = "pd-standard"
  zone = "us-central1-a"
  size = 10
}
```

The backend bucket must exist before Terraform initialization.

Verify the backend bucket exists:

```bash
gcloud storage buckets list | grep falcontf75
```

If the bucket does not exist, create it before running `terraform init`:

```bash
gcloud storage buckets create gs://falcontf75 \
  --location=us-central1 \
  --project=class75-michaelanunda
```

After the backend exists, Terraform can initialize against the remote GCS state backend.

---

## Deployment Instructions for 2-vpc.tf

The `2-vpc.tf` file enables required GCP APIs and creates custom VPC networks.

The file enables the following services:

- `compute.googleapis.com`
- `container.googleapis.com`

It also creates the following custom VPC networks:

- `main`
- `warrior-king`

The `main` VPC is defined using:

```hcl
resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}
```

The `warrior-king` VPC is defined using:

```hcl
resource "google_compute_network" "warrior-king" {
  name                            = "warrior-king"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}
```

Before applying this configuration, validate that the APIs can be enabled in the target project and that the VPC names do not already conflict with existing networks.

Check existing VPC networks:

```bash
gcloud compute networks list
```

Check enabled services:

```bash
gcloud services list --enabled \
  --filter="NAME:(compute.googleapis.com OR container.googleapis.com)"
```

---

## Deployment Instructions for Terraform Init

Run Terraform initialization from the root of the repository:

```bash
terraform init
```

This command performs the following actions:

- Downloads the required Terraform provider plugins.
- Initializes the Google provider.
- Configures the GCS backend.
- Prepares the working directory for Terraform operations.

Expected evidence captured in this repository:

```text
./deliverables/1_terraform_init.png
```

This screenshot should show successful Terraform initialization and backend configuration.

---

## Deployment Instructions for Terraform Validate

Run Terraform validation from the root of the repository:

```bash
terraform validate
```

This command checks whether the Terraform configuration is syntactically valid and internally consistent.

Expected evidence captured in this repository:

```text
./deliverables/2_terraform_validate.png
```

A successful validation confirms that Terraform can parse and evaluate the configuration files.

---

## Deployment Instructions for terraform plan > ./deliverables/04_10_2026_weekB_hw/plan.text

The lab requires exporting the Terraform plan output into a text file and storing it in the dated homework directory.

The repository currently lists the exported plan file as:

```text
./deliverables/04_10_2026_weekB_hw/plan.txt
```

To create the dated homework folder, run:

```bash
mkdir -p ./deliverables/04_10_2026_weekB_hw
```

To export the Terraform plan output to the existing listed artifact name, run:

```bash
terraform plan > ./deliverables/04_10_2026_weekB_hw/plan.txt
```

If the lab evaluator specifically requires the filename `plan.text`, use this command instead:

```bash
terraform plan > ./deliverables/04_10_2026_weekB_hw/plan.text
```

The recommended approach is to use one filename consistently across the repo, screenshots, Git commits, and README. Since the repository structure lists `plan.txt`, this README treats `plan.txt` as the primary deliverable.

Expected plan screenshots captured in this repository:

```text
./deliverables/3_terraform_plan_1.png
./deliverables/3a_terraform_plan_2.png
```

Expected exported plan file:

```text
./deliverables/04_10_2026_weekB_hw/plan.txt
```

The `terraform plan` command previews infrastructure changes before they are applied. This is a critical review step because it shows which resources Terraform intends to create, update, or destroy.

---

## Deployment Instructions for Terraform Apply

Run Terraform apply from the root of the repository:

```bash
terraform apply
```

Terraform will display the execution plan and prompt for confirmation.

When prompted, type:

```text
yes
```

This command provisions the resources defined in the Terraform configuration files.

Expected resources include:

- GCP Compute Engine persistent disk named `grafana-disk`.
- GCP custom VPC network named `main`.
- GCP custom VPC network named `warrior-king`.
- Required GCP APIs enabled or confirmed as enabled.

Expected evidence captured in this repository:

```text
./deliverables/4_terraform_apply_1.png
./deliverables/4a_terraform_apply_2.png
./deliverables/4b_terraform_apply_3.png
./deliverables/4c_terraform_apply_4.png
```

After apply completes, verify the resources in GCP:

```bash
gcloud compute disks list --filter="name=grafana-disk"
gcloud compute networks list --filter="name:(main OR warrior-king)"
```

---

## Deployment Instructions for Terraform Destroy

Run Terraform destroy from the root of the repository when the lab resources are no longer needed:

```bash
terraform destroy
```

Terraform will display the resources marked for destruction and prompt for confirmation.

When prompted, type:

```text
yes
```

This command tears down Terraform-managed infrastructure created during the lab.

Expected evidence captured in this repository:

```text
./deliverables/5_terraform_destroy_1.png
./deliverables/5a_terraform_destroy_2.png
./deliverables/5b_terraform_destroy_3.png
```

After destroy completes, verify that the resources are no longer present:

```bash
gcloud compute disks list --filter="name=grafana-disk"
gcloud compute networks list --filter="name:(main OR warrior-king)"
```

The expected result is that the Terraform-managed disk and VPC networks should no longer appear as active resources.

Note: The Terraform backend bucket is not destroyed by this Terraform configuration. The backend bucket must exist independently because Terraform requires it before initialization.

---

## Layout out of the Repository

The repository is organized as follows:

```text
05-week-05/
├── .gitignore
├── 0-authentication.tf
├── 1-backend.tf
├── 2-vpc.tf
├── README.md
└── deliverables/
    ├── 04_10_2026_weekB_hw/
    │   └── plan.txt
    ├── 1_terraform_init.png
    ├── 2_terraform_validate.png
    ├── 3_terraform_plan_1.png
    ├── 3a_terraform_plan_2.png
    ├── 4_terraform_apply_1.png
    ├── 4a_terraform_apply_2.png
    ├── 4b_terraform_apply_3.png
    ├── 4c_terraform_apply_4.png
    ├── 5_terraform_destroy_1.png
    ├── 5a_terraform_destroy_2.png
    └── 5b_terraform_destroy_3.png
```

### Root-level files

| File | Description |
|---|---|
| `.gitignore` | Defines files and folders that should not be tracked by Git. |
| `0-authentication.tf` | Configures the Google Terraform provider, target project, and region. |
| `1-backend.tf` | Configures the GCS backend and defines a persistent disk resource. |
| `2-vpc.tf` | Enables required GCP APIs and creates custom VPC networks. |
| `README.md` | Documents the lab purpose, workflow, commands, deliverables, and engineering philosophy. |

### Deliverables directory

| Path | Description |
|---|---|
| `deliverables/1_terraform_init.png` | Screenshot of `terraform init` output. |
| `deliverables/2_terraform_validate.png` | Screenshot of `terraform validate` output. |
| `deliverables/3_terraform_plan_1.png` | First screenshot of `terraform plan` output. |
| `deliverables/3a_terraform_plan_2.png` | Second screenshot of `terraform plan` output. |
| `deliverables/4_terraform_apply_1.png` | First screenshot of `terraform apply` output. |
| `deliverables/4a_terraform_apply_2.png` | Second screenshot of `terraform apply` output. |
| `deliverables/4b_terraform_apply_3.png` | Third screenshot of `terraform apply` output. |
| `deliverables/4c_terraform_apply_4.png` | Fourth screenshot of `terraform apply` output. |
| `deliverables/5_terraform_destroy_1.png` | First screenshot of `terraform destroy` output. |
| `deliverables/5a_terraform_destroy_2.png` | Second screenshot of `terraform destroy` output. |
| `deliverables/5b_terraform_destroy_3.png` | Third screenshot of `terraform destroy` output. |
| `deliverables/04_10_2026_weekB_hw/plan.txt` | Exported Terraform plan output. |

---

## Engineering philosophy from this lab

This lab reinforces an infrastructure engineering principle: **cloud resources should be declared, reviewed, applied, verified, and destroyed through a repeatable workflow.**

Terraform is not only a provisioning tool. It is also a control plane for change management. The `plan` phase provides an opportunity to inspect intent before execution. The `apply` phase converts reviewed intent into real infrastructure. The `destroy` phase proves that resources are lifecycle-managed and can be safely torn down when no longer required.

Capturing screenshots and exporting the Terraform plan output creates an audit trail. This matters in professional cloud environments because infrastructure work must be reproducible, reviewable, and accountable. A successful deployment is not just one where resources are created. A successful deployment is one where another engineer can inspect the repository, understand the workflow, reproduce the commands, validate the evidence, and trust the teardown process.

The practical engineering lesson from this lab is that disciplined infrastructure work depends on three things:

1. **Declarative configuration** — infrastructure is defined in code rather than manually assembled.
2. **Execution evidence** — command outputs and plan files are preserved for review.
3. **Lifecycle ownership** — resources are not only created, but also validated and destroyed cleanly.

This workflow reflects the operating model expected in DevOps, DevSecOps, SRE, and cloud engineering environments: automate deliberately, verify continuously, and leave behind documentation that makes the system understandable to the next engineer.