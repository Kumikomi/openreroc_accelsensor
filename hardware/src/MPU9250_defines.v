`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:47:09 11/17/2015 
// Design Name: 
// Module Name:    MPU9250_defines 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define MPU9250_RA_WHO_AM_I         8'h75
`define MPU9250_RA_ACCEL_XOUT_H     8'h3B
`define MPU9250_RA_ACCEL_XOUT_L     8'h3C
`define MPU9250_RA_ACCEL_YOUT_H     8'h3D
`define MPU9250_RA_ACCEL_YOUT_L     8'h3E
`define MPU9250_RA_ACCEL_ZOUT_H     8'h3F
`define MPU9250_RA_ACCEL_ZOUT_L     8'h40
`define MPU9250_RA_TEMP_OUT_H       8'h41
`define MPU9250_RA_TEMP_OUT_L       8'h42
`define MPU9250_RA_GYRO_XOUT_H      8'h43
`define MPU9250_RA_GYRO_XOUT_L      8'h44
`define MPU9250_RA_GYRO_YOUT_H      8'h45
`define MPU9250_RA_GYRO_YOUT_L      8'h46
`define MPU9250_RA_GYRO_ZOUT_H      8'h47
`define MPU9250_RA_GYRO_ZOUT_L      8'h48


//`define MPU9250_RA_SIGNAL_PATH_RESET    8'h68
//`define MPU9250_RA_MOT_DETECT_CTRL      8'h69
//`define MPU9250_RA_USER_CTRL        8'h6A
//`define MPU9250_RA_PWR_MGMT_1       8'h6B
//`define MPU9250_RA_PWR_MGMT_2       8'h6C
//`define MPU9250_RA_BANK_SEL         8'h6D
//`define MPU9250_RA_MEM_START_ADDR   8'h6E
//`define MPU9250_RA_MEM_R_W          8'h6F
//`define MPU9250_RA_DMP_CFG_1        8'h70
//`define MPU9250_RA_DMP_CFG_2        8'h71
//`define MPU9250_RA_FIFO_COUNTH      8'h72
//`define MPU9250_RA_FIFO_COUNTL      8'h73
//`define MPU9250_RA_FIFO_R_W         8'h74
