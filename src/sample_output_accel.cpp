#include "ros/ros.h"
#include "accel_sensor.h"
#include <stdio.h>

void chatterCallback(const openreroc_accelsensor::accel_sensor msg)
{
    printf("x:%f\n",msg.real_ax);
    printf("y:%f\n",msg.real_ay);
    printf("z:%f\n",msg.real_az);
}

int main(int argc, char  **argv)
{
	ros::init(argc, argv, "sample_output_accel");
	ros::NodeHandle n;
	ros::Subscriber sub = n.subscribe("accel_sensor_value", 1000, chatterCallback);
	ros::spin();
  	return 0;
}
