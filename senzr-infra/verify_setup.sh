#!/bin/bash

# Setup Verification Script
# This script checks your current setup and guides you through the connection process

# Configuration
DIRECTUS_URL="http://ad5b1eb3b1fff4345bd4d4be7065213f-272763669.ap-south-1.elb.amazonaws.com:8000"
TOKEN="CdPAg71DiI_t8Kq_FXCMnCooBr4pu2cP"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Setup Verification Script${NC}"
echo "=============================="

# Check 1: Current directory files
echo -e "${YELLOW}📁 Checking current directory...${NC}"
echo "Current directory: $(pwd)"
echo "Files in directory:"
ls -la | grep -E '\.(tf|txt|sh)$' || echo "No .tf, .txt, or .sh files found"

# Check 2: Look for schema.tf
echo ""
echo -e "${YELLOW}📋 Looking for schema.tf...${NC}"
if [ -f "schema.tf" ]; then
    echo -e "${GREEN}✅ Found schema.tf${NC}"
    echo "File size: $(ls -lh schema.tf | awk '{print $5}')"
    echo "First 5 lines:"
    head -5 schema.tf
    echo "..."
    echo "Resource count: $(grep -c '^resource' schema.tf)"
else
    echo -e "${RED}❌ schema.tf not found${NC}"
    echo ""
    echo "Available .tf files:"
    find . -name "*.tf" -type f | head -10
fi

# Check 3: Test Directus connection
echo ""
echo -e "${YELLOW}📡 Testing Directus connection...${NC}"
connection_test=$(curl -s -w "HTTP_CODE:%{http_code}" -X GET "$DIRECTUS_URL/server/info" \
    -H "Authorization: Bearer $TOKEN")

http_code=$(echo "$connection_test" | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2)
response_body=$(echo "$connection_test" | sed 's/HTTP_CODE:[0-9]*$//')

if [ "$http_code" = "200" ]; then
    echo -e "${GREEN}✅ Directus connection successful${NC}"
    project_name=$(echo "$response_body" | grep -o '"project_name":"[^"]*"' | cut -d'"' -f4)
    directus_version=$(echo "$response_body" | grep -o '"directus_version":"[^"]*"' | cut -d'"' -f4)
    echo "Project: $project_name"
    echo "Version: $directus_version"
else
    echo -e "${RED}❌ Directus connection failed${NC}"
    echo "HTTP Code: $http_code"
    echo "Response: $response_body"
fi

# Check 4: Current collections in Directus
echo ""
echo -e "${YELLOW}📊 Checking existing collections...${NC}"
collections_response=$(curl -s -X GET "$DIRECTUS_URL/collections" \
    -H "Authorization: Bearer $TOKEN")

if echo "$collections_response" | grep -q '"data"'; then
    echo -e "${GREEN}✅ Successfully retrieved collections${NC}"
    collection_count=$(echo "$collections_response" | grep -o '"collection":"[^"]*"' | wc -l)
    echo "Total collections: $collection_count"
    
    echo "Collections list:"
    echo "$collections_response" | grep -o '"collection":"[^"]*"' | cut -d'"' -f4 | head -20 | sed 's/^/  - /'
    
    if [ $collection_count -gt 20 ]; then
        echo "  ... and $((collection_count - 20)) more"
    fi
else
    echo -e "${RED}❌ Failed to retrieve collections${NC}"
    echo "Response: $(echo "$collections_response" | head -c 200)"
fi

# Check 5: Create quick fix if needed
if [ ! -f "schema.tf" ] && [ -f "paste.txt" ]; then
    echo ""
    echo -e "${YELLOW}🔧 Found paste.txt - checking if it contains schema...${NC}"
    
    if grep -q '^resource' paste.txt; then
        echo -e "${GREEN}✅ paste.txt contains Terraform resources${NC}"
        echo "Creating schema.tf from paste.txt..."
        cp paste.txt schema.tf
        echo -e "${GREEN}✅ Created schema.tf${NC}"
    else
        echo -e "${RED}❌ paste.txt doesn't contain Terraform resources${NC}"
        echo "First few lines of paste.txt:"
        head -5 paste.txt
    fi
fi

echo ""
echo -e "${BLUE}💡 Status Summary:${NC}"
if [ -f "schema.tf" ] && [ "$http_code" = "200" ]; then
    echo -e "${GREEN}🎉 Ready to import! All checks passed.${NC}"
else
    echo -e "${YELLOW}⚠️  Some issues found - see details above${NC}"
fi
