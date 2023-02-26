#!/bin/bash

#  _                 _                         _              _
# | |__   ___   ___ | | ___ __ ___   __ _ _ __| | __      ___| |__
# | '_ \ / _ \ / _ \| |/ / '_ ` _ \ / _` | '__| |/ /     / __| '_ \
# | |_) | (_) | (_) |   <| | | | | | (_| | |  |   <   _  \__ \ | | |
# |_.__/ \___/ \___/|_|\_\_| |_| |_|\__,_|_|  |_|\_\ (_) |___/_| |_|

# absolute path to the bookmark file
BOOKMARKFILE="/home/rezk/.scripts/bookmarks.md"
# program of your choice
METHOD="dmenu" # or "rofi"


NEWLINE=$'\n'
# editable commands based on the medthod you choose
if [ "$METHOD" = "dmenu" ]; then
    ChooseCommand="dmenu"
    InputCommand="dmenu -t"
elif [ "$METHOD" = "rofi" ]; then
    ChooseCommand="rofi -dmenu -theme Monokai"
    InputCommand="rofi -dmenu -l 1 -theme Monokai"
else
    notify-send "not a valid method"
    exit
fi

bookmark=$(xclip -o)
# display the fields from the bookmarks file
if  grep -o '##...\+##' $BOOKMARKFILE ; then
    FileFields="$(grep -o '##...\+##' $BOOKMARKFILE | tr -d \#  ) ${NEWLINE} <add-new-field>"
else
    FileFields="<add-new-field>"
fi
# get main field from dmenu or rofi 
chosenField=$(echo "$FileFields" | $ChooseCommand -p "Choose field: " -l 7)


# add new field 
if echo "$chosenField" | grep -q "add" ; then
    # there is no -t option in dmenu it is my build
    chosenField=$($InputCommand -p "Name of the field ? " |  xargs )
    # exit if no field selected
    [ -z "$chosenField" ] && exit 

    # check if the field is already there 
    if ! grep -q "## $chosenField ##" $BOOKMARKFILE; then
        echo $"${NEWLINE}${NEWLINE}-----------------" >> $BOOKMARKFILE
        echo "## $chosenField ##" >> $BOOKMARKFILE
        echo $"-----------------${NEWLINE}${NEWLINE}" >> $BOOKMARKFILE
    fi
fi

# exit if no field selected
[ -z "$chosenField" ] && exit 


# remove leading and trailing whitespaces
chosenField="$(echo "$chosenField" | xargs)" 

grep -q "## $chosenField ##" "$BOOKMARKFILE" || { 
    notify-send "OoPs!" "Not a valid field"
    exit
}
# get the line number of the main field
linenum=$(grep -n "## $chosenField ##" $BOOKMARKFILE | cut -d ":" -f 1)  
# add two and remove whitespces  
linenum="$(echo $((linenum + 2)) | xargs)"
# search for bookmark if it in the file
if  grep -q "^$bookmark" $BOOKMARKFILE  ; then
    notify-send "OoPs""Bookmark is already there under $chosenField"
else

    # title of the bookmark
    title=$($InputCommand -p "Bookmark title" | xargs )
    content="[$title]($bookmark)"
    # if no title typed then just append the bookmark
    [ -z "$title" ] && content="($bookmark)"    
    # append the content to the file 
    sed -i "$linenum i  $content" "$BOOKMARKFILE"
    notify-send "🔖 $title added " "Bookmark $bookmark added under $chosenField field "
fi