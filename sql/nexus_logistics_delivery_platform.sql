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



-- ============================================================
-- SECTION 04: STAGING DATA QUALITY CHECKS
-- Project: Nexus Logistics & Delivery Operations Platform
-- Purpose: Review data quality issues identified during staging
-- ============================================================

USE DATABASE NEXUS_LOGISTICS_DB;

-- ------------------------------------------------------------
-- 4.1 CUSTOMER DATA QUALITY SUMMARY
-- ------------------------------------------------------------

SELECT
    DATA_QUALITY_STATUS,
    COUNT(*) AS RECORD_COUNT
FROM STAGING.STAGING_CUSTOMERS
GROUP BY DATA_QUALITY_STATUS
ORDER BY RECORD_COUNT DESC;


-- ------------------------------------------------------------
-- 4.2 SHIPMENT DUPLICATE CHECK
-- ------------------------------------------------------------

SELECT
    SHIPMENT_ID,
    COUNT(*) AS RECORD_COUNT
FROM STAGING.STAGING_SHIPMENTS
GROUP BY SHIPMENT_ID
HAVING COUNT(*) > 1;


-- ------------------------------------------------------------
-- 4.3 DELIVERY ATTEMPT DATA QUALITY SUMMARY
-- ------------------------------------------------------------

SELECT
    DATA_QUALITY_STATUS,
    COUNT(*) AS RECORD_COUNT
FROM STAGING.STAGING_DELIVERY_ATTEMPTS
GROUP BY DATA_QUALITY_STATUS
ORDER BY RECORD_COUNT DESC;


-- ------------------------------------------------------------
-- 4.4 SHIPMENT EVENT DUPLICATE CHECK
-- ------------------------------------------------------------

SELECT
    EVENT_ID,
    COUNT(*) AS RECORD_COUNT
FROM STAGING.STAGING_SHIPMENT_EVENTS
GROUP BY EVENT_ID
HAVING COUNT(*) > 1;



-- ============================================================
-- SECTION 05: CURATED LAYER
-- Project: Nexus Logistics & Delivery Operations Platform
-- Purpose: Store cleaned and validated business data
-- ============================================================

USE DATABASE NEXUS_LOGISTICS_DB;

-- ------------------------------------------------------------
-- 5.1 CURATED TABLE INVENTORY
-- ------------------------------------------------------------

SHOW TABLES IN SCHEMA NEXUS_LOGISTICS_DB.CURATED;


-- ------------------------------------------------------------
-- 5.2 CURATED CUSTOMER SUMMARY
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS TOTAL_CUSTOMERS,
    COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMERS
FROM NEXUS_LOGISTICS_DB.CURATED.CURATED_CUSTOMERS;


-- ------------------------------------------------------------
-- 5.3 CURATED SHIPMENT SUMMARY
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS TOTAL_SHIPMENTS,
    COUNT(DISTINCT SHIPMENT_ID) AS UNIQUE_SHIPMENTS
FROM NEXUS_LOGISTICS_DB.CURATED.CURATED_SHIPMENTS;


-- ------------------------------------------------------------
-- 5.4 CURATED DELIVERY ATTEMPT SUMMARY
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS TOTAL_DELIVERY_ATTEMPTS
FROM NEXUS_LOGISTICS_DB.CURATED.CURATED_DELIVERY_ATTEMPTS;


-- ------------------------------------------------------------
-- 5.5 CURATED INVOICE SUMMARY
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS TOTAL_INVOICES,
    ROUND(SUM(INVOICE_TOTAL), 2) AS TOTAL_INVOICE_AMOUNT
FROM NEXUS_LOGISTICS_DB.CURATED.CURATED_INVOICES;



-- ============================================================
-- SECTION 06: ANALYTICS VIEWS
-- Project: Nexus Logistics & Delivery Operations Platform
-- Purpose: Provide business-ready summaries for reporting
-- ============================================================

USE DATABASE NEXUS_LOGISTICS_DB;

-- ------------------------------------------------------------
-- 6.1 SHIPMENT PERFORMANCE
-- Analyse shipment volumes and shipping fees by status
-- and service level
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW ANALYTICS.VW_SHIPMENT_PERFORMANCE AS
SELECT
    SHIPMENT_STATUS,
    SERVICE_LEVEL,
    COUNT(*) AS TOTAL_SHIPMENTS,
    ROUND(AVG(WEIGHT_KG), 2) AS AVG_WEIGHT_KG,
    ROUND(AVG(SHIPPING_FEE), 2) AS AVG_SHIPPING_FEE,
    ROUND(SUM(SHIPPING_FEE), 2) AS TOTAL_SHIPPING_FEES
FROM CURATED.CURATED_SHIPMENTS
GROUP BY
    SHIPMENT_STATUS,
    SERVICE_LEVEL;


-- ------------------------------------------------------------
-- 6.2 DELIVERY PERFORMANCE
-- Summarise delivery attempts by result
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW ANALYTICS.VW_DELIVERY_PERFORMANCE AS
SELECT
    ATTEMPT_RESULT,
    COUNT(*) AS TOTAL_ATTEMPTS,
    COUNT(DISTINCT SHIPMENT_ID) AS UNIQUE_SHIPMENTS
FROM CURATED.CURATED_DELIVERY_ATTEMPTS
GROUP BY ATTEMPT_RESULT;


-- ------------------------------------------------------------
-- 6.3 INVOICE SUMMARY
-- Analyse invoice counts and amounts by invoice status
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW ANALYTICS.VW_INVOICE_SUMMARY AS
SELECT
    INVOICE_STATUS,
    COUNT(*) AS TOTAL_INVOICES,
    ROUND(SUM(INVOICE_TOTAL), 2) AS TOTAL_INVOICE_AMOUNT,
    ROUND(AVG(INVOICE_TOTAL), 2) AS AVERAGE_INVOICE_AMOUNT
FROM CURATED.CURATED_INVOICES
GROUP BY INVOICE_STATUS;


-- ------------------------------------------------------------
-- 6.4 CUSTOMER SUMMARY
-- Analyse customer activity by customer type and state
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW ANALYTICS.VW_CUSTOMER_SUMMARY AS
SELECT
    CUSTOMER_TYPE,
    STATE,
    COUNT(*) AS TOTAL_CUSTOMERS,
    COUNT_IF(IS_ACTIVE = 'TRUE') AS ACTIVE_CUSTOMERS,
    COUNT_IF(IS_ACTIVE = 'FALSE') AS INACTIVE_CUSTOMERS
FROM CURATED.CURATED_CUSTOMERS
GROUP BY
    CUSTOMER_TYPE,
    STATE;


-- ------------------------------------------------------------
-- 6.5 VIEW INVENTORY
-- List analytics views in the schema
-- ------------------------------------------------------------

SHOW VIEWS IN SCHEMA NEXUS_LOGISTICS_DB.ANALYTICS;
