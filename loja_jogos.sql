-- Script da Loja de Jogos (GameVault)
-- Executar no phpMyAdmin / MySQL. Usa o banco "portfolio" do repositório do professor.
-- ATENÇÃO: recria a tabela `jogo` (apaga os dados dela, se já existir). As outras tabelas não são tocadas.

CREATE DATABASE IF NOT EXISTS `portfolio` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `portfolio`;

DROP TABLE IF EXISTS `jogo`;

CREATE TABLE `jogo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(120) NOT NULL,
  `plataforma` varchar(40) NOT NULL,
  `genero` varchar(40) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  `estoque` int(11) NOT NULL DEFAULT 0,
  `imagem` varchar(500) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dados de exemplo (preços fictícios). A coluna `imagem` aceita a URL de uma capa; sem ela, o site mostra um cartão colorido.
INSERT INTO `jogo` (`nome`, `plataforma`, `genero`, `preco`, `estoque`, `imagem`, `descricao`) VALUES
('The Legend of Zelda: Breath of the Wild', 'Nintendo Switch', 'Aventura', 299.90, 8, NULL, 'Explore um vasto mundo aberto cheio de segredos, masmorras e desafios.'),
('God of War Ragnarök', 'PlayStation 5', 'Ação', 249.90, 5, NULL, 'Kratos e Atreus enfrentam deuses nórdicos em uma jornada épica.'),
('Forza Horizon 5', 'Xbox Series X', 'Corrida', 199.90, 12, NULL, 'Corridas em mundo aberto com carros de todos os tipos e cenários variados.'),
('Minecraft', 'PC', 'Sandbox', 99.90, 30, NULL, 'Construa, explore e sobreviva em um mundo feito de blocos.'),
('FIFA 23', 'PlayStation 4', 'Esporte', 149.90, 0, NULL, 'Simulador de futebol com times e campeonatos de várias ligas.'),
('Elden Ring', 'PC', 'RPG', 229.90, 4, NULL, 'RPG de ação em mundo aberto, com combates desafiadores.'),
('Mario Kart 8 Deluxe', 'Nintendo Switch', 'Corrida', 279.90, 15, NULL, 'Corridas divertidas com itens e personagens clássicos, ótimas para jogar com amigos.'),
('Cyberpunk 2077', 'PC', 'RPG', 129.90, 3, NULL, 'RPG de ação em uma metrópole futurista cheia de escolhas.'),
('Spider-Man 2', 'PlayStation 5', 'Ação', 299.90, 6, NULL, 'Aventura de super-herói balançando por uma Nova York de mundo aberto.'),
('Halo Infinite', 'Xbox Series X', 'FPS', 119.90, 9, NULL, 'Tiro em primeira pessoa com campanha e multiplayer.'),
('Hollow Knight', 'PC', 'Metroidvania', 46.90, 20, NULL, 'Aventura 2D de exploração em um reino subterrâneo de insetos.'),
('Stardew Valley', 'Nintendo Switch', 'Simulação', 54.90, 2, NULL, 'Cuide de uma fazenda, faça amizades e viva a vida no campo.');
