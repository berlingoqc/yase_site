/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

import com.google.gson.Gson;
import java.io.InputStream;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author wq
 */
public class YaseDB extends MyBD {
	
	private static final String QUERY_add_texture = "INSERT INTO yase_texture(USER_ID,name,data) VALUES ( ? , ? , ? )";
	private static final String QUERY_add_skybox = "INSERT INTO yase_skybox(USER_ID,name,back_data,bot_data,front_data,left_data,right_data,top_data VALUES(?,?,?,?,?,?,?,?)";
	private static final String QUERY_add_model = "INSERT INTO yase_model(USER_ID,name,data) VALUES(?,?,?)";
	private static final String QUERY_yase_config = "INSERT INTO yase_config(USER_ID,name,data) VALUES(?,?,?)";
	
	public static AccountDB getAccountDBInstance() throws SQLException, ClassNotFoundException {
		// Va cherche la config de connection pour crée une db
		SettingsDB s = new SettingsDB();
		if(!s.OpenConfig()) return null;
		ConnectionInfo ci = s.getConnectionInfo();
		AccountDB d = new AccountDB(ci);
		d.OpenIfClose();
		return d;
	}
	
	public YaseDB(ConnectionInfo info) throws SQLException, ClassNotFoundException {
		super(info);
	}
	
	
	public void AddNewTexture(int user_id,String filename, InputStream is) throws SQLException {
		
	}
	
}
