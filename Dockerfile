FROM mcr.microsoft.com/dotnet/aspnet:3.1-focal AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

# # Creates a non-root user with an explicit UID and adds permission to access the /app folder
# # For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
# RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser

FROM mcr.microsoft.com/dotnet/sdk:3.1-focal AS build
WORKDIR /src
COPY ["sample-web-app.csproj", "./"]
RUN dotnet restore "sample-web-app.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "sample-web-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "sample-web-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Create a group and user so we are not running our container and application as root which is a security issue.
RUN addgroup --system --gid 1000 customgroup \
    && adduser --system --uid 1000 --ingroup customgroup --shell /bin/sh customuser

RUN chown -R customuser:customgroup /app
# Tell docker that all future commands should run as the appuser user, must use the user number
USER 1000

ENTRYPOINT ["dotnet", "sample-web-app.dll"]
