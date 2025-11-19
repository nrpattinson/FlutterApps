#!/bin/bash

# set -x

mkdir -p counters300

function counter {
	pnmtopng tmp/${1}.ppm > counters300/$2.png
}

counter counter_1_1 mek_ayyubid
counter counter_1_2 mek_juhayna
counter counter_1_3 mek_beja
counter counter_1_4 mek_shilluk
counter counter_1_5 mek_kawahla
counter counter_1_6 crusades_2
counter counter_1_7 portugal

counter counter_2_1 mek_mamluk
counter counter_2_2 mek_jad
counter counter_2_3 mek_kanz
counter counter_2_4 mek_funj
counter counter_2_5 crusades_1
counter counter_2_6 crusades_0

counter counter_3_1 uru_abraham
counter counter_3_2 uru_mark
counter counter_3_3 uru_solomon
counter counter_3_4 uru_kerenbes
counter counter_3_5 uru_rafael
counter counter_3_6 uru_david
counter counter_3_7 metropolitan_peter
counter counter_3_8 metropolitan_jesus

counter counter_4_1 uru_moses_george
counter counter_4_2 uru_george
counter counter_4_3 uru_mercury
counter counter_4_4 uru_joel
counter counter_4_5 uru_zachary
counter counter_4_6 uru_cyriac
counter counter_4_7 metropolitan_john
counter counter_4_8 metropolitan_shenoute

counter counter_5_1 feudal_n1
counter counter_5_6 bishop_f
counter counter_5_7 mosque

counter counter_6_1 feudal_p1
counter counter_6_6 bishop_i
counter counter_6_7 bishop_5
counter counter_6_8 ethiopians

counter counter_7_1 nubian_archers
counter counter_7_3 eparch
counter counter_7_5 monastery_4
counter counter_7_6 monastery_5
counter counter_7_7 land_sale_2
counter counter_7_8 land_sale_3

counter counter_8_6 monastery_6
counter counter_8_8 land_sale_4

counter counter_9_1 princess_mariam
counter counter_9_2 princess_martha
counter counter_9_3 princess_agatha
counter counter_9_4 princess_anthelia
counter counter_9_5 princess_petronia
counter counter_9_6 princess_kristina
counter counter_9_7 dynastic_marriage

counter counter_10_1 asset_nobility
counter counter_10_2 asset_kingship
counter counter_10_3 asset_army
counter counter_10_4 famine
counter counter_10_8 slaves

counter counter_11_1 migration_a
counter counter_11_3 migration_b
counter counter_11_4 migration_c
counter counter_11_6 migration_d
counter counter_11_8 migration_e

