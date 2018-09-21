/**
 * @filename ADC_SPI_INTERFACE_TB.v
 * @brief This is a testbench for verifying the design of
 *        the ADC_SPI_INTERFACE module
 *
 *
 */
 
module ADC_SPI_INTERFACE_TB();

	// For timing purposes
	localparam HALF_PERIOD = 5;
	localparam PERIOD = HALF_PERIOD*2;

    /* DUT input signals */
    reg SCLK;
    reg SDO1;
    
    /* DUT output signals */
    wire SYNC1;
    wire SDI1;
	 wire [127:0] serial_read;
    
    integer i;
    
    /* Device Under Test (DUT) instantiation */
    ADC_SPI_INTERFACE DUT
    (
        .SCLK(SCLK),
        .SDI1(SDI1),
        .SDO1(SDO1),
        .SYNC1(SYNC1),
		  .serial_read(serial_read)
    );

    initial begin
        SCLK = 1'b0;
        SDO1 = 1'b0;
        i = 0;
        
		  #(PERIOD*16*5);
		  // Send random numbers to the simulated ADC
        for (i=0; i<128; i=i+1)
            #PERIOD SDO1 <= $urandom%2;
				
			#(PERIOD*50);
			$stop;
    end
    
    /* Generate clock */
    always@(SCLK)
        #HALF_PERIOD SCLK <= ~SCLK; // 5 time units is arbitrarily chosen
    
endmodule
