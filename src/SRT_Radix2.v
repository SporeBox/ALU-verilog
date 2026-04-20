// SRT Radix-2 Divider - 8 biti
// Imparte Q la M, produce catul Q si restul A
// Tabela de selectie bazata pe A[8:6]:
//   000, 001 → A = A - M  (cifra cat = +1)
//   111, 110 → A = A + M  (cifra cat = -1)
//   altceva  → A = A      (cifra cat =  0)

module SRT_Radix2(
    input            clk,
    input            start,      // semnal de start
    input      [7:0] M_in,       // impartitorul  (INBUS)
    input      [7:0] Q_in,       // deimpartitul  (INBUS)
    output reg [7:0] Q_out,      // catul          (OUTBUS)
    output reg [7:0] A_out,      // restul         (OUTBUS)
    output reg       done        // 1 cand gata
);

    // Registre interne
    reg signed [8:0] A;          // rest partial, 9 biti cu semn
    reg signed [8:0] M;          // impartitorul extins la 9 biti
    reg        [7:0] Q;          // cat in formare (cifre redundante)
    reg        [7:0] Q_neg;      // complementul catului (cifre -1)
    reg        [2:0] CNT2;       // contor iteratii (0..7)
    reg        [3:0] CNT1;       // contor pentru ajustare finala
    reg              mp;         // semnul lui M (M[7])
    reg              running;    // 1 cat timp ruleaza

    // Biti de selectie SRT
    wire [2:0] sel = A[8:6];

    always @(posedge clk) begin
        if (start) begin
            // C0 - initializare
            A     <= 9'b0;
            CNT1  <= 4'b0;
            CNT2  <= 3'b0;
            Q     <= Q_in;
            Q_neg <= 8'b0;
            done  <= 0;
            running <= 1;

            // C1 - citeste M din INBUS
            M  <= {{1{M_in[7]}}, M_in};  // extensie semn la 9 biti
            mp <= M_in[7];               // retine semnul lui M

        end else if (running) begin

            // C2 - verifica mp si pregateste A
            if (mp == 0) begin
                // M pozitiv: A[8:0]=Q[7:0] concatenat cu 0, M[7:0]=M[7:0]
                A    <= {Q[7:0], 1'b0};  // shift stanga
                Q    <= {Q[6:0], 1'b0};
                Q_neg<= 8'b0;
                CNT1 <= CNT1 + 1;
            end else begin
                // M negativ: acelasi lucru dar M se negheaza
                A    <= {Q[7:0], 1'b0};
                Q    <= {Q[6:0], 1'b0};
                Q_neg<= 8'b0;
                CNT1 <= CNT1 + 1;
            end

            // Tabela de selectie SRT - A[8]A[7]A[6]
            case (sel)
                3'b000, 3'b001: begin
                    // Cifra cat = +1: A = A - M
                    A    <= A - M;
                    Q    <= {Q[6:0], 1'b1};      // pune 1 in Q
                    Q_neg<= {Q_neg[6:0], 1'b0};  // pune 0 in Q_neg
                end
                3'b110, 3'b111: begin
                    // Cifra cat = -1: A = A + M
                    A    <= A + M;
                    Q    <= {Q[6:0], 1'b0};       // pune 0 in Q
                    Q_neg<= {Q_neg[6:0], 1'b1};   // pune 1 in Q_neg
                end
                default: begin
                    // Cifra cat = 0: A ramane
                    A    <= A;
                    Q    <= {Q[6:0], 1'b0};
                    Q_neg<= {Q_neg[6:0], 1'b0};
                end
            endcase

            // Verifica CNT2
            if (CNT2 == 3'd7) begin
                // Am facut 8 iteratii

                // Verifica A[8] pentru corectie finala
                if (A[8] == 1'b1) begin
                    A    <= A + M;
                    Q    <= Q + 1;
                end

                // Verifica CNT1 pentru ajustare Q
                if (CNT1 != 4'b0) begin
                    A    <= {A[7:0], Q_in[7]};
                    A[8] <= 1'b0;
                    CNT1 <= CNT1 - 1;
                end

                // C6, C7, C11 - catul final Q = Q - Q_neg
                Q_out <= Q - Q_neg;
                A_out <= A[7:0];
                done    <= 1;
                running <= 0;

            end else begin
                CNT2 <= CNT2 + 1;
            end
        end
    end

endmodule
