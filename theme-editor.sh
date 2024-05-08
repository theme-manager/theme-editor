#!/bin/sh

# functions
printUsage() {
    echo "Usage:
    theme-editor.sh <name>"
#Options:
#    -l  --list                          List themes
#    -c  --create    <name> <imagePath>  Create theme
#    -d  --delete    <name>              Delete theme
#    -h  --help                          Show this help message
#    -s  --set       <name> (apply)      Set theme, optionally apply [1|0]
#    -u  --update    <name> <imagePath>  Update theme"
}

# error codes
# 0 - success
# 1 - missing argument(s)
# 2 - wrong argument(s)
# 3 - missing dependecy
# 4 - wrong configuration file
# 5 - internal error

themesPath="$HOME/.config/themes"

checkIfThemeExists() {
    themeExists=false
    for file in "$themesPath/"*; do
        if [ "$(basename "$file")" = "$1" ]; then
            themeExists=true
        fi
    done
    if $themeExists; then
        echo 0
    else 
        echo 1
    fi
}

#check if theme name is valid and theme with this name exists
if [ "$(checkIfThemeExists "$1")" = "1" ]; then
    echo "Theme with name '$1' does not exist!"
    exit 2 
fi

showColor() {
    hex=$(echo "$1" | sed 's/#//g')
    echo "$(perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@")" \
        "$1" \
        "$(printf "\t%d %d %d\n" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}")"
}

displayCurrentColors() {
    #enter edit mode
    while IFS= read -r hexCode; do
        showColor "$hexCode"
    done < "$themesPath/$1/colors/colors-hex.txt"
}

echo "\\e[48:2::5:14:16m \\e[49m"

displayCurrentColors "$1"