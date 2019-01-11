.. _lessonimages:

Lesson Image Requirements
=========================

Because Antidote runs on Kubernetes, all lessons are powered by Docker images. However, there are a few rules for including images
in Antidote.

- All files necessary for building a lesson image must be included in the lesson directory. Lessons hosted on
  NRE Labs must use images built via our tooling. No external images will be used.
- Any images meant to be used as type ``device`` or ``utility`` must be
  configured to listen for SSH connections on port 22 and support the credentials antidote/antidotepassword.
