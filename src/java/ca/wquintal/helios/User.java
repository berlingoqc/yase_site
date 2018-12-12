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
public class User {
	public static final int ROLE_ADMIN = 2;
	public static final int ROLE_NORMAL = 1;
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public int getRole() {
		return role;
	}

	public void setRole(int role) {
		this.role = role;
	}
	private String username;
	private String password;
	private int role;
        public User() {
            
        }
        
	public User(String username, String passsword) {
		this.username = username;
		this.password = password;
		this.role = ROLE_NORMAL;
	}
	public User(String username, String password, int role) {
		this.username = username;
		this.password = password;
		this.role = role;
	}
}
