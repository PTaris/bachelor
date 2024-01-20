<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Ajouter un livre";
    $donnees['titre_page'] = "Ajouter un livre";
    include "debut-page.inc.php";
?>

<main>
<div class="container-xl">
<h2>Ajout d'un nouveau livre à Blook</h2>
<br/>
    <?php
    if (isset($_SESSION['id_membre']))
    {
    ?>
        <form action="enregistrer-livre.php" method="post">

            <div class="form-floating">
                <label for="titre"> Titre</label>
                <input name="titre" class="form-control" type="text"/>
            </div>
            <br/>
            <div class="form-floating">
                <label for="auteur"> Auteur</label>
                <input name="auteur" class="form-control" type="text"/>
            </div>
            <br/>
            <div class="form-floating">
                <label for="genre">Genre</label>
                <input name="genre"class="form-control" list="genres"  type="text"/>
                <datalist id="genres">
                    <?php
                        $requete = "SELECT *  FROM `genre_litteraire` ORDER BY `genre`";
                        $reponse = $pdo -> prepare($requete);
                        $reponse -> execute();
                        $genres = $reponse ->fetchAll();
                        $nombre_genres = count($genres);
                        for ($i=0; $i<$nombre_genres; $i++)
                        {
                        echo "<option value=".$genres[$i]['genre'].">";
                        }
                    ?>
                </datalist>
            </div>
            <br/>
            <div class="form-floating">
                <label for="resume"> Resumé</label>
                <textarea name="resume" class="form-control" style="height: 100px"></textarea>
            </div>
            <br/>
            <div class="form-floating">
                <label for="mots-cles"> Mots-clés qui définissent ce livre (<em>Veuillez séparer chaque mot-clé d'une virgule</em>)</label>
                <textarea name="mots-cles" class="form-control" style="height: 100px"></textarea>
            </div>
            <br/>

            <label for="couverture" class="form-label"> Veuillez choisir une couverture pour le livre (<em>Votre fichier doit être en .PNG</em>)</label><br />
            <input type="hidden" name="MAX_FILE_SIZE" value="3000000" />
            <input type="file" class="form-control" name="fichier" /><br /> <br/>

            <button type='submit' class='btn btn-primary'>Envoyer</button>
        </form>

    <?php
    }
    else
    {
       echo "Si vous n'êtes pas connectés, vous ne pouvez pas ajouter un livre.";
    }
    ?>
    </div>
</main>

<?php include "fin-page.inc.php"; ?>