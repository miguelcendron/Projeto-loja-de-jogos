 Loja de Jogos online - Gamevault

 
Projeto final da disciplina: aplicação web de uma **loja de jogos** com **CRUD completo**, feita com Java (Servlets/JSP), MySQL e Bootstrap.

## Funcionalidades

- Cadastro, edição, exclusão e consulta de jogos (nome, plataforma, gênero, preço, estoque, capa e descrição)
- Painel com total de jogos, unidades em estoque, valor em estoque e quantidade de esgotados
- Busca por nome, filtro por plataforma e ordenação 
- Exibição em **cartões**  ou em **tabela**
- Página de detalhes de cada jogo
- Mensagens de sucesso/erro após cada operação
- Validação dos dados no navegador e no servidor
- Prévia da capa no formulário 
- Tela de erro


## Como executar

1. Inicie o MySQL/MariaDB (por exemplo, pelo XAMPP).
2. Importe o `loja_jogos.sql` no phpMyAdmin. Ele usa o banco `portfolio` e recria a tabela `jogo`.
3. Se o MySQL tiver senha, ajuste `src/main/resources/db.properties` .
4. Gere o WAR: `mvn clean package`
5. Copie `target/LojaJogos.war` para a pasta `webapps` do Tomcat 10.1+ e inicie o Tomcat
   (ou execute o projeto no Eclipse/VS Code com *Run on Server*).
6. Acesse: <http://localhost:8080/LojaJogos/>

## Autor

Miguel Eduardo Southier Cendron - IFC Campus Videira
2º Ano de Informática turma B
