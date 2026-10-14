/*====================================================================
 PROJECT NAME : Nexus - Logistics & Delivery Operations Platform
 PLATFORM     : Snowflake
 LANGUAGE     : SQL

 PROJECT OBJECTIVE
 ---------------------------------------------------------------------
 Build an end-to-end logistics data platform in Snowflake.

 The project processes customer information, drivers, logistics hubs,
 shipments, shipment events, delivery attempts and invoices.

 DATA ARCHITECTURE
 ---------------------------------------------------------------------
 RAW -> STAGING -> CURATED -> ANALYTICS

 RAW
     Stores ingested source data.

 STAGING
     Applies data standardization, type conversion, deduplication
     and data quality classification.

 CURATED
     Stores selected business-ready records after staging checks.

 ANALYTICS
     Provides business-facing views for shipment performance,
     delivery performance, invoice summaries and customer summaries.

 DATABASE
 ---------------------------------------------------------------------
 NEXUS_LOGISTICS_DB

 SCHEMAS
 ---------------------------------------------------------------------
 INGEST
 RAW
 STAGING
 CURATED
 ANALYTICS
 AUDIT

 CURATED TABLES
 ---------------------------------------------------------------------
 CURATED_CUSTOMERS
 CURATED_DRIVERS
 CURATED_HUBS
 CURATED_INVOICES
 CURATED_SHIPMENTS
 CURATED_DELIVERY_ATTEMPTS
 CURATED_SHIPMENT_EVENTS

 ANALYTICS VIEWS
 ---------------------------------------------------------------------
 VW_SHIPMENT_PERFORMANCE
 VW_DELIVERY_PERFORMANCE
 VW_INVOICE_SUMMARY
 VW_CUSTOMER_SUMMARY

 IMPORTANT
 ---------------------------------------------------------------------
 This script documents the project implementation.


/*====================================================================
 SECTION 01 - DATABASE AND SCHEMA CONTEXT
====================================================================*/

USE DATABASE NEXUS_LOGISTICS_DB;

-- Review the project schemas
SHOW SCHEMAS IN DATABASE NEXUS_LOGISTICS_DB;

-- Review tables in the RAW layer
SHOW TABLES IN SCHEMA NEXUS_LOGISTICS_DB.RAW;

-- Review tables in the STAGING layer
SHOW TABLES IN SCHEMA NEXUS_LOGISTICS_DB.STAGING;

-- Review tables in the CURATED layer
SHOW TABLES IN SCHEMA NEXUS_LOGISTICS_DB.CURATED;

-- Review views in the ANALYTICS layer
SHOW VIEWS IN SCHEMA NEXUS_LOGISTICS_DB.ANALYTICS;

 Review CREATE OR REPLACE statements carefully before execution.
 They can replace existing objects and overwrite their contents.

====================================================================*/
