openreroc_gyrosensor
=======

[OpenReroc (Open Reconfigurable Robot Component)](https://github.com/Kumikomi/OpenReroc) is a project to build an open source platform of reconfigurable (i.e. FPGA) devices for robot components.  
This package supports gyro sensor an FPGA board ([ZedBoard](http://zedboard.org/) Xilinx). 
*openreroc_gyrosensor* publishes sensor data to the topic("gyro_sensor_value").  
 
**Git**:         https://github.com/Kumikomi/openreroc_gyrosensor   
**Author**:      Kazushi Yamashina, Hitomi Kimura(Utsunomiya University)  
**Copyright**:   2015, Kazushi Yamashina, Hitomi Kimura Utsunomiya University    
**License**:      new BSD License   
**Latest Version**: 0.1.0  

Directry tree
=======
```
openreroc_gyrosensor 
|-include/ 
|-msg/ 
|-hardware
	|-src/
    |-image/
|-src/ 
|-CMakeLists.txt 
|-package.xml  
|-LICENSE.txt
```

Requirements
======

##Platform for ROS system

- [ZedBoard](http://zedboard.org/)
- [xillinux-1.3c](http://xillybus.com/xillinux)
 - Xillinux is used to communicate between FPGA logic and ARM processor. Xillinux is a platform for Zynq that is released by Xillybus Ltd. Linux (Ubuntu) OS runs on the ARM processor. Xillinux can access to FPGA logic through a specific device file.
- ROS (hydro or groovy) please install on xillinux!
- ssh server

##Software

- ISE 14.7 (for hardware synthesis)

##Sensor

- [MPU-9250 ９軸センサモジュール(３軸加速度＋３軸ジャイロ＋３軸コンパス) ](https://strawberry-linux.com/catalog/items?code=12250)

<img src="http://aquila.is.utsunomiya-u.ac.jp/~kazushi/mpu-9250.jpg" alt="" height="150" />

reference : https://strawberry-linux.com/catalog/items?code=12250

How to build software
=======
Please replace **catkin_ws** to your work space name.

```
cd ~/catkin_ws/src
git clone https://github.com/Kumikomi/openreroc_gyrosensor
cd ..
catkin_make 
```

Test Run
======= 
1. [Xillinux installation](http://xillybus.com/downloads/doc/xillybus_getting_started_zynq.pdf)
 - http://xillybus.com/xillinux

2. Hardware bitstream installation
Please replace **xillydemo.bit** on the SD card with `openreroc_pwm/hardware/image/openreroc_gyrosensor.bit`

3. Insert SD card & boot system

4. Run sample nodes 

**terminal 1**
```
cd ~/catkin_ws/
source devel/setup.bash
roscore &
rosrun openreroc_gyrosensor sample_output_gyro
```

**terminal 2**
```
cd ~/catkin_ws/
source devel/setup.bash
rosrun openreroc_gyrosensor openreroc_gyrosensor
```

How to build hardware
====== 
It's too complex to describe all the necessary procedure to build hardware, so some hints are shown below.
1 : Place of Soruce code `hardware/src`  
2 : Pin assignment: add the code below to **xillydemo.ucf**  

```verilog
#NET  PS_GPIO[32] LOC = W12 | IOSTANDARD = LVCMOS33;	# JB1
#NET  PS_GPIO[33] LOC = W11 | IOSTANDARD = LVCMOS33;	# JB2
#NET  PS_GPIO[34] LOC = V10 | IOSTANDARD = LVCMOS33;	# JB3
#NET  PS_GPIO[35] LOC = W8  | IOSTANDARD = LVCMOS33;	# JB4
#NET  PS_GPIO[36] LOC = V12 | IOSTANDARD = LVCMOS33;	# JB7
#NET  PS_GPIO[37] LOC = W10 | IOSTANDARD = LVCMOS33;	# JB8
#NET  PS_GPIO[38] LOC = V9  | IOSTANDARD = LVCMOS33;	# JB9
#NET  PS_GPIO[39] LOC = V8  | IOSTANDARD = LVCMOS33;	# JB10

NET  SPI_DI_g LOC = V12 | IOSTANDARD = LVCMOS33;	# JB7
NET  SPI_SS_g LOC = W10 | IOSTANDARD = LVCMOS33;	# JB6
NET  SPI_CK_g LOC = V9  | IOSTANDARD = LVCMOS33;	# JB9
NET  SPI_DO_g LOC = V8  | IOSTANDARD = LVCMOS33;	# JB10
```

3 : Add the ports to Top module **xillydemo.v**

```verilog
input SPI_DI_g,
output SPI_SS_g,
output SPI_CK_g,
output SPI_DO_g
```

4 : Add the FIFO connection to Top module **xillydemo.v**

```verilog
// 32-bit loopback
//   fifo_32x512 fifo_32
//     (
//      .clk(bus_clk),
//      .srst(!user_w_write_32_open && !user_r_read_32_open),
//      .din(user_w_write_32_data),
//      .wr_en(user_w_write_32_wren),
//      .rd_en(user_r_read_32_rden),
//      .dout(user_r_read_32_data),
//      .full(user_w_write_32_full),
//      .empty(user_r_read_32_empty)
//      );

sensor_ctl sensor_ctl(
		.clk(bus_clk),
		.rst_32(!user_w_write_32_open && !user_r_read_32_open),
		.din_32(user_w_write_32_data),
		.wr_en_32(user_w_write_32_wren),
		.rd_en_32(user_r_read_32_rden),
		.dout_32(user_r_read_32_data),
		.full_32(user_w_write_32_full),
		.empty_32(user_r_read_32_empty),

		.SPI_DI_g(SPI_DI_g),
		.SPI_SS_g(SPI_SS_g),
		.SPI_CK_g(SPI_CK_g),
		.SPI_DO_g(SPI_DO_g)
);
```

