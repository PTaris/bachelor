<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Profil";
    $donnees['titre_page'] = "Votre profil";
    include "debut-page.inc.php";

?>

<main>
<div class="container-xl">
    <!--Donne à l'utilisateur ses informations personnelles.-->
    <h1>Vos informations</h1>
    <?php
        $id_membre = $_SESSION['id_membre'] ;
        $requete = "SELECT * FROM membre WHERE id=?";
        $reponse = $pdo->prepare($requete);
        $reponse->execute(array($id_membre));
        $enregistrements = $reponse->fetchAll();
        $nombreReponses = count($enregistrements);
    ?>
    <p>Vous êtes <strong><?php echo $enregistrements[0]['pseudo'];?></strong> et votre e-mail est <strong><?php echo $enregistrements[0]['mail'] ;?></strong>.</p>

    <!--Donne à l'utilisateur ses listes de lecture (coups de coeur, à lire et lus)-->
    <h1>Vos listes de lecture</h1>
    
    <div class="accordion" id="accordionExample">
    <div class="accordion-item">
        <h2 class="accordion-header" id="headingOne">
        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
            Vos coups de coeur
        </button>
        </h2>
        <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
        <div class="accordion-body">
    <?php
            $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`, `liste`.`date`  FROM `livre`, `liste`, `modalite`, `auteur`  WHERE `id_livre` = `livre`.`id` AND `id_modalite` = `modalite`.`id` AND `id_auteur` = `auteur`.`id` AND `id_modalite` = '1' AND `liste`.`id_membre` = '$id_membre' ORDER BY `date`";
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
                    echo "<h6> Fini le : ".$livres[$i]['date']."</h6>";
                    echo "<p>".$livres[$i]['resume']."</p>";
                    echo "</div>";
                    echo "</div>" ;
    
                    echo "<br><br>";
                }
    ?>
      </div>
    </div>
  </div>
  
  
  <div class="accordion" id="accordionExample">
    <div class="accordion-item">
        <h2 class="accordion-header" id="headingTwo">
        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="true" aria-controls="collapseTwo">
            Vos futures lectures
        </button>
        </h2>
        <div id="collapseTwo" class="accordion-collapse collapse show" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
        <div class="accordion-body">
    <?php
            $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`, `liste`.`date`  FROM `livre`, `liste`, `modalite`, `auteur`  WHERE `id_livre` = `livre`.`id` AND `id_modalite` = `modalite`.`id` AND `id_auteur` = `auteur`.`id` AND `id_modalite` = '3' AND `liste`.`id_membre` = '$id_membre' ORDER BY `date`";
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
                    echo "<h6> Fini le : ".$livres[$i]['date']."</h6>";
                    echo "<p>".$livres[$i]['resume']."</p>";
                    echo "</div>";
                    echo "</div>" ;
    
                    echo "<br><br>";
                }
    ?>
          </div>
    </div>
  </div>

  <div class="accordion" id="accordionExample">
    <div class="accordion-item">
        <h2 class="accordion-header" id="headingThree">
        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="true" aria-controls="collapseThree">
            Vos lectures passées
        </button>
        </h2>
        <div id="collapseThree" class="accordion-collapse collapse show" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
        <div class="accordion-body">
    <?php
            $requete = "SELECT `livre`.`id`, `titre`,`nom`, `prenom`, `resume`, `liste`.`date`  FROM `livre`, `liste`, `modalite`, `auteur`  WHERE `id_livre` = `livre`.`id` AND `id_modalite` = `modalite`.`id` AND `id_auteur` = `auteur`.`id` AND `id_modalite` = '2' AND `liste`.`id_membre` = '$id_membre' ORDER BY `date`";
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
                    echo "<h6> Fini le : ".$livres[$i]['date']."</h6>";
                    echo "<p>".$livres[$i]['resume']."</p>";
                    echo "</div>";
                    echo "</div>" ;
    
                    echo "<br><br>";
                }
    ?>
              </div>
    </div>
  </div>
  <!--Propose à l'utilisateur de se déconnecter-->
  <p>Si vous voulez vous <strong>déconnecter</strong>, veuillez suivre <a href='deconnexion.php'>ce lien</a>.</p>
</div>
</main>

<?php include "fin-page.inc.php"; ?>