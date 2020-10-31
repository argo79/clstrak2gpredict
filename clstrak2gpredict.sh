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

echo "Vuoi aggiornare i files di celestrak? (S/Y/s/y/N/n)"
read -r VAR1
#echo $VAR1

if [[ $VAR1 == "Y" ]] || [[ $VAR1 == "S" ]] || [[ $VAR1 == "y" ]] || [[ $VAR1 == "s" ]]
then
	rm -R $HOME/.config/Gpredict/logs/
	wget -P $HOME/.config/Gpredict/logs/ -i celestrak.log

fi

echo "Vuoi copiare tutto nella cartella satdata? (S/Y/s/y/N/n)"
read -r VAR2

if [ $VAR2 = "Y" ] || [ $VAR2 = "S" ] || [ $VAR2 = "y" ] || [ $VAR2 = "s" ]
then
	modo=1
else modo=0
fi

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
	 	echo "Ho modificato l'estensione del file "$filename.php" in "$filename.txt
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
		echo "STATUS=0" >> $home/$filename/$numero.sat
		#echo "" >> $home/$numero.sat
		cont=$(($cont+1))
		

		if [[ $modo == "1" ]]; then
			cp -fR $home/$filename/$numero.sat $HOME/.config/Gpredict/pippo/
			#statements
		fi
	done
	
	diff=$(($cont-$old))
	old=($cont)
	echo -e "In tutto ho caricato "$diff" satelliti \e[1m\e[93m" $filename"\e[0m."

done

echo "In tutto ho caricato "$cont" satelliti."
