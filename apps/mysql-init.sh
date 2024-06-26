sudo dnf update -y
sudo dnf install mariadb105-server -y 



CREATE DATABASE backend;
USE test;

CREATE TABLE your_table_name (
  id INT AUTO_INCREMENT PRIMARY KEY,
  column1 VARCHAR(255),
  column2 VARCHAR(255)
);

INSERT INTO your_table_name (column1, column2) VALUES ('value1', 'value2');
