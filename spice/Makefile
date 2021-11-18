
plt=python3 ../../py/plot.py

pixSens:
	${MAKE} ngspice	 TB=pixelSensor_tb

ngspice:
	ngspice -a ${TB}.cir

comp:
	ngspice comparator_tb.cir

memc:
	ngspice memory_cell_tb.cir
pix:
	ngspice pixel_tb.cir

top:
	ngspice top.cir
