#!/bin/bash

#variables
field=()
for ((i=0; i<9; i++)); do
	field[$i]="."
done

declare -A pos_map
pos_map=([ul]=0 [uc]=1 [ur]=2 [ml]=3 [mc]=4 [mr]=5 [dl]=6 [dc]=7 [dr]=8)

field_str='' #string that includes the board
player_flag=1
pos=""
move_count=0

#field print function
write_field(){
    field_str=''
	for ((i=0; i<9; i++)); do
		field_str+="${field[$i]}"
		if (( (1+i) %3 == 0 )); then
			field_str+=$'\n'
		else
			field_str+='|'
		fi
	done
	echo "$field_str"
}

check_wincon(){
	local p=$1
	local f=("{field[@]}")
	[[ ${f[0]} == $p && ${f[1]} == $p && ${f[2]} == $p ]] && return 0
	[[ ${f[3]} == $p && ${f[4]} == $p && ${f[5]} == $p ]] && return 0
	[[ ${f[6]} == $p && ${f[7]} == $p && ${f[8]} == $p ]] && return 0

	[[ ${f[0]} == $p && ${f[3]} == $p && ${f[6]} == $p ]] && return 0
	[[ ${f[1]} == $p && ${f[4]} == $p && ${f[7]} == $p ]] && return 0
	[[ ${f[2]} == $p && ${f[5]} == $p && ${f[8]} == $p ]] && return 0

	[[ ${f[0]} == $p && ${f[4]} == $p && ${f[8]} == $p ]] && return 0
	[[ ${f[2]} == $p && ${f[4]} == $p && ${f[6]} == $p ]] && return 0

	return 1
}

move_prompt(){
    local valid=("ul" "uc" "ur" "ml" "mc" "mr" "dl" "dc" "dr")
    local valid_input=false

    while true; do
        read -p "Player $player_flag move! Enter position (ul/uc/ur/ml/mc/mr/dl/dc/dr): " pos

        for v in "${valid[@]}"; do
            if [[ "$pos" == "$v" ]]; then
                valid_input=true;
                break
            fi
        done

        if [[ "$valid_input" == false ]];then
            echo "Invalid position, try again."
            continue
        fi

        index=${pos_map[$pos]}
        if [[ "${field[$index]}" != "." ]]; then
            echo "Position taken, try again"
            valid_input=false
            continue
        fi
        break
    done
    if [[ "$player_flag" == 1 ]]; then
        field[$index]=O
    elif [[ "$player_flag" == 2 ]]; then
        field[$index]=X
    fi
}

write_field

#gameloop
while true; do
    move_prompt
    write_field
    if (( $player_flag == 1 )); then
        result=$(check_wincon O)
        if (( result == 1 )); then
            echo "Congratulations! Player $player_flag won!"
            break
        fi
    fi
    player_flag=$(( player_flag % 2 + 1))
    move_count=$(( move_count + 1 ))
    if (( $move_count == 9 )); then
        echo "Draw! Neither player wins."
        break
    fi
done
