-- Prequisites: 
-- - SQL Setup includes Polybase feature
-- - login with SQL for security workaround for no domain
-- - ODBC Drivers from Microsoft Access Database Engine 2016 Redistributable
-- - CSV file saved into folder F:\share, and optionally share that folder with read access to everyone on local PC
-- Reference: https://learn.microsoft.com/en-us/sql/relational-databases/polybase/polybase-installation?view=sql-server-ver16#use-the-installation-wizard
-- Reference: https://stackoverflow.com/questions/61100707/polybase-to-connect-local-csv-file
-- Reference: https://www.sqlshack.com/sql-server-2016-polybase-tutorial/
-- Drivers: https://www.microsoft.com/en-us/download/details.aspx?id=54920
-- CSV File: contents of customers.csv within block comment below, copy and paste into new file in share folder:
/*
Name,Lastname,email
john,Rambo,jrambo@hotmail.com
john,connor,jconnor@hotmail.com
elvis,presley,epresley@hotmail.com
elmer,hermosa,ehermosa@gmail.com
*/

SELECT SERVERPROPERTY ('IsPolyBaseInstalled') AS IsPolyBaseInstalled;

CREATE DATABASE [CSV_Demo];

USE [CSV_Demo];
exec sp_configure @configname = 'polybase enabled', @configvalue = 1;
RECONFIGURE;

-- create a local datasource
CREATE EXTERNAL DATA SOURCE MyODBC
WITH 
( 
    LOCATION = 'odbc://localhost',
    CONNECTION_OPTIONS = 'Driver=Microsoft Access Text Driver (*.txt, *.csv);Dbq=F:\share',
    PUSHDOWN = OFF
);

-- create a netowrk share datasource
CREATE EXTERNAL DATA SOURCE MyODBCNetwork
WITH 
( 
    LOCATION = 'odbc://localhost',
    CONNECTION_OPTIONS = 'Driver=Microsoft Access Text Driver (*.txt, *.csv);Dbq=\\localhost\share',
    PUSHDOWN = OFF
);


CREATE EXTERNAL FILE FORMAT csvformat 
WITH ( 
    FORMAT_TYPE = DELIMITEDTEXT, 
    FORMAT_OPTIONS ( 
        FIELD_TERMINATOR = ','
    ) 
)

CREATE EXTERNAL TABLE customerstable
( 
    	name NVARCHAR(255),
    	lastname NVARCHAR(255),
		email NVARCHAR(255)
) 
WITH 
( 
    LOCATION = '[customers.csv]', 
    DATA_SOURCE = [MyODBC]
 
)

CREATE EXTERNAL TABLE customerstablenetwork
( 
    	name NVARCHAR(255),
    	lastname NVARCHAR(255),
		email NVARCHAR(255)
) 
WITH 
( 
    LOCATION = '[customers.csv]', 
    DATA_SOURCE = [MyODBCNetwork]
 
)


USE [CSV_Demo]
GO

SELECT [name]
      ,[lastname]
      ,[email]
  FROM [dbo].[customerstable]

GO
SELECT [name]
      ,[lastname]
      ,[email]
  FROM [dbo].[customerstablenetwork]

