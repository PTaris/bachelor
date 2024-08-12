<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Déconnexion";
    $donnees['titre_page'] = "Déconnexion";
    include "debut-page.inc.php";
    //permet à l'utilisateur de se déconnecter
    unset($_SESSION['id_membre']);
?>

<main>
<div class="container-xl">
    <h1>Vous êtes déconnecté</h1>

</div>
</main>

<?php include "fin-page.inc.php"; ?>