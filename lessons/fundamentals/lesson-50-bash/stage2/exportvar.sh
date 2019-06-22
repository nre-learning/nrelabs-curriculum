bar="kerfuffle"
echo "You will not see 'kerfuffle' echoed in the next line:"
/antidote/stage2/echobar.sh
export bar
echo "Now you will see it:" 
/antidote/stage2/echobar.sh

