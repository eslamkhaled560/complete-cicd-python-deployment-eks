FROM python:3.10

WORKDIR /app

COPY . .

# Install the required Python packages
#RUN apt-get update && apt-get install -y
#RUN apt-get install -y python-pip python-dev build-essential
#RUN apt-get install -y libmysqlclient-dev >> needed to install flask_mysqldb on ubuntu

RUN pip install flask flask_mysqldb

EXPOSE 5002

ENTRYPOINT ["python"]
CMD ["app.py"]
