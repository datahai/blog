--run on azure sql database if a master key doesn't exist
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '3431434efadadfe!!!sdafa45';

--create a credential with the same details as the login created earlier
--in Serverless SQL Pools
CREATE DATABASE SCOPED CREDENTIAL ElasticDBQueryCredV2
WITH IDENTITY = 'elasticuser',
SECRET = '<strong_password>';

--now create a data source pointing to the Serverless SQL Pools endpoint and database
--use the credential created in the earlier step
CREATE EXTERNAL DATA SOURCE ExternalDataSourceDataLakeUKMIV2 WITH
    (TYPE = RDBMS,
    LOCATION = 'synapse-ondemand.sql.azuresynapse.net',
    DATABASE_NAME = 'SQLElasticQuery',
    CREDENTIAL = ElasticDBQueryCredV2
);

--create schema to hold tables
CREATE SCHEMA LDW AUTHORIZATION dbo;
GO

--create external table referencing the data source created earlier
CREATE EXTERNAL TABLE LDW.WebTelemetryDelta
(
    UserID varchar(20),
    EventType varchar(100),
    ProductID varchar(100),
    URL varchar(100),
    Device varchar(50),
    SessionViewSeconds int,
    MessageKey varchar(100),
    EventYear int,
    EventMonth int,
    EventDate date
)  
WITH (
       DATA_SOURCE = ExternalDataSourceDataLakeUKMIV2
);
GO

--show 10 rows of the source data
SELECT TOP 10 *
FROM [LDW].[WebTelemetryDelta]
WHERE EventDate = '2022-03-03';

--show 10 rows of the source data
SELECT TOP 10 *
FROM [LDW].[WebTelemetryDelta]
WHERE EventDate = '2022-03-03';
