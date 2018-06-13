FROM jupyter/minimal-notebook
ADD lesson-1/jupyter/requirements.txt /
RUN pip install -r /requirements.txt
RUN mkdir /home/jovyan/.jupyter
ADD lesson-1/jupyter/lesson1.ipynb /home/jovyan/work/
ADD base-jupyter-config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

# Not ideal way of doing this, but works for now.
ADD --chown=jovyan:1001 ssh/id_rsa.pub /home/jovyan/.ssh/id_rsa.pub
ADD --chown=jovyan:1001 ssh/id_rsa /home/jovyan/.ssh/id_rsa
