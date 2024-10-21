# Zillow Real Estate ETL Pipeline

## Overview

This project provisions an AWS Glue ETL pipeline to automate the extraction, transformation, and loading (ETL) of Zillow real estate data using Terraform. The pipeline is designed to fetch property listings from the Zillow API, process the data, and store it in Amazon S3 for further analysis and insights.

## Features

- **Infrastructure-as-Code (IaC):** All resources are provisioned using Terraform, enabling easy deployment and management.
- **Automated Data Pipeline:** The pipeline fetches real estate data from Zillow, processes it, and stores the output in S3.
- **AWS Glue Integration:** Uses AWS Glue for ETL operations, ensuring scalable and efficient data processing.
- **S3 Storage:** Processed data is saved in S3, organized by location and date, facilitating downstream analytics and reporting.

## Architecture

The ETL pipeline consists of the following components:

1. **AWS Glue Jobs:** Orchestrates the ETL process by running scripts that extract data from the Zillow API, transform the data, and load it into S3.
2. **Amazon S3:** Stores the raw and processed data in a structured format.
3. **Terraform:** Provisions and manages AWS resources, including Glue jobs, IAM roles, and S3 buckets.
4. **Lambda Functions:** Supports additional tasks such as organizing the S3 structure and scheduling Glue jobs.

## Prerequisites

Before deploying the infrastructure, make sure you have:

- **Terraform** installed on your local machine. You can download it [here](https://www.terraform.io/downloads.html).
- **AWS CLI** configured with appropriate access permissions.
- **API Key** for accessing Zillow property data.

## Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/zillow-real-estate-glue-pipeline.git
   cd zillow-real-estate-glue-pipeline
   ```

2. **Configure Environment Variables:**

   Create a `.env` file to store your environment variables:

   ```bash
   DST_BUCKET="your-s3-bucket-name"
   REGION="your-aws-region"
   RAW_FOLDER="your-raw-folder-name"
   API_KEY="your-zillow-api-key"
   API_HOST="zillow-com1.p.rapidapi.com"
   ```

3. **Initialize Terraform:**

   ```bash
   terraform init
   ```

4. **Provision the Infrastructure:**

   ```bash
   terraform apply
   ```

   Follow the prompts to review and confirm the changes.

5. **Deploy the ETL Scripts:**

   Make sure your AWS Glue scripts and Lambda functions are packaged and accessible for deployment.

## Usage

1. **Run the AWS Glue Job:**
   Once the infrastructure is provisioned, trigger the AWS Glue job from the AWS Console or by scheduling it through a CloudWatch event.

2. **Monitor Logs:**
   Monitor the progress and logs of the Glue job and Lambda functions using Amazon CloudWatch.

3. **Access Data:**
   Processed data will be available in your specified S3 bucket, organized by state, city, and date.

## Project Structure

```
zillow-real-estate-glue-pipeline/
│
├── .gitignore                          # Ignore unnecessary files and directories
├── requirements.txt                    # Python dependencies for ETL and Lambda
│
├── etl/                                # ETL-related scripts and configurations
│   ├── extract/                        # Extraction module
│   │   ├── System/                    # System configurations and helper scripts
│   │   │   ├── LocalLocation.py
│   │   │   ├── loaction.py
│   │   │   └── workspace.py
│   │   ├── __init__.py                 # Init file for the extract module
│   │   ├── extract_data.py             # Main script to extract data from API
│   │   └── system_config.yml           # YAML configuration for the extraction process
│   │
│   └── glue_job/                       # AWS Glue job scripts
│       └── transform_data.py           # Transformation script executed by Glue job
│
├── infrastructure/                     # Terraform infrastructure code
│   ├── backend/                        # Terraform backend configuration (state management)
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   │
│   ├── modules/                        # Modularized Terraform configurations
│   │   ├── eventbridge/                # EventBridge rules and triggers
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   │
│   │   ├── glue/                       # AWS Glue components
│   │   │   ├── catalog_database/       # Glue Catalog Database resources
│   │   │   │   ├── main.tf
│   │   │   │   ├── outputs.tf
│   │   │   │   └── variables.tf
│   │   │   ├── classifier/             # Glue Classifier resources
│   │   │   │   ├── main.tf
│   │   │   │   ├── output.tf
│   │   │   │   └── variables.tf
│   │   │   ├── crawler/                # Glue Crawler resources
│   │   │   │   ├── main.tf
│   │   │   │   ├── outputs.tf
│   │   │   │   └── variables.tf
│   │   │   ├── iam_role/               # IAM roles for Glue jobs
│   │   │   │   ├── main.tf
│   │   │   │   ├── output.tf
│   │   │   │   └── variables.tf
│   │   │   ├── job/                    # Glue job configuration
│   │   │   │   ├── main.tf
│   │   │   │   ├── outputs.tf
│   │   │   │   └── variables.tf
│   │   │   ├── trigger/                # Glue triggers to automate job runs
│   │   │   │   ├── main.tf
│   │   │   │   ├── outputs.tf
│   │   │   │   └── variables.tf
│   │   │
│   │   ├── lambda/                     # Lambda functions and configurations
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   │
│   │   ├── request_layer/              # Lambda layer for requests library
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   │
│   │   └── s3/                         # S3 bucket configurations
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   │
│   ├── locals.tf                       # Local variables for infrastructure settings
│   └── main.tf                         # Main Terraform configuration entry point
│
└── README.md                           # Project documentation
```

### Explanation:

- **`etl/`**: Contains all ETL-related scripts and configurations. The `extract` folder focuses on data extraction logic, while `glue_job` has transformation scripts run by AWS Glue.
- **`infrastructure/`**: Contains Terraform code, organized modularly for maintainability and scalability. The `backend` folder manages state configurations, while `modules` encapsulate individual AWS services (e.g., EventBridge, Glue, Lambda, S3).
- **`requirements.txt`**: Manages Python dependencies for the ETL scripts and Lambda functions.
- **`README.md`**: Documentation describing the project, setup instructions, and usage details.
- **`.gitignore`**: Specifies files and directories to exclude from version control.

## Contributing

Feel free to fork this repository and submit pull requests. Contributions, enhancements, and bug fixes are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
