#!/usr/bin/env bash

containerName=blocklylight
imageName=dcamilleri13/blocklylight

if [ $1 == "install" ]
then
	echo "Installing docker image"
	docker pull $imageName

elif [ $1 == "update" ]
then
	echo "Deleting older image. Ignore errors"
	docker rm "blocklysim"
	docker rm "blocklysimdev"
	docker rmi "dcamilleri13/blocklysim:withsrc"

	echo "Updating docker image"
	docker pull $imageName
	
elif [ $1 == "run" ]
then
	echo "Running in display mode"
	docker stop $containerName
	docker run -dit --rm --env="DISPLAY="$DISPLAY --env="QT_X11_NO_MITSHM=1" --env="BLOCKLY_PORT=9000" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --name=$containerName  \
					--hostname=$HOSTNAME --network=host --privileged $imageName ./mirosim.sh $2
	cd ./miro_sim_html && ./start_page.sh &
	docker attach $containerName
else
	echo "Unknown parameter"
fi
