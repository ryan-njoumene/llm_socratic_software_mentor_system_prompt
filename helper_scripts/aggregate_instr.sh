#!/bin/sh

instructions_dir="./instructions_library"
output_file="./system_instructions.md"

m_values=$(ls "$instructions_dir")
m_size=$(echo "$m_values" | wc -w)

all_values=$(printf "%s" "$m_values")

ls_index=0
for file in $all_values; do
    if [ "$ls_index" -eq 0 ]; then
        # empty file content
        printf "" > "$output_file"
    fi

    # dir instructions_library
    cat "${instructions_dir}/${file}" >> "$output_file"

    echo "" >> "$output_file"
    
    ls_index=$((ls_index + 1))
done


echo "END"