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
                    docker rm -f flask-app-test || true
                    docker run -d --name flask-app-test -p 8000:8000 -v \"${WORKSPACE}:/app\" flask-app:latest python /app/main.py
                    sleep 5
                    curl -s http://127.0.0.1:8000/
                    docker rm -f flask-app-test
                """
            }
        )
    }

    stage('Deploy') {
        echo "Deploying Docker container..."
        sh "docker rm -f flask-app || true"
        sh "docker run -d --name flask-app -p 8000:8000 flask-app:latest"
    }
}

