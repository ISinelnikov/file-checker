#!/usr/bin/env bash
if [[ -z "$1" || -z "$2" ]]; then
    echo "For start need file with ids and directory for search"
else
    IDS_FILE=$1
    DIRECTORY=$2

    if [[ -d ${DIRECTORY} ]]; then
        if [[ -f ${IDS_FILE} ]]; then

            IFS_OLD=$IFS
            IFS=$'\n'
            idx=0
            ids=()
            for id in $(cat ${IDS_FILE})
            do
                # Skip empty lines
                [[ -z ${id} ]] && continue

                RESULT=$(find ${DIRECTORY} -name "*$id*.*")

                # If directory not contains file
                [[ -z ${RESULT} ]] && continue

                let idx=$idx+1
                ids[$idx]=${id}
            done

            if [[ ${#ids[@]} -eq 0 ]]; then
                echo "Not found ids files in directory."
            else
                for id in ${ids[@]}
                do
                    sed -i "/$id/d" ${IDS_FILE}
                done

            IFS=${IFS_OLD}
            fi
        else
            echo "No such file $IDS_FILE"
        fi
    else
        echo "No such directory $DIRECTORY"
    fi
fi
