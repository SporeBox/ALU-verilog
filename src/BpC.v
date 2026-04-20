module BpC(input Gjk, input Pjk, input Gij, input Pij, input ci,
           output Gik, output Pik, output cj);

assign Gik = Gjk | (Gij & Pjk);
assign Pik = Pjk & Pij;
assign cj =Gij | (Pij & ci);

endmodule
