#!/bin/sh
export timestamp=$(date +%H%M%s)
echo $timestamp
rosrun openreroc_accelsensor openreroc_accelsensor > log/${timestamp}.txt