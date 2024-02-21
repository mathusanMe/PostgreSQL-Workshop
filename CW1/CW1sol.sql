\! echo ----------------------- Requête 1 -----------------------
\! echo "Afficher la définition de chacune des tables que l'on vient de créer ;"
\! echo " "

\d produit
\d usine
\d magasin
\d provenance

\! echo ----------------------- Requête 2 -----------------------
\! echo "Afficher le contenu de chaque table ;"
\! echo " "

SELECT * FROM produit;
SELECT * FROM usine;
SELECT * FROM magasin;
SELECT * FROM provenance;

\! echo ----------------------- Requête 3 -----------------------
\! echo "Afficher les villes où il y a une usine \; Comment éviter les doublons ?"
\! echo " "

SELECT ville FROM usine;

SELECT DISTINCT ville FROM usine;

\! echo ----------------------- Requête 4 -----------------------
\! echo "Afficher les noms et les couleurs de chaque produit ;"
\! echo " "

SELECT nom_prod, couleur FROM produit;

\! echo ----------------------- Requête 5 -----------------------
\! echo "Afficher la référence et la quantité de chaque produit livré au magasin avec la référence 14 ;"
\! echo " "

SELECT ref_prod, quantite FROM provenance 
WHERE ref_mag = 14;

\! echo ----------------------- Requête 6 -----------------------
\! echo "Afficher la référence, le nom et la ville de toutes les usines de Marseille ;"
\! echo " "

SELECT ref_usine, nom_usine, ville FROM usine 
WHERE ville = 'Marseille';

\! echo ----------------------- Requête 7 -----------------------
\! echo "Afficher les références des magasins qui sont approvisionnés par l’usine de référence 109 en produit de référence 1 ;"
\! echo " "

SELECT ref_mag FROM provenance 
WHERE ref_usine = 109 AND ref_prod = 1;

\! echo ----------------------- Requête 8 -----------------------
\! echo "Afficher la référence et le nom de tous les produits rouges ;"
\! echo " "

SELECT ref_prod, nom_prod FROM produit 
WHERE couleur = 'rouge';

\! echo ----------------------- Requête 9 -----------------------
\! echo "Afficher le nom des magasins dans une ville qui commence avec la lettre ’L’ ;"
\! echo " "

SELECT nom_mag FROM magasin 
WHERE ville LIKE 'L%';

\! echo ----------------------- Requête 10 -----------------------
\! echo "Afficher la référence et le nom de tous les produits dont le nom commence par \"casse\" ;"
\! echo " "

SELECT ref_prod, nom_prod FROM produit 
WHERE nom_prod LIKE 'casse%';

\! echo ----------------------- Requête 11 -----------------------
\! echo "Afficher la référence des magasins auxquels on livre quelque chose. Faites la requête sans préciser DISTINCT puis avec ;"
\! echo " "

SELECT ref_mag FROM provenance;

SELECT DISTINCT ref_mag FROM provenance;

\! echo ----------------------- Requête 12 -----------------------
\! echo "Afficher les noms et les couleurs des produits qui pèsent entre 15 et 45 ;"
\! echo " "

SELECT nom_prod, couleur FROM produit 
WHERE poids BETWEEN 15 AND 45;

\! echo ----------------------- Requête 13 -----------------------
\! echo "Afficher les noms des produits jaunes ou bleus qui pèsent moins que 20 ;"
\! echo " "

SELECT nom_prod FROM produit 
WHERE (couleur = 'jaune' OR couleur = 'bleu') AND poids < 20;

\! echo ----------------------- Requête 14 -----------------------
\! echo "Afficher les noms des produits jaunes ou des produits bleus qui pèsent moins que 20 ; Quelle est la différence avec la requête précédente ?"
\! echo " "

SELECT nom_prod FROM produit 
WHERE couleur = 'jaune' OR couleur = 'bleu' AND poids < 20;

\! echo "Dans la première requête, la condition sur le poids est appliquée à tous les produits, alors que dans la deuxième, elle ne l'est qu'aux produits bleus ;"
\! echo " "

\! echo ----------------------- Requête 15 -----------------------
\! echo "Afficher les lampes et les produits qui pèsent plus que 30 ;"
\! echo " "

SELECT nom_prod FROM produit 
WHERE nom_prod LIKE 'lampe%' OR poids > 30;

\! echo ----------------------- Requête 16 -----------------------
\! echo "Afficher les références des magasins qui ont le nom \"NULL\" ;"
\! echo " "

SELECT ref_mag FROM magasin 
WHERE nom_mag = 'NULL';

\! echo ----------------------- Requête 17 -----------------------
\! echo "Afficher les références des magasins qui n’ont pas de nom ;"
\! echo " "

SELECT ref_mag FROM magasin 
WHERE nom_mag IS NULL;

\! echo ----------------------- Requête 18 -----------------------
\! echo "Afficher les références des produits fabriqués par l’usine martin de Nantes\; répondez d’abord en utilisant deux requêtes successives (requêtes monotables), ensuite une seule (jointure de deux tables) ;"
\! echo " "

SELECT ref_usine FROM usine 
WHERE nom_usine = 'martin' AND ville = 'Nantes';
SELECT ref_prod FROM provenance 
WHERE ref_usine = 109;

SELECT ref_prod FROM provenance P 
JOIN usine U ON P.ref_usine = U.ref_usine 
WHERE U.nom_usine = 'martin' AND U.ville = 'Nantes';

\! echo ----------------------- Requête 19 -----------------------
\! echo "Afficher les noms des usines qui sont dans une ville où il y a aussi un magasin ;"
\! echo " "

SELECT nom_usine FROM usine, magasin
WHERE usine.ville = magasin.ville;

\! echo ----------------------- Requête 20 -----------------------
\! echo "Afficher les références et les quantités des produits livrés aux magasins dont le nom commence avec \"P\" ;"
\! echo " "

SELECT ref_prod, quantite FROM provenance P
JOIN magasin M ON P.ref_mag = M.ref_mag
WHERE M.nom_mag LIKE 'P%';

\! echo ----------------------- Requête 21 -----------------------
\! echo "Afficher les noms des usines où on fabrique des ordinateurs ;"
\! echo " "

SELECT nom_usine FROM usine U
JOIN provenance P ON U.ref_usine = P.ref_usine
JOIN produit PR ON P.ref_prod = PR.ref_prod
WHERE PR.nom_prod LIKE 'ordinateur';

\! echo ----------------------- Requête 22 -----------------------
\! echo "Afficher les noms des produits dont le poids correspond à une référence ; (par exemple tabouret)"
\! echo " "

SELECT P1.nom_prod FROM produit P1, produit P2
WHERE P1.poids = P2.ref_prod;