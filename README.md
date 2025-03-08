# skill_test_3
Terraform Deployment for Frontend, Backend, and MongoDB
This project demonstrates how to deploy an infrastructure on AWS using Terraform. It includes the following components:

Frontend EC2 Instance (Running React app)
Backend EC2 Instance (Running Node.js app)
MongoDB EC2 Instance (Running MongoDB database)
Project Overview
In this project, we use Terraform to deploy the following resources on AWS:

Frontend Instance: An EC2 instance running a React application.
Backend Instance: An EC2 instance running a Node.js backend application.
MongoDB Instance: An EC2 instance running MongoDB to store the data.
Security Group Rules
To ensure secure communication between the instances, we have created necessary Security Group Rules for each instance:

Frontend Instance:

Port 22: SSH access to the instance.
Port 80: HTTP access for the frontend.
Port 3000: Port for React application.
Backend Instance:

Port 22: SSH access to the instance.
Port 80: HTTP access for the backend.
Port 3001: Port for the backend application.
MongoDB Instance:

Port 27017: MongoDB port, open to communication from the backend instance.
These security rules are applied using Terraform.

User Data Configuration
For each EC2 instance (Frontend, Backend, MongoDB), Terraform’s user_data configuration is used to automatically install necessary packages on instance launch.

Frontend and Backend EC2 Instances:

Git: Installed to clone the GitHub repository.
Node.js & npm: Installed for running the React and Node.js apps.
MongoDB EC2 Instance:

MongoDB: Installed to run the database.
Database Creation: A database named travelmemory is created in MongoDB.
MongoDB User: An admin user is created to access the database.
After the instances are set up, the .env files are updated with the necessary configuration:

Frontend .env: Contains the BACKEND_URL pointing to the backend public IP address and port 3001.
Backend .env: Contains the MONGO_URI pointing to the MongoDB instance and port 27017.
Jenkins Pipeline for Continuous Deployment
To automate the deployment process:

A Jenkins pipeline is created to fetch the Terraform scripts from the GitHub repository.
AWS Credentials are used in the Jenkins pipeline to interact with AWS resources securely.
The Jenkins pipeline executes the Terraform commands (terraform init and terraform apply) to create the infrastructure.
A GitHub Webhook is set up to automatically trigger the Jenkins pipeline whenever changes are pushed to the GitHub repository.
Jenkinsfile
The Jenkinsfile contains the necessary steps to:

Clone the repository.
Configure AWS credentials.
Initialize and apply Terraform configurations.
Steps to Set Up
Clone the GitHub Repository:

bash
Copy
git clone https://github.com/shivamsonari376/skill_test_3.git
cd skill_test_3
Configure AWS Credentials in Jenkins:

In Jenkins, go to Manage Jenkins > Manage Credentials and add your AWS Access Key ID and Secret Access Key.
Set Up Jenkins Pipeline:

Create a Jenkins Pipeline job and configure it to use the Jenkinsfile from the GitHub repository.
Set up a GitHub Webhook to trigger the pipeline whenever changes are made to the repository.
Run the Jenkins Job:

Trigger the Jenkins pipeline manually or automatically via the GitHub Webhook to deploy the infrastructure.
Conclusion
This project demonstrates an automated way to deploy and configure a full-stack application with a frontend, backend, and MongoDB database using Terraform and Jenkins. The infrastructure is set up with proper security rules, and the deployment is automated with continuous integration via Jenkins and GitHub webhooks.
