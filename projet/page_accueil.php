<?php

require("secu.php");
?>
<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta charset="utf-8">
		<title>Emotions et Decisions</title>
		<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
		<link rel="stylesheet" type="text/css" href="style/material-design-lite.css"/> 
		<script type="text/javascript" src="js/material-design-lite.js"></script>
		<link rel="stylesheet" href="style/styles.css"/>
	</head>

	<body>
		<div id="header">
			<h1>Projet de fin d'étude DUT Informatique AS</h1>
			<div class="title">
				<p>Dans le cadre de nos études à l'IUT de Montpellier-Sète, pour notre second semestre en année spéciale il nous ait
				demandé de réaliser un projet.<br>
				Nous allons donc vous faire passer un test qui se déroulera en 3 étapes :
					<li>Un questionnaire personnel</li>
					<li>Une série de questions/réponses</li>
					<li>Un questionnaire de fin sur votre ressenti</li>
			</p>
			<p>Nous vous remercions donc de participer à notre projet</p>
			</div>
		</div>
		
		
		<div class="button_accueil">
			<form name="frm" action="./question_debut.html" method="post">
				<input class="mdl-button mdl-button--raised mdl-button--colored" type="submit" value="Commencer">
			</form>
		</div>
		<div class="name">
			<p>AXEL BOISSON - THOMAS FOCH - YANN LEMAIRE -  PAUL MOTTIN</p>
		</div>
		
		<div class="admin">
			<p align="center" >Accès aux administrateurs du jeu </p>
			 <form action="page_accueil.php" method="post">
				 <p>
					 <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label" id="password">
						<input class="mdl-textfield__input" type="password" name="password"/>
						<label class="mdl-textfield__label" for="password">Uniquement pour les administrateurs</label>
					</div>
					<br>
					 <center><input class="mdl-button mdl-button--raised mdl-button--colored" type="submit" value="Valider"/></center>
				 </p>
			 </form>
			 
			 <?php
			/*
			$password = 1;
			$password = secu::identification($_POST['password']);


			if ($password ==  true){
				header('location:./stats.php');
			}
			if ($password == 1){
				
			} 
			if ($password ==  false){
				echo "<p align=\"center\">Mot de passe incorrect !</p>";
			 }

		*/ ?>
			 
		</div>	
		
		
		
	</body>
</html>
