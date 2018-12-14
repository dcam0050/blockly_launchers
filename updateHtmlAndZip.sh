#!/usr/bin/env bash

declare -a files_arr=("index.html" "resource")
declare -a folders_arr=("developers" "students_linux" "students_win" "students_mac")

file_prefix="/home/michael/docker_home/robot_blockly/block_generator/combined_interface/"
folder_prefix="blockly_sim_"
## now loop through the above array


for fol in "${folders_arr[@]}"
do
    target="$folder_prefix$fol/miro_sim_html"

    for fil in "${files_arr[@]}"
    do
       source="$file_prefix$fil"
       cp -r $source $target
    done
    # or do whatever with individual element of the array
done

rm *.zip
for fol in "${folders_arr[@]}"
do
    target="$folder_prefix$fol"
    zip -r "$target.zip" "$target"
done
