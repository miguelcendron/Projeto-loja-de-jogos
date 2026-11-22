# 🎮 GameVault - Loja de Jogos

Projeto final da disciplina: aplicação web de uma **loja de jogos** com **CRUD completo**, feita com Java (Servlets/JSP), MySQL e Bootstrap.

## Requisitos do trabalho

| Requisito | Como foi atendido |
|-----------|-------------------|
| **C**reate | Botão "+ Novo jogo" → formulário com validação → `JogoDAO.inserir` |
| **R**ead   | Catálogo em cartões ou tabela, busca por nome, filtro de plataforma, ordenação, painel de resumo e página de detalhes → `JogoDAO.listar`, `buscarPorId`, `resumo` |
| **U**pdate | Botão "Editar" → formulário preenchido → `JogoDAO.atualizar` |
| **D**elete | Botão "Excluir" com janela de confirmação → `JogoDAO.excluir` |
| Estilização | CSS próprio (tema escuro) + **Bootstrap 5**, layout responsivo (funciona no celular) |
| Banco de dados | MySQL/MariaDB, banco `portfolio` do repositório base, tabela `jogo` (`loja_jogos.sql`) |
| Servidor | Apache Tomcat 10.1+ (aplicação empacotada em WAR via Maven) |

## Funcionalidades

- Cadastro, edição, exclusão e consulta de jogos (nome, plataforma, gênero, preço, estoque, capa e descrição)
- Painel com total de jogos, unidades em estoque, valor em estoque e quantidade de esgotados
- Busca por nome, filtro por plataforma e ordenação (nome, preço, estoque, mais recentes)
- Exibição em **cartões** (com capa) ou em **tabela**
- Página de detalhes de cada jogo
- Mensagens de sucesso/erro após cada operação
- Validação dos dados no navegador e no servidor
- Prévia da capa no formulário (colando o endereço de uma imagem)
- Tela de erro amigável

## Boas práticas usadas

- Organização em camadas (MVC): `model`, `dao`, `controller` (Servlet) e `views` (JSP)
- `PreparedStatement` em todas as consultas (protege contra SQL Injection)
- `<c:out>` em todos os textos exibidos (protege contra XSS)
- Padrão Post/Redirect/Get (recarregar a página não repete o cadastro)
- Configuração do banco em arquivo separado: `src/main/resources/db.properties`

## Tecnologias

Java 21+ · Servlets e JSP (Jakarta EE) · JSTL · Apache Tomcat 10.1+ · MySQL/MariaDB · Maven · Bootstrap 5

## Estrutura

```
src/main/java/br/edu/ifc/videira/loja/
  model/Jogo.java, Resumo.java      -> classes de dados
  dao/Conexao.java                  -> conexão JDBC (lê o db.properties)
  dao/JogoDAO.java                  -> INSERT, SELECT, UPDATE e DELETE
  controller/JogoServlet.java       -> recebe as ações e valida os dados
src/main/resources/db.properties    -> usuário, senha e endereço do banco
src/main/webapp/
  index.jsp                         -> redireciona para /jogos
  css/estilo.css                    -> estilos
  WEB-INF/views/                    -> lista, form, detalhes, erro, cabecalho, rodape
loja_jogos.sql                      -> cria a tabela `jogo` com 12 jogos de exemplo
```

## Como executar

1. Inicie o MySQL/MariaDB (por exemplo, pelo XAMPP).
2. Importe o `loja_jogos.sql` no phpMyAdmin. Ele usa o banco `portfolio` e (re)cria a tabela `jogo`.
3. Se o seu MySQL tiver senha, ajuste `src/main/resources/db.properties` (padrão: usuário `root`, sem senha).
4. Gere o WAR: `mvn clean package`
5. Copie `target/LojaJogos.war` para a pasta `webapps` do Tomcat 10.1+ e inicie o Tomcat
   (ou execute o projeto no Eclipse/VS Code com *Run on Server*).
6. Acesse: <http://localhost:8080/LojaJogos/>

## Autor

Nome do aluno - IFC Campus Videira
