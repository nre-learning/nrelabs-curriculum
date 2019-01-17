Configuring Syringe
================================

Syringe is configured through environment variables. Since Syringe is typically deployed on Kubernetes, the best
way to pass these to Syringe is directly in the ``Pod`` or ``Deployment`` definition:

.. code:: yaml

    (...truncated...)

    containers:
    - name: syringe
      image: antidotelabs/syringe:latest
      imagePullPolicy: Always
      env:
      - name: SYRINGE_LESSONS
        value: "/antidote/lessons"
      - name: SYRINGE_DOMAIN
        value: "localhost"

    (...truncated...)

If you're using `antidote-selfmedicate <https://github.com/nre-learning/antidote-selfmedicate>`_ to spin up an instance of Antidote and Syringe yourself, note that these are provided
in the included `Kubernetes manifest <https://github.com/nre-learning/antidote-selfmedicate/blob/master/syringe.yml>`_.



See the table below for a description of each, as well as information on which are required, and which have default values.

+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| Variable Name                 | Required? | Default Value                                | Description                                                                                                      |
+===============================+===========+==============================================+==================================================================================================================+
| SYRINGE_LESSONS               | Yes       | N/A                                          | Directory where the lessons are stored                                                                           |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| SYRINGE_DOMAIN                | Yes       | N/A                                          | Domain where Antidote-web is running. Used to control ingress routing                                            |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| SYRINGE_GRPC_PORT             | No        | 50099                                        | Port to use for Syringe's GRPC service                                                                           |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| SYRINGE_HTTP_PORT             | No        | 8086                                         | Port to use for the grpc-gateway REST API for Syringe                                                            |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| SYRINGE_TIER                  | No        | local                                        | Controls which lessons Syringe makes available based on lesson metadata. Can be ``local``, ``ptr``, or ``prod``. |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| SYRINGE_LESSON_REPO_REMOTE    | No        | https://github.com/nre-learning/antidote.git | Git repo from which to clone lessons into lesson endpoint pods                                                   |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| SYRINGE_LESSON_REPO_BRANCH    | No        | master                                       | Git branch to use in lesson endpoint pods                                                                        |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
| SYRINGE_LESSON_REPO_DIR       | No        | /antidote                                    | Destination directory to use when cloning into lesson endpoint pods                                              |
+-------------------------------+-----------+----------------------------------------------+------------------------------------------------------------------------------------------------------------------+
