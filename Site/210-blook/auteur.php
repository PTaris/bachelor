<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Auteur";
    $donnees['titre_page'] = "Auteurs";
    include "debut-page.inc.php";
    if (isset($_GET['id']))
    {
        //on repère quelles lettres doivent être affichées
        $id = $_GET['id'];
        if ($id == "A") { $fin = "D" ;}
        if ($id == "E") {$fin = "H" ;}
        if ($id == "I") {$fin = "L";}
        if ($id == "M") {$fin = "P";}
        if ($id == "Q") {$fin = "T";}
        if ($id == "U") {$fin = "Z";}
    }

?>

<main>
    <div class="container-xl">
        <br>
        <h1>Classés par auteurs <?php if (isset ($id)) { echo "de ".$id." à ".$fin ; }?></h1>
        <br>
        <br>

        <?php
        
        //si on ne veut pas afficher tous les titres
        if (isset ($id))
        {
        
            if ($id == "A") { $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume` FROM `livre` INNER JOIN `auteur` ON `id_auteur` = `auteur`.`id` WHERE `nom` LIKE 'A%' OR `nom` LIKE 'B%' OR `nom` LIKE 'C%' OR `nom` LIKE 'D%' ORDER BY `auteur`.`nom`";}
            elseif ($id == "E") { $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume` FROM `livre` INNER JOIN `auteur` ON `id_auteur` = `auteur`.`id` WHERE `nom` LIKE 'E%' OR `nom` LIKE 'F%' OR `nom` LIKE 'G%' OR `nom` LIKE 'H%' ORDER BY `auteur`.`nom`";}
            elseif ($id == "I") { $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume` FROM `livre` INNER JOIN `auteur` ON `id_auteur` = `auteur`.`id` WHERE `nom` LIKE 'I%' OR `nom` LIKE 'J%' OR `nom` LIKE 'K%' OR `nom` LIKE 'L%' ORDER BY `auteur`.`nom`";}
            elseif ($id == "M") { $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume` FROM `livre` INNER JOIN `auteur` ON `id_auteur` = `auteur`.`id` WHERE `nom` LIKE 'M%' OR `nom` LIKE 'N%' OR `nom` LIKE 'O%' OR `nom` LIKE 'P%' ORDER BY `auteur`.`nom`";}
            elseif ($id == "Q") { $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume` FROM `livre` INNER JOIN `auteur` ON `id_auteur` = `auteur`.`id` WHERE `nom` LIKE 'R%' OR `nom` LIKE 'S%' OR `nom` LIKE 'T%' OR `nom` LIKE 'U%' ORDER BY `auteur`.`nom`";}
            elseif ($id == "U") { $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume` FROM `livre` INNER JOIN `auteur` ON `id_auteur` = `auteur`.`id` WHERE `nom` LIKE 'U%' OR `nom` LIKE 'V%' OR `nom` LIKE 'W%' OR `nom` LIKE 'X%' OR `nom` LIKE 'Y%' OR `nom` LIKE 'Z%' ORDER BY `auteur`.`nom`";}
            
            
            $reponse = $pdo -> prepare($requete);
            $reponse -> execute();
            $livres = $reponse ->fetchAll();
            $nombre_livres = count($livres);
                
            //on affiche les livres trouvés dans la base
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
            
            

        }

        //si on veut afficher tous les titres
        else
        {
            $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`  FROM `livre` INNER JOIN `auteur` ON `id_auteur` = `auteur`.`id` ORDER BY `auteur`.`nom`";
            $reponse = $pdo -> prepare($requete);
            $reponse -> execute();
            $livres = $reponse ->fetchAll();
            $nombre_livres = count($livres);
            
            //on affiche tous les livres enregistrés dans la base
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
        }            
        ?>
        <p>Si vous ne voyez pas votre nouveau coup de coeur dans cette liste, n'hésitez pas <a href=ajouter-livre.php> à le rajouter !</a></p>

    </div>
</main>


<?php include "fin-page.inc.php"; ?>