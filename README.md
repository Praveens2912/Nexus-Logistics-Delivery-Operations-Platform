# Nexus — Logistics & Delivery Operations Platform

## Project Overview

Nexus is an end-to-end logistics data engineering project built using Snowflake SQL.

The project processes logistics data across customers, drivers, hubs, shipments, delivery attempts, shipment events and invoices. It applies data quality checks and organizes the data into layers to support business reporting and operational analysis.

## Technology Stack

- Snowflake
- SQL
- Data Profiling
- Data Quality Validation
- Data Transformation
- Data Modeling
- Analytical Views

## Data Architecture

The project uses a layered data architecture:

1. **INGEST** — Data ingestion resources and configuration.
2. **RAW** — Source data retained for processing.
3. **STAGING** — Data profiling and quality classification.
4. **CURATED** — Filtered and prepared business data.
5. **ANALYTICS** — Views for reporting and business analysis.
6. **AUDIT** — Schema reserved for audit-related functionality.

## Data Domains

The project covers seven business datasets:

- Customers
- Drivers
- Hubs
- Shipments
- Shipment Events
- Delivery Attempts
- Invoices

## Data Engineering Work Completed

- Created a Snowflake database with dedicated schemas.
- Organized logistics data into raw, staging and curated layers.
- Identified duplicate identifiers in shipment data.
- Removed duplicate shipment records during staging.
- Identified invalid and incomplete customer attributes.
- Classified delivery attempt data quality issues.
- Applied data quality filters during curated table creation.
- Excluded shipments with invalid origin hub references.
- Created analytics views for shipment performance.
- Created delivery performance summaries.
- Created invoice summary views.
- Created customer activity summaries.

## Analytics Views

| View | Business Purpose |
|---|---|
| `VW_SHIPMENT_PERFORMANCE` | Analyses shipment volumes and shipping fees by status and service level |
| `VW_DELIVERY_PERFORMANCE` | Summarises delivery attempts by result |
| `VW_INVOICE_SUMMARY` | Analyses invoice counts and invoice amounts by status |
| `VW_CUSTOMER_SUMMARY` | Summarises customer activity by customer type and state |

## Data Quality Improvements

The project identified duplicate records and invalid or incomplete values across several datasets.

Examples include:

- Duplicate shipment ID `S000001501`
- Duplicate delivery attempt ID `A000000011`
- Duplicate shipment event ID `E0000000160`
- Invalid customer email and phone values
- Invalid shipment hub references
- Invalid or missing delivery dates
- Delivery attempt records requiring review

Records were handled according to the relevant staging and curated processing rules. Missing values were reviewed in context rather than automatically treated as errors.

## Curated Data Volumes

The following record counts were observed in the completed curated tables.

| Curated Table | Records |
|---|---:|
| `CURATED_CUSTOMERS` | 14,992 |
| `CURATED_DRIVERS` | 699 |
| `CURATED_HUBS` | 30 |
| `CURATED_SHIPMENTS` | 49,999 |
| `CURATED_SHIPMENT_EVENTS` | 79,816 |
| `CURATED_DELIVERY_ATTEMPTS` | 14,298 |
| `CURATED_INVOICES` | 46,998 |

These counts represent the observed curated table sizes. Differences between raw and curated counts can result from deduplication, quality filters and reference checks.

## Repository Structure

```text
nexus-logistics-delivery-platform/
│
├── README.md
└── sql/
    └── nexus_logistics_delivery_platform.sql
```

## How to Explore the SQL

Open the SQL script in the `sql` folder to review the database setup context, staging data quality checks, curated-layer queries, analytics views and data quality documentation.

**Note:** The SQL file documents the project work completed in Snowflake. Review statements that create or replace database objects before executing them in another environment.

## Project Outcome

This project demonstrates practical Snowflake SQL skills across layered data processing, data quality analysis, curated data preparation and analytics view development.

It provides a foundation for further work on incremental processing, audit logging, automated orchestration and dashboard integration.
