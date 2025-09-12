#!/bin/sh

# This is the definitive script. It is POSIX-compliant and requires no
# extra packages. It manually parses the CUE file and mathematically
# corrects any invalid timestamps before passing them to FFmpeg.

set -e
DOWNLOAD_PATH="$1"

echo "Running final parser/corrector script on: ${DOWNLOAD_PATH}"
cd "${DOWNLOAD_PATH}" || exit 1

# --- SAFETY CHECK ---
cue_count=$(find . -maxdepth 1 -type f -name "*.cue" | wc -l)
flac_count=$(find . -maxdepth 1 -type f -name "*.flac" | wc -l)

if [ "$cue_count" -eq 1 ] && [ "$flac_count" -eq 1 ]; then
    echo "Single CUE and FLAC file found. Proceeding."

    flacfile=$(find . -maxdepth 1 -type f -name "*.flac")
    cuefile=$(find . -maxdepth 1 -type f -name "*.cue")
    flacfile_cleaned=$(basename "$flacfile")

    # STEP 1: Rip and CORRECT all track start times using awk.
    # This awk program reads each timestamp, fixes any invalid frame/second
    # values, and prints a clean list.
    times_list=$(cat "$cuefile" | tr -d '\r' | grep "INDEX 01" | \
        awk '{
            split($3, t, ":");
            M = t[1]; S = t[2]; F = t[3];
            if (F >= 75) { S += int(F / 75); F %= 75; }
            if (S >= 60) { M += int(S / 60); S %= 60; }
            printf "%02d:%02d:%02d\n", M, S, F;
        }' | tr '\n' ' ')

    track_count=$(echo "$times_list" | wc -w)
    echo "Found and corrected $track_count track start times."

    # STEP 2: Loop through the corrected times and split the file.
    i=1
    while [ $i -le $track_count ]; do
        track_num_padded=$(printf %02d $i)
        start_time=$(echo "$times_list" | cut -d' ' -f$i)
        
        if [ $i -lt $track_count ]; then
            next_track_index=$((i + 1))
            end_time=$(echo "$times_list" | cut -d' ' -f$next_track_index)
            echo "--> Splitting Track $track_num_padded (Start: $start_time, End: $end_time)"
            ffmpeg -hide_banner -loglevel error -i "$flacfile_cleaned" -ss "$start_time" -to "$end_time" -c copy "track${track_num_padded}.flac"
        else
            echo "--> Splitting LAST Track $track_num_padded (Start: $start_time to End of File)"
            ffmpeg -hide_banner -loglevel error -i "$flacfile_cleaned" -ss "$start_time" -c copy "track${track_num_padded}.flac"
        fi
        i=$((i + 1))
    done

    echo "Successfully split all tracks."
else
    echo "Skipping split: Not a single CUE/FLAC combo. (CUEs: $cue_count, FLACs: $flac_count)"
fi

echo "Script finished successfully."
