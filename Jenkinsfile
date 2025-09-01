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
                sh "docker run --rm flask-app:latest pytest /app/tests/unit"
            },
            "Integration Tests": {
                echo "Running Integration Tests inside Docker..."
                sh "docker run --rm flask-app:latest pytest /app/tests/integration"
            },
            "API Tests": {
                echo "Running API Tests..."
                sh """
                    docker rm -f flask-app-test || true
                    docker run -d --name flask-app-test -p 8000:8000 flask-app:latest
                    echo "Waiting for app to start..."
                    for i in {1..5}; do
                        if docker exec flask-app-test curl -s http://127.0.0.1:8000/; then
                            echo "App is up!"
                            break
                        else
                            echo "App not ready yet... retrying"
                            sleep 2
                        fi
                    done
                    docker logs flask-app-test
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

