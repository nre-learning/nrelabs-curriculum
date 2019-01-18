FROM ubuntu:xenial
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential python3-pip python3-dev
COPY . /app
WORKDIR /app
RUN pip3 install -r /app/sample_app/requirements.txt
RUN python3 /app/setup.py install
ENTRYPOINT ["python3"]
CMD ["run_sample_app.py"]
