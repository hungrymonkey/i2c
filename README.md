# I2C Boss-worker device

This repository contains various attempts to implement an I2C protocol with VHDL.

Only i2c.vhd and i2c_slave.vhd implementations work.

https://en.wikipedia.org/wiki/I%C2%B2C


## Components

### 1. I2C Boss - Single Boss Design - i2c.vhd

| Variable | Type | Description                | Keyword |
|----------|------|----------------------------|---------|
| bus_clk  | Int  | I2c Bus Clock Speed Cycles | GENERIC |
| sys_clk  | Int  | System Clock Speed Cycles  | GENERIC |
| CLK      | Bit  | Alternating 0 or 1 signal  | PORT    |
| RESET    | Bit  | Reset                      | PORT    |
| P        | Bit  | Pull Up Resistor           | PORT    |
| SDA      | Bit  | Serial Data Line           | PORT    |
| SCL      | Bit  | Stretch Clock              | PORT    |

### 2. Bitwise shiftregister - shift_reg.vhd

| Variable | Type | Description                                | Keyword |
|----------|------|--------------------------------------------|---------|
| trigger  | Bit  | Bit that either store or output the memory | PORT    |
| input    | Bit  | Input bit                                  | PORT    |
| output   | Bit  | Output Bit                                 | PORT    |

### 3. I2C Worker - Single Worker Design i2c_slave.vhd

| Variable   | Type  | Description                | Keyword |
|------------|-------|----------------------------|---------|
| sys_clk    | Int   | Clock on the entire device | GENERIC |
| bus_clk    | Int   | I2c Bus Clock              | GENERIC |
| slave_addr | 7 Bit | Reference Address          | GENERIC |
| CLK        | Bit   | Clock                      | PORT    |
| RESET      | Bit   | Reset Bit                  | PORT    |
| SCL        | Bit   | Stretch Clock              | PORT    |
| SDA        | Bit   | Input Output Bit           | PORT    |
| P          | Byte  | 8 bit pull up resistor     | PORT    |

## Glossary
1. H - Pull up Resistor - https://en.wikipedia.org/wiki/Pull-up_resistor
2. bit - 0 or 1 state
3. byte - 8 bits
