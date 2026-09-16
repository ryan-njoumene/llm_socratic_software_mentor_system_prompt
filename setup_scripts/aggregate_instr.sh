#!/bin/sh

m_dir="./mendatory_instructions"
e_dir="./extended_knowledge_instructions"
output_file="./all_instructions.md"

m_values=$(ls "$m_dir")
m_size=$(echo "$m_values" | wc -w)

e_values=$(ls "$e_dir")
e_size=$(echo "$e_values" | wc -w)

all_values=$(printf "%s %s" "$m_values" "$e_values")

ls_index=0
for file in $all_values; do
    if [ "$ls_index" -eq 0 ]; then
        # empty file content
        printf "" > "$output_file"
    fi

    if [ "$ls_index" -lt "$m_size" ]; then
        # m
        cat "${m_dir}/${file}" >> "$output_file"
    else
        # e
        cat "${e_dir}/${file}" >> "$output_file"
    fi

    echo "" >> "$output_file"
    
    ls_index=$((ls_index + 1))
done


echo "END"