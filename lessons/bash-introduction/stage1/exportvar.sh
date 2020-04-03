bar="kerfuffle"
echo "You will not see 'kerfuffle' echoed in the next line:"
/antidote/stage1/echobar.sh
export bar
echo "Now you will see it:" 
/antidote/stage1/echobar.sh

