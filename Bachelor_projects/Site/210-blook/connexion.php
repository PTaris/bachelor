<?php
    require_once("connexion_base.php");
    $donnees['menu'] = "Accueil";
    $donnees['titre_page'] = "Page d'accueil";
    include "debut-page.inc.php";
?>

<main>
<div class="container-xl">

<?php
    //si on veut se connecter, on est sur le lien connexion.php?id=1
    if (isset($_GET['id']))
    {
        //on demande à l'utilisateur son pseudo et son mot de passe
        ?>
        <h1>Connexion</h1>
        <p>Si vous n'avez pas encore de compte sur Blook, veuillez <a href='connexion.php?'>vous inscrire</a>.</p>
        <form action='verifier-connexion.php' method='post'>
        <label for='pseudo'>Pseudo:</label>
        <input name='pseudo', type='text'/>
        <label for='motdepasse'>Mot de passe:</label>
        <input name='motdepasse', type='password'/>
        <input type='submit'/>
        </form>
        <?php
    }
    //si on veut s'inscrire, on est sur le lien connexion.php
    else
    {
        //on demande à l'utilisateur un pseudo, un mot de passe et une adresse mail
        ?>
        <h1>Inscription</h1>
        <p>Si vous êtes déjà inscrits, veuillez <a href='connexion.php?id=1'>vous connecter</a>.</p>
        <form action="enregistrer-membre.php" method="post">
            <label for="pseudo">Pseudo:</label>
            <input name="pseudo", type="text"/>
            <label for="motdepasse">Mot de passe:</label>
            <input name="motdepasse", type="password"/>
            <label for="email">Adresse mail:</label>
            <input name="email", type="text"/>
            <input type="submit"/>
        </form>
    <?php    
    }
?>
<br/>
</div>
</main>

<?php include "fin-page.inc.php"; ?>