/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

import java.io.IOException;
import java.sql.*;

import com.sun.org.apache.xpath.internal.operations.Bool;

public class MyBD {

    public static final String[] Drivers = new String[]{
        "org.mariadb.jdbc.Driver"
    };

    protected Exception  exception;
    protected Connection connection;
    private   ConnectionInfo	infoConnection;


    public MyBD(ConnectionInfo info) throws SQLException, ClassNotFoundException {
        // Load JDBC driver
        Class.forName(info.driver);
        System.out.println("Driver loaded");

	infoConnection = info;
    }
    
    public void OpenIfClose() throws SQLException {
	if(connection == null || connection.isClosed()) {
		connection = DriverManager.getConnection(
		infoConnection.GetConnection(),infoConnection.GetUser(),infoConnection.GetPassword());
	}
    }

    public Boolean CreateTableFromFile(String file) {
        FileUtils f = new FileUtils();
	String content = f.GetContentFile(file);
	if (content.equals("")) {
            exception = new Exception("File content is empyu");
            return false;
        }
        Statement stmt;
        try {
		stmt = connection.createStatement();
		stmt.executeUpdate(content);
		stmt.close();
        } catch(SQLException e) {
            exception = e;
            return false;
        }

        return false;
    }

    public Boolean Close() {
	    try {
		    if(connection != null && !connection.isClosed()) {
			connection.close();
			return true;
		    }
	    } catch (SQLException e) {
		    exception = e;
	    }
	    return false;
    }
    
    public Exception GetLastException() {
        return exception;
    }
}
