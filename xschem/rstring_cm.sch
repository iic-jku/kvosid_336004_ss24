v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {32k} 110 140 0 0 0.4 0.4 {}
T {32k} 200 140 0 0 0.4 0.4 {}
T {32k} 320 140 0 0 0.4 0.4 {}
T {32k} 410 140 0 0 0.4 0.4 {}
N 160 80 200 80 {
lab=#net1}
N 260 80 300 80 {
lab=#net2}
N 360 80 400 80 {
lab=#net3}
N 460 80 500 80 {
lab=VR_N}
N 70 80 100 80 {
lab=VR_P}
N 130 100 130 120 {
lab=VSS}
N 230 100 230 120 {
lab=VSS}
N 330 100 330 120 {
lab=VSS}
N 430 100 430 120 {
lab=VSS}
N 130 120 430 120 {
lab=VSS}
N 280 120 280 140 {
lab=VSS}
N 280 60 280 80 {
lab=#net2}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 130 80 1 1 {name=R1
L=5.6
model=res_xhigh_po_0p35
spiceprefix=X
mult=1}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 230 80 1 1 {name=R2
L=5.6
model=res_xhigh_po_0p35
spiceprefix=X
mult=1}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 330 80 1 1 {name=R3
L=5.6
model=res_xhigh_po_0p35
spiceprefix=X
mult=1}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 430 80 1 1 {name=R4
L=5.6
model=res_xhigh_po_0p35
spiceprefix=X
mult=1}
C {devices/iopin.sym} 280 140 1 0 {name=p1 lab=VSS}
C {devices/ipin.sym} 70 80 0 0 {name=p2 lab=VR_P}
C {devices/ipin.sym} 500 80 0 1 {name=p3 lab=VR_N}
C {devices/opin.sym} 280 60 3 0 {name=p4 lab=VR_M}
