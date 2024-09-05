<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Apropos";
    $donnees['titre_page'] = "Crédits du site";
    include "debut-page.inc.php";
?>

<main>
<div class="container-xl">
    <h2>Fonctionnement du site</h2>
    <p>Blook est un site de partage de coups de coeur entre lecteurs, nous permettant d'échanger, de diffuser et de découvrir nos prochains livres préférés. Nous proposons à nos utilisateurs d'ajouter eux-mêmes leurs coups de coeur lorsque Blook ne les recense pas et de commenter les livres disponibles sur le site. Il est également possible de lister les livres que l'on aimerait lire, les livres que l'on a lus et les livres que l'on a adoré.</p>
    <p>Les personnes inscrites se sont engagées à suivre les règles de modération du site, qui sont les suivantes :</p>
    <ul>
        <li>Les commentaires comportant des spoilers devront être signalés comme tels lors de leur publication.</li>
        <li>Les commentaires ne comporteront pas d'insultes à l'égard des personnages, de l'autrice ou auteur, ni de propos à caractère discriminatoire.</li>
        <li>Les commentaires resteront respectueux de l'oeuvre et de son contenu dans le cas de critiques positives ou négatives.</li>
        <li>Les administrateurs du site se réservent le droit de supprimer tout commentaire dérogeant aux règles citées ci-dessus.</li>
        <li>Les administrateurs du site se réservent le droit de supprimer tout compte dérogeant aux règles citées ci-dessus en cas de récidive.</li>
    </ul>
    
    <h2>Qui sommes nous ?</h2>
    <p>Nous sommes trois étudiantes en Licence 2 MIASHS à l'Université de Bordeaux : Charline Montant, Elise Montaut et Pauline Taris. Lectrices plus ou moins régulières, nous voulions permettre à tous, peu importent l'âge, la fréquence de lecture et les genres préférés, d'avoir un espace pour échanger.</p>

    <h2>Comment nous contacter ?</h2>
    <p>Vous pouvez nous contacter à :
        <ul>
            <li><strong>Mail :</strong> blook@blook.org</li>
            <li><strong>Numéro de téléphone :</strong> 09 XX XX XX XX</li>
            <li><strong>Adresse postale :</strong> Université de Bordeaux - campus Talence</li>
        </ul>
    </p>
</main>

</div>
<?php include "fin-page.inc.php"; ?>