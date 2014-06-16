-- Create the Boundary SDK Database
CREATE DATABASE IF NOT EXISTS services CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- Create the Boundary User
CREATE USER 'boundary'@'localhost' IDENTIFIED BY 'boundary';

-- Grant priviledges to the boundary user
GRANT ALL PRIVILEGES ON services.* TO 'boundary'@'localhost';
