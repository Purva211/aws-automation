# ☁️ AWS Automation Using Shell Scripting

A simple **Bash Shell Script** that automates basic AWS resource checks and generates a useful report.

The script uses the **AWS CLI** to collect information about your AWS account and resources such as EC2, S3, Lambda, and IAM.
![Uploading ChatGPT Image Sep 16, 2026, 03_29_07 PM.png…]()

## ✨ Features

* ✅ Checks whether AWS CLI is installed
* 🔐 Verifies AWS authentication
* 🖥️ Counts running EC2 instances
* 🪣 Counts S3 buckets
* ⚡ Counts Lambda functions
* 👤 Counts IAM users
* 📝 Creates an execution log
* 📊 Generates an AWS resource report
* 🧹 Uses `trap` for cleanup and interruption handling

## 📁 Project Structure

```text
aws-automation/
│
├── aws_automation.sh
├── logs/
│   └── aws_task.log
│
├── reports/
│   └── aws_report.txt
│
└── README.md
```

## 🛠️ Requirements

Before running the script, make sure you have:

* Linux / WSL
* Bash
* AWS CLI
* Configured AWS credentials

Configure AWS:

```bash
aws configure
```

## ▶️ How to Run

Give the script execution permission:

```bash
chmod +x aws_automation.sh
```

Run the script:

```bash
./aws_automation.sh
```

## 📄 Output

After execution, the script creates:

**Log file**

```text
logs/aws_task.log
```

Contains information about the script execution and errors.

**Report file**

```text
reports/aws_report.txt
```

Contains:

* AWS Account ID
* User ARN
* Running EC2 instances
* S3 bucket count
* Lambda function count
* IAM user count
* EC2 instance IDs

## 🔄 Workflow

```text
Start
  ↓
Check AWS CLI
  ↓
Check AWS Credentials
  ↓
Fetch AWS Resources
  ↓
EC2 | S3 | Lambda | IAM
  ↓
Generate Log & Report
  ↓
Finish
```

## 🎯 Purpose

This project demonstrates how **Shell Scripting + AWS CLI** can be used to automate repetitive cloud management tasks and create simple resource reports.

## 🚀 Future Improvements

* Add more AWS services
* Export reports as CSV/JSON
* Add email notifications
* Add scheduled execution using Cron
* Add resource cost information

---

### 💡 Learning

> **Shell Script + AWS CLI = Simple Cloud Automation**

Made with ❤️ using **Bash and AWS CLI**.
