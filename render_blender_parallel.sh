#!/bin/bash

BLENDER_FULL_PATH=$(realpath $1)
START_FRAME=$2
END_FRAME=$3
EXT=$(echo $4 | tr '[:lower:]' '[:upper:]')
EXT_LOWER=$(echo $EXT| tr '[:upper:]' '[:lower:]')

PROJ_FOLDER=$(dirname $BLENDER_FULL_PATH)/
BLENDER_FILENAME=$(basename $BLENDER_FULL_PATH)
PARENT_FOLDER=$(dirname $PROJ_FOLDER)/
PROJ_FOLDER_REL=${PROJ_FOLDER#$PARENT_FOLDER}

NUMBER_NODES=$(grep -v "^#" ~/.parallel/sshloginfile | wc -l)
FRAMES_FOLDER=${PROJ_FOLDER_REL::-1}-frames

BLENDER_EXECUTABLE='~/bin/blender-2.80'

echo $PROJ_FOLDER
echo $BLENDER_FILENAME
echo $PARENT_FOLDER
echo $PROJ_FOLDER_REL
echo $EXT
echo $EXT_LOWER
echo $START_FRAME
echo $END_FRAME
echo $FRAMES_FOLDER
echo $NUMBER_NODES

cd $PARENT_FOLDER

echo "Transfering files"
seq 1 $NUMBER_NODES | parallel --slf ~/.parallel/sshloginfile --progress --workdir /tmp/blender_rendering --plus --tf $PROJ_FOLDER_REL echo "Copied to \`hostname\`"
echo "Transfered!"

echo "Rendering"
seq $START_FRAME $END_FRAME | parallel --slf ~/.parallel/sshloginfile --progress --workdir /tmp/blender_rendering --plus --return $FRAMES_FOLDER/{1}.$EXT_LOWER $BLENDER_EXECUTABLE --background ${PROJ_FOLDER_REL::-1}/$BLENDER_FILENAME -o "$FRAMES_FOLDER/#.$EXT_LOWER" -F $EXT -f {1} > /dev/null
echo "Rendered"

echo "Removing files"
seq 1 $NUMBER_NODES | parallel --slf ~/.parallel/sshloginfile --progress --workdir /tmp/blender_rendering --plus rm -rf $PROJ_FOLDER_REL
seq 1 $NUMBER_NODES | parallel --slf ~/.parallel/sshloginfile --progress --workdir /tmp/blender_rendering --plus rm -rf $FRAMES_FOLDER
echo "Removed"
