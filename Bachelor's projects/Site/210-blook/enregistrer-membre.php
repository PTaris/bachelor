<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Inscription";
    $donnees['titre_page'] = "Inscription";
    include "debut-page.inc.php";

    if (isset($_POST["pseudo"]))
    {
        $pseudo = $_POST["pseudo"];
    }

    if (isset($_POST["motdepasse"]))
    {
        $motdepasse = $_POST["motdepasse"];
    }

    if (isset($_POST["email"]))
    {
        $email = $_POST["email"];
    }

    $motdepasse_crypte = password_hash($motdepasse, PASSWORD_DEFAULT);

    // exécuter une requete MySQL de type INSERT
    $requete="INSERT INTO membre (pseudo,mail,motdepasse, datecreation)
    VALUES ( ?, ?, ?,NOW())";
    $reponse=$pdo->prepare($requete);
    $reponse->execute(array($pseudo, $email, $motdepasse_crypte));

?>

<main>
<div class="container-xl">
    <h2>Inscription d'un nouveau membre</h2>
    <?php
        echo "Votre email est ".$email." et votre pseudo est ".$pseudo.".</br>";
        echo "Bienvenue sur Blook."
    ?>
</div>
</main>