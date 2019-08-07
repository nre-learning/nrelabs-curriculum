echo "You passed $# parameters to this script."

EXPECTED_PARAMETERS=4

if [ $# -eq $EXPECTED_PARAMETERS ]; then
	echo "Parameter check passed."
elif [ $# -gt $EXPECTED_PARAMETERS ]; then
	echo "You have $(( $# - $EXPECTED_PARAMETERS)) more parameters than expected."
elif [ $# -lt $EXPECTED_PARAMETERS ]; then
	echo "You have $(( $EXPECTED_PARAMETERS - $# )) fewer parameters than expected."
else
	echo "You messed up good because it's logically impossible for you to see this message."
fi

