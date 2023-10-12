#!/bin/bash

#Variables internes globals
selected_country="XX"
selected_state="XX"

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

function se(){
        local selected_name=$1
        local state_found=false
        if [[ $selected_name != "" ]]
        then
                while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
                do
                        if [[ $state_name == $selected_name && $selected_country == $country_code ]] 
                        then
                                state_found=true
                                selected_state=$state_code
                        fi
                done<cities_1.csv

                if [[ $state_found = false ]]
                then
                        selected_state="XX"
                fi
                printf "%s\n" "$selected_state"
        fi
}

function le(){
        local prev_state=""
        if [[ $selected_country != "XX" ]]
        then
                while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
                do
                        if [[ $state_code != $prev_state && $country_code == $selected_country ]]
                        then
                                printf '%s\t %s\n' "$state_code" "$state_name"
                        fi
                        prev_state=$state_code
                done<cities_1.csv
        fi
}

function lcp(){
        if [[ $selected_country != "XX" ]]
        then
                while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
                do
                        if [[ $country_code == $selected_country ]]
                        then
                                #TO-DO: Verificar longtitud más larga para el nombre de una ciudad.
                                printf '%-30s\t %s\n' "$name" "$wikiDataId"
                        fi
                done<cities_1.csv
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
        	se)
            		echo "Introdueix el nom de l'estat: "
            		read state_name
            		se $state_name
        	;;
                le)
                        le
                ;;
                lcp)
                        lcp
                ;;
                *)
                        echo "Opció invàlida"

                ;;
        esac
done

#while IFS=, read -r f1 f2 f3 f4
#do
#       printf 'fila1: %s, fila2: %s, fila3: %s, fila 4: %s\n' "$f1" "$f2" "$f3" "$f4"
#done<cities_1.csv