
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
    name        VARCHAR(50)     NOT NULL,
    data        BLOB,

    PRIMARY KEY (ID),
    FOREIGN KEY (USER_ID) REFERENCES account(ID)

);


CREATE TABLE IF NOT EXISTS yase_skybox(
    ID          INT             NOT NULL AUTO_INCREMENT,
    USER_ID     INT             NOT NULL,
    name        VARCHAR(50)     NOT NULL,
    back_data        BLOB,
    bot_data         BLOB,
    front_data       BLOB,
    left_data        BLOB,
    right_data       BLOB,
    top_data         BLOB,
    PRIMARY KEY (ID),
    FOREIGN KEY (USER_ID) REFERENCES account(ID)
);


CREATE TABLE IF NOT EXISTS yase_model(
    ID          INT             NOT NULL AUTO_INCREMENT,
    USER_ID     INT             NOT NULL,
    name        VARCHAR(50)     NOT NULL,
    data        BLOB,

    PRIMARY KEY (ID),
    FOREIGN KEY (USER_ID) REFERENCES account(ID)
);

