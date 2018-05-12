-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Sam 12 Mai 2018 à 13:03
-- Version du serveur: 5.5.24-log
-- Version de PHP: 5.4.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `info`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `chiffreAge`(OUT p_min INT, OUT p_moy INT, OUT p_max INT)
BEGIN

SELECT MIN( age ) , AVG( age ) , MAX( age ) INTO p_min, p_moy, p_max
FROM utilisateur;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_temps_reponse_1`(IN num_personne INT)
BEGIN

SET @Temps_total = 
(SELECT timediff(temps_rep, temps_debut_utilisateur)
FROM reponse
JOIN appartient on appartient.id_reponse = reponse.id_reponse
JOIN jeux on jeux.id_questionnaire = appartient.id_questionnaire
WHERE appartient.id_personne = num_personne AND reponse.id_reponse in (SELECT MAX(id_reponse) FROM reponse));

UPDATE reponse SET Temps_prit_rep = @Temps_total
WHERE Temps_prit_rep IS null;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_temps_reponse_autre`(IN num_personne INT)
BEGIN

SET @Temps_before = 
(SELECT temps_rep
FROM reponse
WHERE id_reponse in (SELECT MAX(id_reponse) - 1 FROM reponse));

SET @Temps_inserer = 
(SELECT timediff(temps_rep,@Temps_before)
FROM reponse
JOIN appartient on appartient.id_reponse = reponse.id_reponse
JOIN jeux on jeux.id_questionnaire = appartient.id_questionnaire
WHERE appartient.id_personne = num_personne AND reponse.id_reponse in (SELECT MAX(id_reponse) FROM reponse));

UPDATE reponse SET Temps_prit_rep = @Temps_inserer
WHERE Temps_prit_rep IS null;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_temps_tot`(IN num_personne INT)
BEGIN

SET @temps_tot=(
SELECT timediff(temps_rep, temps_debut_utilisateur)
FROM reponse
JOIN appartient on appartient.id_reponse = reponse.id_reponse
JOIN jeux on jeux.id_questionnaire = appartient.id_questionnaire
WHERE appartient.id_personne = num_personne 
AND reponse.id_reponse in (SELECT MAX(id_reponse) FROM reponse));

UPDATE utilisateur SET temps_total = @temps_tot
WHERE utilisateur.id_personne = num_personne ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `moyNoteAge`(OUT p_1cat FLOAT, OUT p_2cat FLOAT, OUT p_3cat FLOAT, OUT p_4cat FLOAT, OUT p_5cat FLOAT, OUT p_6cat FLOAT)
BEGIN

SELECT AVG(reussite_nota) INTO p_1cat
FROM utilisateur
WHERE age BETWEEN 0 and 17;

SELECT AVG(reussite_nota) INTO p_2cat
FROM utilisateur
WHERE age between 18 and 25;

SELECT AVG(reussite_nota) INTO p_3cat
FROM utilisateur
WHERE age between 26 and 35;

SELECT AVG(reussite_nota) INTO p_4cat
FROM utilisateur
WHERE age between 36 and 50;

SELECT AVG(reussite_nota) INTO p_5cat
FROM utilisateur
WHERE age between 50 and 65;

SELECT AVG(reussite_nota) INTO p_6cat
FROM utilisateur
WHERE age > 65;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `moyReussiteChemin`( IN v_chemin INT)
BEGIN

SELECT AVG(reussite_nota)
FROM utilisateur
WHERE id_personne = ( SELECT u.id_personne
FROM utilisateur u
WHERE u.id_personne = utilisateur.id_personne 
AND u.id_personne %4 = v_chemin);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `moyReussiteNotaJauge`(IN affi_jauge INT)
BEGIN

SELECT AVG(reussite_nota)
FROM utilisateur
JOIN appartient on utilisateur.id_personne = appartient.id_personne
JOIN jeux on appartient.id_questionnaire = jeux.id_questionnaire
WHERE jauge = affi_jauge; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `moyReussiteSexe`( IN v_sexe VARCHAR(5))
BEGIN

SELECT sexe, AVG(reussite_nota)
FROM utilisateur
WHERE sexe = v_sexe;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nbPersParNote`()
BEGIN

SELECT DISTINCT reussite_nota, COUNT( reussite_nota ) 
FROM utilisateur
GROUP BY reussite_nota;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nbRegretQuestion`()
BEGIN

SELECT DISTINCT id_question, COUNT( regret ) 
FROM question
JOIN appartient on appartient.id_question = question.id_question
JOIN utilisateur on utilisateur.id_personne = utilisateur.id_personne
where id_question = regret
GROUP BY regret;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nbSexe`(IN p_sexe VARCHAR(5))
BEGIN

SELECT COUNT(id_personne)
FROM utilisateur
WHERE sexe = p_sexe;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nbUtilisateur`()
BEGIN

SELECT COUNT( id_personne ) 
FROM utilisateur;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nbUtilisateurCsp`(IN p_csp VARCHAR(20))
BEGIN

SELECT COUNT( csp ) 
FROM utilisateur
WHERE csp = p_csp;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nbUtilisateurParCsp`()
BEGIN

SELECT DISTINCT csp, COUNT( csp ) 
FROM utilisateur
GROUP BY csp;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reussiteChemin`()
BEGIN

SELECT categorie, reussite, COUNT(reussite)
FROM jeux
JOIN appartient on appartient.id_questionnaire = jeux.id_questionnaire
JOIN utilisateur on utilisateur.id_personne = appartient.id_personne
WHERE reussite != '0'
GROUP BY categorie, reussite;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reussiteJauge`()
BEGIN

SELECT jauge, reussite, COUNT(reussite)
FROM utilisateur
JOIN appartient on utilisateur.id_personne = appartient.id_personne
JOIN jeux on appartient.id_questionnaire = jeux.id_questionnaire
WHERE reussite != '0'
GROUP BY jauge, reussite;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reussiteSexe`()
BEGIN

SELECT sexe, reussite, COUNT(reussite)
FROM utilisateur
WHERE reussite != '0'
GROUP BY sexe, reussite;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `appartient`
--

CREATE TABLE IF NOT EXISTS `appartient` (
  `id_questionnaire` int(11) NOT NULL,
  `id_reponse` int(11) NOT NULL,
  `id_question` int(11) NOT NULL,
  `id_personne` int(11) NOT NULL,
  PRIMARY KEY (`id_questionnaire`,`id_reponse`,`id_question`,`id_personne`),
  KEY `FK_appartient_id_reponse` (`id_reponse`),
  KEY `FK_appartient_id_question` (`id_question`),
  KEY `FK_appartient_id_personne` (`id_personne`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `appartient`
--

INSERT INTO `appartient` (`id_questionnaire`, `id_reponse`, `id_question`, `id_personne`) VALUES
(322, 737, 2, 222),
(322, 738, 4, 222),
(322, 739, 6, 222),
(322, 740, 8, 222),
(322, 741, 9, 222),
(322, 742, 11, 222),
(322, 743, 13, 222),
(322, 744, 15, 222),
(323, 745, 1, 223),
(323, 746, 3, 223),
(323, 747, 5, 223),
(323, 748, 5, 223),
(323, 749, 10, 223),
(323, 750, 12, 223),
(323, 751, 14, 223),
(323, 752, 16, 223),
(324, 753, 1, 224),
(324, 754, 3, 224),
(324, 755, 5, 224),
(324, 756, 7, 224),
(324, 757, 9, 224),
(324, 758, 11, 224),
(324, 759, 13, 224),
(324, 760, 15, 224),
(325, 761, 2, 225),
(325, 762, 4, 225),
(325, 763, 6, 225),
(325, 764, 8, 225),
(325, 765, 10, 225),
(325, 766, 12, 225),
(325, 767, 14, 225),
(325, 768, 16, 225),
(326, 769, 2, 226),
(326, 770, 4, 226),
(326, 771, 6, 226),
(326, 772, 8, 226),
(326, 773, 9, 226),
(326, 774, 11, 226),
(326, 775, 13, 226),
(326, 776, 15, 226),
(327, 777, 1, 227),
(327, 778, 3, 227),
(327, 779, 5, 227),
(327, 780, 7, 227),
(327, 781, 10, 227),
(327, 782, 12, 227),
(327, 783, 14, 227),
(327, 784, 16, 227),
(328, 785, 1, 228),
(328, 786, 3, 228),
(328, 787, 5, 228),
(328, 788, 7, 228),
(328, 789, 9, 228),
(328, 790, 11, 228),
(328, 791, 13, 228),
(328, 792, 15, 228),
(329, 793, 2, 229),
(329, 794, 4, 229),
(329, 795, 6, 229),
(329, 796, 8, 229),
(329, 797, 10, 229),
(329, 798, 12, 229),
(329, 799, 14, 229),
(329, 800, 16, 229),
(330, 801, 2, 230),
(330, 802, 4, 230),
(330, 803, 6, 230),
(330, 804, 8, 230),
(330, 805, 9, 230),
(330, 806, 11, 230),
(330, 807, 13, 230),
(330, 808, 15, 230),
(331, 809, 1, 231),
(331, 810, 3, 231),
(331, 811, 5, 231),
(331, 812, 7, 231),
(331, 813, 10, 231),
(331, 814, 12, 231),
(331, 815, 14, 231),
(331, 816, 16, 231),
(332, 817, 1, 232),
(332, 818, 3, 232),
(332, 819, 5, 232),
(332, 820, 7, 232),
(332, 821, 9, 232),
(332, 822, 11, 232),
(332, 823, 13, 232),
(332, 824, 15, 232),
(333, 825, 2, 233),
(333, 826, 4, 233),
(333, 827, 6, 233),
(333, 828, 8, 233),
(333, 829, 10, 233),
(333, 830, 12, 233),
(333, 831, 14, 233),
(333, 832, 16, 233),
(334, 833, 2, 234),
(334, 834, 4, 234),
(334, 835, 6, 234),
(334, 836, 8, 234),
(334, 837, 9, 234),
(334, 838, 11, 234),
(334, 839, 13, 234),
(334, 840, 15, 234),
(335, 841, 1, 235),
(335, 842, 3, 235),
(335, 843, 5, 235),
(335, 844, 7, 235),
(335, 845, 10, 235),
(335, 846, 12, 235),
(335, 847, 14, 235),
(335, 848, 16, 235),
(336, 849, 1, 236),
(336, 850, 3, 236),
(336, 851, 5, 236),
(336, 852, 7, 236),
(336, 853, 9, 236),
(336, 854, 11, 236),
(336, 855, 13, 236),
(336, 856, 15, 236),
(337, 857, 2, 237),
(337, 858, 4, 237),
(337, 859, 6, 237),
(337, 860, 8, 237),
(337, 861, 10, 237),
(337, 862, 12, 237),
(337, 863, 14, 237),
(337, 864, 16, 237),
(338, 865, 2, 238),
(338, 866, 4, 238),
(338, 867, 6, 238),
(338, 868, 8, 238),
(338, 869, 9, 238),
(338, 870, 11, 238),
(338, 871, 13, 238),
(338, 872, 15, 238),
(339, 873, 1, 239),
(339, 874, 3, 239),
(339, 875, 5, 239),
(339, 876, 7, 239),
(339, 877, 10, 239),
(339, 878, 12, 239),
(339, 879, 14, 239),
(339, 880, 16, 239),
(340, 881, 1, 240),
(340, 882, 3, 240),
(340, 883, 5, 240),
(340, 884, 7, 240),
(340, 885, 9, 240),
(340, 886, 11, 240),
(340, 887, 13, 240),
(340, 888, 15, 240),
(341, 889, 2, 241),
(341, 890, 4, 241),
(341, 891, 6, 241),
(341, 892, 8, 241),
(341, 893, 10, 241),
(341, 894, 12, 241),
(341, 895, 14, 241),
(341, 896, 16, 241),
(342, 897, 2, 242),
(342, 898, 4, 242),
(342, 899, 6, 242),
(342, 900, 8, 242),
(342, 901, 9, 242),
(342, 902, 11, 242),
(342, 903, 13, 242),
(342, 904, 15, 242),
(343, 905, 1, 243),
(343, 906, 3, 243),
(343, 907, 5, 243),
(343, 908, 7, 243),
(343, 909, 10, 243),
(343, 910, 12, 243),
(343, 911, 14, 243),
(343, 912, 16, 243),
(344, 912, 1, 244),
(344, 912, 3, 244),
(344, 912, 5, 244),
(344, 912, 7, 244),
(344, 912, 9, 244),
(344, 912, 11, 244),
(344, 912, 13, 244),
(344, 912, 15, 244),
(345, 912, 2, 245),
(346, 912, 2, 246),
(346, 912, 4, 246),
(346, 912, 6, 246),
(346, 912, 8, 246),
(346, 912, 9, 246),
(346, 912, 11, 246),
(346, 912, 13, 246),
(346, 912, 15, 246),
(347, 912, 1, 247),
(347, 912, 3, 247),
(348, 932, 1, 248),
(348, 933, 3, 248),
(348, 934, 5, 248),
(348, 935, 7, 248),
(348, 936, 9, 248),
(348, 937, 11, 248),
(348, 938, 13, 248),
(348, 939, 15, 248),
(349, 940, 2, 249),
(349, 941, 4, 249),
(349, 942, 6, 249),
(349, 943, 8, 249),
(349, 944, 10, 249),
(349, 945, 12, 249),
(349, 946, 14, 249),
(349, 947, 16, 249),
(350, 948, 2, 249),
(350, 949, 4, 249),
(350, 950, 6, 249),
(350, 951, 8, 249),
(350, 952, 10, 249),
(350, 953, 12, 249),
(350, 954, 14, 249),
(350, 955, 16, 249),
(352, 956, 2, 249),
(352, 957, 4, 249),
(352, 958, 6, 249),
(352, 959, 8, 249),
(352, 960, 10, 249),
(352, 961, 12, 249),
(352, 962, 14, 249),
(352, 963, 16, 249),
(353, 964, 2, 249),
(353, 965, 4, 249),
(353, 966, 6, 249),
(353, 967, 8, 249),
(353, 968, 10, 249),
(353, 969, 12, 249),
(353, 970, 14, 249),
(353, 971, 16, 249),
(353, 972, 2, 254),
(353, 973, 4, 254),
(353, 974, 6, 254),
(353, 975, 8, 254),
(353, 976, 9, 254),
(353, 977, 11, 254),
(353, 978, 13, 254),
(353, 979, 15, 254),
(354, 980, 1, 255),
(354, 981, 3, 255),
(354, 982, 5, 255),
(354, 983, 7, 255),
(354, 984, 10, 255),
(354, 985, 12, 255),
(354, 986, 14, 255),
(354, 987, 16, 255),
(354, 988, 1, 256),
(354, 989, 3, 256),
(354, 990, 5, 256),
(354, 991, 7, 256),
(354, 992, 9, 256),
(354, 993, 11, 256),
(354, 994, 13, 256),
(354, 995, 15, 256),
(354, 996, 2, 257),
(354, 997, 4, 257),
(354, 998, 6, 257),
(354, 999, 8, 257),
(354, 1000, 10, 257),
(354, 1001, 12, 257),
(354, 1002, 14, 257),
(354, 1003, 16, 257),
(356, 1004, 2, 258),
(356, 1005, 4, 258),
(356, 1006, 6, 258),
(356, 1007, 8, 258),
(356, 1008, 9, 258),
(356, 1009, 11, 258),
(356, 1010, 13, 258),
(356, 1011, 15, 258),
(357, 1012, 1, 259),
(357, 1013, 3, 259),
(357, 1014, 5, 259),
(357, 1015, 7, 259),
(357, 1016, 10, 259),
(357, 1017, 12, 259),
(357, 1018, 14, 259),
(357, 1019, 16, 259),
(359, 1019, 2, 261),
(360, 1020, 2, 262),
(360, 1021, 4, 262),
(360, 1022, 6, 262),
(360, 1023, 8, 262),
(360, 1024, 9, 262),
(360, 1025, 11, 262),
(360, 1026, 13, 262),
(360, 1027, 15, 262),
(361, 1028, 1, 263),
(361, 1029, 3, 263),
(361, 1030, 5, 263),
(361, 1031, 7, 263),
(361, 1032, 10, 263),
(361, 1033, 12, 263),
(361, 1034, 14, 263),
(361, 1035, 16, 263),
(362, 1036, 1, 264),
(362, 1037, 3, 264),
(362, 1038, 5, 264),
(362, 1039, 7, 264),
(362, 1040, 9, 264),
(362, 1041, 11, 264),
(362, 1042, 13, 264),
(362, 1043, 15, 264),
(363, 1044, 2, 265),
(363, 1045, 4, 265),
(363, 1046, 6, 265),
(363, 1047, 8, 265),
(363, 1048, 10, 265),
(363, 1049, 12, 265),
(363, 1050, 14, 265),
(363, 1051, 16, 265),
(364, 1052, 2, 266),
(364, 1053, 4, 266),
(364, 1054, 6, 266),
(364, 1055, 8, 266),
(364, 1056, 9, 266),
(364, 1057, 11, 266),
(364, 1058, 13, 266),
(364, 1059, 15, 266),
(365, 1060, 1, 267),
(365, 1061, 3, 267),
(365, 1062, 5, 267),
(365, 1063, 7, 267),
(365, 1064, 10, 267),
(365, 1065, 12, 267),
(365, 1066, 14, 267),
(365, 1067, 16, 267);

--
-- Déclencheurs `appartient`
--
DROP TRIGGER IF EXISTS `insertion_temps_reponse`;
DELIMITER //
CREATE TRIGGER `insertion_temps_reponse` AFTER INSERT ON `appartient`
 FOR EACH ROW BEGIN

UPDATE reponse
SET Temps_rep = now()
where id_reponse = NEW.id_reponse;

END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `choix_question`
--

CREATE TABLE IF NOT EXISTS `choix_question` (
  `id_choix` int(11) NOT NULL AUTO_INCREMENT,
  `choix1` varchar(25) DEFAULT NULL,
  `choix2` varchar(25) DEFAULT NULL,
  `id_question` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_choix`),
  KEY `FK_choix_question_id_question` (`id_question`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

--
-- Contenu de la table `choix_question`
--

INSERT INTO `choix_question` (`id_choix`, `choix1`, `choix2`, `id_question`) VALUES
(1, 'Je reporte', 'Je reste', 1),
(2, 'Je partage', 'Je paye', 2),
(3, 'Mentir', 'Vérité', 3),
(4, 'Faire la bise', 'Serrer la main', 4),
(5, 'Vivre ensemble', 'Attendre un peu', 5),
(6, 'Jeter les posters', 'Imposer votre décoration', 6),
(7, 'Accepter', 'Refuser', 7),
(8, 'Accepter', 'Refuser', 8),
(9, 'Refuser de choisir', 'Choisir votre partenaire', 9),
(10, 'Demander ', 'Regarder sans demander', 10),
(11, 'Mutation', 'Licenciement', 11),
(12, 'Travailler au domicile', 'Continuer ainsi', 12),
(13, 'L''aîné', 'Le cadet', 13),
(14, 'Acceptez-vous', 'Refusez-vous', 14),
(15, 'Mariage religieu', 'Non religieu', 15),
(16, 'Mariage en intérieur', 'Mariage en extérieur', 16);

-- --------------------------------------------------------

--
-- Structure de la table `jeux`
--

CREATE TABLE IF NOT EXISTS `jeux` (
  `id_questionnaire` int(11) NOT NULL AUTO_INCREMENT,
  `categorie` int(11) DEFAULT NULL,
  `jauge` int(1) DEFAULT NULL,
  `temps_debut_utilisateur` datetime NOT NULL,
  PRIMARY KEY (`id_questionnaire`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=366 ;

--
-- Contenu de la table `jeux`
--

INSERT INTO `jeux` (`id_questionnaire`, `categorie`, `jauge`, `temps_debut_utilisateur`) VALUES
(320, 0, 1, '2018-05-12 13:30:24'),
(321, 0, 0, '2018-05-12 13:30:24'),
(322, 2, 1, '2018-05-12 13:30:24'),
(323, 3, 0, '2018-05-12 13:30:24'),
(324, 0, 1, '2018-05-12 13:30:24'),
(325, 1, 0, '2018-05-12 13:30:24'),
(326, 2, 1, '2018-05-12 13:30:24'),
(327, 3, 0, '2018-05-12 13:30:24'),
(328, 0, 1, '2018-05-12 13:30:24'),
(329, 1, 1, '2018-05-12 13:30:24'),
(330, 2, 0, '2018-05-12 13:30:24'),
(331, 3, 1, '2018-05-12 13:30:24'),
(332, 0, 1, '2018-05-12 13:30:24'),
(333, 1, 0, '2018-05-12 13:30:24'),
(334, 2, 1, '2018-05-12 13:30:24'),
(335, 3, 0, '2018-05-12 13:30:24'),
(336, 0, 0, '2018-05-12 13:30:24'),
(337, 1, 0, '2018-05-12 13:30:24'),
(338, 2, 1, '2018-05-12 13:30:24'),
(339, 3, 0, '2018-05-12 13:30:24'),
(340, 0, 0, '2018-05-12 13:30:24'),
(341, 1, 1, '2018-05-12 13:30:24'),
(342, 2, 0, '2018-05-12 13:30:24'),
(343, 3, 1, '2018-05-12 13:30:24'),
(344, 0, 1, '2018-05-12 13:30:24'),
(345, 1, 1, '2018-05-12 13:30:24'),
(346, 2, 0, '2018-05-12 13:30:24'),
(347, 3, 0, '2018-05-12 13:30:24'),
(348, 0, 0, '2018-05-12 13:30:24'),
(349, 1, 0, '2018-05-12 13:30:24'),
(350, 1, 1, '2018-05-12 13:30:24'),
(351, 1, 0, '2018-05-12 13:30:24'),
(352, 1, 0, '2018-05-12 13:30:24'),
(353, 1, 1, '2018-05-12 13:30:24'),
(354, 3, 1, '2018-05-12 13:30:24'),
(356, 2, 1, '2018-05-12 13:30:24'),
(357, 3, 0, '2018-05-12 13:30:24'),
(358, 0, 1, '2018-05-12 13:30:24'),
(359, 1, 1, '2018-05-12 13:30:24'),
(360, 2, 1, '2018-05-12 13:34:12'),
(361, 3, 0, '2018-05-12 13:47:53'),
(362, 0, 0, '2018-05-12 14:12:49'),
(363, 1, 0, '2018-05-12 14:17:16'),
(364, 2, 1, '2018-05-12 14:22:55'),
(365, 3, 0, '2018-05-12 14:27:17');

-- --------------------------------------------------------

--
-- Structure de la table `question`
--

CREATE TABLE IF NOT EXISTS `question` (
  `id_question` int(11) NOT NULL AUTO_INCREMENT,
  `texte` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id_question`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

--
-- Contenu de la table `question`
--

INSERT INTO `question` (`id_question`, `texte`) VALUES
(1, 'Durant votre premier rdv, votre patron vous appelle pour une urgence au bureau, reportez-vous le rendez-vous ?'),
(2, 'À la fin de votre premier rendez-vous le serveur apporte l''addition, que décidez-vous ?'),
(3, 'Durant la première rencontre avec la famille du conjoint autour d''un repas ses parents vous pose une question délicates: “dites moi combien de partenaire avez-vous eu avant de rencontrer notre enfants ? “ répondez-vous de manière honnête ou préférez vous mentir ?'),
(4, 'Vous rencontrez la famille de votre conjoint pour la première fois, optez vous pour serrer la main ou faire la bise ?'),
(5, 'Votre conjoint vous propose d''emménager ensemble, cependant elle a un des ses parents à charge, qui est dépendant physiquement. Acceptez-vous de vivre avec votre conjoint et donc son parent ou refusez vous ?'),
(6, 'Vous allez emménager avec votre conjoint, pendant que vous faites vos cartons vous réalisez que tous vos poster de Laurie que vous aviez acheté durant votre adolescence risque de mal passer dans le nouvel appartement, les jetez-vous ou imposez-vous votre décoration'),
(7, 'Au cours d’une discussion sur le fait de fonder une famille avec votre conjoint, ce dernier vous manifeste son intention de vouloir adopter un enfant handicapé dans un avenir proche, acceptez-vous ou non ?'),
(8, 'Votre conjoint veut donner à votre premier enfant le nom de Mao, même si c’est une fille, acceptez-vous ?'),
(9, 'Durant une violente dispute avec votre conjoint, il/elle vous reproche que votre meilleur(e) ami(e) est un obstacle à votre vie de couple et vous demande de faire un choix entre l’un des deux, que décidez-vous ?'),
(10, 'Votre conjoint envoie beaucoup de sms ces derniers jours sans que vous sachiez qui en est le destinataire. Lui demandez-vous ou regardez-vous son portable quand il/elle a le dos tourné ?'),
(11, 'Vous apprenez à votre travail qu’un plan social est en cours. Votre supérieur vous propose une mutation de 3 ans à l’autre bout du monde bien rémunéré, si vous dites non vous êtes licenciés. Que choisissez-vous devant votre conjoint ?'),
(12, 'Vous avez beaucoup de travail depuis le début de la semaine, afin de ne pas emmener du travail à votre domicile vous rentrez très tard, votre conjoint commence à se plaindre et en arrive à vous suspecter de voir quelqu''un d’autre. Que décidez-vous de faire ?'),
(13, 'Votre subissez un terrible accident de voiture avec vos 2 enfants et votre conjoint. Vos deux enfants sont dans un état critique et votre femme est inconsciente mais saine et sauve, vous devez pratiquer un massage cardiaque sur l’un de vos deux enfants, sachant pertinemment que pendant ce temps là l'),
(14, 'Votre partenaire est cloué(e) au lit en raison d’une vilaine grippe. Elle vous demande de modifier vos horaires de bureau pour aller chercher les enfants lorsque l’école est fini.'),
(15, 'Votre conjoint et vous allez vous marier, cependant une question importante reste en suspens. La famille de votre conjoint est très pieuse et serait extrêmement heureuse d’organiser une cérémonie religieuse, à l’inverse votre famille, totalement anti-religieuse serait très vexé à l’idée de participe'),
(16, 'Vous rêvez de vous marier en plein air. Cependant, les circonstances font que vous devrez vous marier à Lille en Novembre, le mariage risque donc d’être assez humide. Persévérez-vous dans votre idée ou décidez-vous de suivre l’idée de votre conjoint d’un mariage en intérieur ?');

-- --------------------------------------------------------

--
-- Structure de la table `question_difficile`
--

CREATE TABLE IF NOT EXISTS `question_difficile` (
  `id_q_d` varchar(25) NOT NULL,
  `id_question` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_q_d`),
  KEY `FK_question_difficile_id_question` (`id_question`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `question_difficile`
--

INSERT INTO `question_difficile` (`id_q_d`, `id_question`) VALUES
('Q1', 1),
('Q2', 3),
('Q3', 5),
('Q4', 7),
('Q5', 9),
('Q6', 11),
('Q7', 13),
('Q8', 15);

-- --------------------------------------------------------

--
-- Structure de la table `question_facile`
--

CREATE TABLE IF NOT EXISTS `question_facile` (
  `id_q_f` varchar(25) NOT NULL,
  `id_question` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_q_f`),
  KEY `FK_question_facile_id_question` (`id_question`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `question_facile`
--

INSERT INTO `question_facile` (`id_q_f`, `id_question`) VALUES
('Q1', 2),
('Q2', 4),
('Q3', 6),
('Q4', 8),
('Q5', 10),
('Q6', 12),
('Q7', 14),
('Q8', 16);

-- --------------------------------------------------------

--
-- Structure de la table `reponse`
--

CREATE TABLE IF NOT EXISTS `reponse` (
  `id_reponse` int(11) NOT NULL AUTO_INCREMENT,
  `reponse` varchar(25) DEFAULT NULL,
  `temps_rep` datetime NOT NULL,
  `Temps_prit_rep` time DEFAULT NULL,
  PRIMARY KEY (`id_reponse`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1068 ;

--
-- Contenu de la table `reponse`
--

INSERT INTO `reponse` (`id_reponse`, `reponse`, `temps_rep`, `Temps_prit_rep`) VALUES
(1, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(721, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(722, 'Mentir', '0000-00-00 00:00:00', '00:00:19'),
(723, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(724, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(725, 'Refuser de choisir', '0000-00-00 00:00:00', '00:00:19'),
(726, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(727, 'L''aîné', '0000-00-00 00:00:00', '00:00:19'),
(728, 'Mariage religieu', '0000-00-00 00:00:00', '00:00:19'),
(729, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(730, 'Mentir', '0000-00-00 00:00:00', '00:00:19'),
(731, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(732, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(733, 'Choisir votre partenaire', '0000-00-00 00:00:00', '00:00:19'),
(734, 'Licenciement', '0000-00-00 00:00:00', '00:00:19'),
(735, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(736, 'Non religieu', '0000-00-00 00:00:00', '00:00:19'),
(737, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(738, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(739, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(740, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(741, 'Refuser de choisir', '0000-00-00 00:00:00', '00:00:19'),
(742, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(743, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(744, 'Mariage religieu', '0000-00-00 00:00:00', '00:00:19'),
(745, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(746, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(747, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(748, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(749, 'Demander ', '0000-00-00 00:00:00', '00:00:19'),
(750, 'Continuer ainsi', '0000-00-00 00:00:00', '00:00:19'),
(751, 'Acceptez-vous', '0000-00-00 00:00:00', '00:00:19'),
(752, 'Mariage en extérieur', '0000-00-00 00:00:00', '00:00:19'),
(753, 'Je reporte', '0000-00-00 00:00:00', '00:00:19'),
(754, 'Mentir', '0000-00-00 00:00:00', '00:00:19'),
(755, 'Vivre ensemble', '0000-00-00 00:00:00', '00:00:19'),
(756, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(757, 'Choisir votre partenaire', '0000-00-00 00:00:00', '00:00:19'),
(758, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(759, 'L''aîné', '0000-00-00 00:00:00', '00:00:19'),
(760, 'Non religieu', '0000-00-00 00:00:00', '00:00:19'),
(761, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(762, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(763, 'Jeter les posters', '0000-00-00 00:00:00', '00:00:19'),
(764, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(765, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(766, 'Travailler au domicile', '0000-00-00 00:00:00', '00:00:19'),
(767, 'Refusez-vous', '0000-00-00 00:00:00', '00:00:19'),
(768, 'Mariage en extérieur', '0000-00-00 00:00:00', '00:00:19'),
(769, 'Je partage', '0000-00-00 00:00:00', '00:00:19'),
(770, 'Faire la bise', '0000-00-00 00:00:00', '00:00:19'),
(771, 'Jeter les posters', '0000-00-00 00:00:00', '00:00:19'),
(772, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(773, 'Refuser de choisir', '0000-00-00 00:00:00', '00:00:19'),
(774, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(775, 'L''aîné', '0000-00-00 00:00:00', '00:00:19'),
(776, 'Mariage religieu', '0000-00-00 00:00:00', '00:00:19'),
(777, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(778, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(779, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(780, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(781, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(782, 'Continuer ainsi', '0000-00-00 00:00:00', '00:00:19'),
(783, 'Refusez-vous', '0000-00-00 00:00:00', '00:00:19'),
(784, 'Mariage en extérieur', '0000-00-00 00:00:00', '00:00:19'),
(785, 'Je reporte', '0000-00-00 00:00:00', '00:00:19'),
(786, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(787, 'Vivre ensemble', '0000-00-00 00:00:00', '00:00:19'),
(788, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(789, 'Refuser de choisir', '0000-00-00 00:00:00', '00:00:19'),
(790, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(791, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(792, 'Mariage religieu', '0000-00-00 00:00:00', '00:00:19'),
(793, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(794, 'Faire la bise', '0000-00-00 00:00:00', '00:00:19'),
(795, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(796, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(797, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(798, 'Travailler au domicile', '0000-00-00 00:00:00', '00:00:19'),
(799, 'Refusez-vous', '0000-00-00 00:00:00', '00:00:19'),
(800, 'Mariage en intérieur', '0000-00-00 00:00:00', '00:00:19'),
(801, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(802, 'Faire la bise', '0000-00-00 00:00:00', '00:00:19'),
(803, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(804, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(805, 'Choisir votre partenaire', '0000-00-00 00:00:00', '00:00:19'),
(806, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(807, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(808, 'Non religieu', '0000-00-00 00:00:00', '00:00:19'),
(809, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(810, 'Mentir', '0000-00-00 00:00:00', '00:00:19'),
(811, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(812, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(813, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(814, 'Continuer ainsi', '0000-00-00 00:00:00', '00:00:19'),
(815, 'Acceptez-vous', '0000-00-00 00:00:00', '00:00:19'),
(816, 'Mariage en extérieur', '0000-00-00 00:00:00', '00:00:19'),
(817, 'Je reporte', '0000-00-00 00:00:00', '00:00:19'),
(818, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(819, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(820, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(821, 'Refuser de choisir', '0000-00-00 00:00:00', '00:00:19'),
(822, 'Licenciement', '0000-00-00 00:00:00', '00:00:19'),
(823, 'L''aîné', '0000-00-00 00:00:00', '00:00:19'),
(824, 'Mariage religieu', '0000-00-00 00:00:00', '00:00:19'),
(825, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(826, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(827, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(828, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(829, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(830, 'Travailler au domicile', '0000-00-00 00:00:00', '00:00:19'),
(831, 'Acceptez-vous', '0000-00-00 00:00:00', '00:00:19'),
(832, 'Mariage en intérieur', '0000-00-00 00:00:00', '00:00:19'),
(833, 'Je partage', '0000-00-00 00:00:00', '00:00:19'),
(834, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(835, 'Jeter les posters', '0000-00-00 00:00:00', '00:00:19'),
(836, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(837, 'Choisir votre partenaire', '0000-00-00 00:00:00', '00:00:19'),
(838, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(839, 'L''aîné', '0000-00-00 00:00:00', '00:00:19'),
(840, 'Non religieu', '0000-00-00 00:00:00', '00:00:19'),
(841, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(842, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(843, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(844, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(845, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(846, 'Travailler au domicile', '0000-00-00 00:00:00', '00:00:19'),
(847, 'Acceptez-vous', '0000-00-00 00:00:00', '00:00:19'),
(848, 'Mariage en extérieur', '0000-00-00 00:00:00', '00:00:19'),
(849, 'Je reporte', '0000-00-00 00:00:00', '00:00:19'),
(850, 'Mentir', '0000-00-00 00:00:00', '00:00:19'),
(851, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(852, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(853, 'Choisir votre partenaire', '0000-00-00 00:00:00', '00:00:19'),
(854, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(855, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(856, 'Mariage religieu', '0000-00-00 00:00:00', '00:00:19'),
(857, 'Je partage', '0000-00-00 00:00:00', '00:00:19'),
(858, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(859, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(860, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(861, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(862, 'Continuer ainsi', '0000-00-00 00:00:00', '00:00:19'),
(863, 'Refusez-vous', '0000-00-00 00:00:00', '00:00:19'),
(864, 'Mariage en intérieur', '0000-00-00 00:00:00', '00:00:19'),
(865, 'Je partage', '0000-00-00 00:00:00', '00:00:19'),
(866, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(867, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(868, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(869, 'Refuser de choisir', '0000-00-00 00:00:00', '00:00:19'),
(870, 'Mutation', '0000-00-00 00:00:00', '00:00:19'),
(871, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(872, 'Mariage religieu', '0000-00-00 00:00:00', '00:00:19'),
(873, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(874, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(875, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(876, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(877, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(878, 'Continuer ainsi', '0000-00-00 00:00:00', '00:00:19'),
(879, 'Refusez-vous', '0000-00-00 00:00:00', '00:00:19'),
(880, 'Mariage en intérieur', '0000-00-00 00:00:00', '00:00:19'),
(881, 'Je reporte', '0000-00-00 00:00:00', '00:00:19'),
(882, 'Mentir', '0000-00-00 00:00:00', '00:00:19'),
(883, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(884, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(885, 'Choisir votre partenaire', '0000-00-00 00:00:00', '00:00:19'),
(886, 'Licenciement', '0000-00-00 00:00:00', '00:00:19'),
(887, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(888, 'Non religieu', '0000-00-00 00:00:00', '00:00:19'),
(889, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(890, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(891, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(892, 'Accepter', '0000-00-00 00:00:00', '00:00:19'),
(893, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(894, 'Continuer ainsi', '0000-00-00 00:00:00', '00:00:19'),
(895, 'Acceptez-vous', '0000-00-00 00:00:00', '00:00:19'),
(896, 'Mariage en intérieur', '0000-00-00 00:00:00', '00:00:19'),
(897, 'Je paye', '0000-00-00 00:00:00', '00:00:19'),
(898, 'Serrer la main', '0000-00-00 00:00:00', '00:00:19'),
(899, 'Imposer votre décoration', '0000-00-00 00:00:00', '00:00:19'),
(900, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(901, 'Refuser de choisir', '0000-00-00 00:00:00', '00:00:19'),
(902, 'Licenciement', '0000-00-00 00:00:00', '00:00:19'),
(903, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(904, 'Non religieu', '0000-00-00 00:00:00', '00:00:19'),
(905, 'Je reste', '0000-00-00 00:00:00', '00:00:19'),
(906, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(907, 'Attendre un peu', '0000-00-00 00:00:00', '00:00:19'),
(908, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(909, 'Regarder sans demander', '0000-00-00 00:00:00', '00:00:19'),
(910, 'Continuer ainsi', '0000-00-00 00:00:00', '00:00:19'),
(911, 'Refusez-vous', '0000-00-00 00:00:00', '00:00:19'),
(912, 'Mariage en intérieur', '0000-00-00 00:00:00', '00:00:19'),
(932, 'Je reporte', '0000-00-00 00:00:00', '00:00:19'),
(933, 'Vérité', '0000-00-00 00:00:00', '00:00:19'),
(934, 'Vivre ensemble', '0000-00-00 00:00:00', '00:00:19'),
(935, 'Refuser', '0000-00-00 00:00:00', '00:00:19'),
(936, 'Choisir votre partenaire', '0000-00-00 00:00:00', '00:00:19'),
(937, 'Licenciement', '0000-00-00 00:00:00', '00:00:19'),
(938, 'Le cadet', '0000-00-00 00:00:00', '00:00:19'),
(939, 'Non religieu', '0000-00-00 00:00:00', '00:00:19'),
(940, 'Je partage', '2018-05-08 16:56:22', '00:00:19'),
(941, 'Serrer la main', '2018-05-08 16:56:28', '00:00:19'),
(942, 'Imposer votre décoration', '2018-05-08 16:56:36', '00:00:19'),
(943, 'Refuser', '2018-05-08 16:56:43', '00:00:19'),
(944, 'Regarder sans demander', '2018-05-08 16:56:50', '00:00:19'),
(945, 'Continuer ainsi', '2018-05-08 16:57:02', '00:00:19'),
(946, 'Acceptez-vous', '2018-05-08 16:57:09', '00:00:19'),
(947, 'Mariage en extérieur', '2018-05-08 16:57:18', '00:00:19'),
(948, 'Je paye', '2018-05-08 17:19:13', '00:00:19'),
(949, 'Serrer la main', '2018-05-08 17:20:21', '00:00:19'),
(950, 'Imposer votre décoration', '2018-05-08 17:20:42', '00:00:19'),
(951, 'Refuser', '2018-05-08 17:20:56', '00:00:19'),
(952, 'Regarder sans demander', '2018-05-08 17:21:02', '00:00:19'),
(953, 'Travailler au domicile', '2018-05-08 17:21:11', '00:00:19'),
(954, 'Refusez-vous', '2018-05-08 17:21:18', '00:00:19'),
(955, 'Mariage en extérieur', '2018-05-08 17:21:23', '00:00:19'),
(956, 'Je partage', '0000-00-00 00:00:00', '00:00:19'),
(957, 'Faire la bise', '2018-05-08 18:12:26', '00:00:19'),
(958, 'Jeter les posters', '2018-05-08 18:12:32', '00:00:19'),
(959, 'Accepter', '2018-05-08 18:12:37', '00:00:19'),
(960, 'Demander ', '2018-05-08 18:12:43', '00:00:19'),
(961, 'Continuer ainsi', '2018-05-08 18:12:50', '00:00:19'),
(962, 'Refusez-vous', '2018-05-08 18:12:57', '00:00:19'),
(963, 'Mariage en extérieur', '2018-05-08 18:13:04', '00:00:19'),
(964, 'Je paye', '2018-05-08 18:15:06', '00:00:19'),
(965, 'Faire la bise', '2018-05-08 18:15:11', '00:00:19'),
(966, 'Jeter les posters', '2018-05-08 18:15:17', '00:00:19'),
(967, 'Accepter', '2018-05-08 18:15:23', '00:00:19'),
(968, 'Regarder sans demander', '2018-05-08 18:15:29', '00:00:19'),
(969, 'Continuer ainsi', '2018-05-08 18:15:37', '00:00:19'),
(970, 'Refusez-vous', '2018-05-08 18:15:44', '00:00:19'),
(971, 'Mariage en extérieur', '2018-05-08 18:15:51', '00:00:19'),
(972, 'Je partage', '2018-05-08 18:24:51', '00:00:19'),
(973, 'Serrer la main', '2018-05-08 18:25:00', '00:00:19'),
(974, 'Imposer votre décoration', '2018-05-08 18:25:16', '00:00:19'),
(975, 'Accepter', '2018-05-08 18:25:22', '00:00:19'),
(976, 'Refuser de choisir', '2018-05-08 18:25:29', '00:00:19'),
(977, 'Licenciement', '2018-05-08 18:25:37', '00:00:19'),
(978, 'L''aîné', '2018-05-08 18:26:01', '00:00:19'),
(979, 'Mariage religieu', '2018-05-08 18:26:15', '00:00:19'),
(980, 'Je reste', '2018-05-09 10:03:10', '00:00:19'),
(981, 'Mentir', '2018-05-09 10:03:20', '00:00:19'),
(982, 'Attendre un peu', '2018-05-09 10:03:28', '00:00:19'),
(983, 'Refuser', '2018-05-09 10:03:37', '00:00:19'),
(984, 'Regarder sans demander', '2018-05-09 10:04:03', '00:00:19'),
(985, 'Continuer ainsi', '2018-05-09 10:04:11', '00:00:19'),
(986, 'Acceptez-vous', '2018-05-09 10:04:17', '00:00:19'),
(987, 'Mariage en intérieur', '2018-05-09 10:04:44', '00:00:19'),
(988, 'Je reporte', '2018-05-09 10:30:20', '00:00:19'),
(989, 'Mentir', '2018-05-09 10:30:25', '00:00:19'),
(990, 'Attendre un peu', '2018-05-09 10:30:31', '00:00:19'),
(991, 'Refuser', '2018-05-09 10:30:38', '00:00:19'),
(992, 'Choisir votre partenaire', '2018-05-09 10:30:47', '00:00:19'),
(993, 'Licenciement', '2018-05-09 10:30:54', '00:00:19'),
(994, 'Le cadet', '2018-05-09 10:31:02', '00:00:19'),
(995, 'Mariage religieu', '2018-05-09 10:31:23', '00:00:19'),
(996, 'Je paye', '2018-05-10 18:27:31', '00:00:19'),
(997, 'Serrer la main', '2018-05-10 18:28:15', '00:00:19'),
(998, 'Imposer votre décoration', '2018-05-10 18:28:24', '00:00:19'),
(999, 'Refuser', '2018-05-10 18:28:30', '00:00:19'),
(1000, 'Demander ', '2018-05-10 18:28:36', '00:00:19'),
(1001, 'Continuer ainsi', '2018-05-10 18:28:47', '00:00:19'),
(1002, 'Refusez-vous', '2018-05-10 18:29:15', '00:00:19'),
(1003, 'Mariage en extérieur', '2018-05-10 18:29:22', '00:00:19'),
(1004, 'Je paye', '2018-05-10 18:31:41', '00:00:19'),
(1005, 'Serrer la main', '2018-05-10 18:33:31', '00:00:19'),
(1006, 'Imposer votre décoration', '2018-05-10 18:33:38', '00:00:19'),
(1007, 'Accepter', '2018-05-10 18:34:42', '00:00:19'),
(1008, 'Choisir votre partenaire', '2018-05-10 18:34:49', '00:00:19'),
(1009, 'Licenciement', '2018-05-10 18:34:55', '00:00:19'),
(1010, 'L''aîné', '2018-05-10 18:37:25', '00:00:19'),
(1011, 'Non religieu', '2018-05-10 18:37:31', '00:00:19'),
(1012, 'Je reste', '2018-05-10 18:40:39', '00:00:19'),
(1013, 'Vérité', '2018-05-10 18:41:34', '00:00:19'),
(1014, 'Attendre un peu', '2018-05-10 18:41:40', '00:00:19'),
(1015, 'Accepter', '2018-05-10 18:41:53', '00:00:19'),
(1016, 'Regarder sans demander', '2018-05-10 18:42:00', '00:00:19'),
(1017, 'Continuer ainsi', '2018-05-10 18:42:25', '00:00:19'),
(1018, 'Acceptez-vous', '2018-05-10 18:42:31', '00:00:19'),
(1019, 'Mariage en extérieur', '2018-05-12 13:30:57', '00:00:19'),
(1020, 'Je partage', '2018-05-12 13:34:42', '00:00:19'),
(1021, 'Serrer la main', '2018-05-12 13:36:14', '00:00:19'),
(1022, 'Imposer votre décoration', '2018-05-12 13:36:41', '00:00:19'),
(1023, 'Refuser', '2018-05-12 13:37:09', '00:00:19'),
(1024, 'Choisir votre partenaire', '2018-05-12 13:38:00', '00:00:19'),
(1025, 'Licenciement', '2018-05-12 13:38:06', '00:00:19'),
(1026, 'Le cadet', '2018-05-12 13:38:12', '00:00:19'),
(1027, 'Non religieu', '2018-05-12 13:38:19', '00:00:19'),
(1028, 'Je reporte', '2018-05-12 13:48:12', '00:00:19'),
(1029, 'Mentir', '2018-05-12 13:48:41', '00:00:29'),
(1030, 'Attendre un peu', '2018-05-12 13:50:09', '00:01:28'),
(1031, 'Refuser', '2018-05-12 13:50:16', '00:00:07'),
(1032, 'Regarder sans demander', '2018-05-12 13:50:22', '00:00:06'),
(1033, 'Travailler au domicile', '2018-05-12 13:50:28', '00:00:06'),
(1034, 'Refusez-vous', '2018-05-12 13:50:34', '00:00:06'),
(1035, 'Mariage en extérieur', '2018-05-12 13:50:41', '00:00:07'),
(1036, 'Je reste', '2018-05-12 14:12:56', '00:00:07'),
(1037, 'Vérité', '2018-05-12 14:13:01', '00:00:05'),
(1038, 'Attendre un peu', '2018-05-12 14:13:08', '00:00:07'),
(1039, 'Refuser', '2018-05-12 14:13:14', '00:00:06'),
(1040, 'Refuser de choisir', '2018-05-12 14:13:19', '00:00:05'),
(1041, 'Licenciement', '2018-05-12 14:13:27', '00:00:08'),
(1042, 'L''aîné', '2018-05-12 14:13:34', '00:00:07'),
(1043, 'Mariage religieu', '2018-05-12 14:13:42', '00:00:08'),
(1044, 'Je partage', '2018-05-12 14:17:34', '00:03:52'),
(1045, 'Serrer la main', '2018-05-12 14:18:19', '00:00:45'),
(1046, 'Imposer votre décoration', '2018-05-12 14:18:26', '00:00:07'),
(1047, 'Accepter', '2018-05-12 14:18:38', '00:00:12'),
(1048, 'Demander ', '2018-05-12 14:18:46', '00:00:08'),
(1049, 'Continuer ainsi', '2018-05-12 14:19:04', '00:00:18'),
(1050, 'Acceptez-vous', '2018-05-12 14:19:13', '00:00:09'),
(1051, 'Mariage en extérieur', '2018-05-12 14:19:23', '00:00:10'),
(1052, 'Je partage', '2018-05-12 14:23:00', '00:03:37'),
(1053, 'Faire la bise', '2018-05-12 14:23:05', '00:00:05'),
(1054, 'Jeter les posters', '2018-05-12 14:23:10', '00:00:05'),
(1055, 'Accepter', '2018-05-12 14:23:16', '00:00:06'),
(1056, 'Refuser de choisir', '2018-05-12 14:23:21', '00:00:05'),
(1057, 'Licenciement', '2018-05-12 14:23:27', '00:00:06'),
(1058, 'L''aîné', '2018-05-12 14:23:32', '00:00:05'),
(1059, 'Mariage religieu', '2018-05-12 14:23:39', '00:00:07'),
(1060, 'Je reporte', '2018-05-12 14:27:23', '00:00:06'),
(1061, 'Mentir', '2018-05-12 14:28:03', '00:00:40'),
(1062, 'Attendre un peu', '2018-05-12 14:28:36', '00:00:33'),
(1063, 'Refuser', '2018-05-12 14:28:42', '00:00:06'),
(1064, 'Regarder sans demander', '2018-05-12 14:28:48', '00:00:06'),
(1065, 'Continuer ainsi', '2018-05-12 14:28:55', '00:00:07'),
(1066, 'Continuer ainsi', '2018-05-12 14:28:58', '00:00:03'),
(1067, 'Mariage en extérieur', '2018-05-12 14:29:05', '00:00:07');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE IF NOT EXISTS `utilisateur` (
  `id_personne` int(11) NOT NULL AUTO_INCREMENT,
  `sexe` varchar(25) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `situation_familliale` varchar(25) DEFAULT NULL,
  `csp` varchar(25) DEFAULT NULL,
  `csp_heure` int(11) DEFAULT NULL,
  `activite` varchar(100) DEFAULT NULL,
  `activite_heure` int(11) DEFAULT NULL,
  `heure_sommeil` int(11) DEFAULT NULL,
  `heure_famille` int(11) DEFAULT NULL,
  `regret` varchar(11) NOT NULL,
  `deci_diff` varchar(11) NOT NULL,
  `reussite` varchar(3) DEFAULT NULL,
  `reussite_nota` int(11) DEFAULT NULL,
  `nombre_enfants` int(11) DEFAULT NULL,
  `temps_total` time NOT NULL,
  PRIMARY KEY (`id_personne`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=268 ;

--
-- Contenu de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id_personne`, `sexe`, `age`, `situation_familliale`, `csp`, `csp_heure`, `activite`, `activite_heure`, `heure_sommeil`, `heure_famille`, `regret`, `deci_diff`, `reussite`, `reussite_nota`, `nombre_enfants`, `temps_total`) VALUES
(222, 'homme', 21, 'concubinage', 'cadre', 24, 'sport', 6, 8, 82, '1,2,5', '2,4,7', '0', 4, 0, '00:00:00'),
(223, 'femme', 30, 'concubinage', 'employe', 35, 'Manga', 9, 8, 68, '1,3,6,8', '1,3,7,8', '0', 10, 1, '00:00:00'),
(224, 'homme', 40, 'marrie', 'intermediaire', 32, 'livres', 12, 9, 61, '', '3,5', '0', 9, 3, '00:00:00'),
(225, 'femme', 50, 'divorce', 'cadre', 38, 'yoga', 6, 7, 75, '1,4,8', '2,5,8', '0', 8, 2, '00:00:00'),
(226, 'femme', 56, 'divorce', 'employe', 33, 'aucun', 0, 8, 79, '1,4,8', '1,7', '0', 7, 1, '00:00:00'),
(227, 'homme', 63, 'divorce', 'chomage', 0, 'sport, lecture, sculpture', 30, 9, 75, '2,3,6', '2,5,8', '0', 6, 3, '00:00:00'),
(228, 'homme', 18, 'celibataire', 'etudiant', 30, 'sport, soirée, tchill', 15, 10, 53, '1,3,4,6,8', '1,2,4,7', '0', 5, 0, '00:00:00'),
(229, 'femme', 15, 'marrie', 'etudiant', 29, 'danse, equitation', 12, 11, 50, '1,3,4,6,8', '1,4,5,8', '0', 3, 0, '00:00:00'),
(230, 'homme', 35, 'concubinage', 'autonome', 36, 'golf', 6, 9, 63, '2,3,6,7,8', '2,4,6,8', '0', 2, 2, '00:00:00'),
(231, 'femme', 46, 'marrie', 'intermediaire', 37, 'relaxation', 16, 8, 59, '1,2,3,4,5,6', '1,3,5,8', '0', 1, 0, '00:00:00'),
(232, 'homme', 29, 'divorce', 'etudiant', 35, 'jeux vidéo', 20, 9, 50, '2,4,6,8', '1,2,3,4,5,6', '0', 0, 1, '00:00:00'),
(233, 'homme', 37, 'marrie', 'cadre', 38, 'aucun', 0, 8, 74, '2,5,8', '1,7', '0', 7, 1, '00:00:00'),
(234, 'femme', 43, 'marrie', 'cadre', 35, 'yoga', 6, 8, 71, '2,4,5,8', '1,2,6,8', '0', 4, 2, '00:00:00'),
(235, 'homme', 51, 'celibataire', 'intermediaire', 34, 'serie, manga', 16, 9, 55, '2,5,8', '2,8', '0', 7, 2, '00:00:00'),
(236, 'homme', 47, 'marrie', 'agriculteur', 40, 'chasse, peche', 16, 9, 49, '2,5,7', '3,6,8', '0', 8, 3, '00:00:00'),
(237, 'homme', 39, 'concubinage', 'cadre', 36, 'aucun', 0, 9, 69, '1,3,5,8', '2,4,5,7', '0', 5, 1, '00:00:00'),
(238, 'homme', 28, 'concubinage', 'ouvrier', 32, 'sculpture, soudure', 10, 8, 70, '1,2,5,7', '1,2,4,5,8', '0', 2, 0, '00:00:00'),
(239, 'femme', 37, 'marrie', 'cadre', 29, 'jeux video', 6, 8, 77, '1,4,8', '3,5,7', 'Oui', 4, 1, '00:00:00'),
(240, 'femme', 48, 'divorce', 'cadre', 36, 'bourse', 6, 8, 70, '2,3,5,6', '1,2,3,4,5,6', 'Non', 2, 6, '00:00:00'),
(241, 'homme', 52, 'concubinage', 'employe', 29, 'khg', 2, 9, 74, '5', '4', 'Oui', 9, 2, '00:00:00'),
(242, 'homme', 25, 'concubinage', 'cadre', 36, 'golf', 6, 8, 70, '1,2,5,7,8', '2,3,4,6,8', 'Non', 3, 0, '00:00:00'),
(243, 'homme', 28, 'concubinage', 'cadre', 38, 'aucun', 0, 6, 88, '1,2,4,6,8', '2,3,4,6,8', 'Non', 1, 1, '00:00:00'),
(244, 'homme', 58, 'concubinage', 'employe', 35, 'paris', 6, 8, 71, '1,3,5,7', '1,3', 'Non', 6, 3, '00:00:00'),
(245, 'homme', 15, 'celibataire', 'etudiant', 25, 'rien', 0, 8, 87, '', '', NULL, NULL, 0, '00:00:00'),
(246, 'homme', 20, 'concubinage', 'etudiant', 26, 'fetard', 8, 8, 78, '1,3,6,8', '1,3,4', 'Oui', 6, 0, '00:00:00'),
(247, 'femme', 21, 'marrie', 'cadre', 26, 'manga', 15, 8, 71, '', '', NULL, NULL, 0, '00:00:00'),
(248, 'homme', 21, 'concubinage', 'etudiant', 26, 'hasard', 15, 8, 71, '3,7', '3,7', 'Oui', 8, 3, '00:00:00'),
(249, 'femme', 22, 'concubinage', 'etudiant', 26, 'tennis', 4, 8, 82, '2,5,6', '2,3,5,6', 'Non', 2, 0, '00:00:00'),
(254, 'femme', 64, 'concubinage', 'chomage', 0, 'scrable', 4, 0, 164, '', '', 'Oui', 10, 3, '00:00:00'),
(255, 'femme', 26, 'concubinage', 'employe', 32, 'rien', 0, 9, 73, '1', '1', 'Oui', 8, 0, '00:00:00'),
(256, 'homme', 44, 'concubinage', 'cadre', 36, 'sculpture', 4, 8, 72, '2,4,7', '2,5', 'Oui', 5, 2, '00:00:00'),
(257, 'femme', 62, 'divorce', 'cadre', 42, 'poterie', 6, 8, 64, '1,3,5,6,7,8', '1,2,3,7,8', 'Non', 4, 2, '00:00:00'),
(258, 'femme', 49, 'divorce', 'intermediaire', 34, 'chevaux', 3, 9, 68, '', '', 'Oui', 10, 1, '00:00:00'),
(259, 'homme', 35, 'marrie', 'intermediaire', 38, 'plein air', 8, 7, 73, '', '', 'Oui', 8, 1, '00:00:00'),
(260, 'homme', 22, 'celibataire', 'etudiant', 28, 'baseball', 15, 9, 62, '', '', NULL, NULL, 0, '00:00:00'),
(261, 'femme', 29, 'concubinage', 'cadre', 36, 'travaux manuelle', 6, 8, 70, '', '', NULL, NULL, 1, '00:00:00'),
(262, 'homme', 31, 'celibataire', 'agriculteur', 36, 'moto', 3, 9, 66, '2,4,5,7', '2,4,5,8', 'Non', 4, 0, '00:00:00'),
(263, 'femme', 32, 'concubinage', 'cadre', 32, 'couture', 2, 9, 71, '2,5,6,7', '2,4,5,7', 'Non', 4, 2, '00:00:00'),
(264, 'femme', 34, 'marrie', 'intermediaire', 37, 'soirée', 8, 8, 67, '2,6,8', '2,4,6,8', 'Oui', 6, 1, '00:00:53'),
(265, 'homme', 55, 'divorce', 'chomage', 0, 'nature', 20, 8, 92, '1,2,3,4', '4,6,7', 'Oui', 6, 2, '00:02:07'),
(266, 'femme', 38, 'divorce', 'intermediaire', 34, 'aucun', 0, 8, 78, '3,7', '2,6', 'Non', 2, 1, '00:00:44'),
(267, 'homme', 29, 'marrie', 'intermediaire', 34, 'yoga', 6, 8, 72, '2,4,6', '3,5,7', 'Non', 4, 1, '00:01:48');

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `appartient`
--
ALTER TABLE `appartient`
  ADD CONSTRAINT `FK_appartient_id_personne` FOREIGN KEY (`id_personne`) REFERENCES `utilisateur` (`id_personne`),
  ADD CONSTRAINT `FK_appartient_id_question` FOREIGN KEY (`id_question`) REFERENCES `question` (`id_question`),
  ADD CONSTRAINT `FK_appartient_id_questionnaire` FOREIGN KEY (`id_questionnaire`) REFERENCES `jeux` (`id_questionnaire`),
  ADD CONSTRAINT `FK_appartient_id_reponse` FOREIGN KEY (`id_reponse`) REFERENCES `reponse` (`id_reponse`);

--
-- Contraintes pour la table `choix_question`
--
ALTER TABLE `choix_question`
  ADD CONSTRAINT `FK_choix_question_id_question` FOREIGN KEY (`id_question`) REFERENCES `question` (`id_question`);

--
-- Contraintes pour la table `question_difficile`
--
ALTER TABLE `question_difficile`
  ADD CONSTRAINT `FK_question_difficile_id_question` FOREIGN KEY (`id_question`) REFERENCES `question` (`id_question`);

--
-- Contraintes pour la table `question_facile`
--
ALTER TABLE `question_facile`
  ADD CONSTRAINT `FK_question_facile_id_question` FOREIGN KEY (`id_question`) REFERENCES `question` (`id_question`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
