#!/usr/bin/env bash

containerName=blocklylight
devcontainerName=blocklylightdev
imageName=dcamilleri13/blocklylight


if [ $1 == "install" ]
then
	echo "Installing docker image"
	docker pull $imageName
elif [ $1 == "update" ]
then
	echo "Updating docker image"
	docker pull $imageName
elif [ $1 == "edit" ]
then
	echo "Running in edit mode and will commit on exit. Run in edit_nocommit mode if you're not sure of the changes you will do"
	docker stop $containerName

	docker run -dit --env="DISPLAY="$DISPLAY --env="QT_X11_NO_MITSHM=1" --env="BLOCKLY_PORT=9000" --volume="/home/$USER/docker_home:/root/workspace:rw" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --name=$containerName  \
					--hostname=$HOSTNAME --network=host --privileged $imageName bash

	docker attach $containerName
	echo "wait while commiting changes"
	docker commit $containerName $imageName
	echo "commit finished"
	docker rm $containerName
elif [ $1 == "edit_nocommit" ]
then
	echo "Running in edit mode but won't commit on exit."
	docker stop $devcontainerName

	if [ ! "$(docker ps -aq -f name=$devcontainerName)" ]; then
	    docker run -dit --env="DISPLAY="$DISPLAY --env="QT_X11_NO_MITSHM=1" --env="BLOCKLY_PORT=9000" --volume="/home/$USER/docker_home:/root/workspace:rw" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --name=$devcontainerName  \
					--hostname=$HOSTNAME --network=host --privileged $imageName bash
	else
		docker start $devcontainerName
	fi
	docker attach $devcontainerName
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
