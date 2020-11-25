docker build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg no_proxy=$no_proxy -t jam:dev .
docker rm -f jenkins-agent-minimal
docker run -d --restart=always --name jenkins-agent-minimal -p 32222:22 jam:dev
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jenkins-agent-minimal
