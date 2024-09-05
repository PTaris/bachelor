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
		<title>
            <?php echo $donnees['titre_page']; ?>
		</title>
	</head>
    
    <body>
    <header>

    <!--barre de navigation --> 
    <nav class="navbar navbar-expand-lg navbar-light justify-content-between" style="background-color: #C5E1D4;">
    <div class="container-fluid">
        <!-- lien pour la page d'accueil en cliquant sur le logo -->
        <a class="navbar-brand" href="index.php">
            <img src="images/logo.png" width="60" height="60" class="d-inline-block align-top" alt="">
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <!-- lien pour se rendre sur la page genre.php -->
                <li class="nav-item">
                    <a class="nav-link" href="genre.php">Genres</a>
                </li>
                
                <!-- dropdown permettant soit d'accéder à tous les livres triés par auteur, soit à tous les livres triés par auteur dans une certaine intervalle de lettres-->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="auteur.php" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Auteurs
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="auteur.php">Tous les auteurs</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="auteur.php?id=A">A-D</a></li>
                        <li><a class="dropdown-item" href="auteur.php?id=E">E-H</a></li>
                        <li><a class="dropdown-item" href="auteur.php?id=I">I-L</a></li>
                        <li><a class="dropdown-item" href="auteur.php?id=M">M-P</a></li>
                        <li><a class="dropdown-item" href="auteur.php?id=Q">Q-T</a></li>
                        <li><a class="dropdown-item" href="auteur.php?id=U">U-Z</a></li>
                    </ul>
                </li>
            </ul>
        </div>

        <!-- barre de recherche-->
        <form class="form-inline" action="recherche.php" method = "post">
        <div class="input-group">
            <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" name = "recherche">
            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Chercher</button>
        </div>
        </form>

        <!-- se connecter/s'inscrire ou accéder au compte -->
        <?php
        //si le membre est connecté ET n'est pas sur la page pour se déconnecter, on lui propose d'aller sur son profil
        if (isset($_SESSION['id_membre']) && $donnees['titre_page'] != 'Déconnexion')
        {
          echo "<form method='get' action='profil.php'> <button type='submit' class='btn btn-primary'>Mon profil</button> </form>";  
        }
        //si le membre n'est pas connecté, on lui propose de se connecter ou de s'inscrire
        else
        {
            echo "<form method='get' action='connexion.php'> <button type='submit' class='btn btn-primary'>Connexion/Inscription</button> </form>";
        }
        ?>
        
    </div>
    </nav>
    </header>