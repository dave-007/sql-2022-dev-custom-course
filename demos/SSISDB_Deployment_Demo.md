## DEMO GOAL: Step through creating SSISDB, creating a simple SSIS project and deploying to the SSISDB.


### HIGH LEVEL STEPS

#### Create SSISDB Catalog

- FROM SSMS, right click Integration Services Catalog folder and Create Catalog
- ![alt text](image-9.png) 

#### Create simple SSIS Project with Package

- Connect to SQL Server and create SSISDB
- ![Creating SSISDB](image.png)
- Enter strong password you can remember and click OK
- Right click SSISDB and Create Folder named *Sandbox*
- ![alt text](image-10.png)
- Review your SSISDB
- ![alt text](image-11.png)
- Create C:\SSISDEMO folder
- In VS 2022, Create new SSIS Project, any name, with defaults
- Rename Package.dtsx to ExportTables.dtsx
- ![alt text](image-2.png)
- In Connection Manager, create connection to AdventureWorks2022
- ![AWDW2022](image-1.png)
- Add Data Flow Task
- In Data Flow Task, add OLEDB data source
- Uses dbo.DimReseller as source
- ![alt text](image-6.png)
- In Columns, **uncheck ProductLine**
- ![alt text](image-8.png)
- Add new Flat File Destination
    - Connect blue output line from OLE DB Source
    - Create new Flat File connection manager
        - Delimited
        - Browse to C:\SSISDEMO\, type filename DimReseller, type of CSV, click open
        - Check Columns names in first row, click OK
        - ![alt text](image-7.png)
        - Click Mappings, OK
    - You have a basic package to export the DimReseller data to CSV
    - ![alt text](image-3.png)
    - Debug the package and resolve any errors, verify it writes to C:\SSISDEMO
    - ![alt text](image-4.png)
    - Delete the file (will create again)

#### Deploy Project to SSISDB

- Right Click Project and Deploy
- ![alt text](image-5.png)
- Choose SSIS in SQL Server, next
- Enter server name localhost, and browse to /SSISDB/Sandbox/Test01, next
- ![alt text](image-12.png)
- Click Deploy
- Locate and Execute your package
- ![alt text](image-13.png)
- Review Overview Report
- ![alt text](image-14.png)