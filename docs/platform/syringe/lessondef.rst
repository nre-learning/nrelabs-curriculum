.. _lessondef:

Lesson Definitions
================================

Syringe uses a totally file-driven approach to lesson definitions. This allows us to store all lessons as "code"
within a Git repository, rather than maintain a database of lesson state all the time. When syringe starts,
it looks for lesson definitions within a directory, loads them into memory, and serves them directly via its API.

.. note::
    The way that ``syringe.yaml`` files are put together is still a work-in-progress. Be prepared for changes to
    the below information, as we improve Syringe and make it (hopefully) easier to put these lesson files together.

These lesson definitions are written in YAML. A very simple example is shown below. This file describes a very
simple lesson in two parts, with a single linux container for interactivity:

.. code:: yaml

  ---
  lessonName: Introduction to YAML
  lessonID: 14
  category: introductory
  topologyType: none

  utilities:
  - name: linux1
    image: antidotelabs/utility
    sshuser: antidote
    sshpassword: antidotepassword

  stages:
    1:
      description: Lists
      labguide: https://raw.githubusercontent.com/nre-learning/antidote/master/lessons/lesson-14/stage1/guide.md
    2:
      description: Dictionaries (key/value pairs)
      labguide: https://raw.githubusercontent.com/nre-learning/antidote/master/lessons/lesson-14/stage2/guide.md


A more complicated example adds network devices to the mix. This not only adds images to the file, but
we also need to add a list of connections for Syringe to place between our network devices, as well as
configurations to apply to each device at each lesson stage:

.. code:: yaml

  ---
  lessonName: Network Unit Testing with JSNAPY
  lessonID: 12
  category: verification
  lessondiagram: https://raw.githubusercontent.com/nre-learning/antidote/master/lessons/lesson-12/lessondiagram.png
  topologyType: custom

  utilities:
  - name: linux1
    image: antidotelabs/utility
    sshuser: antidote
    sshpassword: antidotepassword

  devices:
  - name: vqfx1
    image: antidotelabs/vqfxspeedy:snap1
    sshuser: root
    sshpassword: VR-netlab9
  - name: vqfx2
    image: antidotelabs/vqfxspeedy:snap2
    sshuser: root
    sshpassword: VR-netlab9
  - name: vqfx3
    image: antidotelabs/vqfxspeedy:snap3
    sshuser: root
    sshpassword: VR-netlab9

  connections:
  - a: vqfx1
    b: vqfx2
    subnet: 10.12.0.0/24
  - a: vqfx2
    b: vqfx3
    subnet: 10.23.0.0/24
  - a: vqfx3
    b: vqfx1
    subnet: 10.31.0.0/24
  - a: vqfx1
    b: linux1
    subnet: 10.1.0.0/24

  stages:
    1:
      description: No BGP config - tests fail
      labguide: https://raw.githubusercontent.com/nre-learning/antidote/master/lessons/lesson-12/stage1/guide.md

      configs:
        vqfx1: stage1/configs/vqfx1.txt
        vqfx2: stage1/configs/vqfx2.txt
        vqfx3: stage1/configs/vqfx3.txt

    2:
      description: Correct BGP config - tests pass
      labguide: https://raw.githubusercontent.com/nre-learning/antidote/master/lessons/lesson-12/stage2/guide.md

      configs:
        vqfx1: stage2/configs/vqfx1.txt
        vqfx2: stage2/configs/vqfx2.txt
        vqfx3: stage2/configs/vqfx3.txt
