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
import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author wq
 */
public class YaseDB extends MyBD {
	
	
	public class Texture {

		public byte[] getData() {
			return data;
		}

		public void setData(byte[] data) {
			this.data = data;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getCategory() {
			return category;
		}

		public void setCategory(String category) {
			this.category = category;
		}

		public int getWidth() {
			return width;
		}

		public void setWidth(int width) {
			this.width = width;
		}

		public int getHeight() {
			return height;
		}

		public void setHeight(int height) {
			this.height = height;
		}

		public int getChannels() {
			return channels;
		}

		public void setChannels(int channels) {
			this.channels = channels;
		}
		public Texture() {}
		public Texture(String n, String c,int w,int h,int ch, byte[] data)
		{
			name = n; category = c; width = w; height = h;channels = ch;
		}
		private byte[] data;
 		private String name;
		private String category;
		private int width;
		private int height;
		private int channels;
		
	}
	
	private static final String QUERY_add_texture =		"INSERT INTO yase_texture(USER_ID,name,category,width,height,channels,data_img) VALUES ( ? , ? , ? , ? , ?, ? , ? )";
	private static final String QUERY_add_skybox =		"INSERT INTO yase_skybox(USER_ID,name,back_data,bot_data,front_data,left_data,right_data,top_data) VALUES(?,?,?,?,?,?,?,?)";
	private static final String QUERY_add_model =		"INSERT INTO yase_model(USER_ID,name,data) VALUES(?,?,?)";
	private static final String QUERY_add_loaded_texture =  "INSERT INTO yase_loaded_texture(USER_ID,name,filename) VALUES(?,?,?)";
	private static final String QUERY_add_yase_config =		"INSERT INTO yase_config(USER_ID,name,data) VALUES(?,?,?)";
	
	private static final String QUERY_available_loaded =    "SELECT name,filename FROM yase_loaded_texture WHERE USER_ID = ?";
	
	private static final String QUERY_available_model = "SELECT name FROM yase_model WHERE USER_ID = ?";
	
	private static final String QUERY_get_model = "SELECT data FROM yase_model WHERE USER_ID = ? AND name = ?";
	
	private static final String QUERY_get_config =		"SELECT data FROM yase_config WHERE USER_ID = ?";
	
	private static final String QUERY_available_skybox =	"SELECT name FROM yase_skybox WHERE USER_ID = ?";
	private static final String QUERY_skybox_face =		"SELECT ? FROM yase_skybox WHERE USER_ID = ? AND name = ?";
	private static final String QUERY_available_texture =	"SELECT name FROM yase_texture WHERE USER_ID = ?";
	private static final String QUERY_get_texture_data =	"SELECT name,category,width,height,channels,data_img FROM yase_texture WHERE USER_ID = ? AND name = ?";
	
	public static YaseDB getDBInstance() throws SQLException, ClassNotFoundException {
		// Va cherche la config de connection pour crée une db
		SettingsDB s = new SettingsDB();
		if(!s.OpenConfig()) return null;
		ConnectionInfo ci = s.getConnectionInfo();
		YaseDB d = new YaseDB(ci);
		d.OpenIfClose();
		return d;
	}
	
	public YaseDB(ConnectionInfo info) throws SQLException, ClassNotFoundException {
		super(info);
	}
	
	public void AddSkybox(int user_id,String name,InputStream d_back,InputStream d_bot,InputStream d_front, InputStream d_left, InputStream d_right, InputStream d_top) throws SQLException {
		PreparedStatement s = connection.prepareStatement(QUERY_add_skybox);
		s.setInt(1, user_id);
		s.setString(2, name);
		s.setBlob(3, d_back);
		s.setBlob(4, d_bot);
		s.setBlob(5, d_front);
		s.setBlob(6, d_left);
		s.setBlob(7, d_right);
		s.setBlob(8, d_top);
		s.executeUpdate();
	}
	
	public List<String> GetSkyBoxList(int user_id) throws SQLException {
		List<String> lt = new ArrayList<>();
		PreparedStatement s = connection.prepareStatement(QUERY_available_skybox);
		s.setInt(1, user_id);
		ResultSet rs = s.executeQuery();
		while(rs.next()) {
			lt.add(rs.getString(1));
		}
		return lt;
	}
	
	public List<String> GetLoadedTextureList(int user_id) throws SQLException {
		List<String> lt = new ArrayList<>();
		PreparedStatement s = connection.prepareStatement(QUERY_available_loaded);
		s.setInt(1, user_id);
		ResultSet rs = s.executeQuery();
		while(rs.next()) {
			String ss = "";
			ss += rs.getString(1);
			ss += ";";
			ss += rs.getString(2);
			lt.add(ss);
		}
		return lt;	
	}
	
	public void AddLoadedTexture(int user_id,String name, String filename) throws SQLException {
		PreparedStatement ps = connection.prepareStatement(QUERY_add_loaded_texture);
		ps.setInt(1, user_id);
		ps.setString(2, name);
		ps.setString(3, filename);
		ps.executeUpdate();
	
	
	}
	
	public List<String> GetModelList(int user_id) throws SQLException {
		List<String> lt = new ArrayList<>();
		PreparedStatement s = connection.prepareStatement(QUERY_available_model);
		s.setInt(1, user_id);
		ResultSet rs = s.executeQuery();
		while(rs.next()) {
			lt.add(rs.getString(1));
		}
		return lt;	
	}
	
	
	public byte[] GetModelData(int user_id, String name) throws SQLException {
		PreparedStatement s = connection.prepareStatement(QUERY_get_model);
		s.setInt(1, user_id);
		s.setString(2, name);
		ResultSet rs = s.executeQuery();
		if(!rs.first()) return null;
		return rs.getBytes(1);
	}
	
	public void AddModel(int user_id,String name,InputStream is) throws SQLException {
		PreparedStatement ps = connection.prepareStatement(QUERY_add_model);
		ps.setInt(1, user_id);
		ps.setString(2, name);
		ps.setBlob(3, is);
		ps.executeUpdate();
	}
	
	
	public byte[] GetSkyBoxFace(int user_id,String name,int face) throws SQLException {
		byte[] b = null;
		String s = "bot_data";
		switch(face) {
			case 0: s = "back_data"; break;
			case 1: s = "bot_data"; break;
			case 2: s = "front_data"; break;
			case 3: s = "left_data"; break;
			case 4: s = "right_data"; break;
			case 5: s = "top_data"; break;
		}
		PreparedStatement st = connection.prepareStatement(QUERY_skybox_face);
		st.setString(1, s);
		st.setInt(2, user_id);
		st.setString(3, name);
		ResultSet rs = st.executeQuery();
		if(!rs.first()) return null;
		return rs.getBytes(1);
	}
	
	public void AddEnvironmentConfig(int user_id,InputStream data) throws SQLException {
		PreparedStatement s = connection.prepareStatement(QUERY_add_yase_config);
		s.setInt(1, user_id);
		s.setString(2, "default");
		s.setBlob(3, data);
		s.executeUpdate();
	}
	
	public byte[] GetEnvironmentConfig(int user_id) throws SQLException {
		PreparedStatement s = connection.prepareStatement(QUERY_get_config);
		s.setInt(1, user_id);
		ResultSet rs = s.executeQuery();
		if(!rs.first()) return null;
		
		return rs.getBytes(1);
	}
	
	public Texture GetTexture(int user_id,String name) throws SQLException {
		PreparedStatement s = connection.prepareStatement(QUERY_get_texture_data);
		s.setInt(1, user_id);
		s.setString(2, name);
		ResultSet rs = s.executeQuery();
		if(!rs.first()) return null;
		Texture t = new Texture();
		t.setName(rs.getString(1));
		t.setCategory(rs.getString(2));
		t.setWidth(rs.getInt(3));
		t.setHeight(rs.getInt(4));
		t.setChannels(rs.getInt(5));
		t.setData(rs.getBytes(6));
		return t;
	}
	
	public List<String> GetTextureList(int user_id) throws SQLException {
		List<String> lt = new ArrayList<>();
		PreparedStatement s = connection.prepareStatement(QUERY_available_texture);
		s.setInt(1, user_id);
		ResultSet rs = s.executeQuery();
		while(rs.next()) {
			lt.add(rs.getString(1));
		}
		return lt;
	}
	
	
	public void AddNewTexture(int user_id,String filename,String category, int width, int height, int channel ,InputStream is) throws SQLException {
		//connection.setAutoCommit(false);
		PreparedStatement ps = connection.prepareStatement(QUERY_add_texture);
		ps.setInt(1, user_id);
		ps.setString(2, filename);
		ps.setString(3, category);
		ps.setInt(4, width);
		ps.setInt(5, height);
		ps.setInt(6,channel);
		ps.setBlob(7, is);
		ps.executeUpdate();
		//connection.commit();
	}
	
}
