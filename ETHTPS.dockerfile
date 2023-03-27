FROM mcr.microsoft.com/dotnet/sdk:6.0

WORKDIR /ethtps
COPY ETHTPS.API .
ENV ASPNETCORE_URLS="http://*:5000"
ENV ASPNETCORE_ENVIRONMENT="Development.Docker"
RUN ["dotnet", "restore"]
RUN ["dotnet", "build"]

EXPOSE 5000/tcp

ENTRYPOINT ["dotnet", "run", "--no-launch-profile", "--project=ETHTPS.API"]
