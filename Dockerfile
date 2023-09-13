#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY *.sln .
COPY CloudFestDemo/*.csproj ./CloudFestDemo/
COPY CloudFestDemoUnitTests/*.csproj ./CloudFestDemoUnitTests/
RUN dotnet restore 

COPY CloudFestDemo/. ./CloudFestDemo/
COPY CloudFestDemoUnitTests/. ./CloudFestDemoUnitTests/

WORKDIR /src/CloudFestDemo
RUN dotnet publish -c release -o /app --no-restore

FROM build AS publish 
RUN dotnet publish "CloudFestDemo.csproj" -c Release -o /app/publish


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CloudFestDemo.dll"]
