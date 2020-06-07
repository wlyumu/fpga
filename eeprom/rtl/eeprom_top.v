
module eeprom_top(
    //system clock
    input               sys_clk    ,      // 系统时钟
    input               sys_rst_n  ,      // 系统复位
    //eeprom interface
    output              rom_scl    ,      // eeprom的时钟线scl
    inout               rom_sda    ,      // eeprom的数据线sda
    //user interface
    output   [3:0]      led               // led显示
);

//parameter define
parameter    SLAVE_ADDR =  7'b1010000   ; // 器件地址(SLAVE_ADDR)
parameter    BIT_CTRL   =  1'b1         ; // 字地址位控制参数(16b/8b)
parameter    CLK_FREQ   = 26'd50_000_000; // i2c_dri模块的驱动时钟频率(CLK_FREQ)
parameter    I2C_FREQ   = 18'd250_000   ; // I2C的SCL时钟频率
parameter    L_TIME     = 17'd125_000   ; // led闪烁时间参数

//wire define
wire           clk       ;                // I2C操作时钟
wire           i2c_exec  ;                // i2c触发控制
wire   [15:0]  i2c_addr  ;                // i2c操作地址
wire   [ 7:0]  i2c_data_w;                // i2c写入的数据
wire           i2c_done  ;                // i2c操作结束标志
wire           i2c_rh_wl ;                // i2c读写控制
wire   [ 7:0]  i2c_data_r;                // i2c读出的数据
wire           error_flag;                // 错误标志

//*****************************************************
//**                    main code
//*****************************************************

//例化e2prom读写模块
eeprom_rw u_e2prom_rw(
    //global clock
    .clk         (clk       ),    // 时钟信号
    .rst_n       (sys_rst_n ),    // 复位信号
    //i2c interface
    .i2c_exec    (i2c_exec  ),    // I2C触发执行信号
    .i2c_rh_wl   (i2c_rh_wl ),    // I2C读写控制信号
    .i2c_addr    (i2c_addr  ),    // I2C器件内地址
    .i2c_data_w  (i2c_data_w),    // I2C要写的数据
    .i2c_data_r  (i2c_data_r),    // I2C读出的数据
    .i2c_done    (i2c_done  ),    // I2C一次操作完成
    //user interface
    .error_flag  (error_flag)     // 错误标志
);

//例化i2c_dri
i2c_driver #(
    .SLAVE_ADDR  (SLAVE_ADDR),    // slave address从机地址，放此处方便参数传递
    .CLK_FREQ    (CLK_FREQ  ),    // i2c_dri模块的驱动时钟频率(CLK_FREQ)
    .I2C_FREQ    (I2C_FREQ  )     // I2C的SCL时钟频率
) u_i2c_driver(
    //global clock
    .clk         (sys_clk   ),    // i2c_dri模块的驱动时钟(CLK_FREQ)
    .rst_n       (sys_rst_n ),    // 复位信号
    //i2c interface
    .i2c_exec    (i2c_exec  ),    // I2C触发执行信号
    .bit_ctrl    (BIT_CTRL  ),    // 器件地址位控制(16b/8b)
    .i2c_rh_wl   (i2c_rh_wl ),    // I2C读写控制信号
    .i2c_addr    (i2c_addr  ),    // I2C器件内地址
    .i2c_data_w  (i2c_data_w),    // I2C要写的数据
    .i2c_data_r  (i2c_data_r),    // I2C读出的数据
    .i2c_done    (i2c_done  ),    // I 2C一次操作完成
    .scl         (rom_scl   ),    // I2C的SCL时钟信号
    .sda         (rom_sda   ),    // I2C的SDA信号
    //user interface
    .i2c_driv_clk(clk       )     // I2C操作时钟
);

//例化led_alarm模块
led_alarm #(.L_TIME(L_TIME  )     // 控制led闪烁时间
) u_led_alarm(
    //system clock
    .clk         (clk       ),    // 时钟信号
    .rst_n       (sys_rst_n ),    // 复位信号
    //led interface
    .led         (led       ),    // LED 灯
    //user interface
    .error_flag  (error_flag)     // 错误标志
);
endmodule