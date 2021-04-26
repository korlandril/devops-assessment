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