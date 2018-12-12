/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

/**
 *
 * @author wq
 */

    public class ConnectionInfo {

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public void setDatabase(String database) {
        this.database = database;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public void setPassword(String password) {
        this.password = password;
    }
        String driver;
        String host;
        String database;
        String user;
        String password;

        public ConnectionInfo(String host,String database,String user,String password, String driver) {
            this.host = host;
            this.database = database;
            this.user = user;
            this.password = password;
            this.driver = driver;
        }

        public String GetConnection() {
		return "jdbc:mysql://"+host+"/"+database;
        }
        public String GetUser() { return user;}
        public String GetPassword() { return password; }
        public String GetDriver() { return driver; }
    }