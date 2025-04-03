-- mettre en place table

CREATE TEMP TABLE temp_personnes (
    identifier INT,
    full_name VARCHAR(100),
    age INT
);

\COPY temp_personnes (identifier, full_name, age)
FROM 'chemin/vers/personnes.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE personnes
RENAME COLUMN identifier TO id,
RENAME COLUMN full_name TO nom;

-- pour clé etrangere

ALTER TABLE nom_de_votre_table DROP CONSTRAINT nom_de_la_contrainte;
ALTER TABLE nom_de_votre_table RENAME COLUMN ancien_nom TO nouveau_nom;
ALTER TABLE nom_de_votre_table
ADD CONSTRAINT nom_de_la_contrainte FOREIGN KEY (nouveau_nom) REFERENCES autre_table(colonne_reference);

-- plusieurs base dans une base

CREATE SCHEMA schema1;
CREATE SCHEMA schema2;

-- Table dans schema1
CREATE TABLE schema1.clients (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100)
);

CREATE TABLE schema1.adresses (
    id SERIAL PRIMARY KEY,
    client_id INT,
    adresse VARCHAR(255),
    FOREIGN KEY (client_id) REFERENCES schema1.clients(id)
);

-- Table dans schema2
CREATE TABLE schema2.commandes (
    id SERIAL PRIMARY KEY,
    client_id INT,
    montant DECIMAL(10, 2),
    FOREIGN KEY (client_id) REFERENCES schema1.clients(id)
);

CREATE TABLE schema2.produits (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prix DECIMAL(10, 2)
);

-- Table commande_produits pour la relation many-to-many entre commandes et produits
CREATE TABLE schema2.commande_produits (
    commande_id INT,
    produit_id INT,
    quantite INT,
    PRIMARY KEY (commande_id, produit_id),
    FOREIGN KEY (commande_id) REFERENCES schema2.commandes(id),
    FOREIGN KEY (produit_id) REFERENCES schema2.produits(id)
);

SELECT c.nom AS client, p.nom AS produit, cp.quantite
FROM schema2.commande_produits cp
JOIN schema2.commandes co ON cp.commande_id = co.id
JOIN schema1.clients c ON co.client_id = c.id
JOIN schema2.produits p ON cp.produit_id = p.id;
