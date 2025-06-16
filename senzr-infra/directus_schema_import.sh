#!/bin/bash

# Directus Schema Import Script
# This script reads your schema.tf file and creates collections in Directus

# Configuration
DIRECTUS_URL="http://ad5b1eb3b1fff4345bd4d4be7065213f-272763669.ap-south-1.elb.amazonaws.com:8000"
TOKEN="CdPAg71DiI_t8Kq_FXCMnCooBr4pu2cP"
SCHEMA_FILE="schema.tf"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Directus Schema Import Script${NC}"
echo "=================================="

# Extract table names from schema.tf
echo -e "${YELLOW}📋 Extracting table names from schema.tf...${NC}"

# Look for different patterns in your schema file
tables=$(grep -E '^resource\s+"[^"]+"\s+"[^"]+"' "$SCHEMA_FILE" | \
         grep -v 'postgresql_' | \
         grep -v 'directus_' | \
         sed 's/resource "[^"]*" "\([^"]*\)".*/\1/' | \
         sort | uniq)

if [ -z "$tables" ]; then
    echo -e "${YELLOW}⚠️  No standard table resources found. Checking for other patterns...${NC}"
    
    # Try to find other patterns
    echo "Content of schema.tf:"
    cat "$SCHEMA_FILE"
    
    echo ""
    echo -e "${BLUE}💡 It looks like your schema.tf contains database setup, not table definitions.${NC}"
    echo "Do you have another file with your actual table schemas?"
    echo ""
    echo "Available .tf files:"
    find . -name "*.tf" -type f
    
    exit 1
fi

echo -e "${GREEN}✅ Found tables:${NC}"
echo "$tables" | sed 's/^/  - /'

# Create collections in Directus
echo -e "${YELLOW}��️  Creating collections in Directus...${NC}"

success_count=0
total_count=$(echo "$tables" | wc -l)

for table in $tables; do
    echo -n "Creating collection: $table ... "
    
    response=$(curl -s -X POST "$DIRECTUS_URL/collections" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"collection\": \"$table\",
            \"meta\": {
                \"collection\": \"$table\",
                \"icon\": \"table_chart\",
                \"note\": \"Imported from schema.tf\",
                \"display_template\": \"{{id}}\",
                \"hidden\": false,
                \"singleton\": false
            }
        }")
    
    if echo "$response" | grep -q '"data"'; then
        echo -e "${GREEN}✅${NC}"
        ((success_count++))
    else
        echo -e "${RED}❌${NC}"
        echo "    Error: $(echo "$response" | head -c 100)"
    fi
    
    sleep 0.5
done

echo ""
echo "=================================="
echo -e "${BLUE}📊 Import Summary${NC}"
echo "Total tables found: $total_count"
echo -e "Successfully created: ${GREEN}$success_count${NC}"
echo -e "Failed: ${RED}$((total_count - success_count))${NC}"

if [ $success_count -gt 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Success! Visit your Directus admin panel to see the collections${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  No new collections were created${NC}"
fi
