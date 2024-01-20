<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Livre";
    $donnees['titre_page'] = "Livre";
    include "debut-page.inc.php";
?>

<!--Liens pour les fiches de style css et bootstrap--> 
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link href="style.css" rel="stylesheet" type="text/css" media="all" />

<main>
<div class="container-xl">
    <?php
        $id_livre=$_GET['id'];
        if (isset ($_SESSION['id_membre'])) {$id_membre=$_SESSION['id_membre'];}

        // exécuter une requete MySQL de type SELECT
        //$requete = "SELECT `auteur`,`titre`,`resume`,`mots-clés`,`genre` FROM `livre`";
        $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`, `genre`, `mots_cles`  FROM `livre`, `genre_litteraire`, `auteur`  WHERE `id_genre` = `genre_litteraire`.`id` AND `id_auteur` = `auteur`.`id` AND `livre`.`id` = ?";
        $reponse = $pdo->prepare($requete);
        $reponse->execute(array($id_livre));
        // récupérer tous les enregistrements dans un tableau
        $livre = $reponse->fetchAll();    
        $livre_aut_nom=$livre[0]['nom'];
        $livre_aut_prenom=$livre[0]['prenom'];
        $livre_titre=$livre[0]['titre'];
        $livre_resume=$livre[0]['resume'];
        $livre_genre=$livre[0]['genre'];
        $livre_mc=$livre[0]['mots_cles'];
                        
        //Affiche les informations issus de la base à propos du livre
        echo "<div class='row align-items-start'>";
        echo "<div class='col-3'> <img src='couvertures/".$id_livre.".PNG' height=300 /> </div>";

        echo "<div class='col-7'>" ;
        echo "<h3><a href='livre.php?id=".$id_livre."' class='link-secondary'> " .$livre_titre. "</a></h3>";
        echo "<h5>".$livre_aut_nom." ".$livre_aut_prenom."</h5>" ;
        echo "<p>".$livre_resume."</p>";
                    
        echo "</br>Genre : <p>".$livre_genre."</p>";
        echo "</br>Mots-clés : <p>".$livre_mc."</p>";
        echo "</div>";
        echo "</div>" ;

        echo "<br><br>";
        

        if (isset($_SESSION['id_membre']))
        {
            ?>

        <!--formulaire envoyant le livre dans une liste choisi -->
        <div id="boutons">
            <form action="liste_livre.php" method="post">
            </br>
                <input type="submit" value="Coups de coeurs" name="coups-de-coeurs"/>
                <input type="submit" value="Lu" name="lu" />
                <input type="submit" value="A Lire" name="a-lire" />
                
                <!--partie en hidden pour le recueil d'informations nécessaire pour l'insertion dans les bases-->

                <input type="hidden" value="<?php echo $livre_titre;?>" name="titre"/>
                
                <input type="hidden" value="<?php echo $id_livre;?>" name="id_livre"/>
                
                <input type="hidden" value="<?php echo $id_membre;?>" name="id_membre"/>


            </form>
        </div>

        <?php
        }
        else
        {
            echo "<p>Pour créer des listes et enregistrer vos livres dans ces listes, connectez-vous ou créez un compte !</p>";
        }

        //requête pour afficher les commentaires avec spoiler

        $requete = "SELECT `id_livre`,`spoiler`,`pseudo` FROM `commentaire`,`livre`,`membre` WHERE `id_livre`=`livre`.`id`AND `commentaire`.`id_membre`=`membre`.`id`  AND `id_livre`=?";
        $reponse = $pdo->prepare($requete);
        $reponse->execute(array($id_livre));
        // récupérer tous les enregistrements dans un tableau
        $com = $reponse->fetchAll();
        // connaitre le nombre d'enregistrements
        $nombreReponses = count($com);
        // parcourir le tableau des enregistrements

    ?>
        <!--Utilisation d'un accordéon bootstrap-->
        <div id="tout">
            <div class="accordion accordion-flush" id="accordionFlushExample">
                <div class="accordion-item">
                    <h2 class="accordion-header" id="flush-headingOne">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseOne" aria-expanded="false" aria-controls="flush-collapseOne">
                        <h2>Commentaires avec spoilers</h2>
                    </button>
                    </h2>
                        <div id="flush-collapseOne" class="accordion-collapse collapse" aria-labelledby="flush-headingOne" data-bs-parent="#accordionFlushExample">
                            <div class="accordion-body">
                            <?php
                                for ($i=0; $i<count($com); $i++)
                                {
                                $com_spoiler=$com[$i]['spoiler'];
                                $com_pseudo=$com[$i]['pseudo'];
                                // condition pour que la valeur des commentaires par défaut ne s'affiche pas                         
                                if ($com_spoiler!=NULL)

                                    {echo "</br><strong><tr><td>".$com_pseudo."</strong></td><td> : ".$com_spoiler."</td></tr>";}
                                }
                            ?>
                        </div>
                </div>
            </div>
        
        </br>

    <?php

        //requête SQL permettant d'afficher les commentaires sans spoiler
        
        // exécuter une requete MySQL de type SELECT
        $requete = "SELECT `texte`,`pseudo` FROM `commentaire`,`membre` WHERE `id_membre`=`membre`.`id`AND `id_livre`='$id_livre'";
        $reponse = $pdo->prepare($requete);
        $reponse->execute();
        // récupérer tous les enregistrements dans un tableau
        $spoilfree = $reponse->fetchAll();
        // connaitre le nombre d'enregistrements
        $nombreReponses = count($spoilfree);
        // parcourir le tableau des enregistrements
        ?>      
            <div class="accordion" id="accordionExample">
                    <div class="accordion-item">
                    <h2 class="accordion-header" id="headingOne">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                    <h2>Commentaires</h2>
                    </button>
                    </h2>
                        <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                            <div class="accordion-body">
        <?php
            for ($i=0; $i<count($spoilfree); $i++)
            {
                $spoilfree_texte=$spoilfree[$i]['texte'];
                $spoilfree_pseudo=$spoilfree[$i]['pseudo'];

            // Le but est ici aussi de ne pas afficher la valeur pas défaut des commentaires sans spoiler

                if ($spoilfree_texte!=NULL)    
                    {echo "</br><strong><tr><td>".$spoilfree_pseudo."</strong></td><td> : ".$spoilfree_texte."</td></tr>";}
            }
        ?>
                        </div>
                    </div>
                </div>
            </div>
        <!--affiche les commentaire sans spoiler-->
        </br>

        <?php
        if (isset($_SESSION['id_membre']))
        {
            ?>
        <form action="liste_livre.php" method="post">
        <fieldset>
            <div id="bordure">
        </br>
            </div>
                <div class="box">
                <legend>Laisser un commentaire</legend>
                </div>
        <br/>
        
                <!--Ajouter un commentaire avec ou sans spoiler (à spécifier à l'envoie-->
                <div class="box">
                <textarea type="text" name="commentaire" rows="5" cols="30">
                </textarea>
                </div>
        <br/>
                <!--possibilité de préciser si on veut parler d'un spoiler--> 
                    <div class="box"><input type="submit" value="Envoyer"/>
                    </div>
        
                    <div class="box"><input type="submit" value="Avec spoiler" name="spoilercom"/>
                    </div>
                
            </div>
        </fieldset>

        <!-- Il faut refaire la manipulation avec les hidden car c'est un autre formulaire qui est envoyé -->
        <input type="hidden" value="<?php echo $livre_titre;?>" name="titre"/>

        <input type="hidden" value="<?php echo $id_livre;?>" name="id_livre"/>

        <input type="hidden" value="<?php echo $id_membre;?>" name="id_membre"/>
        
        </form>
        <?php
        }
        else
        {
            echo "<p>Afin de commenter un livre, connectez-vous ou créez un compte !</p>";
        }
        ?>

</div>
</main>
<?php include "fin-page.inc.php"; ?>
