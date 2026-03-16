iverilog -o tb/cla4b_tb.vvp tb/CLA4b_tb.v $(find src -name '*.v' -print) && vvp tb/cla4b_tb.vvp
iverilog -o tb/cla8b_tb.vvp tb/CLA8b_tb.v $(find src -name '*.v' -print) && vvp tb/cla8b_tb.vvp
mv cla4b.vcd sim
mv cla4b_tb.vvp sim
mv cla8b.vcd sim
mv cla8b_tb.vvp sim
./showWave.sh $1
