BO3 Workshop Language Fix
A Windows batch script that makes Black Ops 3 custom maps (Steam Workshop) compatible with any in-game language — even if the map itself only ships files for one language.

What it does
Many Black Ops 3 custom maps only include language files (`.ff` / `.xpak`) for a single language (usually English). If your game is set to a different language, the game may fail to find the matching files for that map, causing missing content or errors.
This script scans your Workshop folder and, for every custom map missing a file for your chosen language, creates a renamed copy of an existing language file (preferably `en`, or another available language as a fallback).
Since these files mainly tell the game which language output to reference, this effectively makes maps that don't contain their own unique text/audio work correctly in any language.

Features
Prompts for the target language prefix interactively (e.g. `ge`, `fr`, `it`) — not hardcoded to one language
Scans all subfolders under the Workshop content directory automatically
Detects files by their first two characters + extension, regardless of the rest of the filename
Falls back from `en` to any other available language if `en` is missing
Asks for confirmation before making any changes, per folder
Never overwrites or deletes original files — only creates copies
Prints a summary at the end: which folders were changed and how many in total

Requirements
Windows
Black Ops 3 installed via Steam
Workshop content downloaded (the script targets App ID `311210`, Black Ops 3's Workshop content folder)

Usage
Download `bo3\_workshop\_language\_fix.bat` from this repository.
Adjust the `ROOT` path in the script if your Steam library isn't in the default location:

   set "ROOT=C:\\Program Files (x86)\\Steam\\steamapps\\workshop\\content\\311210"

Run the script (double-click, or run from a command prompt).
Enter your desired language prefix when prompted (e.g. `ge` for German).
For each folder that's missing a file for your language, review the proposed change and confirm with `Y` or skip with `N`.
At the end, check the summary for a list of all folders that were changed.

Why this works
The language-prefixed `.ff` / `.xpak` files don't necessarily contain unique translated content themselves — they largely act as pointers telling the game which language output to load.
Once a file exists for your language, the game correctly references its standard language audio/text, even for maps that never shipped their own translation.

License
This project is licensed under the MIT License. Feel free to use, modify, and build on this script; just keep the original credit.

Disclaimer!
This script only copies and renames files within your local Workshop folder — it doesn't modify original files or download anything. Use at your own risk; always keep backups of your Workshop content if you're unsure.
Please note that this is intended only for maps, not mods; furthermore, I don't know what will happen if you use it otherwise, as it wasn't designed for that.
The script won't stop you from applying it to mods, nor does it detect that it is dealing with a mod rather than a map.
