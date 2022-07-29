-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.24-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para vrp
DROP DATABASE IF EXISTS `vrp`;
CREATE DATABASE IF NOT EXISTS `vrp` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `vrp`;

-- Copiando estrutura para tabela vrp.emp_diario
DROP TABLE IF EXISTS `emp_diario`;
CREATE TABLE IF NOT EXISTS `emp_diario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataInicio` date NOT NULL DEFAULT current_timestamp(),
  `nome` varchar(50) NOT NULL,
  `emp_user_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela vrp.emp_user
DROP TABLE IF EXISTS `emp_user`;
CREATE TABLE IF NOT EXISTS `emp_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataInicio` date NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL,
  `ativo` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela vrp.grupo
DROP TABLE IF EXISTS `grupo`;
CREATE TABLE IF NOT EXISTS `grupo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(250) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL,
  `radio` tinytext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela vrp.grupo_user
DROP TABLE IF EXISTS `grupo_user`;
CREATE TABLE IF NOT EXISTS `grupo_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `lider` float NOT NULL DEFAULT 0,
  `id_grupo` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para view vrp.vw_identif_org
DROP VIEW IF EXISTS `vw_identif_org`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vw_identif_org` (
	`user_id` INT(11) NOT NULL,
	`name` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`phone` VARCHAR(20) NULL COLLATE 'latin1_swedish_ci',
	`foto` VARCHAR(150) NULL COLLATE 'latin1_swedish_ci',
	`dvalue` TEXT NULL COLLATE 'latin1_swedish_ci',
	`registration` VARCHAR(20) NULL COLLATE 'latin1_swedish_ci',
	`org` VARCHAR(9) NULL COLLATE 'utf8mb4_general_ci',
	`Lider` VARCHAR(14) NULL COLLATE 'utf8mb4_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para view vrp.vw_org_user
DROP VIEW IF EXISTS `vw_org_user`;
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `vw_org_user` (
	`NAME` VARCHAR(9) NULL COLLATE 'utf8mb4_general_ci',
	`user_id` INT(11) NOT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view vrp.vw_identif_org
DROP VIEW IF EXISTS `vw_identif_org`;
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vw_identif_org`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_identif_org` AS SELECT vui.user_id, vui.name, vui.phone, vui.foto, vud.dvalue, vui.registration,
case when ( vud.dvalue LIKE '%bloods%') then 
'bloods' 
when ( vud.dvalue LIKE '%azuis%') then 
'azuis'
when ( vud.dvalue LIKE '%mafia%') then 
'mafia'
when ( vud.dvalue LIKE '%verdes%') then 
'verdes'
when ( vud.dvalue LIKE '%bratva%') then 
'bratva'
when ( vud.dvalue LIKE '%cartel%') then 
'cartel'
when ( vud.dvalue LIKE '%thelostmc%') then 
'thelostmc'
when ( vud.dvalue LIKE '%vanilla%') then 
'vanilla'
when ( vud.dvalue LIKE '%bahamas%') then 
'bahamas'
when ( vud.dvalue LIKE '%hells%') then 
'hells'
when ( vud.dvalue LIKE '%roxos%') then 
'roxos'
when ( vud.dvalue LIKE '%vagos%') then 
'vagos'
ELSE 
''
END as org,
case when ( vud.dvalue LIKE '%liderbloods%') then 
'liderbloods' 
when ( vud.dvalue LIKE '%liderazuis%') then 
'liderazuis'
when ( vud.dvalue LIKE '%lidermafia%') then 
'lidermafia'
when ( vud.dvalue LIKE '%liderverdes%') then 
'verdes'
when ( vud.dvalue LIKE '%liderbratva%') then 
'liderbratva'
when ( vud.dvalue LIKE '%lidercartel%') then 
'lidercartel'
when ( vud.dvalue LIKE '%liderthelostmc%') then 
'liderthelostmc'
when ( vud.dvalue LIKE '%lidervanilla%') then 
'lidervanilla'
when ( vud.dvalue LIKE '%liderbahamas%') then 
'liderbahamas'
when ( vud.dvalue LIKE '%liderhells%') then 
'liderhells'
when ( vud.dvalue LIKE '%liderroxos%') then 
'liderroxos'
when ( vud.dvalue LIKE '%lidervagos%') then 
'lidervagos'
ELSE 
''
END as Lider
FROM vrp_user_identities vui,  vrp_user_data vud WHERE vui.user_id = vud.user_id AND vud.dkey = 'vRP:datatable' ;

-- Copiando estrutura para view vrp.vw_org_user
DROP VIEW IF EXISTS `vw_org_user`;
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `vw_org_user`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_org_user` AS select case when ( dvalue LIKE '%bloods%') then 
'bloods' 
when ( dvalue LIKE '%azuis%') then 
'azuis'
when ( dvalue LIKE '%mafia%') then 
'mafia' 
when ( dvalue LIKE '%verdes%') then 
'verdes' 
when ( dvalue LIKE '%bratva%') then 
'bratva' 
when ( dvalue LIKE '%cartel%') then 
'cartel' 
when ( dvalue LIKE '%helostmc%') then 
'thelostmc'	
when ( dvalue LIKE '%vanilla%') then 
'vanilla' 
when ( dvalue LIKE '%bahamas%') then 
'bahamas' 
when ( dvalue LIKE '%hells%') then 
'hells' 
when ( dvalue LIKE '%roxos%') then 
'roxos' 
when ( dvalue LIKE '%vagos%') then
 'vagos' 
 ELSE '' 
 END as NAME ,
 user_id
 FROM vrp_user_data vud 
 WHERE vud.dkey = 'vRP:datatable' ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
