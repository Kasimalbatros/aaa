node {
    stage('Checkout') {
        git branch: 'master', url: 'https://github.com/Kasimalbatros/aaa.git'
    }

    stage('Build') {
        echo "Building Docker Image..."
        sh "docker build -t flask-app:latest ."
    }

    stage('Run Tests in Parallel') {
        parallel(
            "Unit Tests": {
                echo "Running Unit Tests inside Docker..."
                sh "docker run --rm -v \"${WORKSPACE}:/app\" flask-app:latest pytest /app/tests/unit"
            },
            "Integration Tests": {
                echo "Running Integration Tests inside Docker..."
                sh "docker run --rm -v \"${WORKSPACE}:/app\" flask-app:latest pytest /app/tests/integration"
            },
            "API Tests": {
                echo "Running API Tests inside Docker..."
                sh """
                    docker rm -f flask-app-test || true
                    docker run -d --name flask-app-test -p 8000:8000 -v "${WORKSPACE}:/app" flask-app:latest python /app/main.py
                    
                    echo "Waiting for app to start..."
                    for i in {1..10}; do
                        if docker exec flask-app-test curl -s http://127.0.0.1:8000/ > /dev/null; then
                            echo "App is up!"
                            exit 0
                        fi
                        echo "App not ready yet... retrying"
                        sleep 2
                    done

                    echo "App failed to start!"
                    docker logs flask-app-test
                    exit 1
                """
                sh "docker rm -f flask-app-test || true"
            }
        )
    }

    stage('Deploy') {
        echo "Deploying Docker container..."
        sh "docker rm -f flask-app || true"
        sh "docker run -d --name flask-app -p 8000:8000 flask-app:latest"
    }
}

