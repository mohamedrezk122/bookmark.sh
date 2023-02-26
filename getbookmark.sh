#!/bin/bash

#  _                 _                         _              _
# | |__   ___   ___ | | ___ __ ___   __ _ _ __| | __      ___| |__
# | '_ \ / _ \ / _ \| |/ / '_ ` _ \ / _` | '__| |/ /     / __| '_ \
# | |_) | (_) | (_) |   <| | | | | | (_| | |  |   <   _  \__ \ | | |
# |_.__/ \___/ \___/|_|\_\_| |_| |_|\__,_|_|  |_|\_\ (_) |___/_| |_|

# absolute path to the bookmark file
BOOKMARKFILE="/home/rezk/.scripts/bookmark_scripts/bookmarks.md"
# program of your choice
METHOD="dmenu" # or "rofi"
TYPE=1

# editable commands based on the medthod you choose
if [ "$METHOD" = "dmenu" ]; then
    ChooseCommand="dmenu"
elif [ "$METHOD" = "rofi" ]; then
    ChooseCommand="rofi -dmenu -theme Monokai"
else
    notify-send "not a valid method"
    exit
fi

# display the fields from the bookmarks file
FileFields=$(grep -o '##...\+##' $BOOKMARKFILE )
chosenField="$(echo "$FileFields"| tr -d \# | $ChooseCommand -p "Choose field: " -l 7)"
# exit if no field selected
[ -z $chosenField ] && exit 

# remove leading and trailing whitespaces
chosenField=`echo $chosenField | xargs` 

set -o noglob         
IFS=$'\n' Fields=($FileFields)
set +o noglob        

# get the total number of lines in the file
total_num_lines="$(wc -l $BOOKMARKFILE | cut -d " " -f 1)"

# echo "## $chosenField ##"

grep -q "## $chosenField ##" "$BOOKMARKFILE" || { 
    notify-send "OoPs!" "Not a valid field"
    exit
}

# compute the line which bookmarks of the field go under.
begin=$(grep -n "## $chosenField ##" $BOOKMARKFILE | cut -d ":" -f 1) 
begin=`echo $((begin + 2)) | xargs`

if [ "${Fields[-1]}" = "## $chosenField ##" ]; then

    end=$total_num_lines
else
    field_index=-1
    # search for the field in the array of fields 
    for i in "${!Fields[@]}" ; 
    do 
        if [ "${Fields[$i]}" = "## $chosenField ##" ];
        then
            # get index and break the loop
            field_index=$i
            break
        fi
    done
    # compute the end line which is the line of the next element in the fields array minus 2 
    end=$(grep -n "${Fields[$field_index+1]}" $BOOKMARKFILE | cut -d ":" -f 1) 
    end=`echo $((end - 2)) | xargs`
fi 

# get the bookmark from list of bookmarks present under the chosen field
bookmarks=$(awk "NR>=$begin&&NR<=$end" $BOOKMARKFILE)
bookmark=$(echo "$bookmarks" | $ChooseCommand -p "Choose bookmark: " -l 7 ) 

# exit if no bookmark chosen 
[ -z $bookmark ] && exit 

# get the content within (url) 
url="$(echo $bookmark | grep -oP '\(\K[^\)]+' )"
# copy url to the clipboard
echo "$url" | xclip -sel clip

# type the url interactively in the focused window comment if just 
# want to copy the url to the clipboard , this works fine if you assigned 
# a shortcut to the script 
[ $TYPE -eq 1 ] && xdotool type "$url"

