node {
    stage('Checkout') {
        git branch: 'master', url: 'https://github.com/Kasimalbatros/checkout-to-deploy-python-pipeline.git'
    }

    stage('Build') {
        echo "Building Docker Image..."
        sh "docker build -t flask-app:latest ."
    }

    stage('Run Tests in Parallel') {
        parallel(
            "Unit Tests": {
                echo "Running Unit Tests inside Docker..."
                sh "docker run --rm -v \"${WORKSPACE}:/app\" flask-app:latest python -m unittest discover /app/tests/unit"
            },
            "Integration Tests": {
                echo "Running Integration Tests inside Docker..."
                sh "docker run --rm -v \"${WORKSPACE}:/app\" flask-app:latest python -m unittest discover /app/tests/integration"
            },
            "API Tests": {
                echo "Running API Tests inside Docker..."
                sh """
                    # Remove existing test container if exists
                    docker rm -f flask-app-test || true

                    # Run container in background
                    docker run -d --name flask-app-test -p 8000:8000 -v \"${WORKSPACE}:/app\" flask-app:latest python /app/main.py

                    # Wait for Flask app to start
                    sleep 5

                    # Run API test
                    curl -s http://127.0.0.1:8000/

                    # Remove test container
                    docker rm -f flask-app-test
                """
            }
        )
    }

    stage('Deploy') {
        echo "Deploying Docker container..."
        # Remove any existing container
        sh "docker rm -f flask-app || true"

        # Run new container
        sh "docker run -d --name flask-app -p 8000:8000 flask-app:latest"
    }
}

