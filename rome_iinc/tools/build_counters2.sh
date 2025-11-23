#!/bin/bash

# set -x

mkdir -p counters180

function counter {
	cp "HIRES/${1}.png" counters180/$2.png
}

function leader {
	counter "Ldr-${1}" leader_${2}
}

function command {
	counter "Loyal-${1}_2" loyal_${2}
	counter "Rebel-${1}" rebel_${2}
}

function date {
	counter "Mkr-Date-${1}" date_${2}
}

function dynasty {
	counter "Mkr-Dyn-${1}" dynasty_${2}
}

function legion {
	counter "Rome-Leg-${1}" legion_${2}
	counter "Rome-Leg-${1}-2" legion_${2}_veteran
}

function statesman {
	counter "Rome2-SM-${1}" statesman_${2}
}

function war {
	counter "War-${1}" war_${2}
}

counter Mkr-Fleet fleet_veteran
counter Mkr-Fleet-1 fleet

leader Avar-Bayan-4 bayan
leader Frankish-Clovis-4 clovis
leader Gothic-Fritigern-5 fritigern
leader Hun-Attilia-5 attila
leader Ostrogoth-Totila-3 totila
leader Persian-Chosroes-7 chosroes
leader Persian-Shapur-4 shapur
leader Vandal-Gaiseric-5 gaiseric

counter Ldr-War-Back barbarian

counter Loyal-Africa_2 loyal_africa
counter Rebel-Afica rebel_africa
command Brittania britannia
command Gallia gallia
counter Loyal-Hispania_2 loyal_hispania
counter Rebel-Hsipania rebel_hispania
command Italia italia
counter Loyal-Moesia_2 loyal_moesia
counter Rebel-Meosia rebel_moesia
counter Loyal-Oriens_2 loyal_oriens
counter Rebel-Oriens_2 rebel_oriens
command Pannonia pannonia
command Pontica pontica
counter Loyal-Thracia_2 loyal_thracia
counter Rebel-Thracia_2 rebel_thracia

counter "Mkr-Coin Minus1" goldn1
counter "Mkr-Coin Plus250" goldp250
counter "Mkr-Coin x1" gold1
counter "Mkr-Coin x10" gold10
counter "Mkr-Coin x10" goldn10

date 286BCE 286ce
date 363CE 363ce
date 425CE 425ce
date 497CE 497ce
date 565CE 565ce

counter Mkr-End turn_end
counter Mkr-Event event
counter Mkr-EventDoubled event_doubled

counter "Mkr-Fire x1" unrest
counter Mkr-Gr25 unrestp25

counter Mkr-Insurgent insurgent

counter "Mkr-Leaf Minus10" prestigen10
counter "Mkr-Leaf x1" prestige1
counter "Mkr-Leaf x10" prestige10
counter Mkr-LeafMinus1 prestigen1

counter Mkr-Pay payp250
counter "Mkr-Shield x1" pay1
counter "Mkr-Shield x10" pay10

counter Mkr-Turn turn
counter Mkr-Viceroy viceroy
counter Mkr-Fall fall

counter RomeII-R-Allied allied
counter RomeII-R-Allied-Frankish foederati_frankish
counter RomeII-R-Allied-Ostrogothic foederati_ostrogothic
counter RomeII-R-Allied-Suevian foederati_suevian
counter RomeII-R-Allied-Vandal foederati_vandal
counter RomeII-R-Allied-Visigoth foederati_visigothic

counter RomeII-R-Auxilia auxilia
counter RomeII-R-Auxilia-2 auxilia_veteran
counter RomeII-R-Cavalry cavalry
counter RomeII-R-Cavalry-2 cavalry_veteran
counter RomeII-R-Guard guard
counter RomeII-R-Guard-2 guard_veteran
counter RomeII-R-Legion legion
counter RomeII-R-Legion-2 legion_veteran
counter RomeII-R-PLegion pseudolegion
counter Mkr-Fort fort

dynasty Constanian constantinian
dynasty Justinian justinian
dynasty Leonid leonid
dynasty Theodosian theodosian
dynasty Valentian valentinian

statesman Aegidius aegidius
statesman Aetius aetius
statesman Alaric alaric
statesman Ambrose ambrose
statesman Anastasius anastasius
statesman Anthemius anthemius
statesman Arbogast arbogast
statesman Arcadius arcadius
statesman Arius arius
statesman Aspar aspar
statesman Auxerre auxerre
statesman Basilicus basiliscus
statesman Belisarius belisarius
statesman Bonus bonus
statesman Carausius carausius
statesman Comentious comentiolus
statesman Constans constans
statesman Constantine_Event constantine_II
statesman Constantine_Veteran constantine_I
statesman Constantius_Frankish constantius_I
statesman Constantius_Stalemate constantius_II
statesman Constantius_Visigothic constantius_III
statesman Crispus crispus
statesman Diocletian diocletian
statesman Eutropius eutropius
statesman Gainas gainas
statesman Galerius galerius
statesman Germanus germanus
statesman Gratien gratian
statesman Grgeory gregory
statesman Heraclius heraclius
statesman Honorius honorius
statesman Julian julian
statesman Justin_Convert justin_I
statesman Justin_Event justin_II
statesman Justinius justinian_I
statesman Leo leo_I
statesman Liberius liberius
statesman Licinius licinius
statesman Magnentius magnentius
statesman Majorian majorian
statesman Marcian marcian
statesman Maurice maurice
statesman Maxentius maxentius
statesman Maximian maximian
statesman Maximinius maximinus_II
statesman Mystacon mystacon
statesman Narses narses
statesman Odoacer odoacer
statesman Petronius petronius
statesman Phocas phocas
statesman PopeLeo pope_leo
statesman Priscus priscus
statesman Ricimer ricimer
statesman Sergius sergius
statesman Stilicho stilicho
statesman Theodara theodora
statesman Theodoric theodoric
statesman Theodosius_Prestige theodosius_II
statesman Theodosius_Veteran theodosius
statesman Theodosius-Persecution theodosius_I
statesman Tiberius tiberius_II
statesman Troglita troglita
statesman Valens valens
statesman Valentinian_Event valentinian_III
statesman Valentinian_Suevian valentinian_I
statesman Zeno zeno

war Alan-9 alan_9
war Arabian-5 arabian_5
war Avar-11 avar_11
war Avar-13 avar_13
war Avar-15 avar_15
war Bulgar-12 bulgar_12
war Bulgar-14 bulgar_14
war Burgundian-11_2 burgundian_11
war Frankish-11_2 frankish_11
war Frankish-13_2 frankish_13
war Hun-13 hun_13
war Hun-14 hun_14
war Hun-15 hun_15
war Isaurian-7 isaurian_7
war Moorish-5_2 moorish_5
war Moorish-7_2 moorish_7
war Nubian-4_2 nubian_4
war Ostrogoth-11 ostrogothic_11
war Ostrogoth-13 ostrogothic_13
war Persian-11_2 persian_11
war Persian-13_2 persian_13
war Persian-15_2 persian_15
war Pictish-4 pictish_4
war Pictish-6 pictish_6
war Sarmatian-8_2 sarmatian_8
war Sarmatian-10_2 sarmatian_10
war Saxon-4_2 saxon_4
war Saxon-6_2 saxon_6
war Scottish-5 scottish_5
war Slav-6 slav_6
war Slav-8 slav_8
war Suevian-9 suevian_9
war Suevian-11 suevian_11
war Suevian-13 suevian_13
war Vandal-7_2 vandal_7
war Vandal-8_2 vandal_8
war Vandal-9_2 vandal_93
war Vandal-91 vandal_91
war Visigoth-10 visigothic_10
war Visigoth-12_2 visigothic_12
war Visigoth-14_2 visigothic_14
