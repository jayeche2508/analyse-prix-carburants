DROP TABLE IF EXISTS Station_doc CASCADE;
DROP TABLE IF EXISTS Carburant_doc CASCADE;
DROP TABLE IF EXISTS Service_doc CASCADE;
DROP TABLE IF EXISTS Service_station_doc CASCADE;
DROP TABLE IF EXISTS Rupture_doc CASCADE;
DROP TABLE IF EXISTS Horaire_doc CASCADE;
DROP TABLE IF EXISTS Releve_prix_doc CASCADE;


--Peuplement du table Station
CREATE TEMP TABLE Station_doc (
    id_station VARCHAR,
    adresse VARCHAR,
    code_postal VARCHAR,
    ville VARCHAR,
    enseigne VARCHAR,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);

\copy Station_doc FROM './Station.csv' DELIMITER ';' CSV HEADER;

INSERT INTO Station(id_station, adresse, code_postal, ville, enseigne, latitude, longitude)
SELECT DISTINCT id_station, adresse, code_postal, ville, COALESCE(enseigne, 'INCONNU'), latitude, longitude
FROM Station_doc;

----Peuplement du table Carburant

CREATE TEMP TABLE Carburant_doc (
    id_carburant INTEGER,
    nom_carburant TEXT
);

\copy Carburant_doc FROM './Carburant.csv' DELIMITER ';' CSV HEADER;

INSERT INTO Carburant(id_carburant, nom_carburant)
SELECT DISTINCT id_carburant, nom_carburant
FROM Carburant_doc;

----Peuplement du table Service

CREATE TEMP TABLE Service_doc (
    id_service INTEGER,
    nom_service VARCHAR
);

\copy Service FROM './Service.csv' DELIMITER ';' CSV HEADER;

INSERT INTO Service(id_service, nom_service)
SELECT DISTINCT id_service, nom_service
FROM Service_doc;

----Peuplement du table Service_station

CREATE TEMP TABLE Service_station_doc (
    id_service INTEGER,
    id_station VARCHAR
);

\copy Service_station FROM './Service_station.csv' DELIMITER ';' CSV HEADER;

INSERT INTO Service_station(id_service, id_station)
SELECT DISTINCT id_service, id_station
FROM Service_station_doc;

----Peuplement du table Rupture

CREATE TEMP TABLE Rupture_doc (
    id_carburant INTEGER,
    id_station VARCHAR,
    date_debut TIMESTAMP,
    date_fin TIMESTAMP
);

\copy Rupture_doc FROM './Rupture.csv' DELIMITER ';' CSV HEADER;

INSERT INTO Rupture(id_carburant, id_station, date_debut, date_fin)
SELECT DISTINCT id_carburant, id_station, date_debut, COALESCE(date_fin, NOW())
FROM Rupture_doc;

----Peuplement du table Horaire

CREATE TEMP TABLE Horaire_doc (
    id_station VARCHAR,
    jour VARCHAR,
    heure_ouverture TEXT,
    heure_fermeture TEXT
);

\copy Horaire_doc FROM './Horaire.csv' DELIMITER ';' CSV HEADER;

INSERT INTO Horaire(id_station, jour, heure_ouverture, heure_fermeture)
SELECT DISTINCT id_station, jour, REPLACE(heure_ouverture, '.', ':')::time, REPLACE(heure_fermeture, '.', ':')::time
FROM Horaire_doc
ON CONFLICT (id_station, jour) DO NOTHING; --Comme au niveau des format des horaires alors j'était obliger d'ajouter cette ligne.

----Peuplement du table Releve_prix

CREATE TEMP TABLE Releve_prix_doc (
    date_releve TIMESTAMP,
    id_carburant INTEGER,
    id_station VARCHAR,
    prix DECIMAL(10, 2)
);

\copy Releve_prix_doc FROM './Releve_prix.csv' DELIMITER ';' CSV HEADER;

INSERT INTO Releve_prix(date_releve, id_carburant, id_station, prix )
SELECT DISTINCT date_releve, id_carburant, id_station, prix
FROM Releve_prix_doc;
