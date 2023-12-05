# Etendo Project Setup

This guide provides detailed steps to set up and run the Etendo project using Docker.

## Prerequisites

- Docker and Docker Compose installed on your machine.
- Git for cloning the repository.
- GitHub credentials for accessing private repositories (if required).

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/etendosoftware/etendo
cd etendo
```

### 2. Copy Environment and Configuration Files

- Copy the `.env` file from the template:

  ```bash
  cp .env.template .env
  ```

- Edit `.env` to include your GitHub credentials:

  ```properties
  GITHUB_USER=[Your GitHub Username]
  GITHUB_TOKEN=[Your GitHub Token]
  ```

- Copy `gradle.properties` from the template:

  ```bash
  cp gradle.properties.template gradle.properties
  ```

### 3. Configure GitHub Credentials

- Open `gradle.properties` and set your GitHub credentials:

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

- For the initial build (with database installation):

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
