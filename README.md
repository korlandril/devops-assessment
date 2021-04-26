# Dockerfile:
```
FROM centos:centos7
COPY ./app/ /app
WORKDIR /app
# Installing Python 3 and OS Requirements
RUN yum update -y && yum install -y python3 $(cat /app/os-requirements.txt)
# Install Python requirements packages
RUN python3 -m pip install -r requirements.txt
EXPOSE 5000
# Default port for Flask and what it is set to be used in server.py
ENTRYPOINT ["python3"]
CMD ["server.py"]
```

# Solution output:

## Successful image build:
```
Executing task: docker build --pull --rm -f "flask-image\flask.dockerfile" -t flask-eval:latest "flask-image" <

[+] Building 0.7s (9/9) FINISHED
=> [internal] load build definition from flask.dockerfile      0.0s 
=> => transferring dockerfile: 269B                            0.0s 
=> [internal] load .dockerignore                               0.0s 
=> => transferring context: 2B                                 0.0s 
=> [internal] load metadata for docker.io/library/centos:cent  0.6s 
=> [internal] load build context                               0.0s 
=> => transferring context: 458B                               0.0s 
=> [1/4] FROM docker.io/library/centos:centos7@sha256:0f4ec88  0.0s 
=> CACHED [2/4] COPY ./app/ /app                               0.0s 
=> CACHED [3/4] WORKDIR /app                                   0.0s 
=> CACHED [4/4] RUN yum update -y && yum install -y python3 $  0.0s 
=> exporting to image                                          0.0s 
=> => exporting layers                                         0.0s 
=> => writing image sha256:a526f35aa026b836f601c7248e3b3c88eb  0.0s 
=> => naming to docker.io/library/flask-eval:latest            0.0s 
```

## Test from inside web app container
```
PS C:\dev\repo\devops-assessment> docker ps
CONTAINER ID   IMAGE            COMMAND               CREATED          STATUS          PORTS                    NAMES
4dcd8966aed0   flask-eval:latest  "python3 server.py"   32 minutes ago   Up 32 minutes   0.0.0.0:5000->5000/tcp   suspicious_bartik
PS C:\dev\repo\devops-assessment> docker exec -it suspicious_bartik /bin/bash
[root@4dcd8966aed0 app]# echo "`curl 0.0.0.0:5000`"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     4  100     4    0     0   3032      0 --:--:-- --:--:-- --:--:--  4000
😄
```

## Test from another container:
```
PS C:\dev\repo\devops-assessment> docker run -it centos:centos7 /bin/bash
[root@aafbdd4032c5 /]# echo "`curl 192.168.50.152:5000`"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     4  100     4    0     0    914      0 --:--:-- --:--:-- --:--:--  1000
😄
```

# Response Questions

## Is your solution ready for use in a production environment? Why?
The Docker image works for what it minimally requires. Some things that could be added would be running Flask in a venv, scanning the image for vulnerabilities, and using specific ENV variables if other software is running with Flask in the same image.