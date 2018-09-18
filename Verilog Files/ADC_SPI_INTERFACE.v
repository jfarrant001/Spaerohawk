// AD5592R ADC MODULE
// Revision A
//   Changes:
//   1) added concantenate_flag reg
//   2) changed extra_options_reg to not assert DAC range bit
//   3) added default cases but left empty for now
module ADC_SPI_INTERFACE(
			SCLK,
			SDI1,
			SDO1,
			SYNC1,
			 );

// INPUTS
input SDO1, SCLK;

// OUTPUTS
output reg SYNC1, SDI1;

// State Machine
// State 0 = Configuration
// State 1 = Extra_Options
// State 2 = Start_Conversions
// state 3 = wait_for_samples
// State 4 = Stream_ADC_Data
// State 5 = Sample channel 0
// State 6 = Sample channel 1
// State 7 = Sample channel 2
// State 8 = Sample channel 3
// State 9 = Sample channel 4
// State 10 = Sample channel 5
// State 11 = Sample channel 6
// State 12 = Sample channel 7

parameter configuration = 0, extra_options = 1, start_conversions = 2, wait_for_samples = 3, stream_adc_data = 4, adc_0 = 5, adc_1 = 6, adc_2 = 7,
adc_3 = 8, adc_4 = 9, adc_5 = 10, adc_6 = 11, adc_7 = 12; 

// ADC DATA
reg [15:0] 
		ADC_CH0,
		ADC_CH1,
		ADC_CH2,
		ADC_CH3,
		ADC_CH4,
		ADC_CH5,
		ADC_CH6,
		ADC_CH7;

reg [3:0] state, next_state;
reg [3:0] count_1;
reg [15:0] config_reg = 16'b0010_0000_1111_1111;
reg [15:0] extra_options_reg = 16'b0001_1001_1010_0000; // Modified with Revision A from 16'b0001_1001_1011_0000 to 16'b0001_1001_1010_0000
reg [15:0] sequence_reg = 16'b0001_0010_1111_1111;
reg [127:0] serial_read;
reg concantenate_flag; // Added with Revision A
integer i;

initial begin
	state = configuration;
	next_state = configuration;
	count_1 = 15;
	SYNC1 = 1;
end


// Chip Initialization & sampling
always@(posedge SCLK) 

begin
	case (state)
	
        configuration: begin
            SYNC1 <= 0;			// Pull SYNC1 LOW
            count_1 <= count_1 - 4'd1; 	// Start counter
            SDI1 <= config_reg[count_1];	// Shift config_reg out MSB

            if (count_1 == 0) 
            begin
                SYNC1 <= 1;	// Pull SYNC HIGH
                count_1 <= 15;	// Reset count_1
                SDI1 <= 0;	// No op mode
                next_state <= extra_options; 
            end
        end

        extra_options: begin
            SYNC1 <= 0;			// Pull SYNC_1 LOW
            count_1 <= count_1 - 4'd1; 	// Start counter
            SDI1 <= extra_options_reg[count_1]; // Shift xtra_opt_reg
                
            if (count_1 == 0) 
            begin
                SYNC1 <= 1;	// Pull SYNC HIGH
                count_1 <= 15;	// Reset count_1
                SDI1 <= 0;	// No op mode
                next_state <= start_conversions; 
            end
        end

        start_conversions: begin
            SYNC1 <= 0;			// Pull SYNC_1 LOW
            count_1 <= count_1 - 4'd1; 	// Start counter
            SDI1 <= sequence_reg[count_1];	// Shift sequence_reg
                
            if (count_1 == 0) 
            begin
                SYNC1 <= 1;	// Pull SYNC HIGH
                count_1 <= 15;	// Reset count_1
                SDI1 <= 0;	// No op mode
                next_state <= wait_for_samples;
            end
        end

        wait_for_samples: begin
            #9 SYNC1 <= 0;		// wait 9, Pull SYNC_1 LOW
            SDI1 <= 0;			// No op mode
            count_1 <= count_1 - 4'd1; 	// Start counter
                
            if (count_1 == 0) 
            begin
                SYNC1 <= 1;	// Pull SYNC HIGH
                count_1 <= 15;	// Reset count_1
                SDI1 <= 0;	// No op mode
                #9 next_state <= adc_0;
            end
        end
        
		adc_0: begin
			concantenate_flag <= 0;
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH0[i] <= SDO1; 		
			end
			SYNC1 <= 1; 
			#9 next_state <= adc_1; // wait 9 cycles
		end

		adc_1: begin
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH1[i] <= SDO1; 		
			end
			SYNC1 <= 1;
			#9 next_state <= adc_2; // wait 9 cycles
		end

		adc_2: begin
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH2[i] <= SDO1; 		
			end
			SYNC1 <= 1;
			#9 next_state <= adc_3; // wait 9 cycles
		end

		adc_3: begin
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH3[i] <= SDO1; 		
			end
			SYNC1 <= 1;
			#9 next_state <= adc_4; // wait 9 cycles
		end

		adc_4: begin
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH4[i] <= SDO1; 		
			end
			SYNC1 <= 1;
			#9 next_state <= adc_5; // wait 9 cycles
		end

		adc_5: begin
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH5[i] <= SDO1; 		
			end
			SYNC1 <= 1;
			#9 next_state <= adc_6; // wait 9 cycles
		end

		adc_6: begin
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH6[i] <= SDO1; 		
			end
			SYNC1 <= 1;
			#9 next_state <= adc_7; // wait 9 cycles
		end

		adc_7: begin
			SDI1 <= 0;	// No op mode
			SYNC1 <= 0;	// Begin
			for (i=15; i>=0; i=i-1) begin
			ADC_CH7[i] <= SDO1; 		
			end
			SYNC1 <= 1;
			concantenate_flag <= 1;
			#9 next_state <= adc_0; // wait 9 cycles
		end
        
        default: begin  // Added with Revision A
            
        end
    endcase
end

// when flag = 1, load all ADC Channels into serial read register	
always@(posedge concantenate_flag) begin
	serial_read <= {ADC_CH7, ADC_CH6, ADC_CH5, ADC_CH4, ADC_CH3, ADC_CH2, ADC_CH1, ADC_CH0};
end

// Update state
always@(posedge SCLK) begin
	state <= next_state;

end

endmodule
