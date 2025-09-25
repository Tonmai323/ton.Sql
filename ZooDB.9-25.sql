---67040233125 ไพรัตย์หลวงจุมพล

create database ZooDB


CREATE TABLE AnimalType (
    animal_type_id INT PRIMARY KEY,
    type_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NULL
);


CREATE TABLE SpeciesInfo (
    species_info_id INT PRIMARY KEY,
    common_name NVARCHAR(100) NOT NULL,
    scientific_name NVARCHAR(100) NOT NULL,
    habitat NVARCHAR(MAX) NULL,
    diet NVARCHAR(MAX) NULL,
    conservation_status NVARCHAR(100) NULL,
    description NVARCHAR(MAX) NULL
);


CREATE TABLE Enclosure (
    enclosure_id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    location NVARCHAR(200) NULL
);


CREATE TABLE Keeper (
    keeper_id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(50) NULL,
    email NVARCHAR(100) NULL
);


CREATE TABLE EnclosureKeeper (
    enclosure_id INT NOT NULL,
    keeper_id INT NOT NULL,
    PRIMARY KEY (enclosure_id, keeper_id),
    FOREIGN KEY (enclosure_id) REFERENCES Enclosure(enclosure_id),
    FOREIGN KEY (keeper_id) REFERENCES Keeper(keeper_id)
);


CREATE TABLE Food (
    food_id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(100) NOT NULL,
    unit NVARCHAR(50) NULL
);


CREATE TABLE Animal (
    animal_id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    gender NVARCHAR(10) NULL,
    birth_date DATE NULL,
    enclosure_id INT NULL,
    animal_type_id INT NULL,
    species_info_id INT NULL,
    FOREIGN KEY (enclosure_id) REFERENCES Enclosure(enclosure_id),
    FOREIGN KEY (animal_type_id) REFERENCES AnimalType(animal_type_id),
    FOREIGN KEY (species_info_id) REFERENCES SpeciesInfo(species_info_id)
);

CREATE TABLE FeedingSchedule (
    feeding_id INT PRIMARY KEY,
    animal_id INT NOT NULL,
    food_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    feeding_date DATE NOT NULL,
    feeding_time TIME NOT NULL,
    keeper_id INT NOT NULL,
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id),
    FOREIGN KEY (food_id) REFERENCES Food(food_id),
    FOREIGN KEY (keeper_id) REFERENCES Keeper(keeper_id)
);
select * from Animal
