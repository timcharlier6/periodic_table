#!/bin/bash

is_numeric() {
    input=$1
    if [[ $input =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

trim() {
    local var=$1
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

get_element_info() {
    element_input=$1
    if is_numeric "$element_input"; then
        query="SELECT p.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
        FROM properties p 
        JOIN elements e ON p.atomic_number = e.atomic_number 
        JOIN types t ON p.type_id = t.type_id
        WHERE p.atomic_number = $element_input  
        LIMIT 1;"
    else
        query="SELECT p.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
        FROM properties p 
        JOIN elements e ON p.atomic_number = e.atomic_number 
        JOIN types t ON p.type_id = t.type_id
        WHERE e.symbol = '$element_input' OR e.name ILIKE '$element_input' 
        LIMIT 1;"
    fi
    
    element_info=$(psql -d periodic_table -U freecodecamp -t -c "$query")
    
    IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$element_info"
    
    if [[ -z $element_info ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $(trim "$atomic_number") is $(trim "$name") ($(trim "$symbol")). It's a $(trim "$type"), with a mass of $(trim "$atomic_mass") amu. $(trim "$name") has a melting point of $(trim "$melting_point") celsius and a boiling point of $(trim "$boiling_point") celsius."
    fi
}

if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
else
    get_element_info "$1"
fi
