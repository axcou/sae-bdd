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