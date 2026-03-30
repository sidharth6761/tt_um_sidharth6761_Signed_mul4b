/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_sidharth6761_Signed_mul4b (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire signed [3:0] a;
wire signed [3:0] b;
wire signed [7:0] y;

assign a = ui_in[3:0];
assign b = ui_in[7:4];

multiplier m1 (
    .a(a),
    .b(b),
    .y(y)
);

// Output mapping    
assign uo_out = y;
assign uio_out = 8'b0;
assign uio_oe  = 8'b0;

// List all unused inputs to prevent warnings
wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

module multiplier(
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [7:0] y
);

wire [3:0] abs_a, abs_b;
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
    ka = 0;
    kb = 0;
    k  = 0;
    Xa = 0;
    Xb = 0;
    s  = 0;
    OMUX = 0;
    
    if(abs_a == 0 || abs_b == 0)
    begin
        Xa = 0;
        Xb = 0;
        s = 0;
        k = 0;
        ka = 0;
        kb = 0;
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
    else if (k == 1'b0)
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


//////////////////////////////////////////////////////////////////////////////////
// Priority Encoder - Finds MSB position
// Input: 4-bit unsigned value
// Output: Position of MSB (0-3)
// Valid: 1 if input != 0
//////////////////////////////////////////////////////////////////////////////////

module encoder(
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);

always @(*) begin
    valid = 1'b1;
    casex(in)
        4'b1xxx: out = 2'd3;    // MSB at position 3
        4'b01xx: out = 2'd2;    // MSB at position 2
        4'b001x: out = 2'd1;    // MSB at position 1
        4'b0001: out = 2'd0;    // MSB at position 0
        default: begin
            out = 2'd0;
            valid = 1'b0;        // No valid bit set (input = 0)
        end
    endcase
end

endmodule
