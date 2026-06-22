-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: rotagames
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `amicizia`
--

DROP TABLE IF EXISTS `amicizia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amicizia` (
  `id_utente1` int NOT NULL,
  `id_utente2` int NOT NULL,
  `data_amicizia` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_utente1`,`id_utente2`),
  KEY `id_utente2` (`id_utente2`),
  CONSTRAINT `amicizia_ibfk_1` FOREIGN KEY (`id_utente1`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `amicizia_ibfk_2` FOREIGN KEY (`id_utente2`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amicizia`
--

LOCK TABLES `amicizia` WRITE;
/*!40000 ALTER TABLE `amicizia` DISABLE KEYS */;
INSERT INTO `amicizia` VALUES (3,1,'2026-06-21 18:27:24');
/*!40000 ALTER TABLE `amicizia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composizione`
--

DROP TABLE IF EXISTS `composizione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `composizione` (
  `id_ordine` int NOT NULL,
  `id_videogioco` int NOT NULL,
  `prezzo_acquisto` decimal(10,2) NOT NULL,
  `product_key` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_ordine`,`id_videogioco`),
  KEY `id_videogioco` (`id_videogioco`),
  CONSTRAINT `composizione_ibfk_1` FOREIGN KEY (`id_ordine`) REFERENCES `ordine` (`id_ordine`) ON DELETE CASCADE,
  CONSTRAINT `composizione_ibfk_2` FOREIGN KEY (`id_videogioco`) REFERENCES `videogioco` (`id_videogioco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composizione`
--

LOCK TABLES `composizione` WRITE;
/*!40000 ALTER TABLE `composizione` DISABLE KEYS */;
INSERT INTO `composizione` VALUES (1,1,62.99,'ROTA-P3R-1234-ABCD');
/*!40000 ALTER TABLE `composizione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `decorazione`
--

DROP TABLE IF EXISTS `decorazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `decorazione` (
  `id_decorazione` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `costo_rotelline` int NOT NULL,
  `url_risorsa` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_decorazione`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decorazione`
--

LOCK TABLES `decorazione` WRITE;
/*!40000 ALTER TABLE `decorazione` DISABLE KEYS */;
INSERT INTO `decorazione` VALUES (1,'Sfondo Oceano Abissale','Sfondo',300,'/assets/decorations/sfondo_oceano.jpg'),(2,'Cornice Pop/Noir','Cornice Avatar',150,'/assets/decorations/cornice_noir.png');
/*!40000 ALTER TABLE `decorazione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elemento_ruota`
--

DROP TABLE IF EXISTS `elemento_ruota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elemento_ruota` (
  `id_elemento` int NOT NULL AUTO_INCREMENT,
  `nome_premio` varchar(100) NOT NULL,
  `probabilita` decimal(5,2) NOT NULL,
  `valore_premio` int NOT NULL,
  PRIMARY KEY (`id_elemento`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elemento_ruota`
--

LOCK TABLES `elemento_ruota` WRITE;
/*!40000 ALTER TABLE `elemento_ruota` DISABLE KEYS */;
INSERT INTO `elemento_ruota` VALUES (1,'Premio Minore',60.00,10),(2,'Premio Medio',30.00,50),(3,'Jackpot Rotelle',10.00,500);
/*!40000 ALTER TABLE `elemento_ruota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genere`
--

DROP TABLE IF EXISTS `genere`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genere` (
  `nome_genere` varchar(50) NOT NULL,
  `descrizione_genere` text,
  PRIMARY KEY (`nome_genere`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genere`
--

LOCK TABLES `genere` WRITE;
/*!40000 ALTER TABLE `genere` DISABLE KEYS */;
INSERT INTO `genere` VALUES ('Azione','Combattimenti frenetici e riflessi pronti.'),('JRPG','Giochi di ruolo di stampo giapponese, con enfasi su trama e stile.'),('Metroidvania','Esplorazione non lineare con acquisizione progressiva di abilità.');
/*!40000 ALTER TABLE `genere` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gestione_catalogo`
--

DROP TABLE IF EXISTS `gestione_catalogo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gestione_catalogo` (
  `id_amministratore` int NOT NULL,
  `id_videogioco` int NOT NULL,
  `azione_eseguita` varchar(255) NOT NULL,
  `data_azione` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_amministratore`,`id_videogioco`,`data_azione`),
  KEY `id_videogioco` (`id_videogioco`),
  CONSTRAINT `gestione_catalogo_ibfk_1` FOREIGN KEY (`id_amministratore`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `gestione_catalogo_ibfk_2` FOREIGN KEY (`id_videogioco`) REFERENCES `videogioco` (`id_videogioco`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gestione_catalogo`
--

LOCK TABLES `gestione_catalogo` WRITE;
/*!40000 ALTER TABLE `gestione_catalogo` DISABLE KEYS */;
INSERT INTO `gestione_catalogo` VALUES (1,1,'Approvazione titolo e inserimento nel catalogo principale','2026-06-21 18:27:24');
/*!40000 ALTER TABLE `gestione_catalogo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `immagine`
--

DROP TABLE IF EXISTS `immagine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `immagine` (
  `id_immagine` int NOT NULL AUTO_INCREMENT,
  `url_risorsa` varchar(500) NOT NULL,
  `id_videogioco` int DEFAULT NULL,
  PRIMARY KEY (`id_immagine`),
  KEY `id_videogioco` (`id_videogioco`),
  CONSTRAINT `immagine_ibfk_1` FOREIGN KEY (`id_videogioco`) REFERENCES `videogioco` (`id_videogioco`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `immagine`
--

LOCK TABLES `immagine` WRITE;
/*!40000 ALTER TABLE `immagine` DISABLE KEYS */;
INSERT INTO `immagine` VALUES (1,'/assets/img/p3r_cover.jpg',1),(2,'/assets/img/p3r_gameplay.jpg',1),(3,'/assets/img/hk_cover.jpg',2);
/*!40000 ALTER TABLE `immagine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario_decorazioni`
--

DROP TABLE IF EXISTS `inventario_decorazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario_decorazioni` (
  `id_utente` int NOT NULL,
  `id_decorazione` int NOT NULL,
  `equipaggiata` tinyint(1) DEFAULT '0',
  `data_acquisto` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_utente`,`id_decorazione`),
  KEY `id_decorazione` (`id_decorazione`),
  CONSTRAINT `inventario_decorazioni_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `inventario_decorazioni_ibfk_2` FOREIGN KEY (`id_decorazione`) REFERENCES `decorazione` (`id_decorazione`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario_decorazioni`
--

LOCK TABLES `inventario_decorazioni` WRITE;
/*!40000 ALTER TABLE `inventario_decorazioni` DISABLE KEYS */;
INSERT INTO `inventario_decorazioni` VALUES (1,1,1,'2026-06-21 18:27:24');
/*!40000 ALTER TABLE `inventario_decorazioni` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `libreria`
--

DROP TABLE IF EXISTS `libreria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `libreria` (
  `id_utente` int NOT NULL,
  `id_videogioco` int NOT NULL,
  `stato_avanzamento` enum('DA_GIOCARE','IN_CORSO','COMPLETATO','ABBANDONATO') DEFAULT 'DA_GIOCARE',
  `product_key_posseduta` varchar(100) DEFAULT NULL,
  `data_aggiunta` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_utente`,`id_videogioco`),
  KEY `id_videogioco` (`id_videogioco`),
  CONSTRAINT `libreria_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `libreria_ibfk_2` FOREIGN KEY (`id_videogioco`) REFERENCES `videogioco` (`id_videogioco`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libreria`
--

LOCK TABLES `libreria` WRITE;
/*!40000 ALTER TABLE `libreria` DISABLE KEYS */;
INSERT INTO `libreria` VALUES (3,1,'IN_CORSO','ROTA-P3R-1234-ABCD','2026-06-21 18:27:24');
/*!40000 ALTER TABLE `libreria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordine`
--

DROP TABLE IF EXISTS `ordine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine` (
  `id_ordine` int NOT NULL AUTO_INCREMENT,
  `data_acquisto` datetime DEFAULT CURRENT_TIMESTAMP,
  `totale_ordine` decimal(10,2) NOT NULL,
  `url_fattura` varchar(500) DEFAULT NULL,
  `id_utente` int DEFAULT NULL,
  PRIMARY KEY (`id_ordine`),
  KEY `id_utente` (`id_utente`),
  CONSTRAINT `ordine_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordine`
--

LOCK TABLES `ordine` WRITE;
/*!40000 ALTER TABLE `ordine` DISABLE KEYS */;
INSERT INTO `ordine` VALUES (1,'2026-06-21 18:27:24',62.99,'/fatture/inv_0001.pdf',3);
/*!40000 ALTER TABLE `ordine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recensione`
--

DROP TABLE IF EXISTS `recensione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recensione` (
  `id_recensione` int NOT NULL AUTO_INCREMENT,
  `testo` text,
  `valutazione` int DEFAULT NULL,
  `ore_giocate_dichiarate` decimal(8,1) DEFAULT NULL,
  `raccomandato` tinyint(1) DEFAULT NULL,
  `data_pubblicazione` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_utente` int DEFAULT NULL,
  `id_videogioco` int DEFAULT NULL,
  PRIMARY KEY (`id_recensione`),
  KEY `id_utente` (`id_utente`),
  KEY `id_videogioco` (`id_videogioco`),
  CONSTRAINT `recensione_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `recensione_ibfk_2` FOREIGN KEY (`id_videogioco`) REFERENCES `videogioco` (`id_videogioco`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recensione`
--

LOCK TABLES `recensione` WRITE;
/*!40000 ALTER TABLE `recensione` DISABLE KEYS */;
INSERT INTO `recensione` VALUES (1,'Stile grafico incredibile, menu fluidissimi!',5,35.5,1,'2026-06-21 18:27:24',3,1);
/*!40000 ALTER TABLE `recensione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente` (
  `id_utente` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `cognome` varchar(100) DEFAULT NULL,
  `via` varchar(255) DEFAULT NULL,
  `cap` varchar(10) DEFAULT NULL,
  `citta` varchar(100) DEFAULT NULL,
  `ruolo` enum('GUEST','REGISTRATO','AMMINISTRATORE','SVILUPPATORE') DEFAULT 'GUEST',
  `nickname` varchar(50) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `saldo_rotelline` int DEFAULT '0',
  `data_ultimo_giro_ruota` date DEFAULT NULL,
  `genere_preferito` varchar(50) DEFAULT NULL,
  `nome_studio_sviluppo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_utente`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'gabriele@rotagames.it','Gabriele Karol','Vicinanza',NULL,NULL,NULL,'AMMINISTRATORE','GabboAdmin','4a8f80d84f37e0ff32b8893d65ab1288d48b552adff2f9817c28c9786f0a4a4028ae27b187e766fccc7bec12e13a9fd9ac8e926c8db882e775dd02a57dc3ceda',1500,NULL,NULL,NULL),(2,'pietro@rotagames.it','Pietro','Senatore',NULL,NULL,NULL,'SVILUPPATORE','PieDev','5c6034da1b7f10a82275a5467974020a3f6f80a67ca6401dd12e3604fc2b5e6bb22073328f7883e77604d06a1cd9118e406c56a441000c4a977f80156c8e18b1',500,NULL,NULL,'Senatore Studios'),(3,'giuseppe@rotagames.it','Giuseppe','Sarlo',NULL,NULL,NULL,'REGISTRATO','GiusyGamer','bbbb0dd6aa5653ee4df33910f3bb0e6be93b5d77403f3bd2eefdc0000c8e5c6a35b304b875a37fe9b6373bd416b4452abeda95cbfeeb9a2edf187ca1888ea4af',250,NULL,NULL,NULL);
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videogioco`
--

DROP TABLE IF EXISTS `videogioco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `videogioco` (
  `id_videogioco` int NOT NULL AUTO_INCREMENT,
  `titolo` varchar(255) NOT NULL,
  `descrizione` text,
  `prezzo_base` decimal(10,2) NOT NULL,
  `sconto_attivo` int DEFAULT '0',
  `piattaforma` varchar(100) DEFAULT NULL,
  `requisiti_sistema` text,
  `stato_approvazione` enum('IN_ATTESA','APPROVATO','RIFIUTATO') DEFAULT 'IN_ATTESA',
  `id_sviluppatore` int DEFAULT NULL,
  `copertina` mediumblob,
  PRIMARY KEY (`id_videogioco`),
  KEY `id_sviluppatore` (`id_sviluppatore`),
  CONSTRAINT `videogioco_ibfk_1` FOREIGN KEY (`id_sviluppatore`) REFERENCES `utente` (`id_utente`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videogioco`
--

LOCK TABLES `videogioco` WRITE;
/*!40000 ALTER TABLE `videogioco` DISABLE KEYS */;
INSERT INTO `videogioco` VALUES (1,'Persona 3 Reload','Rivivi l\'Ora Buia in questo remake spettacolare dal forte stile pop.',69.99,10,'PC, PS5','Minimi: 8GB RAM','APPROVATO',NULL,NULL),(2,'Hollow Knight','Avventurati nelle profondità di Nidosacro.',14.99,0,'PC, Switch','Minimi: 4GB RAM','APPROVATO',NULL,NULL),(3,'Rota Avventura','Un nuovo entusiasmante progetto in sviluppo.',19.99,0,'PC','TBA','IN_ATTESA',2,NULL);
/*!40000 ALTER TABLE `videogioco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videogioco_genere`
--

DROP TABLE IF EXISTS `videogioco_genere`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `videogioco_genere` (
  `id_videogioco` int NOT NULL,
  `nome_genere` varchar(50) NOT NULL,
  PRIMARY KEY (`id_videogioco`,`nome_genere`),
  KEY `nome_genere` (`nome_genere`),
  CONSTRAINT `videogioco_genere_ibfk_1` FOREIGN KEY (`id_videogioco`) REFERENCES `videogioco` (`id_videogioco`) ON DELETE CASCADE,
  CONSTRAINT `videogioco_genere_ibfk_2` FOREIGN KEY (`nome_genere`) REFERENCES `genere` (`nome_genere`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videogioco_genere`
--

LOCK TABLES `videogioco_genere` WRITE;
/*!40000 ALTER TABLE `videogioco_genere` DISABLE KEYS */;
INSERT INTO `videogioco_genere` VALUES (2,'Azione'),(3,'Azione'),(1,'JRPG'),(2,'Metroidvania');
/*!40000 ALTER TABLE `videogioco_genere` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id_utente` int NOT NULL,
  `id_videogioco` int NOT NULL,
  `data_aggiunta` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_utente`,`id_videogioco`),
  KEY `id_videogioco` (`id_videogioco`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`id_videogioco`) REFERENCES `videogioco` (`id_videogioco`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (3,2,'2026-06-21 18:27:24');
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-22 16:17:53
