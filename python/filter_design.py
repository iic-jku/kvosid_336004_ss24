# KV Open Source IC Design (336.004)
# JKU IIC
# (c) Michael Koefinger 2024
#
# Description: Design Multiple Feedback Low-pass filter, map to RC, estimate area

# Created: 22.02.2024
#
import scipy.signal as scs
from math import pi
from control.matlab import *
import matplotlib.pyplot as plt
import numpy as np


def plot_step_response(b, a, t_start=0, t_stop=0.01e-3, t_step=0.01e-6):
    """ Plot step response of Transfer Function defined by
            b: numerator polynom
            a: denominator polynom
    """
    ltisys = (b, a)
    t = np.r_[t_start:t_stop:t_step]
    t_vec, y_vec = scs.step(ltisys, T=t)
    fig = plt.figure(3)
    ax = fig.add_subplot(1, 1, 1)
    ax.plot(t, y_vec)
    ax.set_title('Step response')
    ax.set_xlabel('Time t (s)')
    ax.set_ylabel('Amplitude (1)')
    # ax.axis((10, 1000, -100, 10))
    ax.grid(which='both', axis='both')
    plt.show(block=False)


def calc_rc_mfb_biquad(a0=1.0, wp=1e7, qp=1.0, k_c=50, c2=0.1e-12, use_a=True):
    """ Calculate RC components for a Low-Pass Biquad Section using a Multiple-Feedback Topology
    [5] Lutz Wangenheim. Aktive Filter und Oszillatoren : Entwurf und Schaltungstechnik
        mit integrierten Bausteinen. Springer-Verlag Berlin Heidelberg, 2008.

            a0: DC Gain
            wp: pole frequency in rad/s
            qp: pole quality factor
            k_c: capacitance ratio C1/C2 (input pole capactor C1, feedback capactor C2)
            c2: capacitance value of feedback capacitor C2
            use_a: whether to use solution a or b of the quadratic equation for input resistor R1
    """
    k_r2 = a0
    d = 4 * qp ** 2 * (1 + k_r2)
    if k_c < d:
        raise ValueError("No real solutions k_C < D!")

    r1_a = (1 + np.sqrt(1 - d / k_c)) / (2 * k_r2 * qp * wp * c2)
    r1_b = (1 - np.sqrt(1 - d / k_c)) / (2 * k_r2 * qp * wp * c2)
    print("R_A = %0.2f" % (r1_a / 1e6), "MOhm")
    print("R_B = %0.2f" % (r1_b / 1e6), "MOhm")
    k_r3_a = 1 / (r1_a ** 2 * c2 ** 2 * k_c * k_r2 * wp ** 2)
    k_r3_b = 1 / (r1_b ** 2 * c2 ** 2 * k_c * k_r2 * wp ** 2)
    print("k_R3_A = %0.2f" % k_r3_a)
    print("k_R3_B = %0.2f" % k_r3_b)

    if use_a:
        r1 = r1_a
        k_r3 = k_r3_a
        print("Note: Solution a is used!")
    else:
        r1 = r1_b
        k_r3 = k_r3_b
        print("Note: Solution b is used!")

    c1 = k_c * c2
    r2 = k_r2 * r1
    r3 = k_r3 * r1

    return [c1, c2, r1, r2, r3]


def estimate_rc_chip_area_sky130(r_tot=1e6, c_tot=10e-12):
    """Estimate the RC Chip Area for SKY130 PDK using M3 MiM Caps and High Rsheet Poly Res.

        return: dictionary with R and C areas in m^2 and um^2
    """

    # Calculate occupied chip area
    w_rpoly = 0.35e-6
    r_sheet = 2000
    c_prime = 2e-15 / 1e-12
    l_rtot = r_tot * w_rpoly / r_sheet
    a_rtot = l_rtot * w_rpoly
    a_rtot_umsq = a_rtot / 1e-12
    a_ctot = c_tot / c_prime
    a_ctot_umsq = a_ctot / 1e-12

    return {'msq': {'R': a_rtot, 'C': a_ctot},
            'umsq': {'R': a_rtot_umsq, 'C': a_ctot_umsq}}


def main():
    # Define Filter Specs
    area_max_umsq = (100e-6 * 200e-6) / 1e-12   # max available chip area

    osr = 10                                    # oversampling ratio
    f_pass = 100e3                               # -3dB corner frequency
    f_s = f_pass*osr                              # sampling frequency of the ADC
    f_stop = f_s / 2                              # start of stop band for filter approx.
    a_pass_db = 6.02                             # Pass-band gain
    a_pass = 10 ** (a_pass_db / 20.0)
    a_stop_db = 50                               # Stop-band attenuation, only used by iirfilter() for Chebychev approx.
    filter_approx = 'butter'                    # Select Butterworth low-pass approximation
    filter_type = 'low'                         # Select low-pass filter
    filter_ord = 3                              # Limit order of the filter prototype

    wpass = 2 * pi * f_pass
    # wstop = 2 * pi * fstop
    wvec = 2*pi*np.logspace(np.log10(f_pass)-2, np.log10(f_stop)+2, 100)

    # Get Prototype coeff.
    res = scs.iirfilter(filter_ord, wpass, btype=filter_type, rs=a_stop_db, analog=True, ftype=filter_approx, output='ba')

    # Unpack result in numerator polynom b and denominator polynom a
    b = res[0]
    a = res[1]

    # Plot PZ, Bode and Step response
    sys_tf = TransferFunction(b, a)
    plt.figure(1)
    pzmap(sys_tf)
    plt.title('Pole-Zero Map of Prototype')
    plt.show(block=False)
    plt.figure(2)
    bode(sys_tf, wvec, Hz=True)
    # plt.title('Bode Plot of Prototype')
    plt.show(block=False)

    plot_step_response(b, a, t_start=0, t_stop=5/f_pass, t_step=0.01/f_pass)

    # Convert to second order sections
    biquads = scs.tf2sos(b, a, analog=True)

    # First biquad
    # Get wp and Qp
    biquad1 = biquads[1]
    b_coeff_proto_1 = biquad1[0:3]
    a_coeff_proto_1 = biquad1[3:6]

    # Normalize
    b_coeff_proto_1 = b_coeff_proto_1 / a_coeff_proto_1[2]
    a_coeff_proto_1 = a_coeff_proto_1 / a_coeff_proto_1[2]

    # Note: static gain of first stage is moved to second stage!
    sys_biquad1 = TransferFunction([0, 0, a_pass], a_coeff_proto_1)
    plt.figure(4)
    pzmap(sys_biquad1)
    plt.title('Pole-Zero Map of 1. Biquad')
    plt.show(block=False)
    plt.figure(5)
    bode(sys_biquad1, wvec, Hz=True)
    # plt.title('Bode Plot of 1. Biquad')
    plt.show(block=False)

    # Get pole frequency and pole quality factor
    wp = 1 / np.sqrt(a_coeff_proto_1[0])
    qp = 1 / (wp * a_coeff_proto_1[1])
    # sol_1_b = sp.solve(b_coeff_circ-b_coeff_proto, [R1, R3])
    # sol_1_a = sp.solve(a_coeff_circ-a_coeff_proto, [R1, R3])
    print("fp = %0.2f" % (2 * pi * wp / 1e3), "kHz")
    print("Qp = %0.2f" % qp)

    C1, C2, R1, R2, R3 = calc_rc_mfb_biquad(a_pass, wp, qp, k_c=20, c2=1e-12, use_a=True)
    print("R1 = %.3f" % (R1 / 1e6), "MOhm")
    print("R2 = %.3f" % (R2 / 1e6), "MOhm")
    print("R3 = %.3f" % (R3 / 1e6), "MOhm")
    print("C1 = %.2f" % (C1 / 1e-12), "pF")
    print("C2 = %.2f" % (C2 / 1e-12), "pF")

    # Second Biquad, single pole, passive RC section
    biquad2 = biquads[0]
    b_coeff_proto_2 = biquad2[0:3]
    a_coeff_proto_2 = biquad2[3:6]

    # Normalize
    b_coeff_proto_2 = b_coeff_proto_2 / a_coeff_proto_2[2]
    a_coeff_proto_2 = a_coeff_proto_2 / a_coeff_proto_2[2]

    # Account for static gain b0 of first stage here
    b_coeff_proto_2 = b_coeff_proto_2 * b_coeff_proto_1[2]
    # Get wp
    wp2 = 1 / a_coeff_proto_2[1]

    sys_biquad2 = TransferFunction(b_coeff_proto_2, a_coeff_proto_2)
    plt.figure(6)
    pzmap(sys_biquad2)
    plt.title('Pole-Zero Map of Passive RC Section')
    plt.show(block=False)
    plt.figure(7)
    bode(sys_biquad2, wvec, Hz=True)
    #plt.title('Bode Plot of Passive RC Section')
    plt.show(block=False)

    # Calc RC of passive RC low-pass
    C3 = 2 * C2
    R4 = 1 / (wp2 * C3)
    R4_MOhm = R4 / 1e6
    C3_pF = C3 / 1e-12
    print("R4 = %.3f" % R4_MOhm, "MOhm")
    print("C3 = %.2f" % C3_pF, "pF")

    # Evaluate Transfer Function
    s = TransferFunction.s
    h1_eval = (R2 / R1) * 1 / (1 + C2 * (R2 + R3 + R2 * R3 / R1) * s + C1 * C2 * R2 * R3 * s ** 2)
    h2_eval = 1 / (1 + s * R4 * C3)
    h_eval = series(h1_eval, h2_eval)
    plt.figure(8)
    pzmap(h_eval)
    plt.title('Pole-Zero Map of Biquad Cascade (based on RC components)')
    plt.show(block=False)
    plt.figure(9)
    bode(h_eval, wvec, Hz=True)
    # plt.title('Bode Plot of Biquad Cascade (based on RC components')
    plt.show(block=False)

    # Estimate Chip Area for SKY130
    CL = 5e-12
    r_vec = np.array([R1, R2, R3, R4])
    c_diff_vec = np.array([C1, C3])
    c_se_vec = np.array([C2, CL])
    r_tot = 2 * np.sum(r_vec)
    c_tot = 2 * np.sum(c_se_vec) + np.sum(c_diff_vec)

    res = estimate_rc_chip_area_sky130(r_tot, c_tot)
    area_rtot_umsq = res['umsq']['R']
    area_ctot_umsq = res['umsq']['C']

    # Roughly estimate op-amp area based on
    # Two-Stage Opamp /w Resistive common-mode feedback
    # from [B. Razavi, The Design of a Biquadratic Filter. 2024]
    # Wp = 100e-6
    # Lp = 0.35e-6
    # Wn1 = 100e-6
    # Wn2 = 20e-6
    # Ln = 0.15e-6
    # Rcm = 40e3
    # Rcm_tot = 4*Rcm
    # A_Rcm = estimate_rc_chip_area_sky130(Rcm_tot, 0)
    #
    # Npmos = 4
    # Nnmos1 = 2
    # Nnmos2 = 2
    # A_most = Npmos * Wp * Lp + Nnmos1 * Wn1 * Ln + Nnmos2 * Wn2 * Ln
    # A_opamp = A_Rcm['msq']['R'] + A_most
    # A_opamp_umsq = A_opamp / 1e-12

    # Feedforward compenstated two-stage opamp
    amp_scale = 5
    Wp = 5e-6
    Lp1 = 0.5e-6
    Lp2 = 0.25e-6
    Lp3 = 0.15e-6
    Wn = 3e-6
    Ln1 = 1e-6
    Ln2 = 0.5e-6
    Ln3 = 0.15e-6
    Wn2 = 20e-6
    Ln = 0.15e-6

    NFpb = 5*amp_scale
    NFntin = 5*amp_scale
    NFntout = 5*NFntin
    NFpl = 15*amp_scale
    NFpd = 50*amp_scale
    NFnd = 50*amp_scale

    NFpb2 = 10 * amp_scale
    NFntin2 = 5 * amp_scale
    NFntout2 = 10 * NFntin
    NFpl2 = 60 * amp_scale
    NFpd2 = 40 * amp_scale
    NFnd2 = 15 * amp_scale

    area_bias = Wp*Lp1*(2*NFpb+1*NFpb2)
    area_ota1 = Wp * Lp1 * NFpl + Wn * Ln1 * (NFntin + NFntout) + Wp * Lp2 * NFpd + Wn * Ln2 * NFnd
    area_ota2 = Wp * Lp1 * NFpl2 + Wn * Ln1 * (NFntin2 + NFntout2) + Wp * Lp3 * NFpd2 + Wn * Ln3 * NFnd2

    Rcm = 100e3
    Ccm = 250e-15
    Rcm_tot = 4*Rcm
    Ccm_tot = 4*Ccm
    area_rc_cm = estimate_rc_chip_area_sky130(Rcm_tot, Ccm_tot)

    area_amp_tot = area_ota1 + area_ota2 + area_rc_cm['msq']['R'] + area_rc_cm['msq']['C']
    area_amp_tot_umsq = area_amp_tot / 1e-12

    area_tot_umsq = area_rtot_umsq + area_ctot_umsq + area_amp_tot_umsq
    print("Artot = %0.2f" % area_rtot_umsq, "umsq")
    print("Actot = %0.2f" % area_ctot_umsq, "umsq")
    print("A_opamp = %0.2f" % area_amp_tot_umsq, "umsq")
    print("Atot = %0.2f" % area_tot_umsq, "umsq")
    print("Amax = %0.2f" % area_max_umsq, "umsq")

    if area_tot_umsq > area_max_umsq:
        raise ValueError("Design does not fit in available area!")


if __name__ == '__main__':
    main()
    input("Press Enter to exit...")
