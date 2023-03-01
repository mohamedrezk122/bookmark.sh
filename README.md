
https://user-images.githubusercontent.com/59314933/221429644-c2fb6650-e759-4540-aff5-f683b756a1ed.mp4


```bookmark.sh``` is simply two scripts which saves a bookmarks and retrieve a bookmark. The idea is to have a global bookmark file to use anywhere you want not just a specific browser, also some browser dose not offer sync option.

# Installation 

- The two scripts allows you to choose between ```dmenu``` and  ```rofi```, that can be done through the variable ```METHOD```
- ```dmenu``` by default does not grab keyboard output and return it (as far as i know), but I got you covered you can apply the provided patch file with the following command 

``` sh 
$ cd path_to_dmenu/
$ git apply path_to_patch/dmenu-userinputtext-20230225-db84b38.diff 
$ make
$ sudo make clean install
``` 
It will display some warnings, it is fine. you can test the patch through the command
```sh
$ dmenu -t 
```
It shall draw dmenu, write something and you can see it returned. The previous behavior is very useful in typing the titles of the bookmarks or the name of the field.

## bind the scripts to keyboard shortcuts 

### ```i3wm```

- First make the scripts executable
```sh
$ chmod +x path_to_bookmark_scripts/bookmarkthis.sh
$ chmod +x path_to_bookmark_scripts/getbookmark.sh
```
- Then add this lines to your i3wm config if you are using it

``` i3
## bookmarks scripts
bindsym $mod+bracketright exec --no-startup-id path_to_bookmark_scripts/getbookmark.sh
bindsym $mod+bracketleft  exec --no-startup-id path_to_bookmark_scripts/bookmarkthis.sh
```

# Usage

You can refer to the video above to see how you can use the scripts.

## save bookmark
1- you copied some link which you want to bookmark 
2- click the shortcut you assigned to ```bookmarkthis.sh``` 
3- choose field or add a new one 
4- type the title of of the bookmark or leave it blank 

## get bookmark
1- just click the shortcut you assigned to ```getbookmark.sh```
2- choose the field which the bookmark is under 
3- choose bookmark
4- The ```url``` only copied to clipboard , also ```url``` can be automatically typed where the text cursor occur 
you can set it on by changing the value of ```TYPE=1``` instead of ```TYPE=0``` 


# To do 
- [ ] function to convert the bookmark file to a browsers-compatible HTML file
