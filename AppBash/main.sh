#!/bin/bash

menu_relatorio () {
	echo ""; declare -i v=-1
	cat Menus/menurel.txt
	echo -n "Introduza a opção> "

	# Switch case: Menu Relatorios
	while (true)
	do 
	read v
	case $v in
		0) 	sleep 1; return
		;;

		1) 	chmod +x Relatorios/mediadiscalunos.sh
			sleep 1
			echo -ne "\nEm media ha "
			./Relatorios/mediadiscalunos.sh
			echo " disciplinas por aluno."
		   	read -rsp $'\n\nPressione qualquer tecla para continuar...\n' -n1 key
			return;;
	
		2) 	chmod +x Auxiliar/printidname.sh
		    	sed 's/Objeto/Universidades/g' Auxiliar/printidname.sh > novo.sh
		    	chmod +x novo.sh
		    	echo -ne "\n\e[31mUniversidades:\e[0m "
		   	./novo.sh
		   	 echo -n -e "\nSelecione o id da Universidade: "
		    	read uni_id
		    	existe=$(grep -w "^$uni_id" Dados/Universidades.txt)
		    	while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
				do
					echo -n "Introduza novamente o código: "
					read uni_id
		    			existe=$(grep -w "^$uni_id" Dados/Universidades.txt) #verifica se existe alguma universidade com esse codigo
				done

		    	nome=$(grep "^$uni_id:.*" Dados/Universidades.txt | cut -d : -f 2)
		
			cut -d : -f 3 Dados/Estudantes.txt > tmp
			n=$(grep -wo "$uni_id"  tmp | wc -l)
			sleep 1; echo ""
			echo -e "\e[1;4m$nome\e[0m tem $n alunos."
		   	read -rsp $'\n\nPressione qualquer tecla para continuar...\n' -n1 key
			return;;

		3) 	echo -n "Introduza o ano: " 
	   	    	read ano
		    	echo -n "Introduza o semestre: "
	   	    	read semestre
		    	cut -d "/" -f 2 Dados/Estudantes.txt  | cut -d ";" -f 1 | cut -d : -f1-2 > tmp
	 	    	n=$(grep -o "$ano:$semestre" tmp | wc -l)
			sleep 1; echo ""
		    	echo "Estão inscritos $n alunos no $ano ano, $semestre semestre."; echo""
		   	read -rsp $'\n\nPressione qualquer tecla para continuar...\n' -n1 key
		   	 return;;
		
		4) 	linhas_Disciplinas=$(wc -l < Dados/Disciplinas.txt)
			declare -i j=0
			declare -i k=0
			echo ""
			for (( j=1; j<=linhas_Disciplinas; j++ ))
			do	

			if [ $j -eq 1 ]
			then 
				head -n $j Dados/Disciplinas.txt  > tmp
				n=$(grep -o ";" tmp | wc -l)
				if [ $n -gt 0 ]
				then
					nome=$(cut -d : -f 2 tmp)
					sleep 1; echo ""
					echo -e "\e[1;4m$nome\e[0m com $n alunos"
				else 
					echo -n ""
				fi
			else
				head -n $j Dados/Disciplinas.txt | tail -n 1 > tmp
				n=$(grep -o ";" tmp | wc -l)
				if [ $n -gt 0 ]
				then
					nome=$(cut -d : -f 2 tmp)
					sleep 1; echo ""
					echo -e "\e[1;4m$nome\e[0m com $n alunos"
				else 
					echo -n ""
				fi
			fi
			done
		   	read -rsp $'\n\nPressione qualquer tecla para continuar...\n' -n1 key
			echo ""
			return;;
	
		*)	 echo -n "Introduza uma opção válida> "
			;;
	esac
	done	
	echo ""
	cat Menus/menuprin.txt
}
			

menu_gestao () {
	echo ""; declare -i v=-1
	cat Menus/menugest.txt
	echo -n "Introduza a opção> "

	# Switch case: Menu Gestão
	while (true)
	do 
	read v
	case $v in

		0)	 return
			;;

		1)  	data=$(date +"%h%d-%H%M")		# permite que cada cópia de segurança tenha um nome identificativo, informativo e útil
			tar -czf Backups/$data.tar.gz Dados	# cria a cópia de segurança
			next_id=$(tail -n 1 Backups/Backups.txt | cut -d : -f 1)
			((next_id++))
			echo "$next_id:$data" >> Backups/Backups.txt	# adiciona o registo da cópia criada ao ficheiro Backups/Backups.txt
			echo "Criando cópia de segurança"				# "sleep's" apenas por motivos visuais
			sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
				sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
					sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
			echo -e "...\nCópia de segurança criada!"
		    	sleep 1
			return
			;;

		2) 	if [ -s Backups/Backups.txt ] 			# devolve True se o ficheiro Backups/Backups.txt existir e não for vazio
			then
				echo -e "\nCópias de segurança: "
		    		awk -F ":" '{printf "%s - %s\n",$1, $2}' Backups/Backups.txt	# permite ao utilizador visualizar todas as cópias de segurança que podem ser restauradas
			    	echo -n -e "\nSelecione o número da cópia a restaurar: "
			    	read cop
			   	existe=$(grep -w "^$cop" Backups/Backups.txt)
			    	while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
				do
					echo -n "Introduza novamente o código: "
					read cop
			    		existe=$(grep -w "^$cop" Backups/Backups.txt) 
				done

				nome_backup=$(grep ^$cop Backups/Backups.txt | cut -d : -f 2)

				rm -rf Dados
				tar -xzf Backups/$nome_backup.tar.gz	# restaura a cópia de segurança selecionada
				echo "Restaurando cópia de segurança"
				sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
					sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
						sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
				echo -e "...\nCópia de segurança restaurada!"

			    	sleep 1
				return
		
			else 
				echo "De momento, não existem cópias de segurança."; echo ""
				
			    	sleep 1
				return
			fi
			;;

		3)	if [ -s Backups/Backups.txt ] 
			then
				echo -e "\nCópias de segurança: "
			    	awk -F ":" '{printf "%s - %s\n",$1, $2}' Backups/Backups.txt

			    	echo -n -e "\nSelecione o número da cópia a apagar: "
			    	read cop
			    	existe=$(grep -w "^$cop" Backups/Backups.txt)
			    	while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
				do
					echo -n "Introduza novamente o código: "
					read cop
			    		existe=$(grep -w "^$cop" Backups/Backups.txt) #verifica se existe algum backup (cópia de segurança) com esse codigo
				done
				   
			
				nome_backup=$(grep ^$cop Backups/Backups.txt | cut -d : -f 2)
				rm Backups/$nome_backup.tar.gz		# apaga a cópia de segurança

				echo "Apagando cópia de segurança"
				grep -v ^$cop Backups/Backups.txt > tmp
				cat tmp > Backups/Backups.txt			# apaga do ficheiro Backups/Backups.txt o registo relativo à copia de segurança apagada
				sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
					sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
						sleep 0.2; echo -n "."; sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n ".";sleep 0.2; echo -n "."
				echo -e "...\nCópia de segurança apagada!"

				sleep 1
				return

			else 
				echo -e "\nDe momento, não existem cópias de segurança.\n"
			    	sleep 1
				return
			fi
			;;

		*) 	echo -n "Introduza uma opção válida> "
			;;
	esac
	done	
	echo ""
	cat Menus/menuprin.txt
}

menu_registo () {
	echo ""; declare -i v=-1
	cat Menus/menuregisto.txt	
	echo -n "Introduza a opção> "

	# Switch case: Menu Registo
	while (true)
	do 
	read v
	case $v in

		0) 	sleep 1
			return
			;;

		1 ) 	echo -n "Insira o nome da Universidade: "; read nome
		    	id=$(tail -n 1 Dados/Universidades.txt | cut -d : -f 1); ((id++))
		    	echo "$id:$nome" >> Dados/Universidades.txt
		    	echo -e "Universidade \e[1;4m$nome\e[0m registada com sucesso."
		    	sleep 1
		    	return
			;;

		2 ) 	echo -n "Insira o nome do Professor: "; read nome
		    	id=$(tail -n 1 Dados/Responsaveis.txt | cut -d : -f 1); ((id++))
		    	echo "$id:$nome" >> Dados/Responsaveis.txt
		    	echo -e "Responsavel \e[1;4m$nome\e[0m registado com sucesso."
		    	sleep 1
		    	return
			;;

		3 ) # devido à sua extensão, criou-se o ficheiro correspondente a esta opção: Auxiliar/registoaluno.sh
		     	chmod +x Auxiliar/registoaluno.sh
	    	   	 ./Auxiliar/registoaluno.sh
		   	 sleep 1
		    	return
			;;
		
		4)  	echo -n "Insira o nome da Disciplina: "; read nome
		    	echo -n "Insira o código: "; read codigo
		    	echo -ne "Insira o ano e o semestre em que é lecionada.\nAno: "; read ano

		    	echo -n "Semestre: "; read semestre
			while [[ ! $semestre =~ ^[1-2]+$ ]] 		# so permite escolher 1 ou 2 semestre
			do
				echo -n "Semestre inválido, opcoes 1º ou 2º: "
				read semestre
		    	done
		   	echo "$codigo:$nome:$ano:$semestre" >> Dados/Disciplinas.txt

		    	cat Dados/Disciplinas.txt > tmp; sort -n -o tmp Dados/Disciplinas.txt	# ordena as disciplinas por codigo
		    	echo -e "Disciplina \e[1;4m$nome\e[0m registada com sucesso."
		    	sleep 1; return
			;;

		*) echo -n "Introduza uma opção válida> "
		;;
	esac
	done	

	echo ""
	cat Menus/menuprin.txt
}

menu_visualizar () {
	declare -i v=-1	# (-1 para entrar no ciclo While)
			
	# Switch case: Menu Visualização
	echo ""; cat Menus/menuvis.txt
	while ((!($v==0)))
	do 
	echo -n "Introduza a opção> "	
	read v
	case $v in
		0) 	sleep 1; return
			;;

		1) 	chmod +x Auxiliar/printidname.sh
		   	sed 's/Objeto/Universidades/g' Auxiliar/printidname.sh > novo.sh
		   	chmod +x novo.sh
		   	echo -ne "\n\e[1;4mUniversidades:\e[0m "
		   	./novo.sh
		   	sleep 2
			return
			;;

		2) 	chmod +x Auxiliar/printidname.sh
		   	sed 's/Objeto/Responsaveis/g' Auxiliar/printidname.sh > novo.sh
		   	chmod +x novo.sh
		   	echo -ne "\n\e[1;4mResponsaveis:\e[0m "
		   	./novo.sh
		   	sleep 2
			return
			;;

		3) 	chmod +x Auxiliar/printidname.sh
		   	sed 's/Objeto/Estudantes/g' Auxiliar/printidname.sh > novo.sh
		   	chmod +x novo.sh
		   	echo -ne "\n\e[1;4mEstudantes:\e[0m "
		  	 ./novo.sh
		  	 sleep 2
		   	chmod +x Relatorios/infoaluno.sh
		  	 ./Relatorios/infoaluno.sh
		   	read -rsp $'\n\nPressione qualquer tecla para continuar...\n' -n1 key
			return		
			;;

		4) 	chmod +x Auxiliar/printidname.sh
		   	sed 's/Objeto/Disciplinas/g' Auxiliar/printidname.sh > novo.sh
		   	chmod +x novo.sh
		   	echo -ne "\n\e[1;4mDisciplinas:\e[0m "
		   	./novo.sh
		   	chmod +x Relatorios/infodisc.sh
		   	./Relatorios/infodisc.sh
		 	read -rsp $'\n\nPressione qualquer tecla para continuar...\n' -n1 key
			return		
			;;

		*) 	echo -n "Introduza uma opção válida> "
		    	sleep 0.5
			return
			;;
	esac
	done
}

menu_alterar () {
	declare -i v=-1		# declara um inteiro v=-1
	
	# Switch case: Menu Alterar
	echo ""; cat Menus/menualt.txt
	echo -n "Introduza a opção> "
	while (true)
	do 
	read v
	case $v in

		0)  	sleep 1; return
			;;

		1 ) 	chmod +x Auxiliar/printidname.sh
		    	sed 's/Objeto/Universidades/g' Auxiliar/printidname.sh > novo.sh
		    	chmod +x novo.sh
		    	echo -ne "\n\e[31mUniversidades:\e[0m "
		   	./novo.sh
		    	echo -n -e "\nSelecione o id da Universidade a alterar: "
		    	read uni_id
		    	existe=$(grep -w "^$uni_id" Dados/Universidades.txt)
		    	while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
			do
				echo "Universidade de código $uni_id não existe"
				echo -n "Introduza novamente o código da universidade: "
				read uni_id
		    		existe=$(grep -w "^$uni_id" Dados/Universidades.txt) #verifica se existe alguma universidade com esse codigo
			done

		    	nomev=$(grep "^$uni_id:.*" Dados/Universidades.txt | cut -d : -f 2)
		    	echo -e "Universidade selecionada: \e[1;4m$nomev\e[0m"

		    	echo -n -e "\nPretende alterar?\n\t(1-\e[44mAlterar\e[0m\t2-\e[48;5;28mCancelar\e[0m): "
		    	while (true)
		   	do
		    		read opt
		    		case $opt in		# o utilizador tem opção de 1-Alterar ou 2-Cancelar
				1) 	echo -n "Insira o novo nome: "; read nomen
			    		sed -i.bak s/"$nomev"/"$nomen"/g Dados/Universidades.txt
			    		echo -e "\e[1;4m$nomen\e[0m alterada com sucesso."
		    			sleep 1
			    		return
					;; 

				2)  	echo "Cancelado."
		    			sleep 1
			   		return
					;;

				*) 	echo -n "Introduza uma opção válida> "
		    			sleep 0.5
					;;
			esac
			done
			;;	
			    
		2)  	chmod +x Auxiliar/printidname.sh
		    	sed 's/Objeto/Responsaveis/g' Auxiliar/printidname.sh > novo.sh
		   	chmod +x novo.sh
		    	echo -ne "\n\e[31mResponsáveis:\e[0m "
		   	./novo.sh
		    	echo -n -e "\nSelecione o id do Responsável a alterar: "
		    	read resp_id
		    	existe=$(grep -w "^$resp_id" Dados/Responsaveis.txt)
		    	while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
			do
				echo "Responsável de código $resp_id não existe."
				echo -n "Introduza novamente o código do responsável: "
				read resp_id
		    		existe=$(grep -w "^$resp_id" Dados/Responsaveis.txt) 	#verifica se existe algum Responsavel com esse codigo
			done

		    	nomev=$(grep "^$resp_id:.*" Dados/Responsaveis.txt | cut -d : -f 2)
		    	echo -e "Responsável selecionado: \e[1;4m$nomev\e[0m"

			echo -n -e "\nPretende alterar?\n\t(1-\e[44mAlterar\e[0m\t2-\e[48;5;28mCancelar\e[0m): "
		    	while (true)
		    	do
		    		read opt
		    		case $opt in		# o utilizador tem 2 opções 1-Alterar ou 2-Cancelar
					1) 	echo -n "Insira o novo nome: "; read nomen
			    			sed -i.bak s/"$nomev"/"$nomen"/g Dados/Responsaveis.txt
			    			echo -e "\e[1;4m$nomen\e[0m alterada com sucesso."
		    				sleep 1
			    			return
						;; 
				2)  	echo -e "\nCancelado."
		    			sleep 1
			   		return
					;;

				*) 	echo -n "Introduza uma opção válida> "
		    			sleep 0.5
					;;
			esac
			done
			;;	


		3) 	chmod +x Auxiliar/printidname.sh
		    	sed 's/Objeto/Estudantes/g' Auxiliar/printidname.sh > novo.sh
		    	chmod +x novo.sh
		    	echo -ne "\n\e[31mEstudantes:\e[0m "
		   	./novo.sh
		    	echo -n -e "\nSelecione o id do Estudante a alterar: "
		    	read est_id
		    	existe=$(grep -w "^$est_id" Dados/Estudantes.txt)
		    	while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
			do
				echo -n "Introduza novamente o código do estudante $n: "
				read est_id
		    		existe=$(grep -w "^$est_id" Dados/Estudantes.txt) #verifica se existe algum Estudante com esse codigo
			done

		    	nomev=$(grep "^$est_id:.*" Dados/Estudantes.txt | cut -d : -f 2)
		    	echo -e "Estudante selecionado: \e[1;4m$nomev\e[0m"
		    	sleep 1
	
			echo -n -e "\nPretende alterar?\n\t(1-\e[44mAlterar\e[0m\t2 - \e[41mApagar\e[0m\t3-\e[48;5;28mCancelar\e[0m): "
		    	while (true)
		    	do
		    	read opt
		    	case $opt in		# o utilizador tem 3 opções
			1) 	echo -ne "\nInsira o novo nome: "; read nomen
			    	sed -i.bak s/"$nomev"/"$nomen"/g Dados/Estudantes.txt
			    	echo -e "\e[1;4m$nomen\e[0m alterada com sucesso."
		    		sleep 1
			    	return
				;; 

			2) 	grep "$est_id:$nomev" Dados/Estudantes.txt > aluno	# linha relativa ao aluno
				ndisc=$(grep -o ";" aluno | wc -l)						# numero de disciplinas do aluno
				((ndisc++))
				(grep "$est_id:$nomev" aluno | cut -d "/" -f 2 | cut -d ";" -f2-$ndisc) > tmp	# disciplinas do aluno

				for (( i=1; i<ndisc; i++ ))
				do
					codigo_disc=$(cut -d ";" -f $i tmp)			# guarda o codigo da disciplina
					grep ^$codigo_disc Dados/Disciplinas.txt > tmp1		# obtem a linha relativa ao registo da disciplina de codigo = codigo_disc
					# retira a inscricao do aluno na disciplina					
					sed "s/;$est_id//g" tmp1 > tmp3							
					# elimina a linha da disciplina de codigo = codigo_disc do ficheiro Dados/Disciplinas.txt
					grep -v ^$codigo_disc Dados/Disciplinas.txt > tmp2		
					cat tmp2 > Dados/Disciplinas.txt
					# adiciona a linha da disciplina de codigo = codigo_disc ja sem a inscricao do aluno.
					cat tmp3 >> Dados/Disciplinas.txt
				done
				

				grep -v "$est_id:$nomev" Dados/Estudantes.txt > tmp
			     	cat tmp > Dados/Estudantes.txt
			    	echo -e "Estudante \e[1;4m$nomev\e[0m apagado dos registos." 
		   	 	sleep 1
				echo ""
			    	rm tmp; rm aluno
			    	return;;

			3)  	echo -e "\nCancelado."
		    		sleep 1
			  	return
				;;

			*) 	echo -n "Introduza uma opção válida> "
		    		sleep 0.5
				;;
			esac
			done
			;;	

		4) 	chmod +x Auxiliar/printidname.sh
		    	sed 's/Objeto/Disciplinas/g' Auxiliar/printidname.sh > novo.sh
		    	chmod +x novo.sh
		    	echo -ne "\n\e[31mDisciplinas:\e[0m "
		   	./novo.sh
		    	echo -n -e "\nSelecione o id da Disciplina a alterar: "
		    	read dis_id
		    	existe=$(grep -w "^$dis_id" Dados/Disciplinas.txt)
		    	while [ -z "$existe" ] #-z returns true if the length of "STRING" is zero.
			do
				echo -n "Introduza novamente o código da Disciplina $n: "
				read dis_id
		    		existe=$(grep -w "^$dis_id" Dados/Disciplinas.txt) #verifica se existe algum Disciplina com esse codigo
			done

			echo -ne "Pretende mudar o nome ou ano/semestre da disciplina?\n\t(1 - \e[44mNome\e[0m\t2 - \e[41mAno/semestre\e[0m\t3 - \e[48;5;28mCancelar\e[0m): "
			declare -i v=-1		# declara um inteiro v=-1
			while (true)
			do 
			read v
			case $v in
				1) 	nome=$(grep ^$dis_id Dados/Disciplinas.txt | cut -d : -f 2)
					echo -n "Novo nome: "
					read nomen
					sed -i.bak s/"$nome"/"$nomen"/g Dados/Disciplinas.txt
					echo -e "Disciplina \e[1;4m$nomen\e[0m alterada com sucesso."
		    			sleep 1
					return;;

				2) 	grep $dis_id Dados/Disciplinas.txt > disciplina				# tem a linha da propria disciplina
					grep -v $dis_id Dados/Disciplinas.txt > tmp
					cat tmp > Dados/Disciplinas.txt							# elimina dos dados a disciplina a ser alterada
					nome=$(grep ^$dis_id disciplina | cut -d : -f 2)
					ano=$(grep ^$dis_id disciplina | cut -d : -f 3)
					sem=$(grep ^$dis_id disciplina | cut -d : -f 4)

					nalunos=$(grep -o ";" disciplina | wc -l)
					if [ $nalunos -eq 0 ]
					then
						touch alunos
					else
						((nalunos++))
						(grep ^$dis_id disciplina | cut -d ";" -f2-$nalunos) > alunos	# numero dos alunos inscritos na disciplina 
					fi

					echo -ne "Insira o novo ano e o semestre em que será lecionada\nAno: "; read anon
					echo -n "Semestre: "; read semestren
					while [[ ! $semestren =~ ^[1-2]+$ ]] 
					do
					echo -n "Semestre inválido, opcoes 1º ou 2º: "
					read semestren
			    		done

					if [ -s alunos ]
					then
						echo -n "$dis_id:$nome:$anon:$semestren" >> Dados/Disciplinas.txt
						echo -n ";" >> Dados/Disciplinas.txt
						cat alunos >> Dados/Disciplinas.txt
						echo  -e "Disciplina \e[1;4m$nome\e[0m alterada com sucesso."
					else
						echo "$dis_id:$nome:$anon:$semestren" >> Dados/Disciplinas.txt
						echo  -e "Disciplina \e[1;4m$nome\e[0m alterada com sucesso."
					fi

					rm alunos; rm disciplina; rm tmp
		    			sleep 1
					return;;

				3)  	echo -e "\nCancelado"
		    			sleep 1
			    		return;;

				*) 	echo -n "Introduza uma opção válida> "
		    			sleep 0.5
					;;
			esac
			done;;

		*) 	echo -n "Introduza uma opção válida> "
		    	sleep 0.5
			;;
	esac
	done	
}

# --------------------------------------------main ------------------------------------------------------------------
	declare -i v=-1				# Declarar inteiros com declare -i ( -1 Para entrar no ciclo While)
	cat Menus/menuprin.txt		# Apresenta o menu principal
	# Switch case: Menu Principal
	while ((!($v==0)))
	do 
	echo -n "Introduza a opção> "	# echo -n evita o caracter NEWLINE
	read v
	case $v in
		0) 	#fim de execução do programa. 
			
			#para não arriscar apagar ficheiros não existentes, usa-se touch para garantir que há no mínimo um ficheiro de cada tipo
			#(temporário, .bak (originado por alteração de nomes por exemplo), e novo.sh caso tenha sido usado para mostrar no ecrã os elementos de um certo objeto) 
			touch tmp10; touch Dados/a.bak; touch novo.sh
			#de forma a não acumular "Lixo" nas variadas diretorias do Projeto. 
			rm *tmp* ;  rm Dados/*.bak*; rm novo.sh
			echo -e "Terminando o programa... \n\n"; exit
			;;

		1 ) 	sleep 0.4
	    		menu_registo
	    		echo ""
	    		cat Menus/menuprin.txt
			;;

		2 )  	sleep 0.4
	    		menu_alterar
	    		echo ""
	    		cat Menus/menuprin.txt
			;;

		3 )  	sleep 0.4
	    		menu_visualizar
	    		echo ""
	    		cat Menus/menuprin.txt
			;;

		4)	sleep 0.4
	    		menu_relatorio
	    		echo ""
	    		cat Menus/menuprin.txt
			;;

		5)  	sleep 0.4
	    		menu_gestao
	    		echo ""
	    		cat Menus/menuprin.txt
			;;

		* ) 	echo "Opção inválida."; echo " "; sleep 0.5
			;;
	esac
	done
