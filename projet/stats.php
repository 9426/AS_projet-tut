<!DOCTYPE html>
<!-- Attention il faut remplacer tout les requetes $sql..Faux ou autre variable contenant FAUX. Ce sont juste des moyens de s'en sortir degeulasse-->
<html lang="fr">
	<head>
		<meta charset="utf-8">
		<title>Emotions et Decisions</title>
		<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
		<link rel="stylesheet" type="text/css" href="style/material-design-lite.css"/> 
		<script type="text/javascript" src="js/material-design-lite.js"></script>
		<link rel="stylesheet" href="style/styles.css"/>
		<script src="anychart/js/anychart.min.js" type="text/javascript"></script>
	</head>

	<body>
		<div id="header">
			<div class="title">
				<u>
					<h1 align="center">Analyse des statistiques</h1>			
				</u>
			</div>
		</div>
		<?php
		require ("config.php");

		try {
			$bdd = new PDO($_SGBD["nsd"], $_SGBD["username"], $_SGBD["password"]);
		} catch(PDOException $e) {
			die("Erreur : " . $e -> getMessage());
		}

		$nbpers = $bdd -> query("SELECT COUNT(id_personne) FROM utilisateur");
		$nb = $nbpers -> fetchColumn();

		$ageMoyen = $bdd -> query("SELECT ROUND(AVG(age)) FROM utilisateur");
		$ageMoy = $ageMoyen -> fetchColumn();
		
		$reussiteMoyen = $bdd -> query("SELECT AVG(reussite_nota) FROM utilisateur");
		$reussiteMoy = $reussiteMoyen -> fetchColumn();
		
		$tempsMoyen =$bdd -> query("SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(Temps_total_format_date))) FROM utilisateur;");
		$tempsMoy = $tempsMoyen -> fetchColumn();

		echo("<center><p>Il y a " . $nb . " personnes qui ont effectué notre test. </p>");
		echo("<p>L'âge moyen des testeurs est de ".$ageMoy. " ans. </p>");
		echo("<p>La reussite moyenne des testeurs est de ".$reussiteMoy. "</p>");
		echo("<p>Le temps moyen pour effectuer le test est de $tempsMoy minutes.</p></center>");

		?>

		<script type="text/javascript">
			anychart.onDocumentReady(function() {
				<?php
					$sql="SELECT COUNT(id_personne) FROM utilisateur WHERE sexe = 'femme'";
					$res = $bdd->query($sql);
					$nbSexeF = $res -> fetchColumn();
					$nbSexeH = $nb - $nbSexeF;
					$tab = array(['HOMME',$nbSexeH],['FEMME',$nbSexeF]);  					// création du tableau PHP

					print('var t='.json_encode($tab)); 		// encodage au format JSON et passage au javascript
?>
				// create pie chart with passed data
				chart = anychart.pie(t);

				// set container id for the chart
				chart.container('RepartitionHF');

				// set chart title text settings
				chart.title('Repartition HOMME - FEMME');

				// set legend title text settings
				chart.legend(true);
				chart.legend().title('Sexe ');
				chart.legend().title().padding([0, 0, 10, 0]);

				// set legend position and items layout
				chart.legend().position('bottom');
				chart.legend().itemsLayout('horizontal');
				chart.legend().align('center');

				// initiate chart drawing
				chart.draw();
			});
		</script>


		<div id="RepartitionHF"></div>
		<style>
         #RepartitionHF {
             width: auto;
             height: 50%;
             margin: 0;
             padding: 0;
         }
        </style>
		</br>
		 <script type="text/javascript">
         anychart.onDocumentReady(function() {

                  	         	<?php
	$sql='CALL nbPersParNote';
	$res = $bdd->query($sql);
	$tab = array(); // création du tableau PHP
   	 while($lg=$res->fetchObject()){
	$tab[]=[$lg ->reussite_nota, $lg -> NbPers]; // alimentation du tableau php avec les données de la requête
   	 }
	print('var t='.json_encode($tab)); 		// encodage au format JSON et passage au javascript
	?>

  // create bar chart
  chart = anychart.bar();

  // turn on chart animation
  chart.animation(true);

  // set container id for the chart
  chart.container('PersParNote');
  chart.padding([10,10,5,5]);

  // set chart title text settings
  chart.title('Nombre de personne par note');

  // create area series with passed data
  var series = chart.bar(t);
  // set tooltip formatter
  series.tooltip().titleFormatter(function(){return "Notes : " + this.x});
  series.tooltip().textFormatter(function () {
      return parseInt(this.value).toLocaleString() +' Personne(s)' ;
  });
  series.tooltip().position('right').anchor('left').offsetX(5).offsetY(0);

  // set yAxis labels formatter
  chart.yAxis().labels().textFormatter(function(){
      return this.value.toLocaleString();
    });

  // set titles for axises
  chart.xAxis().title('Notes');
  chart.yAxis().title('Nombre Personne');
  chart.interactivity().hoverMode('byX');
  chart.tooltip().positionMode('point');
  // set scale minimum
  chart.yScale().minimum(0);

  // initiate chart drawing
  chart.draw();
});

        </script>
		<div id="PersParNote"></div>
		<style>
         #PersParNote {
             width: auto;
             height: 50%;
             margin: 0;
             padding: 0;
         }
        </style>

				 <script type="text/javascript">
         anychart.onDocumentReady(function() {

                  	         	<?php
	$sql='CALL moyReussiteSexe';
	$res = $bdd->query($sql);
	$tab = array(); // création du tableau PHP
   	 while($lg=$res->fetchObject()){
	$tab[]=[$lg ->sexe, $lg -> moyenne]; // alimentation du tableau php avec les données de la requête
   	 }
	print('var t='.json_encode($tab)); 		// encodage au format JSON et passage au javascript
	?>

  // create bar chart
  chart = anychart.bar();

  // turn on chart animation
  chart.animation(true);

  // set container id for the chart
  chart.container('moyReussiteSexe');
  chart.padding([10,10,5,5]);

  // set chart title text settings
  chart.title('Note moyenne de reussite par sexe');

  // create area series with passed data
  var series = chart.bar(t);
  // set tooltip formatter
  series.tooltip().titleFormatter(function(){return this.x});
  series.tooltip().textFormatter(function () {
      return 'Moyenne : ' + this.value.toLocaleString();
  });
  series.tooltip().position('right').anchor('left').offsetX(5).offsetY(0);

  // set yAxis labels formatter
  chart.yAxis().labels().textFormatter(function(){
      return this.value.toLocaleString();
    });

  // set titles for axises
  chart.xAxis().title('Sexe');
  chart.yAxis().title('Moyenne');
  chart.interactivity().hoverMode('byX');
  chart.tooltip().positionMode('point');
  // set scale minimum
  chart.yScale().minimum(0);
  chart.yScale().maximum(10);

  // initiate chart drawing
  chart.draw();
});

        </script>

		<div id="moyReussiteSexe"></div>
		<style>
         #moyReussiteSexe {
             width: auto;
             height: 50%;
             margin: 0;
             padding: 0;
         }
        </style>
        <center>
        <form name="frm" action="./stats2.php" method="post" align="center">
				<input class="mdl-button mdl-button--raised mdl-button--colored" type="submit" value="Suivant">
		</form>
		</center>
	</body>
</html>
