-- Requêtes SQL d'analyse sur la base "carburants"

-- Évolution du prix moyen dans le temps
SELECT date_releve AS time, AVG(prix) AS prix
FROM releve_prix
GROUP BY date_releve;

-- Top 10 des stations les moins chères
SELECT id_station, AVG(prix) AS prix
FROM releve_prix
GROUP BY id_station
ORDER BY prix;

-- Stations les plus avantageuses (prix minimum)
SELECT id_station, MIN(prix) AS prix_min
FROM releve_prix
GROUP BY id_station
ORDER BY prix_min
LIMIT 10;

-- Prix moyen global
SELECT AVG(prix) AS prix_moyen
FROM releve_prix;

-- Nombre de ruptures par carburant
SELECT c.nom_carburant, COUNT(*) AS nb_ruptures
FROM Rupture ru
JOIN Carburant c ON c.id_carburant = ru.id_carburant
GROUP BY c.nom_carburant
ORDER BY nb_ruptures DESC;
