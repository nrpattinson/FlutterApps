#!/bin/bash

# set -x

mkdir -p counters600

function counter {
	pnmtopng tmp/${1}.ppm > counters600/$2.png
}

counter counter_1_1 plane_blue_d
counter counter_1_2 plane_blue_b
counter counter_1_3 diplomat_britain
counter counter_1_4 diplomat_france
counter counter_1_5 diplomat_italy
counter counter_1_6 duce
counter counter_1_7 army_italian_a
counter counter_1_8 army_italian_b

counter counter_2_1 plane_blue_a
counter counter_2_2 plane_blue_c
counter counter_2_3 diplomat_mexico
counter counter_2_4 diplomat_ussr
counter counter_2_5 diplomat_china
counter counter_2_6 carro_armato
counter counter_2_7 army_italian_c
counter counter_2_8 army_italian_d

counter counter_3_1 chit_1
counter counter_3_2 chit_2
counter counter_3_3 chit_3
counter counter_3_4 chit_4
counter counter_3_5 chit_5
counter counter_3_6 chit_6
counter counter_3_7 chit_7
counter counter_3_8 chit_8

counter counter_4_1 chit_9
counter counter_4_2 chit_10
counter counter_4_3 chit_11
counter counter_4_4 chit_12
counter counter_4_5 chit_13
counter counter_4_6 chit_14
counter counter_4_7 chit_15
counter counter_4_8 chit_16

counter counter_5_1 chit_17
counter counter_5_2 chit_18
counter counter_5_3 chit_19
counter counter_5_4 chit_20
counter counter_5_5 chit_21
counter counter_5_6 chit_22
counter counter_5_7 plane_yellow_d
counter counter_5_8 plane_yellow_b

counter counter_6_1 chit_23
counter counter_6_2 chit_24
counter counter_6_3 chit_25
counter counter_6_4 chit_26
counter counter_6_5 chit_27
counter counter_6_6 chit_28
counter counter_6_7 plane_yellow_a
counter counter_6_8 plane_yellow_c

counter counter_7_1 ras_a
counter counter_7_2 ras_c
counter counter_7_3 ras_b
counter counter_7_4 ras_d
counter counter_7_5 dollars
counter counter_7_6 oerlikon
counter counter_7_7 military_events
counter counter_7_8 drm_p1

counter counter_8_1 partisans_a
counter counter_8_2 partisans_b
counter counter_8_3 partisans_c
counter counter_8_4 partisans_d
counter counter_8_5 empire_ethiopia
counter counter_8_6 iea
counter counter_8_7 negus
counter counter_8_8 drm_n1

counter counter_9_5 blackshirts
counter counter_9_6 kebur_zabanya
counter counter_9_7 attack
counter counter_9_8 minefield

counter counter_10_5 red_cross_hospital
counter counter_10_6 black_lions
counter counter_10_7 sequence_of_play
counter counter_10_8 italian_east_africa

counter counter_11_1 fascist_rule
counter counter_11_5 army_aoi_a
counter counter_11_6 army_aoi_b
counter counter_11_7 army_aoi_c
counter counter_11_8 army_aoi_d

counter counter_1_3_r180 diplomat_britain_flipped
counter counter_1_4_r180 diplomat_france_flipped
counter counter_1_5_r180 diplomat_italy_flipped
counter counter_1_7_r180 army_italian_a_flipped
counter counter_1_8_r180 army_italian_b_flipped

counter counter_2_3_r180 diplomat_mexico_flipped
counter counter_2_4_r180 diplomat_ussr_flipped
counter counter_2_5_r180 diplomat_china_flipped
counter counter_2_7_r180 army_italian_c_flipped
counter counter_2_8_r180 army_italian_d_flipped

counter counter_11_5_r180 army_aoi_a_flipped
counter counter_11_6_r180 army_aoi_b_flipped
counter counter_11_7_r180 army_aoi_c_flipped
counter counter_11_8_r180 army_aoi_d_flipped
