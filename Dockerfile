FROM registry.access.redhat.com/ubi8/dotnet-80:8.0

# Set ASPNETCORE_URLS
ENV ASPNETCORE_URLS="http://+:5000;https://+:8080"

# Switch to root for changing dir ownership/permissions
USER 0

# Change to app directory
WORKDIR /app

# Copy the niaries
COPY /bin/release/net8.0/publish ./

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container user

RUN chown -R 1001:0 /app && chmod -R og+rwx /app

# random UID nonroot
USER 1001

# Expose port 80 for the app
EXPOSE 8080
EXPOSE 5000

RUN dotnet dev-certs https

# Start the application using dotnet
ENTRYPOINT dotnet dotnetopenshift.dll
