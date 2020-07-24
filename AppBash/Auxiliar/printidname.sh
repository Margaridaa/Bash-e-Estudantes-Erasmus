#!/bin/bash

# este ficheiro serve como auxilio na impressao/visualizacao dos dados tais como Alunos/Estudantes, Disciplinas, etc, cujos ficheiros de armazenamento de dados contêm demasiada informação, parte dela desnecessária no processo de apresentação de dados para seleção.

# com sed 's/Objeto/Estudantes/g' Aux/printidname.sh > novo.sh no menu_visualizar é possivel usar este mesmo ficheiro para todos os objetos.
echo ""

linhas_Objeto=$(wc -l < Dados/Objeto.txt)

declare -i j=0
declare -i k=0
	for (( j=1; j<=linhas_Objeto; j++ ))
	do	

	if [ $j -eq 1 ]
	then head -n $j Dados/Objeto.txt  > tmp
	
	awk -F ":" '{printf "%s",$1}' tmp
	echo -n " - "
	awk -F ":" '{print $2}' tmp

	else
	head -n $j Dados/Objeto.txt | tail -n 1 > tmp

	awk -F ":" '{printf "%s",$1}' tmp
	echo -n " - "
	awk -F ":" '{print $2}' tmp

	fi

	done

