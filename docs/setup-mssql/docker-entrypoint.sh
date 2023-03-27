#!/bin/bash

# Start the script to create the DB and user
/setup-mssql/docker-configure-db.sh &

# Start SQL Server
/opt/mssql/bin/sqlservr
