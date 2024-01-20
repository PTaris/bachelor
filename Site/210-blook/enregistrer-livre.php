<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Enregistrer";
    $donnees['titre_page'] = "Enregistrement du livre";
    include "debut-page.inc.php";
?>


<main>
    <?php
        if (isset($_POST['titre']))
        {
            $titre = $_POST['titre'];
        }
        if (isset($_POST['auteur']))
        { 
            $auteur = $_POST['auteur'];
        }
        if (isset($_POST['resume']))
        {
            $resume= $_POST['resume'];
        }
        if (isset($_POST['genre']))
        {
            $genre= $_POST['genre'];
        }
        if (isset($_POST['mots-cles']))
        {
            $mots_cles= $_POST['mots-cles'];
        }


        // exécuter une requete MySQL de type INSERT
        $auteur = explode(" ", $auteur);
        $requete = "SELECT `id` FROM `auteur` WHERE (`nom` = '$auteur[0]' OR `nom` = '$auteur[1]') AND (`prenom` = '$auteur[0]' OR `prenom` = '$auteur[1]')";
        $reponse = $pdo->prepare($requete);
        $reponse->execute();
        $enregistrement = $reponse->fetchAll();
        $id_auteur = $enregistrement[0]['id'];

        $requete = "SELECT `id` FROM `genre_litteraire` WHERE `genre` = '$genre'";
        $reponse = $pdo->prepare($requete);
        $reponse->execute();
        $enregistrement = $reponse->fetchAll();
        $id_genre = $enregistrement[0]['id'];


        $requete="INSERT INTO livre (id_membre, titre,id_genre,resume,mots_cles,id_auteur, date)
        VALUES ( ?, ?, ?, ?, ?, ?, NOW())";
        $reponse=$pdo->prepare($requete);
        $reponse->execute(array($_SESSION['id_membre'],$titre, $id_genre, $resume, $mots_cles, $id_auteur));

        $dernier_id = $pdo->lastInsertId();
        

        if(!empty($_FILES['fichier']['tmp_name']))
        {
            $size = getimagesize($_FILES['fichier']['tmp_name']);
            print_r($size);
            echo "Filetype : ".$size['mime'];
            if ($size['mime'] == "image/png")
            {
                $uploaddir = $_SERVER['DOCUMENT_ROOT']."/cswd/projets/couvertures/";
                $uploadfile = $dernier_id.".png";
                if (move_uploaded_file($_FILES['fichier']['tmp_name'], $uploaddir.$uploadfile))
                {
                    
                    echo "<ul>
                                <li>Le titre du livre est  : ".$titre."</li>
                                <li>L'auteur du livre est : ".$auteur."</li>
                                <li>Le résumé est  : ".$resume."</li>
                                <li>Le genre est : ".$genre."</li>
                                <li>Les mots clés sont  : ".$mot_cles."</li>
                            </ul>";
                    echo "Votre proposition sera publiée après vérification des administrateurs du site." ;
        
                    echo "<p>La couverture du livre a bien été ajouté : ".$uploadfile."</p>";
                }
                
                else
                {
                    echo "<p>Problème sur le serveur : ".$uploaddir."</p>";
                }
            }

            else
            {
                    echo "<p>Pas le bon type de fichier : ".$size['mime']."</p>";
            }
        }

        else
        {
            echo "<p>Pas de fichier spécifié.</p>";
        }
    ?>
</main>
<?php include "fin-page.inc.php"; ?>