#!/bin/sh
export timestamp=$(date +%H%M%s)
echo $timestamp
rosrun openreroc_gyrosensor openreroc_gyrosensor > log/${timestamp}.txt