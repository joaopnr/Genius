module fdiv #(parameter FATOR = 25000) (
    input  logic clkin,
    input  logic reset,
    output logic clkout
);

    integer cont;

    initial begin
        clkout = 1'b0;
        cont = 0;
    end
  
    always @(posedge clkin) begin
        if(reset) begin
            cont <= 0;
            clkout <= 1'b0;
        end else if (cont == FATOR) begin
            cont <= 0;
            clkout <= ~clkout;
        end else begin
            cont <= cont + 1;
        end
    end
    
endmodule