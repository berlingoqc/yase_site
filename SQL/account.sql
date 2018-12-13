DROP TABLE IF EXISTS yase_model;
DROP TABLE IF EXISTS yase_loaded_texture;
DROP TABLE IF EXISTS yase_skybox;
DROP TABLE IF EXISTS yase_config;
DROP TABLE IF EXISTS yase_texture;
DROP TABLE IF EXISTS account;
CREATE TABLE IF NOT EXISTS account(
    ID          INT         NOT NULL    AUTO_INCREMENT,
    username    varchar(20) NOT NULL,
    role        INT         NOT NULL,
    psw         varchar(255) NOT NULL,

    PRIMARY KEY(ID)
);

CREATE TABLE IF NOT EXISTS yase_config(
    ID          INT             NOT NULL AUTO_INCREMENT,
    USER_ID     INT             NOT NULL,
    name        VARCHAR(30)     NOT NULL,
    data        BLOB,

    PRIMARY KEY (ID),
    FOREIGN KEY (USER_ID) REFERENCES account(ID)
);


CREATE TABLE IF NOT EXISTS yase_texture(
    ID          INT             NOT NULL AUTO_INCREMENT,
    USER_ID     INT             NOT NULL,
    name        VARCHAR(200)     NOT NULL,
    width       INT             NOT NULL,
    height      INT             NOT NULL,
    channels    INT             NOT NULL,
    category    VARCHAR(200)     NOT NULL,
    data_img    LONGBLOB NOT NULL,

    PRIMARY KEY (ID),
    FOREIGN KEY (USER_ID) REFERENCES account(ID)
);


CREATE TABLE IF NOT EXISTS yase_skybox(
    ID          INT             NOT NULL AUTO_INCREMENT,
    USER_ID     INT             NOT NULL,
    name        VARCHAR(50)     NOT NULL,
    back_data        LONGBLOB NOT NULL,
    bot_data         LONGBLOB NOT NULL,
    front_data       LONGBLOB NOT NULL,
    left_data        LONGBLOB NOT NULL,
    right_data       LONGBLOB NOT NULL,
    top_data         LONGBLOB NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (USER_ID) REFERENCES account(ID)
);


CREATE TABLE IF NOT EXISTS yase_model(
    ID          INT             NOT NULL AUTO_INCREMENT,
    USER_ID     INT             NOT NULL,
    name        VARCHAR(50)     NOT NULL,
    data        LONGBLOB NOT NULL,

    PRIMARY KEY (ID),
    FOREIGN KEY (USER_ID) REFERENCES account(ID)
);

CREATE TABLE IF NOT EXISTS yase_loaded_texture(
    ID INT NOT NULL AUTO_INCREMENT,
    USER_ID INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    filename VARCHAR(50) NOT NULL,

    PRIMARY KEY(ID),
    FOREIGN KEY(USER_ID) REFERENCES account(ID)
);

