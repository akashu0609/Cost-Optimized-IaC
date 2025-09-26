#!/usr/bin/env bash
set -euo pipefail

# Simple load test against ALB DNS using Apache Benchmark (ab)
# Usage: ./scripts/load_test.sh <alb-dns-name> [requests] [concurrency]
# Example: ./scripts/load_test.sh my-alb-1234.us-east-1.elb.amazonaws.com 5000 50

ALB_DNS=${1:-}
REQUESTS=${2:-5000}
CONCURRENCY=${3:-50}
RESULTS_FILE="load_test_results_$(date +%Y%m%d_%H%M%S).txt"

if [[ -z "$ALB_DNS" ]]; then
  echo "ERROR: ALB DNS name is required."
  echo "Usage: $0 <alb-dns-name> [requests] [concurrency]"
  exit 1
fi

# Ensure 'ab' exists
if ! command -v ab >/dev/null 2>&1; then
  echo "ERROR: Apache Benchmark (ab) not found. Install via 'yum install httpd-tools' or 'apt-get install apache2-utils'."
  exit 1
fi

echo "Starting load test against http://$ALB_DNS/ ..."
echo "Requests: $REQUESTS | Concurrency: $CONCURRENCY"
ab -n "$REQUESTS" -c "$CONCURRENCY" "http://$ALB_DNS/" > "$RESULTS_FILE"

echo "Load test complete. Results saved to $RESULTS_FILE"
