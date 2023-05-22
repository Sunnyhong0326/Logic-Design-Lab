`timescale 1ns/1ps

module Exhausted_Testing(a, b, cin, error, done);
output [3:0] a, b;
output cin;
output error;
output done;

reg error = 1'b0, done = 1'b0;
reg [4:0] tmp = 4'b0000;
// input signal to the test instance.
reg [3:0] a = 4'b0000;
reg [3:0] b = 4'b0000;
reg cin = 1'b0;

// output from the test instance.
wire [3:0] sum;
wire cout;

// instantiate the test instance.
Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

initial begin
    // design you test pattern here.
    // Remember to set the input pattern to the test instance every 5 nanasecond
    // Check the output and set the `error` signal accordingly 1 nanosecond after new input is set.
    // Also set the done signal to 1'b1 5 nanoseconds after the test is finished.
    // Example:
    repeat(2)begin
        repeat(2 ** 4)begin
            repeat(2 ** 4)begin
            tmp = a + b + cin;
            #1 
            if(tmp!={cout, sum})
                error = 1'b1;
            else
                error = 1'b0;
            #4
             a = a + 4'b0001;
            end
            b = b + 4'b0001;
        end
        cin = cin + 1'b1;
    end
#1 error = 1'b0;
#4 done = 1'b1;
#5 done = 1'b0;
end

endmodule