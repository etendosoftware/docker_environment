# Etendo Project Setup

### Technical Description: Deployment of Etendo as a Docker Image

#### Overview

The deployment of Etendo as a Docker image involves setting up a containerized environment where the Etendo application runs within a Docker container, orchestrated by Docker Compose. This setup ensures a consistent and isolated environment, making the deployment process more streamlined and less prone to errors due to variations in the underlying host system.

#### Components

1. **Docker Container**: A lightweight, standalone, executable package that includes everything needed to run the Etendo application - code, runtime, system tools, libraries, and settings.

2. **Docker Compose**: A tool for defining and running multi-container Docker applications. It uses a YAML file (`docker-compose.yml`) to configure the application's services, networks, and volumes.

3. **Dockerfile**: A text file containing a series of commands used to assemble the Docker image for the Etendo application.

4. **PostgreSQL Container**: A separate container running the PostgreSQL database, linked to the Etendo application container for data storage.

5. **Volumes**: Persistent storage used by Docker containers, particularly for the PostgreSQL database, to ensure data persistence across container restarts and updates.

6. **Network**: An isolated network created by Docker Compose, allowing containers to communicate with each other.

#### Deployment Process

1. **Building the Image**: The Dockerfile defines the steps to build the Etendo application image, starting from a base Java image, adding the application code, and configuring the necessary environment.

2. **Defining Services**: The `docker-compose.yml` file describes the services (Etendo app and PostgreSQL database), their configuration, networks, and volumes.

3. **Running the Containers**: Docker Compose reads the `docker-compose.yml` file and starts the containers as defined. The Etendo application container connects to the PostgreSQL container for database operations.

4. **Accessing the Application**: Once the containers are running, the Etendo application becomes accessible on the specified port.

#### Key Considerations

- **Isolation**: Each component (application and database) runs in its own container, providing isolation and reducing conflicts between different environments.

- **Scalability**: Docker Compose allows for easy scaling of the application, facilitating the management of multiple instances.

- **Portability**: The Docker setup ensures that the application can be easily moved and deployed across different environments without compatibility issues.

- **Ease of Deployment**: Streamlines the deployment process, reducing the complexity and potential errors associated with manual setups.

### Multi-Stage Building in Docker

#### Overview

Multi-stage builds in Docker allow you to create cleaner Docker images by separating the build process into multiple stages. This method is particularly useful for applications like Etendo, where the build process involves several steps and potentially requires different tools and environments.

#### How It Works in provided Dockerfile

1. **First Stage: Building the Application (as `builder`)**

   - **Base Image**: Starts with `java jdk` as the base image.
   - **User Setup**: Creates a user and group for running the application.
   - **Copying Source Code**: Copies the Etendo source code into the image.
   - **Setting Up the Environment**: Prepares the necessary directories and permissions.
   - **Building the Application**: Executes build commands (`./gradlew setup`, `./gradlew install` or `./gradlew update.database`, and `./gradlew smartbuild`) to compile and prepare the application.
   - **Preparing the WAR File**: Generates the WAR file (`./gradlew antWar`) for deployment.

2. **Second Stage: Creating the Runtime Image**

   - **Base Image**: Uses generic `tomcat` as the base image for the runtime environment.
   - **Copying the WAR File**: Copies only the `etendo.war` file from the `builder` stage. This is the key step that ensures the final image does not contain the source code, only the compiled application.

#### Advantages

- **Efficiency**: By separating the build and runtime environments, the final image is smaller and more efficient, containing only what is necessary to run the application.
- **Security**: Reduces the attack surface of the final image, as it does not include unnecessary build tools and source code.
- **Maintainability**: Simplifies updates and maintenance, as changes in the source code or dependencies only require rebuilding the first stage.

#### Final Image

The final Docker image created by this Dockerfile contains only the necessary components to run the Etendo application on a Tomcat server. It includes the WAR file (`etendo.war`) but does not include the source code or any of the build tools used in the first stage. This approach ensures that the final image is optimized for size, security, and performance.

By using multi-stage builds, you effectively separate the build environment from the runtime environment, resulting in a clean, minimal final Docker image for deployment.

## Prerequisites

- Docker and Docker Compose installed on your machine.
- Git for cloning the repository.
- GitHub credentials for accessing private repositories (if required).

## Setup Instructions

### 1. Prepare the Etendo Source

#### Option A: Clone the Repository (For a Fresh Start)

- Clone the Etendo repository:

  ```bash
  git clone https://github.com/etendosoftware/etendo
  ```

- Copy `gradle.properties` from the template:

  ```bash
  cp gradle.properties.template gradle.properties
  ```

#### Option B: Use Existing Etendo Source Folder

If you already have a custom Etendo source folder, ensure it is named "etendo" and proceed with the next steps.

### 2. Copy Environment File

- Copy the `.env` file from the template:

  ```bash
  cp .env.template .env
  ```

- Edit `.env` to include your GitHub credentials:

  ```properties
  GITHUB_USER=[Your GitHub Username]
  GITHUB_TOKEN=[Your GitHub Token]
  ```

- For macOS Users: Uncomment the following line to the .env file to configure the host address:

  ```properties
  HOST_ADDRESS=host.docker.internal
  ```

  This setting is necessary to ensure proper networking behavior on macOS systems.

### 3. Configure GitHub Credentials

- Open `gradle.properties` (ensure it's already in your existing source or created in Option A) and set your GitHub credentials:

  ```properties
  githubUser=[Your GitHub Username]
  githubToken=[Your GitHub Token]
  ```

### 4. Build and Run the Database

- To build and start the PostgreSQL database, run:

  ```bash
  docker compose up -d postgres
  ```

### 5. Build Etendo Image

- In case of a fresh start (needed for Step 1 Option A), for the initial build (with database installation):

  ```bash
  docker compose build --build-arg network=host --build-arg INSTALL=true
  ```

- For subsequent builds:

  ```bash
  docker compose build --build-arg network=host
  ```

### 6. Start the Etendo Application

- To start the Tomcat server with the Etendo deployment:

  ```bash
  docker compose up -d
  ```

## Accessing the Application

Once the application is up, you can access it at `http://localhost:8080/etendo`.

## Troubleshooting

- Ensure all environment variables are correctly set in `.env`.
- Check Docker and Docker Compose are correctly installed and running.
- For any issues with GitHub access, verify your credentials and permissions.

## Further Information

For more detailed information about Etendo, visit the [official documentation](https://docs.etendo.software).
