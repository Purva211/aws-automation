#!/bin/bash

# ============================================================
# AWS Automation Using Shell Scripting
# ============================================================

# ---------------------- Configuration -----------------------

LOG_DIR="./logs"
REPORT_DIR="./reports"

LOG_FILE="$LOG_DIR/aws_task.log"
REPORT_FILE="$REPORT_DIR/aws_report.txt"

DATE=$(date "+%Y-%m-%d %H:%M:%S")

# ---------------------- Create Directories ------------------

mkdir -p "$LOG_DIR"
mkdir -p "$REPORT_DIR"

# ---------------------- Logging Function --------------------

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ---------------------- Cleanup ------------------------------

cleanup() {
    log "Script execution finished."
}

# Run cleanup when script exits
trap cleanup EXIT

# Handle Ctrl+C / termination
trap 'log "Script interrupted by user."; exit 1' SIGINT SIGTERM


# ============================================================
# START
# ============================================================

log "AWS Automation Script Started"

echo ""
echo "------------------------------------------"
echo "        AWS AUTOMATION REPORT"
echo "------------------------------------------"
echo ""

echo "Execution Time: $DATE"

# ============================================================
# Check AWS CLI
# ============================================================

log "Checking AWS CLI..."

if ! command -v aws &> /dev/null
then
    log "ERROR: AWS CLI is not installed."
    echo ""
    echo "Please install AWS CLI first."
    exit 1
fi

log "AWS CLI is installed."


# ============================================================
# Check AWS Authentication
# ============================================================

log "Checking AWS credentials..."

if ! aws sts get-caller-identity &> /dev/null
then
    log "ERROR: AWS credentials are not configured."
    echo ""
    echo "Please run:"
    echo "aws configure"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity \
    --query "Account" \
    --output text)

USER_ARN=$(aws sts get-caller-identity \
    --query "Arn" \
    --output text)

log "AWS authentication successful."
log "Account ID: $ACCOUNT_ID"


# ============================================================
# EC2 INFORMATION
# ============================================================

log "Fetching EC2 information..."

EC2_RUNNING=$(aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text)

if [ -z "$EC2_RUNNING" ] || [ "$EC2_RUNNING" = "None" ]
then
    EC2_COUNT=0
else
    EC2_COUNT=$(echo "$EC2_RUNNING" | wc -w)
fi

echo "EC2 Running Instances : $EC2_COUNT"

log "Running EC2 instances: $EC2_COUNT"


# ============================================================
# S3 INFORMATION
# ============================================================

log "Fetching S3 buckets..."

S3_BUCKETS=$(aws s3 ls 2>/dev/null | wc -l)

echo "S3 Buckets            : $S3_BUCKETS"

log "S3 buckets: $S3_BUCKETS"


# ============================================================
# LAMBDA INFORMATION
# ============================================================

log "Fetching Lambda functions..."

LAMBDA_COUNT=$(aws lambda list-functions \
    --query "length(Functions)" \
    --output text)

echo "Lambda Functions      : $LAMBDA_COUNT"

log "Lambda functions: $LAMBDA_COUNT"


# ============================================================
# IAM INFORMATION
# ============================================================

log "Fetching IAM information..."

IAM_USERS=$(aws iam list-users \
    --query "length(Users)" \
    --output text)

echo "IAM Users             : $IAM_USERS"

log "IAM users: $IAM_USERS"


# ============================================================
# GENERATE REPORT
# ============================================================

log "Generating report..."

cat > "$REPORT_FILE" <<EOF
==========================================
        AWS AUTOMATION REPORT
==========================================

Execution Time : $DATE
AWS Account    : $ACCOUNT_ID
Identity       : $USER_ARN

------------------------------------------
AWS RESOURCES
------------------------------------------

EC2 Running Instances : $EC2_COUNT
S3 Buckets            : $S3_BUCKETS
Lambda Functions      : $LAMBDA_COUNT
IAM Users             : $IAM_USERS

------------------------------------------
EC2 INSTANCE IDs
------------------------------------------

$EC2_RUNNING

==========================================
Report Generated Successfully
==========================================
EOF


# ============================================================
# FINAL OUTPUT
# ============================================================

log "Report generated: $REPORT_FILE"

echo ""
echo "=========================================="
echo "     AWS AUTOMATION COMPLETED"
echo "=========================================="
echo ""
echo "Report generated successfully!"
echo "Location: $REPORT_FILE"
echo "Log:      $LOG_FILE"
echo ""
echo "=========================================="

log "AWS Automation Script Completed."
