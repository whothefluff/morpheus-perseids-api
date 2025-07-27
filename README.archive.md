# Morpheus Perseids API - Archived Project Restoration Guide

This document provides the steps to restore and run the archived `morpheus-perseids-api` project. The project has been saved with all its Docker image dependencies to ensure it can be run locally at any point in the future, without relying on external online repositories.

## Prerequisites

- A working installation of **Docker** and **Docker Compose**.

## Restoration Steps

Follow these two steps to get the application running on a new machine.

### Step 1: Load the Archived Docker Images

The `docker_images/` directory contains the saved `.tar` files for every service in the application. Run the following commands in your terminal to load them into your local Docker daemon.

```bash
# Load the main application image
docker load < docker_images/morpheus-app.tar

# Load the Redis database image
docker load < docker_images/redis-5.0.8.tar

# Load the Nginx cache image
docker load < docker_images/nginx-1.17.9.tar
```

After running these commands, you can verify the images were loaded successfully by running `docker images`. You should see `my-morpheus-app`, `redis`, and `nginx` in the list.

### Step 2: Start the Application

This project uses a special `docker-compose.archive.yml` file that points to the local images you just loaded.

To start all services, run the following command:

```bash
# Use '-f' to specify the archive file and '-d' to run in the background
docker compose -f docker-compose.archive.yml up -d
```

Your application stack is now running!
*   The web service should be available at **`http://localhost:1500`**.
*   The Nginx cache should be available at **`http://localhost:1501`**.

---

## How This Archive Works

This archive is designed to be completely self-contained. Here are the key components:

*   **`docker_images/` directory:** Contains the frozen, pre-built Docker images for the `web`, `redis`, and `cache` services. These files remove the need to connect to the internet to download dependencies.
*   **`docker-compose.archive.yml`:** This is a modified Compose file that instructs Docker to use the pre-loaded local images instead of trying to build from a `Dockerfile`.
*   **Source Code Volume (`volumes: - .:/app`):** The `web` service is configured to mount the local project directory into the container. This means you can still edit the `.rb` files locally, and the running application will see your changes. **It is critical that the source code is kept with this archive.**
*   **Nginx Configuration (`nginx.conf`):** The Nginx service requires the `nginx.conf` file from this directory to function correctly.

## Useful Commands

```bash
# View the status of your running containers
docker compose -f docker-compose.archive.yml ps

# View the real-time logs of the web application
docker compose -f docker-compose.archive.yml logs -f web

# Stop and remove all running containers for this project
docker compose -f docker-compose.archive.yml down
```