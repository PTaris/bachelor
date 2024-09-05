<?php
    session_start();
    require_once("connexion_base.php");
?>

<!DOCTYPE html>
<html lang="fr">
<head>
	<!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
        <link href="css/monstyle-bootstrap.css" rel="stylesheet" type="text/css" />
    <title>Accueil</title>
</head>
<body>
    <header>
        

        <?php
            if (isset($_SESSION['id_membre']))
            {
                echo "<ul class='nav justify-content-end'> 
                        <li class='nav-item'> 
                            <a class='nav-link active' aria-current='page' href='profil.php'> Profil </a> 
                        </li> 
                    </ul>";  
            }
            else
            {
                echo "<ul class='nav justify-content-end'> 
                        <li class='nav-item'> 
                            <a class='nav-link active' aria-current='page' href='connexion.php'>Connexion / Inscription </a> 
                        </li> 
                    </ul>";
            }
            ?>

        <img class ="center" src="images/grand_logo.jpg" width="250" />

        <style>
            .center
            {
                display: block;
                margin-left: auto;
                margin-right: auto;
            }
        </style>

    </header>

    <main>
        <div class="container-xl">

            <!-- Barre de recherche-->
            <form class="form-inline" action="recherche.php" method = "post">
                <div class="input-group">
                    <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" name = "recherche"/>
                    <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                </div>
            </form>

            <br/>

            <div class="container">
                <ul class="nav nav-pills nav-fill">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="genre.php">Genres</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href=#></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="auteur.php">Auteurs</a>
                    </li>
                </ul>
            </div>

            <br/>
            <br/>

            <h2> Derniers livres publiés </h2>


                <?php
                    
                    $requete ="SELECT `livre`.`id`,`titre` FROM `livre` ORDER BY `livre`.`id` DESC ";
                    $reponse = $pdo -> prepare($requete);
                    $reponse -> execute();
                    $livres = $reponse ->fetchAll();
                    $nombre_livres = count($livres);
                    
                ?>


            <div class="card-group">
            <div class="card">
                <img src=couvertures/<?php echo $livres[0]['id'];?>.png class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title"><?php echo $livres[0]['titre'];?></h5>
                    <a href='livre.php?id=<?php echo $livres[0]['id'];?>' class="btn btn-info">Accéder au livre</a>
                </div>
            </div>
            <div class="card">
                <img src=couvertures/<?php echo $livres[1]['id'];?>.png class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title"><?php echo $livres[1]['titre'];?></h5>
                    <a href='livre.php?id=<?php echo $livres[1]['id'];?>' class="btn btn-info">Accéder au livre</a>
                </div>
            </div>
            <div class="card">
                <img src=couvertures/<?php echo $livres[2]['id'];?>.png class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title"><?php echo $livres[2]['titre'];?></h5>
                    <a href='livre.php?id=<?php echo $livres[2]['id'];?>' class="btn btn-info">Accéder au livre</a>
                </div>
            </div>
            </div>





<?php include "fin-page.inc.php"; ?>