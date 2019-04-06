.. _lessonimages:

Lesson Image Requirements
=========================

Because Antidote runs on Kubernetes, all lessons are powered by Docker images. However, there are a few rules for including images
in Antidote.

- All files necessary for building a lesson image must be included in the lesson directory. Lessons hosted on
  NRE Labs must use images built via our tooling. No external images will be used.
- Any images meant to be used as type ``device`` or ``utility`` must be
  configured to listen for SSH connections on port 22 and support the credentials antidote/antidotepassword.



How can we control what applications and operating systems are used in a lesson?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
We create lesson entities called endpoints from Docker images, including network devices.
We have a set of existing docker images you can probably find useful right out of the box, but we can also incorporate new images when necessary.
See the images requirements page for more details.

During a pull request, you can push images to your own docker hub account, but if you want us to run this content, we'll need
the container source, and we'll be incorporating it into our docker hub account for security purposes.

However, you should only propose a new image when totally necessary. In many cases, putting things like scripts or configs within the lesson directory is sufficient.


Need to highlight existing images that should be considered before new images are created. List the popular images and describe them
