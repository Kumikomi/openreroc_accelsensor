#include "ros/ros.h"
#include "accel_sensor.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

typedef struct AccelSensor_Data
{
	int ax;
	int ay;
	int az;
} accelsensor_data;

int main(int argc, char **argv)
{
  int fd_32;
  int rc;
  
  int accel_x;
  int accel_y;
  int accel_z;
  int accel_x_signed;
  int accel_y_signed;
  int accel_z_signed;
  float real_ax;
  float real_ay;
  float real_az;

  fd_32 = open("/dev/xillybus_read_32", O_RDONLY);

  ros::init(argc, argv, "openreroc_accelsensor");
  ros::NodeHandle n;
  ros::Publisher pub_openreroc_accelsensor = n.advertise<openreroc_accelsensor::accel_sensor>("accel_sensor_value", 1000);
  // ros::Rate loop_rate(1);

  openreroc_accelsensor::accel_sensor msg;
  
  accelsensor_data cur;

  while (ros::ok())
  {
    rc = read(fd_32, &accel_x, sizeof(accel_x));
    rc = read(fd_32, &accel_y, sizeof(accel_y));
    rc = read(fd_32, &accel_z, sizeof(accel_z));

    if(cur.ax != accel_x && cur.ay != accel_y && cur.az != accel_z){
      //msg.gx = gyro_x;
      //msg.gy = gyro_y;
      //msg.gz = gyro_z;
      accel_x_signed = (accel_x > 32768)? (accel_x-65535) : accel_x;
      accel_y_signed = (accel_y > 32768)? (accel_y-65535) : accel_y;
      accel_z_signed = (accel_z > 32768)? (accel_z-65535) : accel_z;   

      msg.real_ax = accel_x_signed / 16384.0;
      msg.real_ay = accel_y_signed / 16384.0;
      msg.real_az = accel_z_signed / 16384.0;

      //printf("x:%d\n",msg.gx);
      //printf("y:%d\n",msg.gy);
      //printf("z:%d\n",msg.gz);
      printf("rawx:%d\n",accel_x);
      printf("rawy:%d\n",accel_y);
      printf("rawz:%d\n",accel_z);

      pub_openreroc_accelsensor.publish(msg);
    }

    cur.ax = accel_x;
    cur.ay = accel_y;
    cur.az = accel_z;

    ros::spinOnce();
    // loop_rate.sleep();
  }

  close(fd_32);
  return 0;
}
