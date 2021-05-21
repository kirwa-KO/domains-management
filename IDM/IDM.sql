
CREATE TABLE nservers (
 id      INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
 host    VARCHAR(255),
 ip      VARCHAR(255),
 os      INTEGER,
 usr     VARCHAR(255),
 pass    VARCHAR(255),
 status  VARCHAR(255),
 lping   DOUBLE,
 port   INT,
 dns BOOLEAN,
 web BOOLEAN,
 email BOOLEAN,
 INDEX (host)
);


CREATE TABLE os (
 id  INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
 os  VARCHAR(255),
 INDEX (ID)
);

INSERT INTO `os` (`id`, `os`) VALUES
  (1, 'Linux - Centos');


CREATE TABLE registrar (
 id      INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
 name    VARCHAR(255),
 url     VARCHAR(255),
 INDEX (name)
);


CREATE TABLE nhosts (
 id      INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
 name    VARCHAR(255),
 ip      VARCHAR(255),
 INDEX (name)
);


CREATE TABLE person (
 id      INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
 name    VARCHAR(255),
 first   VARCHAR(255),
 last    VARCHAR(255),
 email   VARCHAR(255),
 phone   VARCHAR(255),
 INDEX (name)
);


CREATE TABLE domains (
 name         VARCHAR(255) NOT NULL PRIMARY KEY,
 ns1          VARCHAR(255),
 ns2          VARCHAR(255),
 ns3          VARCHAR(255),
 ns4          VARCHAR(255),
 mx1          VARCHAR(255),
 mx2          VARCHAR(255),
 www          VARCHAR(255),
 owner        VARCHAR(255),
 adminp       VARCHAR(255),
 techp        VARCHAR(255),
 billp        VARCHAR(255),
 registrar    VARCHAR(255),
 vpwd         VARCHAR(255),
 expire       VARCHAR(255),
 status       VARCHAR(255),
 costperyear  DOUBLE,
 sale_price  DOUBLE,
 whois        VARCHAR(255) DEFAULT '',
 url          VARCHAR(255) DEFAULT '',
 INDEX (name)
);
