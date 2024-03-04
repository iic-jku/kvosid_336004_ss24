v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {OTA Macro Model:
A0 = Gm*Ro = 4mS*2MOhm/2 = 4000
GBW=fug = Gm/(Co+CL)/2/PI = 4mS/(1pF+5pF)/2/PI = 106MHz
BW = fug/A0 = 26.5kHz} 1130 -340 0 1 0.3 0.3 {}
N 1160 -600 1160 -580 {
lab=voutn1}
N 1160 -540 1160 -520 {
lab=voutp1}
N 400 -630 400 -590 {
lab=vcmi}
N 400 -530 400 -490 {
lab=vcmi}
N 480 -560 480 -540 {
lab=vcmi}
N 480 -480 480 -460 {
lab=GND}
N 400 -430 400 -360 {
lab=vin}
N 400 -760 400 -690 {
lab=vip}
N 320 -640 360 -640 {
lab=GND}
N 320 -640 320 -440 {
lab=GND}
N 320 -440 360 -440 {
lab=GND}
N 290 -480 360 -480 {
lab=#net1}
N 290 -680 290 -480 {
lab=#net1}
N 290 -680 360 -680 {
lab=#net1}
N 240 -680 240 -590 {
lab=#net1}
N 240 -680 290 -680 {
lab=#net1}
N 240 -530 240 -410 {
lab=GND}
N 240 -440 320 -440 {
lab=GND}
N 200 -540 200 -510 {
lab=GND}
N 200 -510 240 -510 {
lab=GND}
N 80 -580 80 -540 {
lab=vid}
N 80 -580 200 -580 {
lab=vid}
N 80 -480 80 -410 {
lab=GND}
N 600 -610 610 -610 {
lab=vip}
N 600 -510 610 -510 {
lab=vin}
N 670 -610 680 -610 {
lab=vipp}
N 670 -510 680 -510 {
lab=vinn}
N 400 -590 400 -530 {
lab=vcmi}
N 680 -610 710 -610 {
lab=vipp}
N 680 -510 710 -510 {
lab=vinn}
N 710 -610 750 -610 {
lab=vipp}
N 710 -510 750 -510 {
lab=vinn}
N 510 -260 510 -240 {
lab=vout}
N 400 -760 560 -760 {
lab=vip}
N 400 -360 560 -360 {
lab=vin}
N 400 -560 480 -560 {
lab=vcmi}
N 560 -510 600 -510 {
lab=vin}
N 560 -610 600 -610 {
lab=vip}
N 510 -180 510 -150 {
lab=GND}
N 1000 -690 1000 -670 {
lab=GND}
N 1000 -440 1000 -420 {
lab=GND}
N 970 -580 1040 -580 {
lab=#net2}
N 970 -540 1040 -540 {
lab=#net3}
N 1000 -540 1000 -500 {
lab=#net3}
N 1000 -610 1000 -580 {
lab=#net2}
N 1100 -580 1150 -580 {
lab=voutn1}
N 1100 -540 1150 -540 {
lab=voutp1}
N 1150 -580 1200 -580 {
lab=voutn1}
N 1150 -540 1200 -540 {
lab=voutp1}
N 480 -560 750 -560 {
lab=vcmi}
N 430 -190 470 -190 {
lab=voutn1}
N 430 -230 470 -230 {
lab=voutp1}
N 560 -760 560 -610 {
lab=vip}
N 560 -510 560 -360 {
lab=vin}
C {devices/vsource.sym} 480 -510 0 0 {name=V2 value=0.9
}
C {devices/vcvs.sym} 400 -460 0 0 {name=E1 value=0.5}
C {devices/vcvs.sym} 400 -660 0 0 {name=E2 value=0.5}
C {devices/vsource.sym} 80 -510 0 0 {name=VIN value="0 AC 1"
}
C {devices/lab_pin.sym} 400 -760 0 0 {name=l1 sig_type=std_logic lab=vip}
C {devices/lab_pin.sym} 400 -360 0 0 {name=l1 sig_type=std_logic lab=vin
}
C {devices/lab_pin.sym} 480 -560 1 0 {name=l3 sig_type=std_logic lab=vcmi}
C {devices/launcher.sym} 130 -120 0 0 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
C {sky130_fd_pr/corner.sym} 170 -260 0 0 {name=CORNER only_toplevel=false corner=tt}
C {devices/lab_pin.sym} 80 -580 1 0 {name=l1 sig_type=std_logic lab=vid}
C {devices/gnd.sym} 80 -410 0 0 {name=l1 lab=GND}
C {devices/code.sym} 40 -260 0 0 {name=STIMULI
only_toplevel=false
value="
.options savecurrents
.options method=gear reltol=.005 
.options sparse
.control
save all

let f_sig = 100
let f_min = 10
let f_max = 1000Meg
let f_stop = 5Meg
let tper_sig = 1/f_sig
let tfr_sig = tper_sig/2
let Adc = 4000
let v_step_o = 0.9
let v_step_i = v_step_o/Adc

let t_rf = 0.1u
let t_step = 50u
let t_delay = 0
let t_per = 2*t_step

let tstep = 0.1*t_rf
let tstop = 2*t_per
let tstart = t_delay

alter @VIN[PULSE] = [ 0 $&v_step_i $&t_delay $&t_rf $&t_rf $&t_step $&t_per 0 ]

set wr_singlescale
set wr_vecnames
option numdgt=3


** Main Simulations
	op
	ac dec 100 $&const.f_min $&const.f_max
	tran $&tstep $&tstop $&tstart
		
	setplot ac1
	let A = v(vout)/v(vid)

	let Amag_dB = vdb(A)
	settype decibel Amag_dB
	let Aarg = 180/PI*cphase(A)

	let fdc = const.f_min+1
	meas ac Adc find Amag_dB when frequency = fdc
	let Amag_fc = Adc-3
	meas ac fc find frequency when Amag_dB = Amag_fc
	meas ac Amax max Amag_dB
	meas ac fug find frequency when Amag_dB=0
	
	let Adc_lin = 10^(Adc/20)
	let GBW = Adc_lin*fc
	print Adc_lin
	print GBW

	plot Amag_dB Aarg ylabel 'Magnitude, Phase'

	setplot tran1
	let vid = v(vid)
	let iop = viop#branch
	let ion = vion#branch
	let vcmo = (voutp1+voutn1)/2

	plot iop ion
	plot vid vout vcmo
	plot v(vip) v(vin) v(voutp1) v(voutn1) vcmo


alter @VIN[DC] = 0
op

remzerovec
write tb_ota_fd_2pole.raw
.endc"}
C {devices/gnd.sym} 480 -460 0 0 {name=l14 lab=GND}
C {devices/vcvs.sym} 240 -560 0 0 {name=E3 value=1}
C {devices/gnd.sym} 240 -410 0 0 {name=l15 lab=GND}
C {devices/title.sym} 160 -40 0 0 {name=l22 author="Michael Koefinger"}
C {devices/lab_pin.sym} 710 -610 1 0 {name=p3 sig_type=std_logic lab=vipp}
C {devices/lab_pin.sym} 710 -510 3 0 {name=p4 sig_type=std_logic lab=vinn}
C {devices/vsource.sym} 640 -610 3 0 {name=VIINP value=0
}
C {devices/vsource.sym} 640 -510 3 1 {name=VIINN value=0
}
C {devices/lab_pin.sym} 1160 -520 3 0 {name=l10 sig_type=std_logic lab=voutp1
}
C {devices/lab_pin.sym} 1160 -600 3 1 {name=l11 sig_type=std_logic lab=voutn1
}
C {devices/lab_pin.sym} 510 -260 0 1 {name=l12 sig_type=std_logic lab=vout}
C {devices/vcvs.sym} 510 -210 0 0 {name=E5 value=1}
C {devices/gnd.sym} 510 -150 0 0 {name=l13 lab=GND}
C {devices/vsource.sym} 1070 -580 3 0 {name=VIOP value=0
}
C {devices/vsource.sym} 1070 -540 3 1 {name=VION value=0
}
C {devices/capa.sym} 1000 -470 0 0 {name=C4
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {devices/capa.sym} 1000 -640 0 0 {name=C6
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1000 -420 0 0 {name=l26 lab=GND}
C {devices/gnd.sym} 1000 -690 2 0 {name=l27 lab=GND}
C {devices/lab_pin.sym} 430 -190 2 1 {name=l2 sig_type=std_logic lab=voutn1
}
C {devices/lab_pin.sym} 430 -230 0 0 {name=l4 sig_type=std_logic lab=voutp1
}
C {/foss/designs/macro-models/ota_fd_2pole.sym} 750 -660 0 0 {name=xota1 GM=4m RO=2Meg CO=1p RP=0 CP=0.1p VCMO=0.9 I0=100u}
