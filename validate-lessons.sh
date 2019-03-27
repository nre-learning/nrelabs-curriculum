eval latest_release=$(curl https://api.github.com/repos/nre-learning/syringe/releases/latest | jq .name)
curl -L -o syringe.tar.gz "https://github.com/nre-learning/syringe/releases/download/$latest_release/syringe-linux-amd64.tar.gz"
tar xvzf syringe.tar.gz
./syrctl validate ../antidote
