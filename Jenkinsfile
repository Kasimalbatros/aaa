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
                echo "Running Unit Tests..."
                sh "python -m unittest discover tests/unit"
            },
            "Integration Tests": {
                echo "Running Integration Tests..."
                sh "python -m unittest discover tests/integration"
            },
            "API Tests": {
                echo "Running API Tests..."
                sh "curl -s http://localhost:8000/"
            }
        )
    }

    stage('Deploy') {
        echo "Deploying Docker container..."
        sh "docker run -d --name flask-app -p 8000:8000 flask-app:latest"
    }
}

