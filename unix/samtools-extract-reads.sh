#!/bin/bash

# Extract reads from bam file matching chromosomal regions from bed file.
# v 1.0.0 | 1-Oct-2013 | git.sbamin.com

if [ "$1" == "-h" ]; then
	echo "Extract reads from bam file matching chromosomal regions from bed file. Output as SAM file."
	echo "Only tab-delimited bed format with minimum three columns (e.g., 1 1001 1200) is supported." 
	echo "NOTE: trim "chr" prefix (if any) from chromosome numbers. bed file header is NOT supported; first line must be a valid region of intrest"
	echo "Usage: `basename $0` bedfile bamfile"
	echo "Example: `basename $0` regions.bed sample.bam"
	exit 0
elif [ "$#" -lt 2 ]; then
	echo "Invalid arguments. Use `basename $0` -h for more"
	echo "Usage: `basename $0` bedfile bamfile"
	echo "Example: `basename $0` regions.bed sample.bam"
	echo "Only tab-delimited bed format with minimum three columns (e.g., 1 1001 1200) is supported. Output as SAM file."
	echo "NOTE: trim "chr" prefix (if any) from chromosome numbers. bed file header is NOT supported; first line must be a valid region of intrest"
	exit 0
fi

BED=$1
BAM=$2
OUTFILE=extracted_"$RANDOM"

# format bed file as per samtools requirement.
awk '{print $1":"$2"-"$3}' "$1" > regions.bed
FILE=regions.bed
BEDCNT=$(wc -l <$FILE)

# extract reads matching first region as well as output header info.
X=1
FIRST=$(head -n $X $FILE | tail -n 1)
echo "$FIRST"
samtools view -h "$2" "$FIRST" > "$OUTFILE".sam

# extract reads matching remaining regions (if any) in bed file.
while [ "$X" -lt "$BEDCNT" ]
do
let X=X+1
REGION=$(head -n $X $FILE | tail -n 1)
echo "Extracting $REGION - $X of $BEDCNT"
samtools view "$2" "$REGION" >> "$OUTFILE".sam
done

rm $FILE
echo "Saving output to "$OUTFILE".sam"

exit 0

