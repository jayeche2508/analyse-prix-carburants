"""
Script d'importation des données CSV vers la base PostgreSQL "carburants".

Chaque fichier CSV est lu ligne par ligne et inséré dans la table
correspondante via psycopg2. Les conflits (doublons de clé primaire)
sont ignorés grâce à ON CONFLICT DO NOTHING dans les requêtes SQL.
"""

import csv
import psycopg2

DB_HOST = "localhost"
DB_NAME = "carburants"
DB_USER = "ton_utilisateur"
DB_PASS = "ton_mot_de_passe"
DOSSIER_CSV = "./"


def importer_csv(nom_fichier, nom_table, requete_insertion):
    chemin = DOSSIER_CSV + nom_fichier
    conn = None
    try:
        conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
        cur = conn.cursor()
        with open(chemin, mode="r", encoding="utf-8-sig") as f:
            reader = csv.reader(f, delimiter=";")
            next(reader)  # ignore l'en-tête
            for ligne in reader:
                ligne = [c.strip() for c in ligne]
                cur.execute(requete_insertion, ligne)
        conn.commit()
        print(f"OK : {nom_table}")
    except Exception as e:
        print(f"ERREUR sur {nom_table} : {e}")
        if conn:
            conn.rollback()
    finally:
        if conn:
            cur.close()
            conn.close()


if __name__ == "__main__":
    print("Début de l'importation")

    importer_csv(
        "Carburant.csv", "Carburant",
        "INSERT INTO Carburant (id_carburant, nom_carburant) VALUES (%s, %s) ON CONFLICT DO NOTHING;"
    )

    importer_csv(
        "Station.csv", "Station",
        "INSERT INTO Station (id_station, adresse, code_postal, ville, enseigne, latitude, longitude) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s) ON CONFLICT DO NOTHING;"
    )

    importer_csv(
        "Service.csv", "Service",
        "INSERT INTO Service (id_service, nom_service) VALUES (%s, %s) ON CONFLICT DO NOTHING;"
    )

    importer_csv(
        "Service_station.csv", "Service_station",
        "INSERT INTO Service_station (id_service, id_station) VALUES (%s, %s) ON CONFLICT DO NOTHING;"
    )

    importer_csv(
        "Horaire.csv", "Horaire",
        "INSERT INTO Horaire (id_station, jour, heure_ouverture, heure_fermeture) "
        "VALUES (%s, %s, %s, %s) ON CONFLICT DO NOTHING;"
    )

    importer_csv(
        "Rupture.csv", "Rupture",
        "INSERT INTO Rupture (id_carburant, id_station, date_debut, date_fin) "
        "VALUES (%s, %s, %s, NULLIF(%s, '')) ON CONFLICT DO NOTHING;"
    )

    importer_csv(
        "Releve_prix.csv", "Releve_prix",
        "INSERT INTO Releve_prix (date_releve, id_carburant, id_station, prix) "
        "VALUES (%s, %s, %s, %s) ON CONFLICT (date_releve, id_carburant, id_station) DO NOTHING;"
    )

    print("Fin de l'importation")
