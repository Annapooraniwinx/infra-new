# Terraform configuration generated from Directus schema
# Generated on: 2025-06-06T11:22:49.984Z
# Directus version: 11.6.1
# Database vendor: postgres

terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.0"
    }
  }
}

# Table: AttendanceSetting
resource "postgresql_table" "AttendanceSetting" {
  name      = "AttendanceSetting"
  schema    = "public"
  
  column {
    name = "id"
    type = "INTEGER"
    not_null = true
    default = "nextval('\"AttendanceSetting_id_seq\"'::regclass)"
  }
  
  column {
    name = "status"
    type = "VARCHAR(255)"
    not_null = true
    default = "draft"
  }
  
  column {
    name = "sort"
    type = "INTEGER"
  }
  
  column {
    name = "user_created"
    type = "UUID"
  }
  
  column {
    name = "date_created"
    type = "TIMESTAMP"
  }
  
  column {
    name = "user_updated"
    type = "UUID"
  }
  
  column {
    name = "date_updated"
    type = "TIMESTAMP"
  }
  
  column {
    name = "tenant"
    type = "UUID"
  }
  
  column {
    name = "photoEntry"
    type = "BOOLEAN"
  }
  
  column {
    name = "configName"
    type = "VARCHAR(255)"
  }
}

# Table: branch
resource "postgresql_table" "branch" {
  name      = "branch"
  schema    = "public"
  
  column {
    name = "id"
    type = "INTEGER"
    not_null = true
    default = "nextval('branch_id_seq'::regclass)"
  }
  
  column {
    name = "status"
    type = "VARCHAR(255)"
    not_null = true
    default = "draft"
  }
  
  column {
    name = "branchId"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "branchName"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "address"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "lat"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "lng"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "tenant"
    type = "UUID"
  }
}

# Table: personalModule
resource "postgresql_table" "personalModule" {
  name      = "personalModule"
  schema    = "public"
  
  column {
    name = "id"
    type = "INTEGER"
    not_null = true
    default = "nextval('\"personalModule_id_seq\"'::regclass)"
  }
  
  column {
    name = "status"
    type = "VARCHAR(255)"
    default = "inactive"
  }
  
  column {
    name = "employeeId"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "accessOn"
    type = "BOOLEAN"
  }
  
  column {
    name = "assignedUser"
    type = "UUID"
  }
}

# Table: attendance
resource "postgresql_table" "attendance" {
  name      = "attendance"
  schema    = "public"
  
  column {
    name = "id"
    type = "INTEGER"
    not_null = true
    default = "nextval('attendance_id_seq'::regclass)"
  }
  
  column {
    name = "status"
    type = "VARCHAR(255)"
    not_null = true
    default = "draft"
  }
  
  column {
    name = "inTime"
    type = "TIME"
  }
  
  column {
    name = "outTime"
    type = "TIME"
  }
  
  column {
    name = "date"
    type = "DATE"
  }
  
  column {
    name = "attendance"
    type = "VARCHAR(255)"
    not_null = true
  }
  
  column {
    name = "employeeId"
    type = "INTEGER"
  }
  
  column {
    name = "tenant"
    type = "UUID"
  }
}

# Table: leave
resource "postgresql_table" "leave" {
  name      = "leave"
  schema    = "public"
  
  column {
    name = "id"
    type = "INTEGER"
    not_null = true
    default = "nextval('leave_id_seq'::regclass)"
  }
  
  column {
    name = "status"
    type = "VARCHAR(255)"
    not_null = true
    default = "draft"
  }
  
  column {
    name = "leaveBalance"
    type = "JSONB"
    default = "[object Object]"
  }
  
  column {
    name = "assignedTo"
    type = "INTEGER"
  }
}

# Table: department
resource "postgresql_table" "department" {
  name      = "department"
  schema    = "public"
  
  column {
    name = "id"
    type = "INTEGER"
    not_null = true
    default = "nextval('department_id_seq'::regclass)"
  }
  
  column {
    name = "status"
    type = "VARCHAR(255)"
    not_null = true
    default = "draft"
  }
  
  column {
    name = "departmentId"
    type = "INTEGER"
  }
  
  column {
    name = "departmentName"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "tenant"
    type = "UUID"
  }
}

# Table: holiday
resource "postgresql_table" "holiday" {
  name      = "holiday"
  schema    = "public"
  
  column {
    name = "id"
    type = "INTEGER"
    not_null = true
    default = "nextval('holiday_id_seq'::regclass)"
  }
  
  column {
    name = "status"
    type = "VARCHAR(255)"
    not_null = true
    default = "draft"
  }
  
  column {
    name = "event"
    type = "VARCHAR(255)"
  }
  
  column {
    name = "tenant"
    type = "UUID"
  }
  
  column {
    name = "date"
    type = "DATE"
  }
}

