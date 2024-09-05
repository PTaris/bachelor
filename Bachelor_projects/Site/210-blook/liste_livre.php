
<!--Liens pour les fiches de style css et bootstrap--> 
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="style.css" rel="stylesheet" type="text/css" media="all" />

<?php
require_once("connexion_base.php");
$donnees['menu'] = "Livre";
$donnees['titre_page'] = "Livre";
include "debut-page.inc.php";
//nos données récupérés avec hidden pour le formulaire sur les listes: coups-de-coeur/ lu/ à lire

    $titre=$_POST['titre'];
    $id_livre=$_POST['id_livre'];
    //$id_membre=$_POST['id_membre'];
    $id_membre=1;

    if (!empty($_POST['coups-de-coeurs'])&&!empty($_POST['titre']))
    
    //dans le cas ou le livre va dans la liste coups-de-coeur
    {
        echo "<div id=\"tout\">Votre livre : ".$titre." est bien enregistré dans la liste coups de coeurs.</br><a href=\"livre.php?id=".$id_livre."\">Retour à la page livre</a></div>";

        $id_modalite=1; // ==> correspond à l'id de notre liste

        // envoie dans la base liste notre livre
        $requete= "INSERT INTO liste (id_livre, id_modalite, id_membre, date) VALUES (?,?,?, NOW())";
        $reponse=$pdo->prepare($requete);
        $reponse->execute(array($id_livre,$id_modalite, $id_membre));
    }

    if (!empty($_POST['lu'])&&!empty($_POST['titre']))
    
    //dans le cas ou le livre va dans la liste lu
    {
        echo "<div id=\"tout\">Votre livre : ".$titre." est bien enregistré dans la liste lu.</br><a href=\"livre.php?id=".$id_livre."\">Retour à la page livre</a></div>";

        $id_modalite=3; // ==> correspond à l'id de notre liste


        $requete= "INSERT INTO liste (id_livre, id_modalite, id_membre) VALUES (?,?,?)";
        $reponse=$pdo->prepare($requete);
        $reponse->execute(array($id_livre,$id_modalite, $id_membre));
    }

    if (!empty($_POST['a-lire'])&&!empty($_POST['titre']))
    
    //dans le cas ou le livre va dans la liste a-lire
    {

        echo "<div id=\"tout\">Votre livre : ".$titre." est bien enregistré dans la liste à lire.</br><a href=\"livre.php?id=".$id_livre."\">Retour à la page livre</a></div>";

        $id_modalite=2;
    
        $requete= "INSERT INTO liste (id_livre, id_modalite, id_membre) VALUES (?,?,?)";
        $reponse=$pdo->prepare($requete);
        $reponse->execute(array($id_livre,$id_modalite, $id_membre));
    
    }

    // on veut récupérer et enregistrer dans la base commentaire les commentaires non spoilant
    
    if (!empty($_POST['commentaire'])&&(!empty($_POST['spoilercom'])))
        
    {
        //on récupère notre commentaire
        $texte= $_POST['commentaire'];

        
        echo "<div id=\"tout\"><p>Votre commentaire: " .$texte. ": a bien été enregistré.</br><a href=\"livre.php?id=".$id_livre."\">Retour à la page livre</a></p></div>";

        //  on a cliqué sur le bouton avec spoiler alors cela envoie le commentaire dans la catégorie spoiler de la table commentaire

        $requete= "INSERT INTO commentaire (id_membre, id_livre, spoiler) VALUES (?,?,?)";
        $reponse=$pdo->prepare($requete);
        $reponse->execute(array($id_membre, $id_livre, $texte));

    }

    // on veut récupérer et enregistrer dans la base commentaire les commentaires spoilant
    
    if (!empty($_POST['commentaire'])&&(empty($_POST['spoilercom'])))

    // si on a pas cliqué sur le bouton avec spoiler alors on envoie le commentaire dans texte de la table commentaire qui s'affiche de manière visible sur la page livre.php

    {
        
        $texte= $_POST['commentaire'];
        echo "<div id=\"tout\"><p>Votre commentaire: " .$texte. ": a bien été enregistré.</br><a href=\"livre.php?id=".$id_livre."\">Retour à la page livre</a></p></div>";

        $requete= "INSERT INTO commentaire (id_membre, id_livre, texte) VALUES (?,?,?)";
        $reponse=$pdo->prepare($requete);
        $reponse->execute(array($id_membre, $id_livre, $texte));
    }

?>


<?php include "fin-page.inc.php"; ?>
