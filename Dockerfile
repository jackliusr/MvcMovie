#Stage 1: Define base image that will be used for production
FROM  mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80


#Stage 2: Build and publish the code
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY MvcMovie.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release

FROM build AS publish
RUN dotnet publish -c Release -o /publish


#Stage 3: Build and publish the code
FROM base AS final
WORKDIR /app
COPY --from=publish /publish .
ENTRYPOINT ["dotnet", "MvcMovie.dll"]