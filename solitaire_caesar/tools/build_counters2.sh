#!/bin/bash

# set -x

mkdir -p counters300

function counter {
	pnmtopng tmp/${1}.ppm > counters300/$2.png
}

counter counter_1_1 legion
counter counter_1_14 vp_10
counter counter_1_15 talents_2
counter counter_1_16 talents_1
counter counter_2_14 vp_100
counter counter_2_15 talents_5
counter counter_3_14 vp_1
counter counter_3_15 talents_10
counter counter_3_16 capital
counter counter_4_1 barbarian_civilized
counter counter_8_1 city
counter counter_9_1 control
counter counter_11_1 barbarian_uncivilized
counter counter_11_6 skilled_general
counter counter_11_7 emperor
counter counter_11_8 turn
