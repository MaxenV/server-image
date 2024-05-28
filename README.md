Multistage building of simple application shows IP addres and current time in Warsaw.
The goal is to build lightest weight image.

You can find the image on [DockerHub repository](https://hub.docker.com/repository/docker/maxenv/server-image/general)

# Versions

There are three versions of dockerfile:

1. default Dockerfile - based on alpine and contains HEALTHCHECK
2. Dockerfile_selfTest - based on scratch and contains HEALTHCHECK test wrote in goLang
3. Dockerfile_minimal - this is the lightest but don't have any HEALTHCHECK, only the app

# Start container

docker run --rm -it -p 8080:8080 --name Test1 maxenv/server-image

# Exercise 3

## a. Build container

### Create new builder

Use the following command to create a new builder:

```bash
docker buildx create --use --name mybuilder --driver docker-container --bootstrap
```

### Build container using the builder

Use the following command to build the container:

```bash
docker buildx build -t local/server-image .
```

### Command which I use

I use this command to build the Docker image for multiple platforms and push it to Docker Hub:

```bash
docker buildx build --sbom=true --provenance=mode=max --platform linux/amd64,linux/arm64 --cache-from=type=registry,ref=maxenv/server-image:latest --cache-to=type=registry,ref=maxenv/server-image:cache,mode=max --push -t maxenv/server-image:latest .
```

## b. run conainer on build image

### Run container from local build image

```bash
docker run --rm -it -p 8080:8080 --name Test1 local/server-image
```

### Run container from dockerhub

```bash
docker run --rm -it -p 8080:8080 --name Test1 maxenv/server-image
```

## c. Retrieving Information from the Server

After running the container, you can retrieve information from the server in your terminal and by visiting http://localhost:8080 in your web browser.

<p>

Screen from terminal<br>
![Screen from terminal](screenshots/TerminalWorks.png)

Screen from website<br>
![Screen from website](screenshots/website.png)

</p>

## d. Check image layers

```bash
docker history maxenv/server-image
```

or for localbuild

```bash
docker history local/server-image
```

# Scout Vulnerabilities

## Commands to check vulnerabilities

```bash
docker scout quickview maxenv/server-image:latest
```

```bash
docker scout cves maxenv/server-image:latest
```

## Screenshots

![Vulnerabilities](screenshots/Vulnerabilities.png)

![Quickview](screenshots/quickview.png)

![Cves](screenshots/cves.png)

# GitHub Actions Workflow

The GitHub Actions workflow file, `gha_example.yml`, automates the process of building, tagging, and pushing a Docker image to DockerHub, as well as scanning the image for vulnerabilities.

Here's a step-by-step breakdown of the workflow:

1. **Trigger**: The workflow is triggered manually (`workflow_dispatch`) or when a new tag is pushed to the repository.

2. **Checkout**: The workflow checks out the source code of the repository.

3. **Docker Metadata Definitions**: The workflow defines metadata for the Docker image, such as the image name and tags.

4. **QEMU and Buildx Setup**: The workflow sets up QEMU and Buildx, which are tools used for building Docker images.

5. **DockerHub Login**: The workflow logs in to DockerHub using the provided username and token.

6. **Build and Push Docker Image**: The workflow builds the Docker image using the Dockerfile in the repository and pushes the image to DockerHub.

7. **Docker Scout Vulnerability Scan**: The workflow scans the Docker image for vulnerabilities using Docker Scout. The results are saved in a SARIF file.

8. **Install jq**: The workflow installs `jq`, a command-line JSON processor.

9. **Show SARIF File**: The workflow displays the contents of the SARIF file.

10. **Parse SARIF File**: The workflow parses the SARIF file and saves the results in a JSON file.

11. **Check Vulnerability Scan Results**: The workflow checks the vulnerability scan results and counts the number of critical and high vulnerabilities.

12. **Show Scanning Results**: The workflow displays the number of critical and high vulnerabilities.

13. **Docker Push**: If there are no critical or high vulnerabilities, the workflow pushes the Docker image to GitHub Container Registry (GHCR). If there are any critical or high vulnerabilities, the workflow skips this step.

This workflow ensures that the Docker image is built and pushed automatically, and that any vulnerabilities in the image are identified and reported. This helps maintain the security and integrity of the Docker image.
