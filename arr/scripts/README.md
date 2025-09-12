# qBittorrent Post-Processing Script
A bash script to automatically split FLAC files based on a CUE sheet, correcting for invalid time stamps and creating individual track files. It is designed to be used as a "Run external program after torrent finished" script for qBittorrent. 

Lidarr doesn't import music that has .flac and .cue files for a whole album. This script resolves that issue by parsing the CUE file, correcting any time error, and splitting the FLAC file into individual FLAC files so that Lidarr can import them correctly. 

This script first checks for a single FLAC and CUE file pair to ensure it only triggers at the correct download. It then uses 'awk' to correct any broken file stamps (the file I was testing it on had this issue, so I added support for if this happens again). Finally, it uses "ffmpeg" to split the main FLAC file into individual, properly named files.  

If you want to use this script too, go on, it wasn't that hard to code. 
You will need these dependecies:
- FFmpeg
- gnu-libiconv

I made a custom Dockerfile to install these dependecies automatically into the lscr.io/linuxserver/qbittorrent:latest. You can find it in this repo too. 
