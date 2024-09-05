<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Recherche";
    $donnees['titre_page'] = "Résultats";
    include "debut-page.inc.php";

    if (isset($_POST['recherche']))
    {
        $recherche = $_POST['recherche'] ;
    }
?>
<main>
<div class="container-xl">
    </br> 
    <h1>Résultats de votre recherche : </h1>
    </br>

    <?php

    //afin d'éviter les répétitions, on enregistre les livres déjà proposés dans un array
    $livres_proposes = array();
    $n = 0;

    // on regarde s'il y a des occurences dans les titres
    $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`  FROM `livre`, `genre_litteraire`, `auteur`  WHERE `id_genre` = `genre_litteraire`.`id` AND `id_auteur` = `auteur`.`id` AND `titre` LIKE '%$recherche%' ORDER BY `auteur`.`nom`";
    $reponse = $pdo -> prepare($requete);
    $reponse -> execute();
    $livres = $reponse ->fetchAll();
    $nombre_livres = count($livres);
    if ($nombre_livres != 0)
    {
        echo "<h2> Trouvés parmi les titres </h2>";
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
            $livres_proposes[$n] = $livres[$i]['id'] ;
            $n = $n+1 ;

        }
    }

    // on regarde s'il y a des occurences chez les auteurs
    $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`  FROM `livre`, `genre_litteraire`, `auteur`  WHERE `id_genre` = `genre_litteraire`.`id` AND `id_auteur` = `auteur`.`id` AND (`nom` LIKE '%$recherche%' OR `prenom` LIKE '%$recherche%') ORDER BY `auteur`.`nom`";
    $reponse = $pdo -> prepare($requete);
    $reponse -> execute();
    $livres = $reponse ->fetchAll();
    $nombre_livres = count($livres);
    //on vérifie qu'on n'a pas déjà affiché les livres sélectionnés plus tôt
    $livres_a_afficher = array();
    $j = 0;
    for ($i=0; $i<$nombre_livres;$i++)
    {
        $dedans = in_array($livres[$i]['id'], $livres_proposes);
        if  ($dedans == false)
        {
            $livres_a_afficher[$j] = $livres[$i];
            $j = $j+1;
        }
    }
    $nombre_livres = count($livres_a_afficher);
    //on affiche les livres qui n'ont pas encore été affichés
    if ($nombre_livres != 0)
    {
        echo "<h2> Trouvés parmi les auteurs </h2>";
        for ($i=0; $i<$nombre_livres; $i++)
        {
    
                echo "<div class='row align-items-start'>";
                echo "<div class='col-3'> <img src='couvertures/".$livres_a_afficher[$i]['id'].".PNG' height=300 /> </div>";

                echo "<div class='col-7'>" ;
                echo "<h3><a href='livre.php?id=".$livres_a_afficher[$i]['id']."' class='link-secondary'> " . $livres_a_afficher[$i]['titre']. "</a></h3>";
                echo "<h5>".$livres_a_afficher[$i]['nom']." ".$livres_a_afficher[$i]['prenom']."</h5>" ;
                echo "<p>".$livres_a_afficher[$i]['resume']."</p>";
                echo "</div>";
                echo "</div>" ;

                echo "<br><br>";
                $livres_proposes[$n] = $livres_a_afficher[$i]['id'] ;
                $n = $n+1 ;
            
        }
    }

    // on regarde s'il y a des occurences dans les mots-clés
    $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`  FROM `livre`, `genre_litteraire`, `auteur`  WHERE `id_genre` = `genre_litteraire`.`id` AND `id_auteur` = `auteur`.`id` AND `mots_cles` LIKE '%$recherche%' ORDER BY `auteur`.`nom`";
    $reponse = $pdo -> prepare($requete);
    $reponse -> execute();
    $livres = $reponse ->fetchAll();
    $nombre_livres = count($livres);
    //on vérifie qu'on n'a pas déjà affiché les livres sélectionnés plus tôt
    $livres_a_afficher = array();
    $j = 0;
    for ($i=0; $i<$nombre_livres;$i++)
    {
        $dedans = in_array($livres[$i]['id'], $livres_proposes);
        if  ($dedans == false)
        {
            $livres_a_afficher[$j] = $livres[$i];
            $j = $j+1;
        }
    }
    $nombre_livres = count($livres_a_afficher);
    //on affiche les livres qui n'ont pas encore été affichés
    if ($nombre_livres != 0)
    {
        echo "<h2> Trouvés parmi les mots-clés </h2>";
        for ($i=0; $i<$nombre_livres; $i++)
        {
            
            
                echo "<div class='row align-items-start'>";
                echo "<div class='col-3'> <img src='couvertures/".$livres_a_afficher[$i]['id'].".PNG' height=300 /> </div>";
    
                echo "<div class='col-7'>" ;
                echo "<h3><a href='livre.php?id=".$livres_a_afficher[$i]['id']."' class='link-secondary'> " . $livres_a_afficher[$i]['titre']. "</a></h3>";
                echo "<h5>".$livres_a_afficher[$i]['nom']." ".$livres_a_afficher[$i]['prenom']."</h5>" ;
                echo "<p>".$livres_a_afficher[$i]['resume']."</p>";
                echo "</div>";
                echo "</div>" ;
    
                echo "<br><br>";
                $livres_proposes[$n] = $livres_a_afficher[$i]['id'] ;
                $n = $n+1 ;
            

        }
    }

    $nombre_livres = count($livres_proposes);
    if ($nombre_livres == 0)
    {
        //si rien n'a été trouvé
        echo "<p>Votre recherche n'a pas trouvé de résultats. Essayez avec une requête plus (ou moins) précise et vérifiez l'orthographe. Si vous avez une idée du genre que vous recherchez ou du nom de l'auteur, vous pouvez directement suivre ces liens :</p>";
    }
    else
    {
        //si des réponses ont été données
        echo "<p>Si vous ne trouvez pas votre bonheur dans ces résultats, essayez avec une requête plus (ou moins) précise ou, si vous avez une idée du genre que vous recherchez ou du nom de l'auteur, vous pouvez directement suivre ces liens : ";
    }
        ?>
        <div class = 'row row-cols-1 row-cols-md-4 g-4'>
        <div class="col">
        <div class="card border-info mb-3" style="max-width: 20rem;">
        <div class="card-body">
            <h5 class="card-title"> Genres </h5>
            <a href="genre.php" class="btn btn-info">Accéder aux livres triés par genre</a>
        </div>
        </div>
        </div>
        <div class="col">
        <div class="card border-info mb-3" style="max-width: 20rem;">
        <div class="card-body">
            <h5 class="card-title"> Auteurs </h5>
            <a href="auteur.php" class="btn btn-info">Accéder aux livres triés par auteur</a>
        </div>
        </div>
        </div>
        <div class="col">
            <div class="card border-info mb-3" style="max-width: 20rem;">
            <div class="card-body">
                <h5 class="card-title"> Ajouter un livre </h5>
                <a href="ajouter-livre.php" class="btn btn-info">Si votre nouveau coup de coeur n'est pas référencé, ajoutez-le !</a>
            </div>
            </div>
            </div>
        </div>
        <?php

    ?>
</div>
</main>

<?php include "fin-page.inc.php"; ?>