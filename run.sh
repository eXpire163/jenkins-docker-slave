docker build -t jam:dev .
docker rm -f jenkins-agent-minimal
docker run -d --restart=always --name jenkins-agent-minimal -p 2222:22 jam:dev
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jenkins-agent-minimal
