@echo off > NUL

:: set de la date
set mypath=%cd%
for /f "tokens=1,2,3 delims=:" %%a in ('time /t') do set heure=%%a
for /f "tokens=1,2,3delims=:" %%a in ('time /t') do set minute=%%b
for /f "tokens=1,2,3 delims=/ " %%a in ('date /t') do set auj=%%c%%b%%a
set madate=%auj%-%heure%%minute%

:: Prompt pour les variables
set sec=8
set /p id=Enter Clip URL (Ctrl + V then press Enter): 
set /p sec=Enter duration of desired outro in seconds (Enter 4, 6 or 8, then press Enter): 

for %%g in (%id%) do set "name=%%~nxg"

:: Download file from twitch ....
TITLE Download file from twitch ....
%mypath%\files\youtube-dl --output %mypath%\files\%name%.mp4 %id%

:: Encoding clip into 1080p60 ....
TITLE Encoding clip into 1080p60 ....
%mypath%\files\ffmpeg -i %mypath%\files\%name%.mp4 -acodec libvo_aacenc -ar 48000 -ab 160k -ac 2 -vcodec libx264 -r 60 -s 1920x1080 -b:v 20000k -maxrate 20000k -bufsize 20000k -y %mypath%\files\%name%_encoded.mp4

:: Joining files together ....
TITLE Joining files together ....
%mypath%\files\ffmpeg -i %mypath%\files\%name%_encoded.mp4 -i %mypath%\files\outro%sec%s.mp4 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" %mypath%\%name%-%madate%.mp4

:: Deleting temporary files ....
TITLE Deleting temporary files ....
del /F /Q %mypath%\files\%name%_encoded.mp4
del /F /Q %mypath%\files\%name%.mp4
cls
TITLE Job is done !
echo Job is done !