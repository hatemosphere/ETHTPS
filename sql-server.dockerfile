# Building SQL server image with ARM support (can be used on Apple silicon)
FROM mcr.microsoft.com/azure-sql-edge:latest

USER root

RUN apt update && apt install -y software-properties-common

# HACK: azure-sql-edge image is running Ubuntu 18.04 as of now, but since there are no Microsoft
# repository for 18.04, we are adding 20.04 to install go-sqlcmd with ARM support
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)" && \
    apt update && apt install -y sqlcmd

USER mssql
