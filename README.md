# Bash e Estudantes Erasmus
Aplicação de linha de comando que permite a gestão de estudantes de Erasmus que cheguem à Universidade.

A sua finalidade é produzir um protótipo duma aplicação informática futura usando a linguagem e comandos do *Bash Shell*. 

A aplicação deve permitir a gestão e criação de relatórios de várias informações como por exemplo, os nomes dos alunos e os nomes dos professores responsáveis no seu país, os nomes das instituições, as disciplinas disponibilizadas pelo departamento de informática, as disciplinas escolhidas pelos alunos, entre outros.

## Organização da Aplicação
A organização da Aplicação faz-se recorrendo a diretorias, cada uma com o seu tipo de informação:

• **Auxiliar** - contém Scripts auxiliares. Por exemplo, o Script `printidname.sh` serve apenas para impressão da *PrimaryKey* e do nome de qualquer objeto. (Ver Menu Visualizar).

• **Backups** - diretoria que contém o ficheiro `Backups.txt`, no qual estão registadas todas as cópias de segurança disponíveis para restauro e as próprias cópias de segurança em ficheiros do tipo `.tar.gz`;

• **Dados** - contém um ficheiro .txt por cada objeto, (Universidades, Estudantes, Responsáveis, Disciplinas), cada um contendo informações sobre o conjunto do respetivo objeto;

• **Menus** - contém a informação dos Menus a serem apresentados ao utilizador em ficheiros `.txt`;

• **Relatorios** - diretoria na qual existem vários Scripts que respondem às opções do Menu Relatórios.

Para além destas diretorias, existe um ficheiro `main.sh` que, tal como o nome indica, é o Script principal que interrelaciona todos os outros Scripts e ficheiros `.txt` presentes nas diretorias referidas acima.

## Manual de Utilização

O utilizador deverá executar a aplicação em sistema operativo *Linux*.

Para execução da aplicação é necessário abrir um terminal e navegar até à diretoria para a qual se transferiu `AppBash`. Posteriormente, a aplicação pode ser executada recorrendo ao comando `./main.sh`.
