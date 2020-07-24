#!/bin/bash

echo -ne "\nIntroduza o numero da disciplina a visualizar: "
read num

existe=$(grep ^$num: "Dados/Disciplinas.txt") #verifica se existe esse numero de Disciplina juntamente com o if

if [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
then echo "Nao existe Disciplina com numero $num."
else
	nome=$(grep ^$num: "Dados/Disciplinas.txt" | cut -d ":" -f 2)

# GET SEMESTRE E ANO ---------------------------------------------------------------
	ano=$(grep ^$num: "Dados/Disciplinas.txt" | cut -d ":" -f 3)
	sem=$(grep ^$num: "Dados/Disciplinas.txt" | cut -d ":" -f 4 | cut -d ";" -f 1)
echo -ne "\nA disciplina $nome de código $num é leccionada no ano $ano e no $sem semestre.\n"
fi
