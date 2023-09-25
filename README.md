# TF-Nginx-End-to-End

## Overview

This project makes use of AWS, Terraform, Git and GitHub Actions to deploy a Nginx Web Application in 3 different environments - Dev, Prod and Staging.

The main focuses of this project were:

- Creating custom, reusable modules for the VPC and WebApp components.
- Using GitHub Actions workflows to enable automatic infrastructure updates when code is pushed to/pulled from the master branch.
- Taking advantage of best practices for security and network design to deploy resources on AWS.
