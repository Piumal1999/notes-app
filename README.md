# notes-app

A simple notes app built with Ballerina.

## Getting Started

### Local Development

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd notes-app
   ```

2. **Build and run the Ballerina service:**

   ```bash
   bal run
   ```

   The service will be available at `http://localhost:9090`.

### Docker Deployment

1. **Build the Ballerina service and create the Docker image:**

   ```bash
   bal build
   ```

   This command will automatically create the docker image with the inbuilt functionality of the Ballerina language.

2. **Run the Docker container:**

   ```bash
   docker run -d -p 9090:9090 notes:latest
   ```

   The service will be accessible at `http://localhost:9090`.
