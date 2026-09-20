CREATE DATABASE carburants;

DROP TABLE IF EXISTS Releve_prix;
DROP TABLE IF EXISTS Horaire;
DROP TABLE IF EXISTS Rupture;
DROP TABLE IF EXISTS Service_station;
DROP TABLE IF EXISTS Station;
DROP TABLE IF EXISTS Carburant;
DROP TABLE IF EXISTS Service;


CREATE TABLE Station (
    id_station VARCHAR PRIMARY KEY NOT NULL,
    adresse VARCHAR NOT NULL,
    code_postal VARCHAR NOT NULL,
    ville VARCHAR NOT NULL,
    enseigne VARCHAR NOT NULL,
    latitude DECIMAL(65, 30) NOT NULL,
    longitude DECIMAL(65, 30) NOT NULL
);

CREATE TABLE Carburant (
    id_carburant INTEGER PRIMARY KEY NOT NULL,
    nom_carburant VARCHAR NOT NULL
);

CREATE TABLE Service (
    id_service INTEGER PRIMARY KEY NOT NULL,
    nom_service VARCHAR NOT NULL
);

CREATE TABLE Service_station (
    id_service INTEGER NOT NULL,
    FOREIGN KEY (id_service) REFERENCES Service(id_service),
    id_station VARCHAR NOT NULL,
    FOREIGN KEY (id_station) REFERENCES Station(id_station),
    PRIMARY KEY (id_service, id_station)
);

CREATE TABLE Rupture (
    id_carburant INTEGER NOT NULL,
    FOREIGN KEY (id_carburant) REFERENCES Carburant(id_carburant),
    id_station VARCHAR NOT NULL,
    FOREIGN KEY (id_station) REFERENCES Station(id_station),
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP NOT NULL,
    PRIMARY KEY(id_carburant, id_station, date_debut)
);

CREATE TABLE Horaire (
    id_station VARCHAR NOT NULL,
    FOREIGN KEY (id_station) REFERENCES Station(id_station),
    jour VARCHAR NOT NULL,
    heure_ouverture TIME NOT NULL,
    heure_fermeture TIME NOT NULL,
    PRIMARY KEY(id_station, jour)
);

CREATE TABLE Releve_prix (
    date_releve TIMESTAMP NOT NULL,
    id_carburant INTEGER NOT NULL,
    FOREIGN KEY (id_carburant) REFERENCES Carburant(id_carburant),
    id_station VARCHAR NOT NULL,
    FOREIGN KEY (id_station) REFERENCES Station(id_station),
    prix DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY(date_releve, id_carburant, id_station)
);

