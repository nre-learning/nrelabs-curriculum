FROM gitlab/gitlab-ce:latest
ADD gitlab.rb /etc/gitlab/gitlab.rb




docker run --detach \
	--hostname localhost \
	--publish 8443:443 --publish 8880:80 --publish 8822:22 \
	--name gitlab \
    --rm \
	--volume /gl/config:/etc/gitlab \
	--volume /gl/logs:/var/log/gitlab \
	--volume /gl/data:/var/opt/gitlab/git-data/ \
  antidotelabs/gitlab
  


