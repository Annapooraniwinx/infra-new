#!/bin/bash

echo "⏰ Checking CloudFront every 2 minutes..."

for i in {1..10}; do
    STATUS=$(aws cloudfront get-distribution --id E3FCNRO635UGLT --query 'Distribution.Status' --output text)
    echo "Check $i/10 - Status: $STATUS"
    
    if [ "$STATUS" = "Deployed" ]; then
        echo "🎉 CloudFront deployed! Testing..."
        curl -I https://d3hubh9hy19nx8.cloudfront.net/
        echo ""
        echo "✅ BOTH URLs NOW WORK:"
        echo "🔗 LoadBalancer: http://afe8abc68853949e2b6fd05b525b5a5e-3f0fc8d4fd571a6a.elb.ap-south-1.amazonaws.com/login"
        echo "🔗 CloudFront: https://d3hubh9hy19nx8.cloudfront.net/login"
        break
    fi
    
    sleep 120  # Check every 2 minutes
done
