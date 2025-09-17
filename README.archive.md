# Morpheus Perseids API - Archived Project Restoration Guide (v1.1)

This document provides the steps to restore and run the archived `morpheus-perseids-api` project. The archive is designed to be completely self-contained for long-term reproducibility. The source code is provided in this repository, and the large Docker image dependencies are stored externally.

By default, it uses a version of the Morpheus app that [Alatius](https://github.com/Alatius) fixed (vowel lengths especially), which can be found [here](https://github.com/whothefluff/morpheus-alatius-xml).

## Prerequisites

- A working installation of **Docker** and **Docker Compose**.

## Restoration Steps (For End-Users)

Follow these five steps to get the application running from the pre-built archive.

### Step 1: Get the Source Code

Clone this repository to your local machine.

### Step 2: Download the Archived Docker Images

The Docker images are stored externally to keep this repository small.

1.  **[Download `docker_images_v1_1.rar` from Google Drive](https://drive.google.com/file/d/1vl9BOTWzCgAoB1PTJFwPGCEbxm1QCstj/view)**.
2.  Extract the `.rar` file into the root of this project directory.

After extracting, you should have a `docker_images/` directory containing three `.tar` files.

### Step 3: Load the Docker Images

Run the following commands in your terminal to load the images from the `.tar` files into your local Docker daemon.

```bash
# Load the main application image
docker load < docker_images/morpheus-alatius-api-v1.tar

# Load the Redis database image
docker load < docker_images/redis-5.0.8.tar

# Load the Nginx cache image
docker load < docker_images/nginx-1.17.9.tar
```

After running these commands, you can verify the images were loaded successfully by running `docker images`. You should see `whothefluff/morpheus-alatius-api:v1.0.0`, `redis:5.0.8`, and `nginx:1.17.9` in the list.

### Step 4: Configure Your Environment

This project uses a `.env` file to manage configuration.

For a basic setup, the default settings in this file are fine. If you need to change ports or use a different image, you can edit the `.env` file directly.

### Step 5: Start the Application

Now you can start all the services. Docker Compose will automatically read your `.env` configuration.

```bash
# Use '-f' to specify the archive file and '-d' to run in the background
docker compose -f docker-compose.archive.yml up -d
```

Your application stack is now running! Based on the default settings in your `.env` file:
*   The web service should be available at **`http://localhost:1500`**.
*   The Nginx cache should be available at **`http://localhost:1501`**.

Example: `http://localhost:1501/analysis/word?lang=lat&engine=morpheuslat&word=amo`

---

## Rebuilding the API Image (For Developers)

The following instructions are for developers who want to rebuild the main API image from source, for example, after updating the base Morpheus XML image. This workflow uses `docker-compose.yml` and the `Dockerfile`.

**1. Build the New Image**

This command reads the `Dockerfile` and builds the new API image, tagging it with the name specified in `FINAL_API_IMAGE` from your `.env` file.
```bash
docker compose build
```

**2. Test the New Build (Optional)**

To run and test the version you just built, use the standard `up` command.
```bash
docker compose up -d
```
You can then stop it with `docker compose down`.

**3. Package the New Image for Distribution**

Once you are satisfied with your build, save the new image to a `.tar` file. This is the file you would distribute to end-users (and the one that is already shared in the `.rar` file as `morpheus-alatius-api-v1.tar`).

*   **Option A: Save the image defined in your `.env` file (Recommended)**
    This command automatically reads the `FINAL_API_IMAGE` variable from your `.env` file and saves the corresponding image.
    ```bash
    grep FINAL_API_IMAGE .env | cut -d '=' -f 2 | tr -d '\r' | xargs -I {} docker save -o docker_images/morpheus-alatius-api-v1.tar {}
    ```

*   **Option B: Save an image by manually specifying name/location**
    If you want to save the final image somewhat differently you can always just run a simple `docker save` command

---

## How This Project is Structured

This project is designed with two distinct workflows in mind: one for end-users running the pre-built archive, and one for developers rebuilding it. Here are the key components:

*   **`docker_images/` directory:** Contains the frozen, pre-built Docker images for all services. These are downloaded separately and loaded locally, removing any need to connect to the internet to fetch dependencies.

*   **`.env` file:** The central place for all user-specific configuration. It controls which images are used, what ports are exposed, and is read by both `docker-compose` files, ensuring consistent settings.

*   **`docker-compose.archive.yml` (For End-Users):** This is the "user" blueprint. It's designed to run the entire application from the pre-built, pre-loaded images defined in the `.env` file. It **does not build anything**, guaranteeing a stable and reproducible run.

*   **`docker-compose.yml` & `Dockerfile` (For Developers):** This is the "factory" blueprint. It reads the `Dockerfile` to **build a new API image from source**, using the base Morpheus image defined in the `.env` file. This is used for creating new, updated versions of the archive.

*   **Source Code Volume (`volumes: - .:/app`):** The `web` service is configured to mount the local project directory into the container. This allows you to edit the `.rb` files locally and see your changes reflected in the running application (after a restart).

*   **Nginx Configuration (`nginx.conf`):** The Nginx service requires this specific configuration file to correctly proxy requests to the web service.

## Useful Commands

```bash
# View the status of your running containers
docker compose -f docker-compose.archive.yml ps

# View the real-time logs of the web application
docker compose -f docker-compose.archive.yml logs -f web

# Stop and remove all running containers for this project
docker compose -f docker-compose.archive.yml down
```