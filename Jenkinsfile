pipeline {
    agent any
    environment {
                AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
                CLUSTER_NAME = 'eks_master'
                ECR_URL = '761371183724.dkr.ecr.us-east-1.amazonaws.com'
                PYTHON_REPO = 'ecr-app'
                MYSQL_REPO = 'ecr-db'
                INGRESS_NAME = "python-ingress"
    }
    stages {
        stage('Build App and Database') {
            steps {
                echo "Building Python App..."
                sh "docker build -t ${PYTHON_REPO}:${BUILD_NUMBER} MySQL-and-Python/FlaskApp/."
                echo "Python build App is successful"

                echo "Building MySQL..."
                sh "docker build -t ${MYSQL_REPO}:${BUILD_NUMBER} MySQL-and-Python/MySQL_Queries/."
                echo "MySQL build is successful"
            }
        }
	    stage('Authenticate AWS ECR') {
            steps {
                echo "Logging into ECR..."
                withCredentials([usernamePassword(credentialsId: 'ecr', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin ${ECR_URL}"
                }
                echo "ECR Authentication successful"
            }
        }
        stage('Push to ECR') {
            steps {
                echo "Tagging Both Images..."
                sh "docker tag ${PYTHON_REPO}:${BUILD_NUMBER} ${ECR_URL}/${PYTHON_REPO}:${BUILD_NUMBER}"
                sh "docker tag ${MYSQL_REPO}:${BUILD_NUMBER} ${ECR_URL}/${MYSQL_REPO}:${BUILD_NUMBER}"
                echo "Tagged"

                echo "Pushing Both Images to ECR..."
                sh "docker push ${ECR_URL}/${PYTHON_REPO}:${BUILD_NUMBER}"
                sh "docker push ${ECR_URL}/${MYSQL_REPO}:${BUILD_NUMBER}"
                echo "Push to ECR is successful"
            }
        }
        stage("Get K8s config file") {
            steps {
            echo "Get config file"
            sh "aws eks update-kubeconfig --name ${CLUSTER_NAME}"
            echo "Kubeconfig authenticated"

            sh "export KUBECONFIG=/var/lib/jenkins/.kube/config"
            }
        }
        stage("Deploy to EKS") {
            steps {
                echo "Applying K8s manifest files"
                sh "kubectl apply -f k8s/deploy.yaml"
                echo "Nginx Ingress Controller deployed successfully"

                sh "envsubst < k8s/app-deploy.yml | kubectl apply -f -"
                echo "Python App deployed successfully"

                sh "envsubst < k8s/db-statefulset.yml | kubectl apply -f -"
                echo "MySQL deployed successfully"

                echo 'Resolving Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io"'
                sh "kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission"

                sh "envsubst < k8s/ingress-routing-by-domain.yml | kubectl apply -f -"
                echo "Ingress Service deployed successfully"
            }
        }
	    stage('Get URL') {
            steps {
                echo "Run app on the following URL"
                sh "kubectl get ingress ${INGRESS_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
            }
        }
    }
}