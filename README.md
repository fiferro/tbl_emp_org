# Script para base VRPEX de um table para: 
1. Varificar o Baú das resisdencias 
2. Verificar os carros que estão na garagem
   - Status
   - Condição
   - Apreendido
3. Criação de Grupos 
4. Propiedades da sua organização 
   - Adicionar menbros caso seja lider
   - Remover membros caso seja o lider 
   - Verificar o Baú 
5. Habilitar o emprego dinamico 

Como instalar 
  * no arquivo server.cfg Criar o ensure tbl_emp_org 
  * executar o script de banco Tablet.sql (atentar com o nome da base de dados)
  * colocar a pasta tbl_emp_org dentro de um modulo do seu servidor 

comno instalar o job dinâmico 
  * abrir um comand Windows
  * selecionar o caminho para a pasta Jobs
  * executar o comando npm install 
  * executar o comando npm start 
  