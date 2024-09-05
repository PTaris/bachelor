<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Accueil";
    $donnees['titre_page'] = "Page d'accueil";
    include "debut-page.inc.php";
?>

<main>
<div class="container-xl">

    <h1>Vérification de la connexion</h1>
    <?php 
        if (!empty($_POST['pseudo']) && !empty($_POST['motdepasse']))
        {
            $pseudo = $_POST['pseudo'];
            $motdepasse = $_POST['motdepasse'];
            $requete = "SELECT * FROM membre WHERE pseudo = ?";
            $reponse = $pdo->prepare($requete);
            $reponse->execute(array($pseudo));
            $enregistrements = $reponse->fetchAll();
            $nombreReponses = count($enregistrements);
            if ($nombreReponses > 0)
            {
                $motdepasse_crypte = $enregistrements[0]['motdepasse'];
                if (password_verify($motdepasse, $motdepasse_crypte))
                {
                echo "Bienvenue sur notre site. <a href='index.php'>Cliquez ici pour rejoindre la page d'accueil</a>.";
                $_SESSION['pseudo'] = $enregistrements[0]['pseudo'];
                $_SESSION['id_membre'] = $enregistrements[0]['id'];
                }
                else
                {
                echo "Le mot de passe est incorrect. <a href='connexion.php?id=1'>Réessayez</a>";
                }
            }
            else
            {
                echo "Le membre n'existe pas. <a href='connexion.php?id=1'>Réessayez de vous connecter</a> ou <a href='connexion.php' inscrivez-vous sur notre site</a>.";
            }
        }
    ?>
    </div>
    </main>

    <?php include "fin-page.inc.php"; ?>