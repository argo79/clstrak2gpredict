#!/bin/bash

#leggi file
set -e
cont=0
old=0

if [ ! -d $HOME/.config/Gpredict/news ]
then
	mkdir $HOME/.config/Gpredict/news
fi

if [ ! -d $HOME/.config/Gpredict/logs ]
then
	mkdir $HOME/.config/Gpredict/logs
fi

home="$HOME/.config/Gpredict/news"

wget -P $HOME/.config/Gpredict/logs/ -i celestrak.log

for file in $HOME/.config/Gpredict/logs/*.*
do 
	numlines=$(wc -l $file | grep -o -E '[0-9]+')
	#filenameT="${file##*/}"
	filext="${file##*.}"
	filename="$(basename "$file" .$filext)"	
	echo $numlines
	echo $filename
	echo $filext

	if [[ $filext == "php" ]]; then
		mv $HOME/.config/Gpredict/logs/$filename.php $HOME/.config/Gpredict/logs/$filename.txt
	 	#statements
	fi 

	if [ ! -d $home/$filename ]
	then
		mkdir $home/$filename
	fi

	for (( i = $numlines; i > 0 ; i=$i-3 )); do
		tail -n -$i $HOME/.config/Gpredict/logs/$filename.txt > $home/$filename/$filename.txt.new
		head -n 3 $home/$filename/$filename.txt.new > $home/$filename/$filename.txt.sup
		#echo $i
		nome=$(head -n 1 $home/$filename/$filename.txt.sup)
		prima=$(cat $home/$filename/$filename.txt.sup | grep "^1")
		seconda=$(cat $home/$filename/$filename.txt.sup | grep "^2")
		
		while IFS= read -r line
			do
				#statements
				echo "" > $home/$filename/provasat.txt
				for x in $line; do
				echo $x	>> $home/$filename/provasat.txt

				done
			done < "$home/$filename/$filename.txt.sup"
			#tail -n +$i $dir/satnogs.txt 
			# > $home/satnogs.txt.new#statements
			#statements
		numero=$(sed -n 3p $home/$filename/provasat.txt)
		#echo "" > $home/$filename/$numero.sat
		echo "[Satellite]" > $home/$filename/$numero.sat
		echo "VERSION=1.1" >> $home/$filename/$numero.sat
		echo "NAME="$nome >> $home/$filename/$numero.sat
		echo "NICKNAME="$nome >> $home/$filename/$numero.sat
		echo "TLE1="$prima >> $home/$filename/$numero.sat
		echo "TLE2="$seconda >> $home/$filename/$numero.sat
		#echo "" >> $home/$numero.sat
		cont=$(($cont+1))
		
	done
	
	diff=$(($cont-$old))
	old=($cont)
	echo "In tutto ho caricato "$diff" satelliti" $filename"."

done

echo "In tutto ho caricato "$cont" satelliti."
