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
	docker run -dit --env="BLOCKLY_PORT=9000" --name=$containerName --hostname=$HOSTNAME --network=host --privileged $imageName ./mirosim.sh $2
	./miro_sim_html/start_page.sh &
	docker attach $containerName
else
	echo "Unknown parameter"
fi
