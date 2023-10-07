#!/bin/bash

#Variables internes globals
selected_country="XX"

function quit(){
	echo "Sortint de l'aplicació"
	exit 0
}
function lp() {
	local prev_country=""
        while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
        do
		 if [[ $country_code != $prev_country ]]
		 then
			 printf '%s\t %s\n' "$country_code" "$country_name"
                 fi
		 prev_country=$country_code
	done<cities_1.csv
}

function sc(){
	local selected_name=$1
	local country_found=false
	if [[ $selected_name != "" ]]
	then
		while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
        	do
		 	if [[ $country_name == $selected_name ]]
		 	then
		 		country_found=true
				selected_country=$country_code
        	fi
		done<cities_1.csv

		if [[ $country_found = false ]]
		then
			selected_country="XX"
		fi
	
		printf "%s\n" "$selected_country"
	fi
}
#Inici del programa
while true
do
	echo "Introdueix la instrucció: "
	read user_input

	case $user_input in
		q)
			quit
		;;
		lp)
			lp
		;;
		sc)
			echo "Introdueix el nom del pais: "
			read country_name
			sc $country_name
		;;
		*)
			echo "Opció invàlida"

		;;
	esac
done

#while IFS=, read -r f1 f2 f3 f4
#do
#	printf 'fila1: %s, fila2: %s, fila3: %s, fila 4: %s\n' "$f1" "$f2" "$f3" "$f4"
#done<cities_1.csv
