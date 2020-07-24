#!/bin/bash

	ndisc=$(grep -o ";" Dados/Estudantes.txt | wc -l)
	nalunos=$(wc -l < Dados/Estudantes.txt)

	echo -n $((ndisc / nalunos))
