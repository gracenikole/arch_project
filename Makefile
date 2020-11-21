default: arm_multi.vvp

arm_multi.vvp: arm_multi.v
	iverilog -o $@ -- $<

arm_multi.vvp: $(filter-out arm_multi.v, $(wildcard *.v))
