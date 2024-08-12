<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Genre";
    $donnees['titre_page'] = "Genres";
    include "debut-page.inc.php";
?>

<main>
    <div class="container-xl">
    <?php
    //si on veut les livres d'un genre particulier
    if (isset ($_GET['id']))
    { 
        $id = $_GET['id'] ;
        $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`  FROM `livre`, `genre_litteraire`, `auteur`  WHERE `id_genre` = `genre_litteraire`.`id` AND `id_auteur` = `auteur`.`id` AND `id_genre` = '$id' ORDER BY `auteur`.`nom`";
        $reponse = $pdo -> prepare($requete);
        $reponse -> execute();
        $livres = $reponse ->fetchAll();
        $nombre_livres = count($livres);
        for ($i=0; $i<$nombre_livres; $i++)
            {
                echo "<div class='row align-items-start'>";
                echo "<div class='col-3'> <img src='couvertures/".$livres[$i]['id'].".PNG' height=300 /> </div>";

                echo "<div class='col-7'>" ;
                echo "<h3><a href='livre.php?id=".$livres[$i]['id']."' class='link-secondary'> " . $livres[$i]['titre']. "</a></h3>";
                echo "<h5>".$livres[$i]['nom']." ".$livres[$i]['prenom']."</h5>" ;
                echo "<p>".$livres[$i]['resume']."</p>";
                echo "</div>";
                echo "</div>" ;

                echo "<br><br>";
            }
        echo "<p>Si vous ne voyez pas votre nouveau coup de coeur dans cette liste, n'hésitez pas <a href=ajouter-livre.php> à le rajouter !</a></p>";
    }
    //si on veut afficher tous les genres
    else
    { 
        $requete = "SELECT *  FROM `genre_litteraire` ORDER BY `genre`";
        $reponse = $pdo -> prepare($requete);
        $reponse -> execute();
        $genres = $reponse ->fetchAll();
        $nombre_genres = count($genres);

        echo "<div class = 'row row-cols-1 row-cols-md-4 g-4'>";
        for ($i=0; $i<$nombre_genres; $i++)
        {?>
            <div class="col">
            <div class="card border-info mb-3" style="max-width: 18rem;">
            <div class="card-body">
                <h5 class="card-title"> <?php echo $genres[$i]['genre'] ; ?> </h5>
                <a href="genre.php?id=<?php echo $genres[$i]['id'];?>" class="btn btn-info">Accéder aux livres</a>
            </div>
            </div>
            </div>
            <?php }
        echo "</div>";
            
        
     }
    ?>



    </div>
</main>

<?php include "fin-page.inc.php"; ?>