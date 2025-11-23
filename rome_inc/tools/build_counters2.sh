#!/bin/bash

# set -x

mkdir -p counters180

function counter {
	cp "HIRES/${1}.png" counters180/$2.png
}

function fleet {
	counter "Fleet-${1}" fleet_${2}_veteran
	counter "Fleet-${1}-F" fleet_${2}
}

function leader {
	counter "Ldr-${1}" leader_${2}
}

function command {
	counter "Loyal-${1}" loyal_${2}
	counter "Rebel-${1}" rebel_${2}
}

function date {
	counter "Mkr-Date-${1}" date_${2}
}

function emperors {
	counter "Rome-Emp-${1}" emperors_${2}
}

function legion {
	counter "Rome-Leg-${1}" legion_${2}
	counter "Rome-Leg-${1}-2" legion_${2}_veteran
}

function statesman {
	counter "Rome-SM-${1}" statesman_${2}
}

function war {
	counter "War-${1}" war_${2}
}

fleet Aegyptian aegyptian
fleet Africa african
fleet Babylon babylonian
fleet Bosporan bosporan
fleet British british
fleet German german
fleet Moesian moesian
fleet Pannonian pannonian
fleet Pontic pontic
fleet "Praetorian x2" praetorian
fleet Syrian syrian

leader Alamannic-Chrocus chrocus
leader British-Boudicca boudicca
leader British-Caratacus caratacus
leader Caledonian-Calgacus calgacus
leader Dacian-Dacebalus decebalus
leader German-Arminius arminius
leader German-Civilus civilus
leader Gothic-Kniva kniva
leader Illyrian-Bato bato
leader Judean-Simeon simeon
leader Marcomannic-Ballamar ballomar
leader Moorish-Tacfarinus tacfarinus
leader Palmyrene-Zenobia zenobia
leader Parthian-Vologases vologases
leader Persian-Shapur shapur

counter Ldr-War-Back barbarian

command Aegyptus aegyptus
counter Loyal-Africa loyal_africa
counter Rebel-Afica rebel_africa
command Brittania britannia
counter Loyal-Gallica loyal_gallia
counter Rebel-Gallia rebel_gallia
counter Loyal-Hispania loyal_hispania
counter Rebel-Hsipania rebel_hispania
command Italia italia
counter Loyal-Moesia loyal_moesia
counter Rebel-Meosia rebel_moesia
command Pannonia pannonia
command Pontica pontica
command Syria syria

counter "Mkr-Coin Minus1" goldn1
counter "Mkr-Coin Plus250" goldp250
counter "Mkr-Coin x1" gold1
counter "Mkr-Coin x10" gold10
counter "Mkr-Coin x10" goldn10

date 27BCE 27bce
date 70CE 70ce
date 138CE 138ce
date 222CE 222ce

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
counter Mkr-Wall wall

counter Rome-Allied allied
counter Rome-Allied-F allied_veteran
counter Rome-Aux auxilia
counter Rome-Aux-F auxilia_veteran

emperors Adoptive adoptive
emperors Antonine antonine
emperors Barracks barracks
emperors Claudian claudian
emperors Flauvian flavian
emperors Illyrian illyrian
emperors Julian julian
emperors Severan severan

counter "Rome-Imp Cav" imperial_cavalry
counter "Rome-Imp Cav-F" imperial_cavalry_veteran

legion I-Adiutrix adiutrix_I
legion I-Germanica germanica_I
legion II-Adiutrix adiutrix_II
legion II-Augusta augusta_II
legion III-Augusta augusta_III
legion III-Cyrenaica cyrenaica_III
legion III-Gallica gallica_III
legion III-Italica italica_III
legion III-Parthica parthica_III
legion II-Italica italica_II
legion I-Illyricorum illyricorum_I
legion II-Parthica parthica_II
legion I-Italica italica_I
legion II-Trajana trajana_II
legion I-Minervia minervia_I
legion I-Parthica parthica_I
legion IV-Flavica flavia_IV
legion IV-Italica italica_IV
legion IV-Macedonica macedonica_IV
legion IV-Scythica scythica_IV
legion IX-Hispania hispana_IX
legion V-Alaudae alaudae_V
legion VI-Ferratta ferrata_VI
legion VII-Claudia claudia_VII
counter Rome-Leg-VII-Gemina legion_gemina_VII
counter Rome-Leg-VII-Gemina-F legion_gemina_VII_veteran
legion VIII-Augusta augusta_VIII
legion VI-Victrix victrix_VI
legion V-Macedonica macedonica_V
legion X-Fretensis fretensis_X
legion X-Gemina gemina_X
legion XI-Claudia claudia_XI
legion XII-Fulminata fulminata_XII
legion XIII-Gemina gemina_XIII
legion XIV-Gemina gemina_XIV
legion XIX-Variania variana_XIX
legion XV-Aplononaris apollinaris_XV
legion XVI-Flavia flavia_XVI
legion XVI-Gallica gallica_XVI
legion XVIII-Variania variana_XVIII
legion XVII-Variania variana_XVII
legion XV-Primigenia primigenia_XV
legion XXII-Deioteriana deiotariana_XXII
legion XXII-Primigenia primigenia_XXII
legion XXI-Rapax rapax_XXI
legion XX-Valeria valeria_XX
legion XXX-Ulpia ulpia_XXX

counter "Rome-Prae Gd" praetorian_guard
counter "Rome-Prae Gd-F" praetorian_guard_veteran

statesman Aelianus aelianus
statesman Aemilian aemilian
statesman Agricola agricola
statesman Agrippa agrippa
statesman Albinus albinus
statesman Alexander alexander
statesman Antoninus antoninus
statesman Arrian arrian
statesman Augustus augustus
statesman Aurelian aurelian
statesman Avideus avidius
statesman Caligula caligula
statesman Caracalia caracalla
statesman Carauisus carausius
statesman Carinus carinus
statesman Carus carus
statesman Cerialus cerialis
statesman Claudius claudius
statesman Commodus commodus
statesman Corbulo corbulo
statesman Decius decius
statesman Diocletian diocletian
statesman Domitian domitian
statesman Drusus drusus
statesman Elagabalus elagabalus
statesman Galba galba
statesman Gallienus gallienus
statesman Gallus gallus
statesman Germanicus germanicus
statesman Gordian gordian
statesman Gothicus gothicus
statesman Hadrian hadrian
statesman Julianus julianus
statesman Laetus laetus
statesman Lucius lucius
statesman Macrinus macrinus
statesman Macro macro
statesman Marcus marcus
statesman Maximilian maximian
statesman Maximinus maximinus
statesman Nero nero
statesman Nervus nerva
statesman Niger niger
statesman Odaenath odaenath
statesman Otho otho
statesman Paulinus paulinus
statesman Pertinax pertinax
statesman Philip philip
statesman Plautianus plautianus
statesman Plautius plautius
statesman pompeianuse pompeianus
statesman Postumus postumus
statesman Probus probus
statesman Queitus quietus
statesman Sejanus sejanus
statesman Severus severus
statesman Silvanus silvanus
statesman Tacitus tacitus
statesman Tiberious tiberius
statesman Timesitheus timesitheus
statesman Titus titus
statesman Trajan trajan
statesman Turbo turbo
statesman Valerian valerian
statesman Vespasian vespasian
statesman Vitlellius vitellius

war Alamannic-10 alamannic_10
war Alamannic-12 alamannic_12
war Alan-9 alan_9
war British-6 british_6
war British-7 british_7
war Burgundian-11 burgundian_11
war Caledonian-4 caledonian_4
war Caledonian-5 caledonian_5
war Cantabrian-8 cantabrian_8
war Dacian-10 dacian_10
war Dacian-11 dacian_11
war Dacian-12 dacian_12
war Frankish-9 frankish_9
war Frankish-11 frankish_11
war German-8 german_8
war German-10 german_10
war German-12 german_12
war German-14 german_14
war Gothic-13 gothic_13
war Gothic-15 gothic_15
war Illyrian-10 illyrian_10
war Illyrian-12 illyrian_12
war Judean-6 judean_6
war Judean-7 judean_7
war Judean-8 judean_8
war Marcomannic-9 marcomannic_9
war Marcomannic-11 marcomannic_11
war Marcomannic-13 marcomannic_13
war Moorish-5 moorish_5
war Moorish-7 moorish_7
war Nubian-4 nubian_4
war Nubian-6 nubian_6
war Palmyrene-14 palmyrene_14
war Parthian-8 parthian_8
war Parthian-10 parthian_10
war Parthian-12 parthian_12
war Parthian-14 parthian_14
war Persian-9 persian_9
war Persian-11 persian_11
war Persian-13 persian_13
war Persian-15 persian_15
war Sarmatian-8 sarmatian_8
war Sarmatian-10 sarmatian_10
war Saxon-6 saxon_6
war Vandal-9 vandal_9
