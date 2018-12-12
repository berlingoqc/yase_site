/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

import com.google.gson.Gson;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;

/**
 *
 * @author wq
 */
public class AccountDB extends MyBD {
	// Mes exceptions que je throw
	public class AccountAlreadyExistsException extends Exception {}
	public class AccountDontExistsException extends Exception {}
	public class BadPasswordException extends Exception {}
	
	public static AccountDB getAccountDBInstance() throws SQLException, ClassNotFoundException {
		// Va cherche la config de connection pour crée une db
		SettingsDB s = new SettingsDB();
		if(!s.OpenConfig()) return null;
		ConnectionInfo ci = s.getConnectionInfo();
		AccountDB d = new AccountDB(ci);
		d.OpenIfClose();
		return d;
	}
	
	public class Jsonable {
		protected String toJSON() {
			Gson g = new Gson();
			return g.toJson(this);
		}
	}

		
	
	public class IdentityToken extends Jsonable {
		
		private String 	identityHash;
		private int 	generateAt;
		
		private	int	id;
		private int 	role;
		
		public IdentityToken(int id,int role, String identityHash) {
			this.id = id;
			this.role = role;
			this.identityHash = identityHash;
			// pas bon apres 2038 fuck un long
			this.generateAt = (int) (System.currentTimeMillis() / 1000L);
		}
		
		public String getIdentityHash() {
			return identityHash;
		}

		public void setIdentityHash(String identityHash) {
			this.identityHash = identityHash;
		}

		public int getGenerateAt() {
			return generateAt;
		}

		public void setGenerateAt(int generateAt) {
			this.generateAt = generateAt;
		}

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public int getRole() {
			return role;
		}

		public void setRole(int role) {
			this.role = role;
		}

	}

	private static final String QUERY_isusernameexists	= "SELECT COUNT(*) AS nbr FROM account WHERE username = ?";
	private static final String QUERY_isadmincreate 	= "SELECT COUNT(*) AS nbr FROM account WHERE username='admin'";
	private static final String QUERY_createaccount 	= "INSERT INTO account (username,role,psw) VALUES (?,?,?)";

	private static final String QUERY_accountlogin 		= "SELECT ID,psw,role FROM account WHERE username = ?";
	private static final String QUERY_validaccount		= "SELECT * FROM account WHERE ID = ? AND psw = ?";
            
        private static final String QUERY_listaccout            = "SELECT ID,username,role FROM account";

	public AccountDB(ConnectionInfo info) throws SQLException, ClassNotFoundException {
		super(info);
	}
	
	// Indique si le code administrateur existe
	public Boolean DoesAccountExists(String name) throws SQLException {
		Statement stmt = connection.createStatement();
		PreparedStatement statement = connection.prepareStatement(QUERY_isusernameexists);
		statement.setString(1, name);
		ResultSet rs = statement.executeQuery();
		if(!rs.first()) return false;
		int nbrItem = rs.getInt("nbr");
		return nbrItem > 0;
	}

	// CreateAdminAccount crée l'account administrateur s'il n'existe pas deja
	public String CreateAdminAccount(String password) throws SQLException, AccountAlreadyExistsException, Exception {
		return CreateAccount("admin",password,User.ROLE_ADMIN);
	}
	
	
	public String CreateAccount(String username, String password,int role) throws SQLException, AccountAlreadyExistsException, Exception {
		if(DoesAccountExists(username)) throw new AccountAlreadyExistsException();
		// First crée un hashing PBKDF2 pour entreposer le mdp
		String salterpw = Password.getSaltedHash(password);
		PreparedStatement statement = connection.prepareStatement(QUERY_createaccount);
		statement.setString(1, username);
		statement.setInt(2, role);
		statement.setString(3, salterpw);
		statement.executeQuery();
		connection.commit();
		return LoginUser(username,password);
	}

	// Login un user et lui retourne sont token d'identification
	public String LoginUser(String username, String password) throws SQLException, BadPasswordException, 
		AccountDontExistsException, Exception {
		PreparedStatement stmt = connection.prepareStatement(QUERY_accountlogin);
		stmt.setString(1, username);
		ResultSet rs = stmt.executeQuery();
		if(!rs.first()) throw new AccountDontExistsException();
		
		int id = rs.getInt("ID");
		String psw = rs.getString("psw");
		int role = rs.getInt("role");
		rs.close();
		
		// Compare le psw hasher de la db avec celui clair envoyer
		if(!Password.check(password, psw)) throw new BadPasswordException();
		
		// si tout est beau on crée le token
		IdentityToken tk = new IdentityToken(id, role, psw);
		return tk.toJSON();
	}

	// Recoit le token de l'identifiant et valide si l'usager est valide
	public Boolean IsValidUser(int id,String hash) throws SQLException {
		PreparedStatement stmt = connection.prepareStatement(QUERY_validaccount);
		stmt.setInt(1, id);
		stmt.setString(2, hash);
		ResultSet rs = stmt.executeQuery();
		return rs.first();
	}
        
        public List<User> getAllUser() throws SQLException {
            List<User> l = new ArrayList<User>();
            PreparedStatement ps = connection.prepareStatement(QUERY_listaccout);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                User u = new User();
           
            }
            return l;
        }

	// Update le mot de passe d'un account, doit pouvoir entrer son ancien mot de passe
	public void UpdateAccountPassword(int id,String oldpw,String newpw) throws SQLException, 
		BadPasswordException {
		
	}
	
	// Delete un account avec le id
	public void DeleteAccount(int id) throws SQLException, AccountDontExistsException {
	
	
	
	}
	
	public void DeleteAll() throws SQLException {
		Statement s = connection.createStatement();
		s.executeQuery("DELETE FROM account");
	}
	
	
}
