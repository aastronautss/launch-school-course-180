DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id SERIAL,
  full_name VARCHAR(255) NOT NULL
);

INSERT INTO users (full_name) VALUES ('Jack Smith');
INSERT INTO users (full_name) VALUES ('John Smith');
