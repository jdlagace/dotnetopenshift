FROM registry.access.redhat.com/ubi8/dotnet-80:8.0

# Set ASPNETCORE_URLS
ENV ASPNETCORE_URLS=https://*:8080

# Switch to root for changing dir ownership/permissions
USER 0

# Copy the niaries
COPY /bin/release/net8.0/publish app

# Change to app directory
WORKDIR app

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container user
# random UID
USER 1001
RUN chown -R 1001:0 /app && chmod -R og+rwx app

# Expose port 8080 for the app
EXPOSE 8080

# Start the application using dotnet
ENTRYPOINT dotnet dotnetopenshift.dll
