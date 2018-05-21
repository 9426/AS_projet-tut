<?php

require("secu.php");
?>
<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta charset="utf-8">
		<title>Emotions et Decisions</title>
		<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
		<link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.blue_grey-blue.min.css" />
		<script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>
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
		<p>Accès aux stats du jeu </p>
		<p>Mot de passe administrateur :</p>

	 <form action="page_accueil.php" method="post">

			 <p>

			 <input type="password" name="password" />

			 <input type="submit" value="Valider" />

			 </p>

	 </form>
<?php

	 $password = secu::identification($_POST['password']);


	if ($password ==  true){
	 header('location:./stats.php');
	}
	else{
	   echo "Mot de passe incorrect!";

	 }

	 ?>
		<div class="name">
			<p>AXEL BOISSON - THOMAS FOCH - YANN LEMAIRE -  PAUL MOTTIN</p>
		</div>
	</body>
</html>
