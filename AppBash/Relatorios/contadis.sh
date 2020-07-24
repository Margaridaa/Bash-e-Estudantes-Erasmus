#!/bin/bash

#este ficheiro permite contar em quantas disciplinas um Estudante está inscrito. Pode ser executado como escrito em ver.sh

echo -n "Selecione o numero do estudante: "
read num

existe=$(grep ^$num: "../Dados/Estudantes.txt") #verifica se existe esse numero de estudante juntamente com o if

if [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
then echo "Nao existe estudante com numero $num."
else
	nome=$(grep ^$num: "../Dados/Estudantes.txt" | cut -d : -f 2)
	ndisc=$(grep ^$num: "../Dados/Estudantes.txt" | cut -d : -f 6 | cut -d : -f 2 | grep -o ";" | wc -l)

echo "O estudante $nome esta inscrito em $ndisc disciplinas."
fi
