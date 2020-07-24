#!/bin/bash

#este ficheiro serve essencialmente para mostrar mais informação (em texto) sobre o Estudante selecionado atraves do terminal.

echo -ne "\nIntroduza o numero do estudante a visualizar: "
read num

existe=$(grep ^$num: "Dados/Estudantes.txt") #verifica se existe esse numero de estudante juntamente com o if

if [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
then echo "Nao existe estudante com numero $num."
else
	nome=$(grep ^$num: "Dados/Estudantes.txt" | cut -d ":" -f 2)

# GET UNIVERSIDADE -----------------------------------------------------------------
	nuniv=$(grep ^$num: "Dados/Estudantes.txt" | cut -d ":" -f 3)
	universidade=$(grep ^$nuniv: "Dados/Universidades.txt" | cut -d ":" -f 2)

# GET RESPONSAVEL ------------------------------------------------------------------
	nresp=$(grep ^$num: "Dados/Estudantes.txt" | cut -d "/" -f 1 | cut -d : -f 4)
	resp=$(grep ^$nresp: "Dados/Responsaveis.txt" | cut -d : -f 2)

# GET SEMESTRE E ANO ---------------------------------------------------------------
	ano=$(grep ^$num: "Dados/Estudantes.txt" | cut -d "/" -f 2 | cut -d : -f 1)
	sem=$(grep ^$num: "Dados/Estudantes.txt" | cut -d "/" -f 2 | cut -d : -f 2 | cut -d ";" -f 1)

# GET Nº DISCIPLINAS TOTAL ---------------------------------------------------------
	ndisct=$(grep "$ano:$sem;" Dados/Disciplinas.txt | wc -l)

# GET Nº DE DISCIPLINAS INSCRITO ---------------------------------------------------
	ndisci=$(grep ";$num" "Dados/Disciplinas.txt" | cut -d ":" -f 1 | wc -l)


echo -ne "\nO aluno $nome vem da $universidade. O/A Professor/a responsável é $resp. O aluno vem no $sem semestre do $ano ano. O departamento de Informática tem para o $sem semestre apenas $ndisct disciplinas disponíveis para alunos Erasmus. O aluno escolheu fazer $ndisci disciplina(s)"
	
	declare -i j=0
	for (( j=2; j<=ndisci+1; j++ ))
	do	
	echo -n ", "
	codigo=$(grep ^$num: "Dados/Estudantes.txt" | cut -d ";" -f $j) 
	discn=$(grep ^$codigo "Dados/Disciplinas.txt" | cut -d ":" -f 2)
	disano=$(grep ^$codigo "Dados/Disciplinas.txt" | cut -d ":" -f 3)
	disem=$(grep ^$codigo "Dados/Disciplinas.txt" | cut -d ":" -f 4 | cut -d ";" -f 1)

	echo -n " $discn com código $codigo, lecionada no $disano ano $disem semestre"
	done

	echo "."
fi
