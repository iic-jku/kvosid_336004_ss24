v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {xamp1 - load N} 1370 -300 0 0 0.4 0.4 {}
T {xamp1 - diffpair P} 1370 -540 0 0 0.4 0.4 {}
T {xamp1 - tail} 1380 -820 0 0 0.4 0.4 {}
T {xamp1 - cs stage N} 1720 -300 0 0 0.4 0.4 {}
T {xamp1 - load P} 1730 -540 0 0 0.4 0.4 {}
T {xamp1 - common-mode} 1750 -830 0 0 0.4 0.4 {}
T {xamp1 - bias} 1070 -1010 0 0 0.4 0.4 {}
N 440 -290 440 -260 {
lab=VDD}
N 440 -200 440 -170 {
lab=GND}
N 440 -300 440 -290 {
lab=VDD}
N 360 -660 360 -620 {
lab=vcmi}
N 360 -560 360 -520 {
lab=vcmi}
N 440 -590 440 -570 {
lab=vcmi}
N 440 -510 440 -490 {
lab=GND}
N 360 -460 360 -390 {
lab=vin_n}
N 360 -790 360 -720 {
lab=vin_p}
N 280 -670 320 -670 {
lab=GND}
N 280 -670 280 -470 {
lab=GND}
N 280 -470 320 -470 {
lab=GND}
N 250 -510 320 -510 {
lab=#net1}
N 250 -710 250 -510 {
lab=#net1}
N 250 -710 320 -710 {
lab=#net1}
N 200 -710 200 -620 {
lab=#net1}
N 200 -710 250 -710 {
lab=#net1}
N 200 -560 200 -440 {
lab=GND}
N 200 -470 280 -470 {
lab=GND}
N 160 -570 160 -540 {
lab=GND}
N 160 -540 200 -540 {
lab=GND}
N 40 -610 40 -570 {
lab=vid}
N 40 -610 160 -610 {
lab=vid}
N 40 -510 40 -440 {
lab=GND}
N 630 -660 640 -660 {
lab=vi_p}
N 630 -500 640 -500 {
lab=vi_n}
N 360 -620 360 -560 {
lab=vcmi}
N 640 -660 670 -660 {
lab=vi_p}
N 640 -500 670 -500 {
lab=vi_n}
N 360 -790 520 -790 {
lab=vin_p}
N 360 -390 520 -390 {
lab=vin_n}
N 360 -590 440 -590 {
lab=vcmi}
N 520 -200 520 -170 {
lab=GND}
N 920 -470 920 -440 {
lab=GND}
N 520 -790 520 -660 {
lab=vin_p}
N 520 -660 570 -660 {
lab=vin_p}
N 520 -500 520 -390 {
lab=vin_n}
N 520 -500 570 -500 {
lab=vin_n}
N 920 -710 920 -680 {
lab=VDD}
N 810 -230 810 -200 {
lab=GND}
N 670 -660 720 -660 {
lab=vi_p}
N 720 -660 720 -620 {
lab=vi_p}
N 720 -620 780 -620 {
lab=vi_p}
N 670 -500 720 -500 {
lab=vi_n}
N 720 -540 720 -500 {
lab=vi_n}
N 720 -540 780 -540 {
lab=vi_n}
N 1050 -620 1100 -620 {
lab=voutn}
N 1050 -540 1100 -540 {
lab=voutp}
N 520 -300 520 -260 {
lab=di_pon}
N 880 -710 880 -680 {
lab=di_pon}
N 1140 -440 1140 -420 {
lab=GND}
N 1140 -740 1140 -720 {
lab=GND}
N 1100 -540 1180 -540 {
lab=voutp}
N 1140 -540 1140 -500 {
lab=voutp}
N 1100 -620 1180 -620 {
lab=voutn}
N 1140 -660 1140 -620 {
lab=voutn}
N 740 -240 770 -240 {
lab=voutn}
N 740 -280 770 -280 {
lab=voutp}
N 810 -330 810 -290 {
lab=vout}
N 810 -330 860 -330 {
lab=vout}
C {devices/vsource.sym} 440 -230 0 0 {name=V3 value=1.8
}
C {devices/gnd.sym} 440 -170 0 0 {name=l4 lab=GND}
C {sky130_fd_pr/corner.sym} 190 -270 0 0 {name=CORNER only_toplevel=false corner=tt}
C {devices/code.sym} 60 -270 0 0 {name=STIMULI
only_toplevel=false
value="
.include /foss/designs/amp_dev_sav.spice
.options savecurrents

.save all
.control
set doAmpSim = 1

if $doAmpSim eq 1
	setplot const
	let f_min = 10
	let f_max = 1G
	let f_stop = 500k

	let Adc = 220
	let v_step_o = 0.9
	let v_step_i = -v_step_o/Adc

	let t_rf = 0.01u
	let t_step = 5u
	let t_delay = 0
	let t_per = 2*t_step

	let tstep = 0.001*t_step
	let tstop = 2*t_per
	let tstart = t_delay

	alter @VIN[DC] = 0.0
	alter @VIN[PULSE] = [ 0 $&v_step_i $&t_delay $&t_rf $&t_rf $&t_step $&t_per 0 ]

	ac dec 100 $&const.f_min $&const.f_max

	noise v(vout) vin dec 100 $&const.f_min $&const.f_max

	tran $&tstep $&tstop $&tstart

	setplot ac1
	let Atot = v(vout)/v(vid)		

	let Amag_ol_dB = vdb(Atot)
	let Aarg_ol = 180/PI*cphase(Atot)

	**let Amag_ol_dB_1 = vdb(A1)
	**let Aarg_ol_1 = 180/PI*cphase(A1)

	**let Amag_ol_dB_2 = vdb(A2)
	**let Aarg_ol_2 = 180/PI*cphase(A2)

	meas ac Adc_ol_dB max Amag_ol_dB
	let Amag_fc = Adc_ol_dB-3
	meas ac fc find frequency when Amag_ol_dB = Amag_fc
	meas ac fug_ol find frequency when Amag_ol_dB=0

	let Adc_ol_lin = 10^(Adc_ol_dB/20)
	let err_gain = 1-Adc_ol_lin/(1+Adc_ol_lin)
	print err_gain*100

	plot Amag_ol_dB Aarg_ol ylabel 'Open Loop Magnitude, Phase'

	setplot noise1
	let acgain = onoise_spectrum/inoise_spectrum
	*plot inoise_spectrum ylog xlog
	plot onoise_spectrum ylog xlog ylabel 'Output Noise'
	plot acgain

	setplot noise2
	let p_noise_o = onoise_total^2
	let p_sig_o = v_step_o/sqrt(2)
	let snr = p_sig_o/p_noise_o
	let snr_dB = 10*log10(snr)

	setplot tran2
	let vcmo = (v(voutp)+v(voutn))/2
	plot v(vin_p) v(vin_n) v(voutp) v(voutn) vcmo
end

reset
op


*rm /foss/designs/filter/dc.txt
*show >> /foss/designs/filter/dc.txt
remzerovec
write tb_amp_ol.raw
.endc"}
C {devices/vdd.sym} 440 -300 0 0 {name=l2 lab=VDD}
C {devices/ngspice_get_value.sym} 1375 -215 0 0 {name=r11 node=v(@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vth])
descr="vth"}
C {devices/ngspice_get_value.sym} 1440 -215 0 0 {name=r12 node=v(@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vgs])
descr="vgs"}
C {devices/ngspice_get_value.sym} 1375 -185 0 0 {name=r13 node=v(@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vds])
descr="vds"}
C {devices/ngspice_get_expr.sym} 1440 -185 0 0 {name=r14 node="[format %.2g [expr [ngspice::get_voltage \\\{@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vgs]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vth]\\\}]]]"
descr="vod"}
C {devices/ngspice_get_expr.sym} 1375 -155 0 0 {name=r15 node="[format %.3g [expr [ngspice::get_voltage \\\{@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vds]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vgs]\\\}] + [ngspice::get_voltage \\\{@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[vth]\\\}]]]"
descr="vds-vod"}
C {devices/ngspice_get_value.sym} 1440 -155 0 0 {name=r16 node=@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[gm]
descr="gm"}
C {devices/ngspice_get_expr.sym} 1375 -125 0 0 {name=r17 node="[format %.3g [expr 1 / [ngspice::get_node \\\{@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[gds]\\\}]]]"
descr="rds"}
C {devices/ngspice_get_value.sym} 1440 -125 0 0 {name=r18 node=i(@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[id])
descr="id"}
C {devices/ngspice_get_value.sym} 1500 -215 0 0 {name=r19 node=@m.xamp1.xmn1.msky130_fd_pr__nfet_01v8[cgs]
descr="cgs"}
C {devices/ngspice_get_value.sym} 1075 -925 0 0 {name=r41 node=v(@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vth])
descr="vth"}
C {devices/ngspice_get_value.sym} 1140 -925 0 0 {name=r42 node=v(@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vgs])
descr="vgs"}
C {devices/ngspice_get_value.sym} 1075 -895 0 0 {name=r44 node=v(@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vds])
descr="vds"}
C {devices/ngspice_get_expr.sym} 1140 -895 0 0 {name=r45 node="[format %.2g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vgs]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vod"}
C {devices/ngspice_get_expr.sym} 1075 -865 0 0 {name=r46 node="[format %.3g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vds]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vgs]\\\}] + [ngspice::get_voltage \\\{@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vds-vod"}
C {devices/ngspice_get_value.sym} 1140 -865 0 0 {name=r47 node=@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[gm]
descr="gm"}
C {devices/ngspice_get_expr.sym} 1075 -835 0 0 {name=r48 node="[format %.3g [expr 1 / [ngspice::get_node \\\{@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[gds]\\\}]]]"
descr="rds"}
C {devices/ngspice_get_value.sym} 1140 -835 0 0 {name=r49 node=i(@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[id])
descr="id"}
C {devices/ngspice_get_value.sym} 1200 -925 0 0 {name=r50 node=@m.xamp1.xmp1.msky130_fd_pr__pfet_01v8[cgs]
descr="cgs"}
C {devices/ngspice_get_value.sym} 1755 -765 0 0 {name=r51 node=v(@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vth])
descr="vth"}
C {devices/ngspice_get_value.sym} 1820 -765 0 0 {name=r52 node=v(@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vgs])
descr="vgs"}
C {devices/ngspice_get_value.sym} 1755 -735 0 0 {name=r53 node=v(@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vds])
descr="vds"}
C {devices/ngspice_get_expr.sym} 1820 -735 0 0 {name=r54 node="[format %.2g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vgs]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vod"}
C {devices/ngspice_get_expr.sym} 1755 -705 0 0 {name=r55 node="[format %.3g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vds]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vgs]\\\}] + [ngspice::get_voltage \\\{@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vds-vod"}
C {devices/ngspice_get_value.sym} 1820 -705 0 0 {name=r56 node=@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[gm]
descr="gm"}
C {devices/ngspice_get_expr.sym} 1755 -675 0 0 {name=r57 node="[format %.3g [expr 1 / [ngspice::get_node \\\{@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[gds]\\\}]]]"
descr="rds"}
C {devices/ngspice_get_value.sym} 1820 -675 0 0 {name=r58 node=i(@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[id])
descr="id"}
C {devices/ngspice_get_value.sym} 1880 -765 0 0 {name=r64 node=@m.xamp1.xmp3.msky130_fd_pr__pfet_01v8[cgs]
descr="cgs"}
C {devices/ngspice_get_value.sym} 1395 -455 0 0 {name=r65 node=v(@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vth])
descr="vth"}
C {devices/ngspice_get_value.sym} 1460 -455 0 0 {name=r66 node=v(@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vgs])
descr="vgs"}
C {devices/ngspice_get_value.sym} 1395 -425 0 0 {name=r67 node=v(@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vds])
descr="vds"}
C {devices/ngspice_get_expr.sym} 1460 -425 0 0 {name=r68 node="[format %.2g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vgs]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vod"}
C {devices/ngspice_get_expr.sym} 1395 -395 0 0 {name=r69 node="[format %.3g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vds]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vgs]\\\}] + [ngspice::get_voltage \\\{@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vds-vod"}
C {devices/ngspice_get_value.sym} 1460 -395 0 0 {name=r70 node=@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[gm]
descr="gm"}
C {devices/ngspice_get_expr.sym} 1395 -365 0 0 {name=r71 node="[format %.3g [expr 1 / [ngspice::get_node \\\{@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[gds]\\\}]]]"
descr="rds"}
C {devices/ngspice_get_value.sym} 1460 -365 0 0 {name=r72 node=i(@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[id])
descr="id"}
C {devices/ngspice_get_value.sym} 1520 -455 0 0 {name=r73 node=@m.xamp1.xmp4.msky130_fd_pr__pfet_01v8[cgs]
descr="cgs"}
C {devices/vsource.sym} 440 -540 0 0 {name=V2 value=0.9
}
C {devices/vcvs.sym} 360 -490 0 0 {name=E1 value=0.5}
C {devices/vcvs.sym} 360 -690 0 0 {name=E2 value=0.5}
C {devices/vsource.sym} 40 -540 0 0 {name=VIN value="0 AC 1"
}
C {devices/lab_pin.sym} 360 -790 0 0 {name=l13 sig_type=std_logic lab=vin_p}
C {devices/lab_pin.sym} 360 -390 0 0 {name=l14 sig_type=std_logic lab=vin_n
}
C {devices/lab_pin.sym} 440 -590 1 0 {name=l15 sig_type=std_logic lab=vcmi}
C {devices/lab_pin.sym} 40 -610 1 0 {name=l16 sig_type=std_logic lab=vid}
C {devices/gnd.sym} 40 -440 0 0 {name=l17 lab=GND}
C {devices/gnd.sym} 440 -490 0 0 {name=l18 lab=GND}
C {devices/vcvs.sym} 200 -590 0 0 {name=E3 value=1}
C {devices/gnd.sym} 200 -440 0 0 {name=l19 lab=GND}
C {devices/vsource.sym} 600 -660 3 0 {name=VIINP value=0
}
C {devices/vsource.sym} 600 -500 3 0 {name=VIINN value=0
}
C {devices/vsource.sym} 520 -230 0 0 {name=V4 value=1.8
}
C {devices/gnd.sym} 520 -170 0 0 {name=l33 lab=GND}
C {devices/lab_pin.sym} 520 -300 1 0 {name=p61 sig_type=std_logic lab=di_pon}
C {devices/title.sym} 200 -80 0 0 {name=l3 author="Michael Koefinger"}
C {devices/gnd.sym} 920 -440 0 0 {name=l5 lab=GND}
C {devices/vdd.sym} 920 -710 0 0 {name=l6 lab=VDD}
C {devices/launcher.sym} 130 -130 0 0 {name=h1
descr="Annotate OP"
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
C {devices/ngspice_get_value.sym} 1395 -745 0 0 {name=r10 node=v(@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vth])
descr="vth"}
C {devices/ngspice_get_value.sym} 1460 -745 0 0 {name=r20 node=v(@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vgs])
descr="vgs"}
C {devices/ngspice_get_value.sym} 1395 -715 0 0 {name=r21 node=v(@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vds])
descr="vds"}
C {devices/ngspice_get_expr.sym} 1460 -715 0 0 {name=r22 node="[format %.2g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vgs]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vod"}
C {devices/ngspice_get_expr.sym} 1395 -685 0 0 {name=r23 node="[format %.3g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vds]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vgs]\\\}] + [ngspice::get_voltage \\\{@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vds-vod"}
C {devices/ngspice_get_value.sym} 1460 -685 0 0 {name=r24 node=@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[gm]
descr="gm"}
C {devices/ngspice_get_expr.sym} 1395 -655 0 0 {name=r25 node="[format %.3g [expr 1 / [ngspice::get_node \\\{@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[gds]\\\}]]]"
descr="rds"}
C {devices/ngspice_get_value.sym} 1460 -655 0 0 {name=r26 node=i(@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[id])
descr="id"}
C {devices/ngspice_get_value.sym} 1520 -745 0 0 {name=r27 node=@m.xamp1.xmp2.msky130_fd_pr__pfet_01v8[cgs]
descr="cgs"}
C {devices/ngspice_get_value.sym} 1725 -215 0 0 {name=r43 node=v(@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vth])
descr="vth"}
C {devices/ngspice_get_value.sym} 1790 -215 0 0 {name=r59 node=v(@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vgs])
descr="vgs"}
C {devices/ngspice_get_value.sym} 1725 -185 0 0 {name=r60 node=v(@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vds])
descr="vds"}
C {devices/ngspice_get_expr.sym} 1790 -185 0 0 {name=r61 node="[format %.2g [expr [ngspice::get_voltage \\\{@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vgs]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vth]\\\}]]]"
descr="vod"}
C {devices/ngspice_get_expr.sym} 1725 -155 0 0 {name=r62 node="[format %.3g [expr [ngspice::get_voltage \\\{@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vds]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vgs]\\\}] + [ngspice::get_voltage \\\{@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[vth]\\\}]]]"
descr="vds-vod"}
C {devices/ngspice_get_value.sym} 1790 -155 0 0 {name=r63 node=@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[gm]
descr="gm"}
C {devices/ngspice_get_expr.sym} 1725 -125 0 0 {name=r74 node="[format %.3g [expr 1 / [ngspice::get_node \\\{@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[gds]\\\}]]]"
descr="rds"}
C {devices/ngspice_get_value.sym} 1790 -125 0 0 {name=r75 node=i(@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[id])
descr="id"}
C {devices/ngspice_get_value.sym} 1850 -215 0 0 {name=r76 node=@m.xamp1.xmn3.msky130_fd_pr__nfet_01v8[cgs]
descr="cgs"}
C {devices/ngspice_get_value.sym} 1745 -465 0 0 {name=r95 node=v(@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vth])
descr="vth"}
C {devices/ngspice_get_value.sym} 1810 -465 0 0 {name=r96 node=v(@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vgs])
descr="vgs"}
C {devices/ngspice_get_value.sym} 1745 -435 0 0 {name=r97 node=v(@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vds])
descr="vds"}
C {devices/ngspice_get_expr.sym} 1810 -435 0 0 {name=r98 node="[format %.2g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vgs]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vod"}
C {devices/ngspice_get_expr.sym} 1745 -405 0 0 {name=r99 node="[format %.3g [expr [ngspice::get_voltage \\\{@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vds]\\\}] - [ngspice::get_voltage \\\{@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vgs]\\\}] + [ngspice::get_voltage \\\{@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[vth]\\\}]]]"
descr="vds-vod"}
C {devices/ngspice_get_value.sym} 1810 -405 0 0 {name=r100 node=@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[gm]
descr="gm"}
C {devices/ngspice_get_expr.sym} 1745 -375 0 0 {name=r101 node="[format %.3g [expr 1 / [ngspice::get_node \\\{@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[gds]\\\}]]]"
descr="rds"}
C {devices/ngspice_get_value.sym} 1810 -375 0 0 {name=r102 node=i(@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[id])
descr="id"}
C {devices/ngspice_get_value.sym} 1870 -465 0 0 {name=r103 node=@m.xamp1.xmp6.msky130_fd_pr__pfet_01v8[cgs]
descr="cgs"}
C {devices/lab_pin.sym} 660 -660 1 1 {name=p6 sig_type=std_logic lab=vi_p}
C {devices/lab_pin.sym} 660 -500 3 1 {name=p7 sig_type=std_logic lab=vi_n}
C {devices/vcvs.sym} 810 -260 0 0 {name=E7 value=1}
C {devices/gnd.sym} 810 -200 0 0 {name=l50 lab=GND}
C {devices/lab_pin.sym} 740 -280 0 0 {name=l53 sig_type=std_logic lab=voutp
}
C {devices/lab_pin.sym} 740 -240 2 1 {name=l54 sig_type=std_logic lab=voutn
}
C {devices/capa.sym} 1140 -470 0 0 {name=CL2
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {/foss/designs/amp.sym} 740 -760 0 0 {name=xamp1}
C {devices/lab_pin.sym} 880 -710 1 0 {name=p1 sig_type=std_logic lab=di_pon}
C {devices/capa.sym} 1140 -690 2 0 {name=CL1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1140 -740 2 0 {name=l1 lab=GND}
C {devices/gnd.sym} 1140 -420 0 0 {name=l7 lab=GND}
C {devices/lab_pin.sym} 1180 -540 2 0 {name=l8 sig_type=std_logic lab=voutp
}
C {devices/lab_pin.sym} 1180 -620 0 1 {name=l9 sig_type=std_logic lab=voutn
}
C {devices/lab_pin.sym} 860 -330 0 1 {name=p2 sig_type=std_logic lab=vout}
