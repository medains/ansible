#!/bin/sh

function remove() {
    echo "Removing $1 from dock"
    # Get location of entry for our application in Dock
    dloc=$(defaults read com.apple.dock persistent-apps | grep file-label\" | awk "/$1/ {print NR}")
    if [[ -z "${dloc}" ]]; then
        echo "Application $1 does not seem to be in the dock"
        return
    fi
    dloc=$((dloc - 1))
    # Remove this entry from Dock's plist file : com.apple.dock.plist
    /usr/libexec/PlistBuddy -c "Delete persistent-apps:$dloc" ~/Library/Preferences/com.apple.dock.plist
}

# Kill the preference cache
killall -u `whoami` cfprefsd

for x in "Microsoft Word" "Microsoft PowerPoint" "Microsoft Outlook" "Microsoft Lync" Contacts Calendar Maps Photos Messages FaceTime iTunes iBooks myMacInfo; do 
    remove "$x"
done

# Restart Dock to persist changes
osascript -e 'delay 3' -e 'tell Application "Dock"' -e 'quit' -e 'end tell' -e 'delay 3'
