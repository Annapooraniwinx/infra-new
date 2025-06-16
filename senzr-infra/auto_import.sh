#!/bin/bash

DIRECTUS_URL="http://ad5b1eb3b1fff4345bd4d4be7065213f-272763669.ap-south-1.elb.amazonaws.com:8000"
TOKEN="CdPAg71DiI_t8Kq_FXCMnCooBr4pu2cP"

# Extract all table names from schema.tf and create collections
grep -o 'resource "postgresql_table" "[^"]*"' schema.tf | cut -d'"' -f4 | while read table; do
    echo "Creating collection: $table"
    
    response=$(curl -s -X POST "$DIRECTUS_URL/collections" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"collection\": \"$table\",
            \"meta\": {
                \"collection\": \"$table\",
                \"icon\": \"table_chart\",
                \"note\": \"Imported from PostgreSQL table: $table\",
                \"hidden\": false,
                \"singleton\": false,
                \"accountability\": \"all\"
            }
        }")
    
    # Check if successful
    if echo "$response" | grep -q "error"; then
        echo "❌ Failed to create $table: $response"
    else
        echo "✅ Successfully created collection: $table"
    fi
    
    # Small delay between requests
    sleep 0.5
done

echo "🎉 Import script completed!"
