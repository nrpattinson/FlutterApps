#!/bin/bash

# set -x

mkdir -p counters300

function counter {
	pnmtopng tmp/${1}.ppm > counters300/$2.png
}

counter counter_1_1_f legio

counter counter_3_2_f leader_marcus_aurelius_bold
counter counter_3_3_f leader_pompeianus
counter counter_3_4_f marker_imperium
counter counter_3_5_f marker_round
counter counter_3_6_f fleet

counter counter_4_2_f leader_pertinax
counter counter_4_3_f leader_maximianus
counter counter_4_4_f marker_year
counter counter_4_5_f eleusinian_mysteries

counter counter_5_1_f fort_1

counter counter_7_1_f army_marcomanni_bold
counter counter_7_3_f army_iazyges_bold
counter counter_7_5_f army_quadi_bold
counter counter_7_6_f no_attack_quadi

counter counter_8_1_f truce_marcomanni
counter counter_8_3_f truce_iazyges
counter counter_8_5_f truce_quadi

counter counter_9_2_f auxilia_1
counter counter_9_4_f mutiny

counter counter_1_1_b legio_flavia_felix_4
counter counter_1_2_b legio_italica_3
counter counter_1_3_b legio_italica_2
counter counter_1_4_b legio_italica_1
counter counter_1_5_b legio_adiutrix_2
counter counter_1_6_b legio_adiutrix_1

counter counter_2_1_b legio_gemina_14
counter counter_2_2_b legio_gemina_13
counter counter_2_3_b legio_gemina_10
counter counter_2_4_b legio_claudia_11
counter counter_2_5_b legio_claudia_7
counter counter_2_6_b legio_macedonia_5

counter counter_3_1_b legio_slaves
counter counter_3_2_b leader_marcus_aurelius_demoralized

counter counter_4_1_b legio_primigenia_22

counter counter_5_1_b fort_2

counter counter_7_1_b army_marcomanni_demoralized
counter counter_7_3_b army_iazyges_demoralized
counter counter_7_5_b army_quadi_demoralized

counter counter_9_2_b auxilia_2
