#!/bin/bash

# Wait 60 seconds for SQL Server to start up by ensuring that
# calling SQLCMD does not return an error code, which will ensure that sqlcmd is accessible
# and that system and user databases return "0" which means all databases are in an "online" state
# https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-2022

# Wait for SQL Server to start
DBSTATUS=""
MAX_RETRIES=60
RETRY_COUNT=0

while [[ "$DBSTATUS" != "1" ]]; do
    # Run the SQL command to check database state
    DBSTATUS=$( /usr/bin/sqlcmd --login-timeout=1 -U sa -Q 'SET NOCOUNT ON; Select SUM(state) from sys.databases' )

    # If DBSTATUS is 0, SQL Server is ready to use
	if [[ $(echo "$DBSTATUS" | grep -o '[0-9]*') -eq 0 ]]; then
		echo "SQL Server is now ready for connections."
		break
	fi

    # If we've exceeded the maximum number of retries, exit the script
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "Failed to start SQL Server after $MAX_RETRIES attempts"
        exit 1
    fi

    # Wait for 1 second before trying again
    sleep 1

    # Increment retry counter
    RETRY_COUNT=$((RETRY_COUNT+1))

    # Print status message
    echo "Waiting for SQL Server to start..."
done

# Run SQL scripts
/usr/bin/sqlcmd -S localhost -U sa -d master -i /setup-mssql/setup.sql
/usr/bin/sqlcmd -S localhost -U sa -d ethtps -i /setup-mssql/init.sql
/usr/bin/sqlcmd -S localhost -U sa -d ethtps -i /setup-mssql/populate.sql

echo "SQL Server setup completed successfully"

