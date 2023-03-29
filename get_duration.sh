#!/bin/bash
#
# This repository calculates the total (and for each file) length of the audio files in the same folder.
# Requires: soxi, bc
#
# Run: nohup time ./get_duration.sh my_audio_folder_full_path .wav log.txt > warnings.txt &

if [[ $# -ne 3 ]]; then
    echo "Please set 3 parameters: source_folder_full_path *.extension output_logfile"
    echo "Example: nohup time ./get_duration.sh /vol/tensusers5/XX/YY/audio/words/segments *.wav log.txt > warnings.txt &"
    exit 2
fi

dir=$1
#extension=.wav
extension=$2
outputfile=$3
rm -f $outputfile

######################## MAIN
files=$(echo `ls -lt $dir | wc -l`)
m_string="$files files to check:"
echo $m_string
echo $m_string >> $outputfile
total=0
while read -r f; do
    d=$(soxi -D "$f")
    echo "$d seconds - $f" >> $outputfile
    total=$(echo "$total + $d" | bc)
done < <(find "$dir" -iname "*$extension" | sort -R)

div=3600
hours=$(awk '{print $1/$2}' <<<"${total} ${div}")
final_string="-> Total audio lentgh: $hours hours all $extension files in '$(basename -- $dir)' folder."
echo $final_string
echo $final_string >> $outputfile