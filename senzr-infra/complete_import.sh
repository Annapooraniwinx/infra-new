#!/bin/bash

DIRECTUS_URL="http://ad5b1eb3b1fff4345bd4d4be7065213f-272763669.ap-south-1.elb.amazonaws.com:8000"
TOKEN="CdPAg71DiI_t8Kq_FXCMnCooBr4pu2cP"

echo "🚀 Starting complete schema import..."

# If you have paste.txt file, extract from it
if [ -f "paste.txt" ]; then
    echo "📁 Found paste.txt, extracting tables..."
    tables=$(grep -o 'resource "postgresql_table" "[^"]*"' paste.txt | cut -d'"' -f4)
else
    # Otherwise use the hardcoded list from your schema
    tables="AttendanceSetting AttendanceSetting_branch AttendanceSetting_mon AttendanceSetting_shifts AttendanceSetting_shifts_1 AttendanceSetting_shifts_2 AttendanceSetting_shifts_3 AttendanceSetting_shifts_4 AttendanceSetting_shifts_5 AttendanceSetting_shifts_6 AttendanceSetting_shifts_7 Crops FAQ SalaryBreakdown accesslevels accesslevels_branch accesslevels_branch_1 accesslevels_doors_2 accesslevels_holiday accesslevels_time accesslevels_translations accessusers actions actions_personalModule actions_personalModule_1 actions_personalModule_2 actions_personalModule_3 aiFaceId alert alert_directus_roles alert_notifications alert_notifications_1 attendance attendanceCycle attendancePolicies attendance_holiday attendance_inn attendance_personalModule bgVerification bookmark branch branch_holiday cardManagement carryForward company config config_AttendanceSetting config_AttendanceSetting_1 config_holiday controllers controllers_accesslevels controllers_branch controllers_directus_users controllers_doors controllers_doors_1 countryCode cronJobs customers customersProducts customersProducts_assigned dealers department deviceManager deviceManager_accesslevels deviceManager_branch deviceManager_department doors doors_accesslevels doors_department doors_tenant expenseReimbursement expenseReimbursement_files export faceId facialData flexibleShift flexibleShift_shifts holiday holiday_branch import junction_directus_users_previousRecord languages leave leaveRequest leaveSetting liveTracking location_actions logs logs_personalModule logs_personalModule_1 logs_personalModule_2 model notifications payment payrollVerification personalModule personalModule_AttendanceSetting personalModule_accesslevels personalModule_accesslevels_1 personalModule_accesslevels_2 personalModule_accesslevels_3 personalModule_aiFaceId personalModule_branch personalModule_branch_1 personalModule_branch_2 personalModule_branch_3 personalModule_branch_4 personalModule_cardId personalModule_cardManagement personalModule_cardManagement_1 personalModule_cardManagement_2 personalModule_cardManagement_3 personalModule_ddff personalModule_department personalModule_department_1 personalModule_department_2 personalModule_holiday personalModule_previousRecord personalModule_salarySetting personalModule_salarySetting_1 personalModule_time personalModule_time_1 personalModule_time_2 personalModule_time_3 personalModule_time_4 perviousPolicy posts previousRecord prodCategory products profile projectTracker projectTracker_directus_users questions salarySetting salarySetting_branch salarySetting_tax serviceManual servicePerson shifts status subscribe tasks tax tdsDeduction tdsDeduction_files tdsDeduction_files_1 tdsRules tenant tenant_doors ticket ticket_controllers ticket_controllers_1 time transport trial4 userManuals userManuals_controllers visitor"
fi

count=0
total=$(echo $tables | wc -w)

for table in $tables; do
    ((count++))
    echo "[$count/$total] Creating collection: $table"
    
    response=$(curl -s -X POST "$DIRECTUS_URL/collections" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"collection\": \"$table\",
            \"meta\": {
                \"collection\": \"$table\",
                \"icon\": \"table_chart\",
                \"note\": \"Imported PostgreSQL table: $table\",
                \"hidden\": false,
                \"singleton\": false,
                \"accountability\": \"all\"
            }
        }")
    
    if echo "$response" | grep -q '"data"'; then
        echo "    ✅ Success"
    else
        echo "    ❌ Failed: $(echo "$response" | head -c 50)..."
    fi
    
    sleep 0.2
done

echo ""
echo "🎉 Import completed! Created collections for $total tables."
echo "🔍 Check your Directus Data Model now!"
