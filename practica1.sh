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

                printf "Country code: %s\n" "$selected_country"
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
                printf "State code: %s\n" "$selected_state"
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
        else
                echo "Selecciona un pais i estat abans d'executar aquesta comanda."
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
        else
                echo "Selecciona un pais abans d'executar aquesta comanda."
        fi
}

function ecp(){
        if [[ $selected_country != "XX" ]]
        then
                while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
                do
                        if [[ $country_code == $selected_country ]]
                        then
                                #Almacenamos el resultado separado por comas en un fichero .csv
                                printf '%s,%s\n' "$name" "$wikiDataId" >> ${selected_country}.csv
                        fi
                done<cities_1.csv
        else
                echo "Selecciona un pais abans d'executar aquesta comanda."
        fi
}

function lce(){
        if [[ $selected_country != "XX" && $selected_state != "XX" ]]
        then
                while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
                do
                        if [[ $country_code == $selected_country && $state_code == $selected_state ]]
                        then
                                #TO-DO: Verificar longtitud más larga para el nombre de una ciudad.
                                printf '%-30s\t %s\n' "$name" "$wikiDataId"
                        fi
                done<cities_1.csv
        else
                echo "Selecciona un pais i estat abans d'executar aquesta comanda."
        fi
}

# TO-DO: Preguntar al professor per què l'exercici 8 i 9 utilitzen el mateix input. Potser errada?
function ece(){
        if [[ $selected_country != "XX" && $selected_state != "XX" ]]
        then
                while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
                do
                        if [[ $country_code == $selected_country && $state_code == $selected_state ]]
                        then
                                #Almacenamos el resultado separado por comas en un fichero .csv
                                printf '%s,%s\n' "$name" "$wikiDataId" >> ${selected_country}_${selected_state}.csv
                        fi
                done<cities_1.csv
        else
                echo "Selecciona un pais i estat abans d'executar aquesta comanda."
        fi
}

function gwd(){
        local selected_name=$1
        local wd_found=false
        local wid=""
        
        # En este ejercicio primero buscamos si existe una ciudad dentro del pais y del estado seleccionado. Usamos el bucle de siempre.
        if [[ $selected_country != "XX" && $selected_state != "XX" ]]
        then
                while IFS=, read -r id name state_id state_code state_name country_id country_code country_name latitude longitude wikiDataId
                do
                        if [[ $country_code == $selected_country && $state_code == $selected_state && $name == $selected_name ]]
                        then
                                wd_found=true
                                wid=$wikiDataId
                        fi
                done<cities_1.csv
        else
                echo "Selecciona un pais i estat abans d'executar aquesta comanda."
        fi

        # Una vez hemos finalizado la búsqueda de la ciudad, revisamos si ha habido alguna coincidencia y buscamos su WId en caso de que exista.
        if [[ $wd_found == true ]]
        then
                if [[ $wid != "" ]]
                then
                        # En MacOS no funciona el comando wget, así que he tenido que utilizar el curl. Lo imprime todo en una linea, eso sí...
                        curl https://www.wikidata.org/wiki/Special:EntityData/${wid}.json --output ${wid}.json --silent
                else
                        echo "La població seleccionada no dispossa de wikiDataId vàlida."
                fi
        else
                echo "No s'ha trobat cap població que pertanyi al pais i estat seleccionats."
        fi
}

function est(){
        # En este ejercicio usamos AWK. FS identifica al separador de columna (,), RS identifica al separador de linea (\n), etc. 
        # En internet hay mucha informacion disponible de variables reservadas de AWK, la variable NR podría ser útil para este ejercicio.
        # Para identificar la columna escribimos $1, $2, $3...
        # Col: 9 latitude, Col: 10 longitude        
        awk \
        'BEGIN { FS=","; RS="\n"; nord=0; sud=0; oriental=0; occidental=0; no_ubic=0; no_wid=0; count=0; }  
        NR>1 {
                { if ($9+0 > 0) nord++; } 
                { if ($9+0 < 0) sud++; }  
                { if ($10+0 > 0) oriental++; }  
                { if ($10+0 < 0) occidental++; }  
                { if ($9+0 == 0 && $10+0 == 0) no_ubic++; } 
                { if ($11"" == "") no_wid++; }
        }
        END {print "Nord", nord, "Sud", sud, "Est", oriental, "Oest", occidental, "No ubic", no_ubic, "No WDId", no_wid}'<cities_1.csv 
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
                ecp)
                        ecp
                ;;
                lce)
                        lce
                ;;
                ece)
                        ece
                ;;
                gwd)
                        echo "Introdueix el nom de la població: "
                        read city_name
                        gwd $city_name
                ;;
                est)
                        est
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