default: arm_multi.vvp

arm_multi.vvp: arm_multi.v
	iverilog -o $@ -- $<

arm_single.vvp: $(filter-out arm_single.v, $(wildcard *.v))
