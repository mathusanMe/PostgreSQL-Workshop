\! echo -----------------------------------------------------------
\! echo ------------------- 1. Requêtes simples -------------------
\! echo -----------------------------------------------------------
\! echo " "

\! echo ----------------------- Requête 1.1 -----------------------
\! echo "Afficher le contenu de chaque table ;"
\! echo " "

SELECT * FROM tournois;
SELECT * FROM matchs;
SELECT * FROM equipes;
SELECT * FROM participation;

\! echo ----------------------- Requête 1.2 -----------------------
\! echo "Afficher l’année des coupes du monde ayant eu lieu en Nouvelle-Zélande ;"
\! echo " "

SELECT T.annee FROM tournois T
WHERE T.pays = 'Nouvelle-Zélande';

\! echo ----------------------- Requête 1.3 -----------------------
\! echo "Afficher le nom des pays ayant une équipe s’appelant ‘XV de France’"
\! echo " "

SELECT E.pays FROM equipes E
WHERE E.nom = 'XV de France';

\! echo ----------------------- Requête 1.4 -----------------------
\! echo "Afficher le numéro des équipes ayant gagné au moins un match, sans répétitions ;"
\! echo " "

SELECT DISTINCT M.gagnant FROM matchs M;

\! echo -----------------------------------------------------------
\! echo ---------------- 2. Requêtes avec jointure ----------------
\! echo -----------------------------------------------------------
\! echo " "

\! echo ----------------------- Requête 2.1 -----------------------
\! echo "Afficher le nom des équipes ayant gagné au moins un match ;"
\! echo " "

SELECT DISTINCT E.nom FROM equipes E 
JOIN matchs M ON E.eid = M.gagnant;

\! echo ----------------------- Requête 2.2 -----------------------
\! echo "Afficher le nom et l’année des tournois dans lesquels l’équipe 2 a perdu un match ;"
\! echo " "

SELECT T.nom, T.annee FROM tournois T 
JOIN matchs M on T.tid = M.tournois
WHERE M.perdant = 2;

\! echo ----------------------- Requête 2.3 -----------------------
\! echo "Afficher le numéro des matchs perdus par les Wallabies ;"
\! echo " "

SELECT M.mid FROM matchs M
JOIN equipes E ON M.perdant = E.eid
WHERE E.nom = 'Wallabies';

\! echo ----------------------- Requête 2.4 -----------------------
\! echo "Afficher le numéro des matchs auxquels ont participé les All Blacks (matchs perdus ou gagnés) ;"
\! echo " "

SELECT M.mid FROM matchs M
JOIN equipes E ON M.perdant = E.eid OR M.gagnant = E.eid
WHERE E.nom = 'All Blacks';

SELECT M.mid FROM matchs M, equipes E
WHERE M.gagnant = E.eid AND E.nom = 'All Blacks'
UNION
SELECT M.mid FROM matchs M, equipes E
WHERE M.perdant = E.eid AND E.nom = 'All Blacks';

\! echo ----------------------- Requête 2.5 -----------------------
\! echo "Afficher le numéro des équipes ayant participé à la coupe du monde 1991 ;"
\! echo " "

SELECT P.eid FROM participation P
JOIN tournois T ON P.tid = T.tid
WHERE annee = 1991;

\! echo -----------------------------------------------------------
\! echo ------------ 3. Requêtes avec double jointure -------------
\! echo -----------------------------------------------------------
\! echo " "

\! echo ----------------------- Requête 3.1 -----------------------
\! echo "Afficher le nom des équipes ayant participé à la coupe du monde 1991 ;"
\! echo " "

SELECT E.nom FROM participation P
JOIN tournois T ON P.tid = T.tid
JOIN equipes E ON P.eid = E.eid
WHERE annee = 1991;

\! echo ----------------------- Requête 3.2 -----------------------
\! echo "Afficher le nom et l’année des tournois dont un match au moins a été perdu par le XV de France;"
\! echo " "

SELECT T.nom, T.annee FROM tournois T
JOIN matchs M ON T.tid = M.tournois
JOIN equipes E ON M.perdant = E.eid
WHERE E.nom = 'XV de France';

\! echo ----------------------- Requête 3.3 -----------------------
\! echo "Afficher le nom des vainqueurs des différentes coupes du monde, année par année ;"
\! echo " "

SELECT E.nom, T.annee FROM equipes E
JOIN matchs M ON M.gagnant = E.eid
JOIN tournois T ON T.tid = M.tournois 
WHERE tour = 'finale';

\! echo ----------------------- Requête 3.4 -----------------------
\! echo "Afficher le nom des équipes ayant perdu au moins un match et gagné au moins un match dans un seul tournoi ;"
\! echo " "

SELECT DISTINCT E.nom FROM equipes E
JOIN matchs M1 ON M1.gagnant = E.eid
JOIN matchs M2 ON M2.perdant = E.eid
WHERE M1.tournois = M2.tournois;

\! echo ----------------------- Requête 3.5.A -----------------------
\! echo "Afficher le nom des équipes ayant été au moins deux fois en finale ;"
\! echo " "

SELECT DISTINCT E.nom FROM equipes E
JOIN matchs M1 ON M1.gagnant = E.eid OR M1.perdant = E.eid
JOIN matchs M2 ON M2.gagnant = E.eid OR M2.perdant = E.eid
WHERE M1.tour = 'finale' and M2.tour = 'finale' and M1.tournois != M2.tournois;

\! echo ----------------------- Requête 3.5.B -----------------------
\! echo "Afficher le nom des équipes ayant été au moins deux fois en finale ;"
\! echo " "

SELECT DISTINCT E.nom FROM equipes E
JOIN matchs M1 ON M1.gagnant = E.eid 
JOIN matchs M2 ON M2.gagnant = E.eid
WHERE M1.tour = 'finale' and M2.tour = 'finale' and M1.tournois != M2.tournois
UNION
SELECT DISTINCT E.nom FROM equipes E
JOIN matchs M1 ON M1.gagnant = E.eid 
JOIN matchs M2 ON M2.perdant = E.eid
WHERE M1.tour = 'finale' and M2.tour = 'finale' and M1.tournois != M2.tournois
UNION
SELECT DISTINCT E.nom FROM equipes E
JOIN matchs M1 ON M1.perdant = E.eid 
JOIN matchs M2 ON M2.perdant = E.eid
WHERE M1.tour = 'finale' and M2.tour = 'finale' and M1.tournois != M2.tournois;

\! echo -----------------------------------------------------------
\! echo -------- 4. Conditions d\'existence et inexistence ---------
\! echo -----------------------------------------------------------
\! echo " "

\! echo ----------------------- Requête 4.1 -----------------------
\! echo "Afficher les équipes dont le pays n’a jamais hébergé une coupe du monde ;"
\! echo " "

SELECT E.nom, E.pays FROM equipes E
WHERE E.pays NOT IN (SELECT T.pays FROM tournois T);

\! echo ----------------------- Requête 4.2 -----------------------
\! echo "Afficher le nom des équipes n’ayant jamais participé à une finale ;"
\! echo " "

SELECT E.nom FROM equipes E
WHERE E.eid NOT IN (
    SELECT M.gagnant FROM matchs M 
    WHERE M.tour = 'demi-finale'
    );

\! echo ----------------------- Requête 4.3 -----------------------
\! echo "Afficher les tournois pendant lequel le ‘XV de France’ a perdu tous ses matchs (évitez d’afficher les tournois où le XV de France n’a pas joué) ;"
\! echo " "

SELECT T.nom, T.annee FROM tournois T
WHERE NOT EXISTS (
    SELECT M.mid FROM matchs M
    JOIN equipes E ON M.gagnant = E.eid
    WHERE E.nom = 'XV de France' AND M.tournois = T.tid
) AND EXISTS (
    SELECT M.mid FROM matchs M
    JOIN equipes E ON M.perdant = E.eid
    WHERE E.nom = 'XV de France' AND M.tournois = T.tid
);

\! echo ----------------------- Requête 4.4 -----------------------
\! echo "Afficher le nom des équipes ayant toujours gagné leurs matchs ;"
\! echo " "

SELECT E.nom FROM equipes E
WHERE NOT EXISTS (
    SELECT M.mid FROM matchs M
    WHERE M.perdant = E.eid
);

\! echo ----------------------- Requête 4.5 -----------------------
\! echo "Afficher le nom des équipes n’ayant participé à aucun match ;"
\! echo " "

SELECT E.nom FROM equipes E
WHERE NOT EXISTS (
    SELECT P.eid FROM participation P
    WHERE P.eid = E.eid
);

\! echo ----------------------- Requête 4.6 -----------------------
\! echo "Afficher le nom des tournois ne correspondant à aucun match présent dans les données."
\! echo " "

SELECT T.nom FROM tournois T
WHERE NOT EXISTS (
    SELECT M.tournois FROM matchs M
    WHERE M.tournois = T.tid
);

\! echo -----------------------------------------------------------
\! echo ---------------- 5. Cohérence de la table -----------------
\! echo -----------------------------------------------------------
\! echo " "

\! echo ----------------------- Requête 5.1 -----------------------
\! echo "Supprimer les tournois ne correspondant à aucun match présent dans les données."
\! echo " "

DELETE FROM tournois T
WHERE NOT EXISTS (
    SELECT M.tournois FROM matchs M
    WHERE M.tournois = T.tid
);

\! echo ----------------------- Requête 5.2 -----------------------
\! echo "Supprimer les équipes n’ayant participé à aucun match."
\! echo " "

DELETE FROM equipes E
WHERE NOT EXISTS (
    SELECT P.eid FROM participation P
    WHERE P.eid = E.eid
);

\! echo ----------------------- Requête 5.3 -----------------------
\! echo "Pour quelle équipe restante existe-t-il une coupe du monde à laquelle elle n’a pas participé ?\nL’Afrique du Sud a été exclue des coupes du monde 1987 et 1991 à cause de l’Apartheid.\nS’il est indiqué le contraire dans la base de donnée, supprimer les lignes correspondantes."
\! echo " "

DELETE FROM participation P
USING tournois T, equipes E
WHERE P.tid = T.tid
AND P.eid = E.eid
AND T.annee IN (1987, 1991)
AND E.pays = 'Afrique du Sud';

SELECT E.nom FROM equipes E
WHERE EXISTS (
    SELECT * FROM tournois T
    WHERE NOT EXISTS (
        SELECT * FROM participation P
        WHERE P.tid = T.tid AND P.eid = E.eid
    )
);

\! echo ----------------------- Requête 5.4 -----------------------
\! echo "Pour chaque coupe du monde il doit y avoir trois matchs présents dans la base de données.\nVérifiez-le et ajoutez les matchs manquant si besoin (en allant chercher les informations sur wikipedia par exemple)."
\! echo " "

SELECT * FROM tournois T
LEFT JOIN (
    SELECT M.tournois, COUNT(*) as nbMatchs FROM matchs M
    GROUP BY M.tournois
) AS match_count ON T.tid = match_count.tournois
WHERE match_count.nbMatchs != 3 OR match_count.nbMatchs IS NULL;

SELECT * FROM matchs M
WHERE M.tournois = 7;

DELETE FROM matchs
WHERE (tournois, gagnant, perdant, tour) IN (
    (7, 2, 8, 'demi-finale'),
    (7, 1, 2, 'finale')
);

INSERT INTO matchs (tournois, gagnant, perdant, tour) VALUES
(7, 2, 8, 'demi-finale'),
(7, 1, 2, 'finale');

SELECT * FROM tournois T
LEFT JOIN (
    SELECT M.tournois, COUNT(*) as nbMatchs FROM matchs M
    GROUP BY M.tournois
) AS match_count ON T.tid = match_count.tournois
WHERE match_count.nbMatchs != 3 OR match_count.nbMatchs IS NULL;

\! echo -----------------------------------------------------------
\! echo -----------------------  END  -----------------------------
\! echo -----------------------------------------------------------
\! echo " "

SELECT setval('equipes_eid_seq', (SELECT MAX(eid) FROM equipes));   -- Reset sequences
SELECT setval('tournois_tid_seq', (SELECT MAX(tid) FROM tournois));