#!/bin/bash
set -e

# ============================================================
# Robust TALYS automation script
# ============================================================

file1="file1.txt"      # 2-column file (ctable, ptable)
file2="file2.txt"      # 3-column file (ftable, upbendc, upbende)
input="input.txt"      # TALYS input template
output="output.dat"    # TALYS log output
final="final.txt"      # Combined xs results (rows = runs)
rp040097="rp040097.tot"


# Prepare output file
> "$final"

# Scaling or offsets
ftable=1
upbende=1.1
upbendc="1.5*10^-7"
ctable=-0.08
ptable=0.4

# Check matching number of lines
n1=$(wc -l < "$file1")
n2=$(wc -l < "$file2")

echo "Lines in file1: $(wc -l < "$file1")"
echo "Lines in file2: $(wc -l < "$file2")"


if [ "$n1" -ne "$n2" ]; then
    echo "Error: file1 and file2 must have the same number of rows."
    exit 1
fi

echo "Running $n1 TALYS iterations..."
echo

# Loop over all rows
for ((i=1; i<=n1; i++)); do
    echo "  Iteration $i / $n1"

    # --- Read line safely (handles extra spaces) ---
    read ctable_val ptable_val < <(sed -n "${i}p" "$file1")
    read ftable_val upbendc_val upbende_val < <(sed -n "${i}p" "$file2")

    # --- Apply math ---
    ctable_val=$(echo "$ctable_val + $ctable" | bc -l)
    ptable_val=$(echo "$ptable_val + $ptable" | bc -l)
    ftable_val=$(echo "$ftable_val * $ftable" | bc -l)
    upbendc_val=$(echo "$upbendc_val * $upbendc" | bc -l)
    upbende_val=$(echo "$upbende_val * $upbende" | bc -l)

    # --- Combine into array (TALYS order) ---
    echo "upbende,upbendc,ftable,ctable,ptable"	
    all_vals=("$upbende_val" "$upbendc_val" "$ftable_val" "$ctable_val" "$ptable_val")

    # Debug: show values
    echo "all_vals: ${all_vals[@]}"

    # --- Prepare input file ---
    cp "$input" input_temp.txt

    # Replace lines robustly (everything after 97 is replaced)
    sed -i "s/^upbende 40 97.*/upbende 40 97 ${all_vals[0]} M1/" input_temp.txt
    sed -i "s/^upbendc 40 97.*/upbendc 40 97 ${all_vals[1]} M1/" input_temp.txt
    sed -i "s/^ftable 40 97.*/ftable 40 97 ${all_vals[2]} E1/" input_temp.txt
    sed -i "s/^ctable 40 97.*/ctable 40 97 ${all_vals[3]}/" input_temp.txt
    sed -i "s/^ptable 40 97.*/ptable 40 97 ${all_vals[4]}/" input_temp.txt

    # Debug: show the generated input
    echo "Input for iteration $i:"
    #cat input_temp.txt
    echo "----------------------"

    # --- Run TALYS ---
    talys < input_temp.txt > "$output"
    
    #echo "Files after TALYS run:"
    #ls -l

    # --- Extract xs column ---
    if [ -f "$rp040097" ]; then
        awk '/^ *[0-9.E+-]+ +[0-9.E+-]+$/ { print $2 }' "$rp040097" | tr '\n' ' ' >> "$final"
        echo "" >> "$final"
    else
        echo "Warning: rp040097 not found for iteration $i" >> "$final"
    fi

    echo "  Finished iteration $i"
    echo
done

echo "============================================================"
echo " Completed $n1 TALYS runs."
echo "Results saved to $final (rows = runs, columns = xs values)"
echo "============================================================"
