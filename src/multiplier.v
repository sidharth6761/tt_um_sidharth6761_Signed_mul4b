`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2026 12:56:54
// Design Name: 
// Module Name: multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module multiplier(
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [7:0] y
);

wire [3:0] abs_a, abs_b;
wire [7:0] mag_result;
wire result_sign;
wire [1:0] pe1, pe2;
wire v1, v2;

reg [1:0] ka, kb;
reg [2:0] k;
reg [7:0] Xa, Xb, s;
reg [2:0] OMUX;

// ========================================
// Step 1: Extract sign bits
// ========================================
wire sign_a = a[3];
wire sign_b = b[3];

// ========================================
// Step 2: Convert to absolute values (2's complement)
// ========================================
assign abs_a = sign_a ? (~a + 1) : a;
assign abs_b = sign_b ? (~b + 1) : b;

// ========================================
// Step 3: Encoders work on absolute values
// ========================================
encoder e1(.in(abs_a), .out(pe1), .valid(v1));
encoder e2(.in(abs_b), .out(pe2), .valid(v2));

// ========================================
// Step 4: Mitchell multiplication on absolute values
// ========================================
always @(*) begin
    if(abs_a == 0 || abs_b == 0)
    begin
        Xa = 0;
        Xb = 0;
        s = 0;
        k = 0;
    end
    else
    begin
        ka = pe1;
        kb = pe2;

        Xa = abs_a << kb;
        Xb = abs_b << ka;

        s = Xa + Xb;
        k = ka + kb;
    end
    
    if (s[k] == 1'b0)
        OMUX = {~s[k], s[k-1 -:2]};
    else if (k==1'b0)
        OMUX = 1'b0;    
    else
        OMUX = s[k-1 -:3];
end

wire [7:0] unsigned_result = (k > 1) ? ({s[k], OMUX, {5{1'b1}}} >> (6-(k-1))) : 8'b0;

// ========================================
// Step 5: Calculate result sign (XOR of input signs)
// ========================================
assign result_sign = sign_a ^ sign_b;

// ========================================
// Step 6: Convert result back to signed (if needed)
// ========================================
assign y = result_sign ? (~unsigned_result + 1) : unsigned_result;

endmodule




module encoder(
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);
always @(*) begin
    valid = 1'b1;
    casex(in)
        4'b1xxx: out = 2'd3;
        4'b01xx: out = 2'd2;
        4'b001x: out = 2'd1;
        4'b0001: out = 2'd0;
        default: begin
            out = 2'd0;
            valid = 1'b0;
        end
    endcase
end
endmodule

