#!/bin/bash

# Fail on any error
set -e

IMAGE_NAME="prudhviraj310/node-app:latest"

echo "🔍 Running Trivy image scan for $IMAGE_NAME ..."
trivy image --exit-code 1 --severity HIGH,CRITICAL $IMAGE_NAME

if [ $? -eq 0 ]; then
    echo "✅ No critical/high vulnerabilities found."
else
    echo "❌ Vulnerabilities detected!"
    exit 1
fi
