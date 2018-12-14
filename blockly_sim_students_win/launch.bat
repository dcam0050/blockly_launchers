@ECHO OFF

REM Set variables 
set containerName=blocklylight

set imageName=dcamilleri13/blocklylight

set arg1=%1



REM Ifs (remember in DOS the program simply goes through instructions, line by line, until it reaches a goto)

if %arg1%==install goto installDocker
if %arg1%==update goto updateDocker

if %arg1%==run goto runDocker


REM else...
echo Parameter not valid. Check instructions.txt.
goto commonexit

REM install routine
:installDocker 
echo Installing docker image...
docker pull %imageName%
goto commonExit


REM update routine
:updateDocker
echo Deleting older image. Ignore errors
docker rm blocklysim
docker rm blocklysimdev
docker rmi dcamilleri13/blocklysim:withsrc

echo Updating docker image...
docker pull %imageName%
goto commonExit

REM run routine
:runDocker
echo Running in display mode...
docker stop %containerName% 
docker run -dit --rm --env="BLOCKLY_PORT=9000" --name=%containerName% --hostname=%HOSTNAME% --network=host --privileged -p 8080:8080 %imageName% ./mirosim.sh %arg2%

cd miro_sim_html && start_page.bat && cd .. &
	
docker attach %containerName%


REM exit
:commonExit
echo Thank you for using MiRoSIM's Docker interface for Windows. Have a nice day.
pause
