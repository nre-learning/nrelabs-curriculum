FROM antidotelabs/utility

RUN apt-get install unzip tree graphviz -y

RUN wget --quiet https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip \
  && unzip terraform_0.11.11_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_0.11.11_linux_amd64.zip

WORKDIR /jtfa
