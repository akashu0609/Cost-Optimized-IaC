pipeline {
    agent any

    environment {
        TF_VERSION = "1.6.0"
        INFRACOST_API_KEY = credentials('infracost-api-key')
        AWS_DEFAULT_REGION = "us-east-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/akashu0609/Cost-Optimized-IaC.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Cost Estimation (Infracost)') {
            steps {
                sh '''
                infracost breakdown --path=. \
                  --format json --out-file infracost.json
                infracost output --path infracost.json --format table
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Policy Check (OPA/Conftest)') {
    steps {
        sh '''
        terraform plan -out=tfplan
        terraform show -json tfplan > tfplan.json
        conftest test tfplan.json --policy ./policy
        '''
			}
		}

        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

		stage('Load Test (Validate Auto Scaling)') {
			steps {
				script {
				def alb_dns = sh(script: "terraform output -raw alb_dns_name", returnStdout: true).trim()
				sh """
				echo "Running load test against ALB: $alb_dns"
				./scripts/load_test.sh $alb_dns
				"""
				}
			}
		}


        stage('Validate Auto Scaling Policies') {
            steps {
                script {
                    // Check CloudWatch alarms exist and are in OK state
                    sh '''
                    echo "Validating CloudWatch alarms..."
                    aws cloudwatch describe-alarms \
                      --alarm-names "${ENV}-cpu-high" "${ENV}-cpu-low" \
                      --query "MetricAlarms[*].StateValue" \
                      --output text
                    '''
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/infracost.json', allowEmptyArchive: true
        }
    }
}
