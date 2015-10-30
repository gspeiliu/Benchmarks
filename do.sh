#!/bin/bash

totalline(){
	sum=0
	for file in `ls *.[ch]`
	do
    	lines=`awk 'END{ print NR; }' ./$file`
    let "sum+=lines"
	done
	echo "totalline:$sum" >> ./output_info/statics.txt
}

recurrence(){
	cd $1
	for file in `ls`
	do
		if [ -d $file ]
			then
			recurrence $file
		elif [ $file == "test.sh" ]
			then
			echo "#"$PWD >> ${all}/all.md
			make
			./$file
			awk -F" " '{ if( $1 == "klee" ) { printf("- 运行命令:\n\t"); x=1; while( x<NF-1 ){ printf("%s ",$x); x++; } printf("\n"); } }' ./$file >> ${all}/all.md
			more ./README >> ${all}/all.md
			echo "" >> ${all}/all.md
			totalline
			more ./output_info/statics.txt >> ${all}/all.md
			awk -F":" '{ printf("%s ",$2); }' ./output_info/statics.txt >> ${all}/DATE.txt
			echo "" >> ${all}/all.md
			echo "" >> ${all}/all.md
			echo "" >> ${all}/all.md
			make clean
			rm -rf klee* output_info result.txt
		fi
	done

	cd ..
}

all=$PWD
rm ${all}/all.md
rm ${all}/DATE.txt
recurrence "."