#!/bin/bash

# Get st2 version based on hardcoded string in st2common
. /etc/lsb-release 
ST2_VERSION=$(/opt/stackstorm/st2/bin/python -c 'exec(open("/opt/stackstorm/st2/lib/python3.6/site-packages/st2common/__init__.py").read()); print(__version__)')
printf "Welcome to \033[1;38;5;208mStackStorm\033[0m \033[1m%s\033[0m (${DISTRIB_DESCRIPTION} %s %s)\n" "v${ST2_VERSION}" "$(uname -o)" "$(uname -m)"
printf " * Documentation: https://docs.stackstorm.com/\n"
printf " * Community: https://stackstorm.com/community-signup\n"
printf " * Forum: https://forum.stackstorm.com/\n"

if [ -n "$ST2CLIENT" ]; then
  printf " Here you can use StackStorm CLI. Examples:\n"
  printf "   st2 action list --pack=core\n"
  printf "   st2 run core.local cmd=date\n"
  printf "   st2 run core.local_sudo cmd='apt-get update' --tail\n"
  printf "   st2 execution list\n"
  printf "\n"
fi
printf "\n"
