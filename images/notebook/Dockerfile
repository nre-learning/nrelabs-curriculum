FROM jupyter/minimal-notebook
ADD requirements.txt /home/jovyan/requirements.txt
RUN pip install -r /home/jovyan/requirements.txt
RUN mkdir -p /home/jovyan/.jupyter
ADD base-jupyter-config.py /home/jovyan/.jupyter/jupyter_notebook_config.py


# Not ideal way of doing this, but works for now.
# ADD --chown=jovyan:1001 ssh/id_rsa.pub /home/jovyan/.ssh/id_rsa.pub
# ADD --chown=jovyan:1001 ssh/id_rsa /home/jovyan/.ssh/id_rsa

# Switch to root to set entrypoint
USER root

# Generate self-signed cert
RUN mkdir -p /opt/jupyterssl
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /opt/jupyterssl/selfsigned.key -out /opt/jupyterssl/selfsigned.crt -subj "/C=US/ST=Oregon/L=Portland/O=Juniper Networks/OU=NRE Labs/CN=labs.networkreliability.engineering"
#ADD platform/letsencrypt/etc/live/networkreliability.engineering/fullchain.pem /opt/jupyterssl/
#ADD platform/letsencrypt/etc/live/networkreliability.engineering/privkey.pem /opt/jupyterssl/

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
# CMD /usr/local/bin/start-notebook.sh --certfile=/opt/jupyterssl/fullchain.pem --keyfile=/opt/jupyterssl/privkey.pem --NotebookApp.base_url="/$SYRINGE_FULL_REF/"

CMD /usr/local/bin/start-notebook.sh --NotebookApp.base_url="/$SYRINGE_FULL_REF/"

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID