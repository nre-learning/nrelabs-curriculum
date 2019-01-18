FROM alpine/git
COPY git-clone.sh /
RUN adduser antidote -D

ENTRYPOINT ["/git-clone.sh"]
