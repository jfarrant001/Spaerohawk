/**
 * @filename ADC_SPI_INTERFACE_TB.v
 * @brief This is a testbench for verifying the design of
 *        the ADC_SPI_INTERFACE module
 *
 *
 */
 
module ADC_SPI_INTERFACE_TB();


    /* DUT input signals */
    reg SCLK;
    reg SDO1;
    
    /* DUT output signals */
    wire SYNC1;
    wire SDI1;
    
    /* Device Under Test (DUT) instantiation */
    ADC_SPI_INTERFACE DUT
    (
        .SCLK(SCLK),
        .SDI1(SDI1),
        .SDO1(SDO1),
        .SYNC1(SYNC1)
    );

    initial begin
        SCLK = 1'b0;
        SDO1 = 1'b0;
        
        
    end
    
    /* Generate clock */
    always@(SCLK)
        #5 SCLK <= ~SCLK; // 5 time units is arbitrarily chosen
    
endmodule
