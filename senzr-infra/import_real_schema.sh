#!/bin/bash

DIRECTUS_URL="http://ad5b1eb3b1fff4345bd4d4be7065213f-272763669.ap-south-1.elb.amazonaws.com:8000"
TOKEN="CdPAg71DiI_t8Kq_FXCMnCooBr4pu2cP"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Importing Real Schema to Directus${NC}"
echo "====================================="

# Extract table names from the real schema file using the correct pattern
echo -e "${YELLOW}📋 Extracting table names from real schema...${NC}"

# Your schema has comments like "# Table: AttendanceSetting" followed by resource definitions
tables=$(grep "^# Table:" real_schema.tf | \
         sed 's/^# Table: //' | \
         sort | uniq)

if [ -z "$tables" ]; then
    echo -e "${RED}❌ No tables found with '# Table:' pattern${NC}"
    echo "Trying alternative pattern..."
    
    # Try extracting from resource names
    tables=$(grep '^resource "postgresql_table"' real_schema.tf | \
             sed 's/resource "postgresql_table" "\([^"]*\)".*/\1/' | \
             sort | uniq)
fi

if [ -z "$tables" ]; then
    echo -e "${RED}❌ No tables found in schema${NC}"
    echo "Let's check the file format:"
    head -10 real_schema.tf
    exit 1
fi

echo -e "${GREEN}✅ Found $(echo "$tables" | wc -l) tables:${NC}"
echo "$tables" | head -20 | sed 's/^/  - /'
if [ $(echo "$tables" | wc -l) -gt 20 ]; then
    echo "  ... and $(($(echo "$tables" | wc -l) - 20)) more"
fi

# Create collections in Directus
echo -e "${YELLOW}🏗️  Creating collections in Directus...${NC}"

success_count=0
total_count=$(echo "$tables" | wc -l)

for table in $tables; do
    echo -n "Creating: $table ... "
    
    response=$(curl -s -X POST "$DIRECTUS_URL/collections" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"collection\": \"$table\",
            \"meta\": {
                \"collection\": \"$table\",
                \"icon\": \"table_chart\",
                \"note\": \"Imported from PostgreSQL schema\",
                \"display_template\": \"{{id}}\",
                \"hidden\": false,
                \"singleton\": false
            }
        }")
    
    if echo "$response" | grep -q '"data"' || echo "$response" | grep -q '"collection":"'$table'"'; then
        echo -e "${GREEN}✅${NC}"
        ((success_count++))
    elif echo "$response" | grep -q 'already exists'; then
        echo -e "${YELLOW}⚠️  (exists)${NC}"
        ((success_count++))
    else
        echo -e "${RED}❌${NC}"
        echo "    Error: $(echo "$response" | head -c 100)"
    fi
    
    sleep 0.2
done

echo ""
echo "====================================="
echo -e "${BLUE}📊 Import Summary${NC}"
echo "Total tables: $total_count"
echo -e "Successfully processed: ${GREEN}$success_count${NC}"
echo -e "Failed: ${RED}$((total_count - success_count))${NC}"

if [ $success_count -gt 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Schema import completed!${NC}"
    echo -e "Visit: ${BLUE}$DIRECTUS_URL${NC}"
    echo "Collections created from your PostgreSQL schema!"
fi
