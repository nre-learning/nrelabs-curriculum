FROM python

RUN apt-get update && apt-get install sshpass

COPY requirements.txt /
RUN pip install -r /requirements.txt

COPY configure.py /