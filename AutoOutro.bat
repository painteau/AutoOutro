@echo off > NUL
set mypath=%cd%
set /p id=Enter Clip URL (Ctrl + V then press Enter): 
set /p sec=Enter duration of desired outro in seconds (Enter 4, 6 or 8, then press Enter): 
TITLE Download file from twitch ....
%mypath%\files\youtube-dl --output %mypath%\files\clip.mp4 %id%
TITLE Encoding clip into 1080p60 ....
%mypath%\files\ffmpeg -i %mypath%\files\clip.mp4 -acodec libvo_aacenc -ar 48000 -ab 160k -ac 2 -vcodec libx264 -r 60 -s 1920x1080 -b:v 20000k -maxrate 20000k -bufsize 20000k -y %mypath%\files\intermediaire.mp4
TITLE Joining files together ....
%mypath%\files\ffmpeg -i %mypath%\files\intermediaire.mp4 -i %mypath%\files\outro%sec%s.mp4 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" %mypath%\FINAL.mp4
TITLE Deleting temporary files ....
del /F /Q %mypath%\files\intermediaire.mp4
del /F /Q %mypath%\files\clip.mp4
cls
TITLE Job is done !
echo Job is done !
pause