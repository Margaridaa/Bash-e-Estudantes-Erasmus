		echo -en "\nInsira o nome do Estudante: "
		    read nome


		    # Responsavel 
		    echo -e "\nO id do seu professor responsável, apresentados abaixo: "
		    chmod +x Auxiliar/printidname.sh
		    sed 's/Objeto/Responsaveis/g' Auxiliar/printidname.sh > novo.sh
		    chmod +x novo.sh
		    ./novo.sh
		    echo -en "\nId: "
		    read idr
		    existe=$(grep ^$idr: Dados/Responsaveis.txt)

		    while [ -z "$existe" ] 
			do
			echo -n "Id inválido, insira novamente: "
			read idr
			existe=$(grep ^$idr: Dados/Responsaveis.txt)
		    done

		    # Pede informacao sobre a universidade que frequenta
		    echo -e "\nO código da sua universidade, apresentadas abaixo: "

		    chmod +x Auxiliar/printidname.sh
		    sed 's/Objeto/Universidades/g' Auxiliar/printidname.sh > novo.sh
		    ./novo.sh
 		
		    echo -en "\nCódigo universidade: "
		    read iduni
		    existe=$(grep ^$iduni: Dados/Universidades.txt)

		    while [ -z "$existe" ] 
			do
			echo -n "Código inválido, insira novamente: "
			read iduni
			existe=$(grep ^$iduni: Dados/Universidades.txt)
		    done
	
		    # Periodo de Erasmus
		    echo -ne "\nO aluno vem no 1º/2º semestre: "
		    read semestre
		    while [[ ! $semestre =~ ^[1-2]+$ ]] 
			do
			echo -n "Semestre inválido, opcoes 1º ou 2º: "
			read semestre
		    done

		    echo -ne "\nNo ano: " 
		    read ano
		    while [[ ! $ano =~ ^[1-2]+$ ]] 
			do
			echo -n "Ano inválido, insira novamente: "
			read ano
		    done

		    echo -e "\nDisciplinas disponiveis no $semestre semestre do $ano ano: " 


		    (grep ".*:$ano:$semestre" Dados/Disciplinas.txt | cut -d : -f 1) > tmpid # guarda os ids das disciplinas validas
		    (grep ".*:$ano:$semestre" Dados/Disciplinas.txt | awk -F ':' '{ print $1" - "$2 }') > tmp
		    cat tmp #mostra as disciplinas validas

		    # Numero de disciplinas em q se vai inscrever
		    n_d_validas=$(wc -l < tmpid)
		    echo -ne "\nNúmero de disciplinas a inscrever: "
		    read ndis
		    while [ $ndis -gt $n_d_validas ]
		    do
			echo -n "Máximo $n_d_validas. Introduza novamente: "
			read ndis
		    done

		    
		    if [ ! $ndis -eq 0 ]
		    then 
			    # pede os codigos das disciplinas
			    echo "Introduza o(s) seu(s) código(s): "
			    declare -a Array_Discip

			    for (( i=0; i<ndis; i++ ))
			    do
				n=$((i+1))
				echo -n "Disciplina $n: "; read numdis
				existe=$(grep -w "^$numdis" tmpid) #verifica se existe esse id de disciplina (tmpid # guardou os ids das disciplinas validas)		
				while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
				do
					echo "Disciplina de código $numdis não disponível para inscrição."
					echo -n "Introduza novamente o código da disciplina $n: "
					#echo "Introduza novamente, da lista abaixo: "
					#cat tmp #mostra as disciplinas validas
					read numdis
					existe=$(grep -w "^$numdis" tmpid) #verifica se existe esse id de disciplina juntamente com o if 
				done

				# por numdis num array
				Array_Discip=("${Array_Discip[@]}" "$numdis")
			    done

			    echo -e "\nEscolheu as disciplinas de código ${Array_Discip[@]}."
			    
		    else 
			echo -e "\nO aluno não se inscreveu em qualquer disciplina."
		
		    fi

		
		    # calcula o seu numero de aluno.
		    id=$(tail -n 1 Dados/Estudantes.txt | cut -d : -f 1)
		    ((id++))

		    echo -n "$id:$nome:$iduni:$idr/$ano:$semestre" >> Dados/Estudantes.txt

		    for (( j=0; j<ndis; j++ ))
		    do
			echo -n ";${Array_Discip[j]}" >> Dados/Estudantes.txt
		    done

		    echo "" >> Dados/Estudantes.txt
		

		    # Acrescenta ao ficheiro Disciplinas.txt o nº de aluno nas disciplinas em q se registou
		    # sed -e "s/$/string after each line/" -i filename 		# permite acrescentar uma coluna a cada linha,
											# msm q difiram do nº de colunas entre si
		    # $ acrescenta no end-of-line. ^ acrescenta no beginning of line.
		    # sed com '' não permite susbtituir com valores de variaveis


		    # Alterar Disciplinas.txt
		    for (( j=0; j<ndis; j++ ))
		    do
			sed "/\b\(${Array_Discip[j]}\)\b/d" Dados/Disciplinas.txt > tmp1 #tmp1: disciplinas nao escolhidas
			grep -v -f tmp1 Dados/Disciplinas.txt > tmp2	#tmp2: disciplinas escolhidas pelo aluno
			cat tmp1 > Dados/Disciplinas.txt		#Disciplinas.txt passa a ter so as nao escolhidas
			sed -e "s/$/;$id/" -i tmp2 			#tmp2: acrescenta-se o numero do aluno às disciplinas escolhidas
			cat tmp2 >> Dados/Disciplinas.txt
		    done

		    sort -n -o tmp3 Dados/Disciplinas.txt
		    cat tmp3 > Dados/Disciplinas.txt

		    # Depois de todos os passos cumpridos, apresenta-se a mensagem de sucesso no registo:
		    echo "$nome registado/a com sucesso."
		    sleep 1.5

