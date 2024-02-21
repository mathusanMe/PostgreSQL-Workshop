\! echo -----------------------------------------------------------
\! echo ------------------ 1. Échauffement : TP2 ------------------
\! echo -----------------------------------------------------------
\! echo " "

\! echo ----------------------- Requête 1.4 -----------------------
\! echo " "

SELECT setval('equipes_eid_seq', (SELECT MAX(eid) FROM equipes));   -- Reset sequences
SELECT setval('tournois_tid_seq', (SELECT MAX(tid) FROM tournois));

\! echo ----------------------- Requête 1.5 -----------------------
\! echo " "

DROP TABLE IF EXISTS joueurs CASCADE;

CREATE TABLE joueurs (
    jid SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    dateDeNaissance DATE NOT NULL,
    nationalite VARCHAR(100) NOT NULL
);

\! echo ----------------------- Requête 1.6 -----------------------
\! echo " "

\i joueur1.sql

\! echo ----------------------- Requête 1.7 -----------------------
\! echo " "

CREATE TABLE joueurEquipes (
    jid INTEGER,
    eid INTEGER,
    PRIMARY KEY (jid, eid),
    FOREIGN KEY (jid) REFERENCES joueurs(jid),
    FOREIGN KEY (eid) REFERENCES equipes(eid)
);

\! echo ----------------------- Requête 1.8 -----------------------
\! echo " "

\i joueur2.sql

\! echo ----------------------- Requête 1.9 -----------------------
\! echo " "

INSERT INTO joueurEquipes VALUES (1, 30);   -- Pas possible car 30 n'existe pas dans la table equipes

\! echo ----------------------- Requête 1.10 -----------------------
\! echo " "

DELETE FROM equipes E WHERE E.nom = 'All Blacks';   -- Pas possible car toujours référencé ailleurs

\! echo ----------------------- Requête 1.11 -----------------------
\! echo " "

ALTER TABLE matchs DROP CONSTRAINT matchs_gagnant_fkey;
ALTER TABLE matchs DROP CONSTRAINT matchs_perdant_fkey;
ALTER TABLE matchs ADD CONSTRAINT matchs_gagnant_fkey FOREIGN KEY (gagnant) REFERENCES equipes(eid) ON DELETE CASCADE;
ALTER TABLE matchs ADD CONSTRAINT matchs_perdant_fkey FOREIGN KEY (perdant) REFERENCES equipes(eid) ON DELETE CASCADE;

\! echo ----------------------- Requête 1.12 -----------------------
\! echo " "

ALTER TABLE participation DROP CONSTRAINT participation_eid_fkey;
ALTER TABLE participation ADD CONSTRAINT participation_eid_fkey FOREIGN KEY (eid) REFERENCES equipes(eid) ON DELETE CASCADE;

ALTER TABLE joueurEquipes DROP CONSTRAINT joueurEquipes_eid_fkey;
ALTER TABLE joueurEquipes ADD CONSTRAINT joueurEquipes_eid_fkey FOREIGN KEY (eid) REFERENCES equipes(eid) ON DELETE CASCADE;

\! echo ----------------------- Requête 1.13 -----------------------
\! echo " "

DELETE FROM equipes E WHERE E.pays = 'Italie';

\! echo ----------------------- Requête 1.14 -----------------------
\! echo " "

DELETE FROM equipes E
WHERE EXISTS (
    SELECT * FROM equipes E1
    JOIN participation P ON P.eid = E1.eid
    JOIN tournois T ON P.tid = T.tid
    WHERE E1.eid = E.eid AND T.pays = 'Italie'
);