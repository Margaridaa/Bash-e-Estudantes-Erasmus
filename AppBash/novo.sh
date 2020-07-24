#!/bin/bash

# este ficheiro serve como auxilio na impressao/visualizacao dos dados tais como Alunos/Estudantes, Disciplinas, etc, cujos ficheiros de armazenamento de dados contêm demasiada informação, parte dela desnecessária no processo de apresentação de dados para seleção.

# com sed 's/Disciplinas/Estudantes/g' Aux/printidname.sh > novo.sh no menu_visualizar é possivel usar este mesmo ficheiro para todos os objetos.
echo ""

linhas_Disciplinas=$(wc -l < Dados/Disciplinas.txt)

declare -i j=0
declare -i k=0
	for (( j=1; j<=linhas_Disciplinas; j++ ))
	do	

	if [ $j -eq 1 ]
	then head -n $j Dados/Disciplinas.txt  > tmp
	
	awk -F ":" '{printf "%s",$1}' tmp
	echo -n " - "
	awk -F ":" '{print $2}' tmp

	else
	head -n $j Dados/Disciplinas.txt | tail -n 1 > tmp

	awk -F ":" '{printf "%s",$1}' tmp
	echo -n " - "
	awk -F ":" '{print $2}' tmp

	fi

	done

