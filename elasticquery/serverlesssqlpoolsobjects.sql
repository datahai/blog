--create login
USE MASTER
CREATE LOGIN elasticuser WITH PASSWORD = '<strong_password>'

--create new database
CREATE DATABASE SQLElasticQuery;
GO

USE SQLElasticQuery;
GO

--create objects for connecting to data lake

--Create a schema to hold our objects
CREATE SCHEMA LDW authorization dbo;

--encryption to allow authentication
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<strong_password>';

--Create a credential using Managed Identity
CREATE DATABASE SCOPED CREDENTIAL DataLakeManagedIdentity
WITH IDENTITY='Managed Identity'

--Create a data source for use in queries
CREATE EXTERNAL DATA SOURCE ExternalDataSourceDataLakeUKMI
    WITH (
        LOCATION   = 'https://<storageaccount>.dfs.core.windows.net/<container>',
        CREDENTIAL = DataLakeManagedIdentity
        );

--Create Delta file format    
CREATE EXTERNAL FILE FORMAT SynapseDeltaFormat
WITH ( 
        FORMAT_TYPE = DELTA
     );

--enable support for UTF8
ALTER DATABASE SQLDatabash COLLATE Latin1_General_100_BIN2_UTF8;

--create external table over Delta
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
    LOCATION = 'cleansed/webtelemetrydeltakey',
    DATA_SOURCE = ExternalDataSourceDataLakeUKMI,  
    FILE_FORMAT = SynapseDeltaFormat
)
GO

--switch to the Serverless databas
USE SQLElasticQuery;
GO
--create user from login
CREATE USER elasticuser FROM LOGIN elasticuser;

--grant select on the Delta table
GRANT SELECT ON LDW.WebTelemetryDelta to elasticuse

--grant the sql user access to the credential to access the data lake
GRANT REFERENCES ON DATABASE SCOPED CREDENTIAL::[DataLakeManagedIdentity] TO [elasticuser];
