#!/usr/bin/env bash
# A $1 monthly budget that emails you at 80%. Run it before you close the laptop.
#   usage: bash scripts/budget-alarm.sh you@example.com
set -euo pipefail

EMAIL="${1:?usage: budget-alarm.sh <your-email>}"
ACCOUNT="$(aws sts get-caller-identity --query Account --output text)"

cat > /tmp/budget.json <<JSON
{
  "BudgetName": "localhost-guardrail",
  "BudgetLimit": { "Amount": "1", "Unit": "USD" },
  "TimeUnit": "MONTHLY",
  "BudgetType": "COST"
}
JSON

cat > /tmp/notifications.json <<JSON
[{
  "Notification": {
    "NotificationType": "ACTUAL",
    "ComparisonOperator": "GREATER_THAN",
    "Threshold": 80,
    "ThresholdType": "PERCENTAGE"
  },
  "Subscribers": [{ "SubscriptionType": "EMAIL", "Address": "${EMAIL}" }]
}]
JSON

aws budgets create-budget \
  --account-id "$ACCOUNT" \
  --budget file:///tmp/budget.json \
  --notifications-with-subscribers file:///tmp/notifications.json

echo "==> budget set. You get an email if this account passes \$0.80 in a month."
