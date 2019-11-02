#!/bin/bash
# requires apt packages: aspell, aspell-en

[[ "$TRAVIS_PULL_REQUEST" == "false" ]] && exit 0 # bypass script if not a pull request

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

FILES_CHANGED=`(git diff --name-only $TRAVIS_COMMIT_RANGE || true) | grep guide.md  && (git diff --name-only $TRAVIS_COMMIT_RANGE || true) | grep notebook.ipynb`
# FILES_CHANGED=`git ls-tree -r spellcheck --name-only | grep guide.md && git ls-tree -r spellcheck --name-only | grep notebook.ipynb`

if [ -z "$FILES_CHANGED" ]
then
    echo -e "$GREEN>> No markdown file to check $NC"

    exit 0;
fi

echo -e "$BLUE>> Following guide or notebook files were changed in this pull request (commit range: $TRAVIS_COMMIT_RANGE):$NC"
echo "$FILES_CHANGED"

TOTAL_NB_MISSPELLED=0
echo -e "$BLUE>> Running spellchecker...$NC"
for FILE in $FILES_CHANGED; do
    CONTENTS=`cat $(echo "$FILE" | sed -E ':a;N;$!ba;s/\n/ /g')`
    # delete markdown code blocks
    CONTENTS=$(echo "$CONTENTS" | sed '/^```/,/^```/d')
    # delete html pre blocks
    CONTENTS=$(echo "$CONTENTS" | sed '/^<pre>/,/^<\/pre>/d')
    # convert markdown inline code to html code
    CONTENTS=$(echo "$CONTENTS" | sed -E 's/(^|[^\\`])`([^`]+)`([^`]|$)/\1<code>\2<\/code>\3/g')
    # delete html code blocks
    CONTENTS=$(echo "$CONTENTS" | sed -r 's/<code>[^<]+<\/code>//g')
    # delete html tags
    CONTENTS=`echo "$CONTENTS" | sed -E 's/<([^<]+)>//g'`
    # delete markdown robot code blocks
    CONTENTS=$(echo "$CONTENTS" | sed '/^>```/,/^>```/d')

    #echo -e "$BLUE>> Content that will be checked:$NC"
    #echo "$CONTENTS"

    #echo -e "$BLUE>> Running spellchecker...$NC"
    MISSPELLED=`echo "$CONTENTS" | aspell --lang=en --encoding=utf-8 --personal=./.aspell.en.pws list | sort -u`

    NB_MISSPELLED=`echo "$MISSPELLED" | wc -w`

    if [ "$NB_MISSPELLED" -gt 0 ]
    then
        TOTAL_NB_MISSPELLED=$((TOTAL_NB_MISSPELLED+NB_MISSPELLED))
        # echo -e "$RED>> Words that might be misspelled, please check:$NC"
        MISSPELLED=`echo "$MISSPELLED" | sed -E ':a;N;$!ba;s/\n/, /g'`
        # echo "$MISSPELLED"
        echo -e "\n$RED>> $FILE $NC"
        echo -e "$RED>> $NB_MISSPELLED words might be misspelled, please check them:$NC"
        echo -e "$MISSPELLED"
    fi
done

if [ "$TOTAL_NB_MISSPELLED" -gt 0 ]
then
    echo -e "\nTotal Misspelled words: $TOTAL_NB_MISSPELLED"
    exit 1
else
        COMMENT="No spelling errors, congratulations!"
        echo -e "$GREEN>> $COMMENT $NC"
fi
exit 0