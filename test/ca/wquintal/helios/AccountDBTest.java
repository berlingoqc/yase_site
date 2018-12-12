/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

import org.junit.Test;
import ca.wquintal.helios.MyBD;
import static org.junit.Assert.*;

/**
 *
 * @author wq
 */
public class AccountDBTest {
	
	private final ConnectionInfo ci = new ConnectionInfo("192.168.0.2", "helios_test", "wq", "ordinateur", MyBD.Drivers[0]);

	public AccountDBTest() {
		
	}
	

	@Test
	public void testAdminExists() throws Exception {
		AccountDB db = new AccountDB(ci);
		Boolean b = db.DoesAccountExists("admin");
		// Doit retourner false
		assertEquals(false, b);
	}

	@Test
	public void testCreateAdminAccount() throws Exception {
		AccountDB db = new AccountDB(ci);
		db.CreateAdminAccount("petancle");
		Boolean b = db.DoesAccountExists("admin");
		assertEquals(true, b);
		
		
		Boolean bad = false;
		// essaye de le recrée et valide que l'exception ce leve
		try {
			db.CreateAdminAccount("petancle");
		} catch (AccountDB.AccountAlreadyExistsException e) {
			bad = true;
		}
		assertEquals(true, bad);
	}

	@Test
	public void testLoginUser() throws Exception {
		AccountDB db = new AccountDB(ci);
		
		String ret = db.LoginUser("admin", "petancle");
		if(ret == null || ret.length() == 0) throw new Exception("Fail to return ik");
		
		// test avec un mauvais non de compte
		Boolean bad = false;
		try {
			db.LoginUser("dasda", "");
		} catch (AccountDB.AccountDontExistsException e) {
			bad = true;
			
		}
		
		assertEquals(true, bad);
		bad = false;
		
		try {
			db.LoginUser("admin", "prot");
		} catch (AccountDB.BadPasswordException e) {
			bad = true;
		}
		
		assertEquals(true, bad);
	}

	@Test
	public void testIsValidUser() throws Exception {
		int id = 1;
		String data = "vUqtyVbNLNVNn48Fe7yCATvQ0KidGzLp3plAloITn7Y=$XXqlWkpSZcXKiRWnrWh1nCtia9yOuAinjU6t+fXIQqc=";
		AccountDB db = new AccountDB(ci);
		if(!db.IsValidUser(id, data)) throw new Exception("Invalide data or id");
		data = "vUqtyVbNLNVNn48Fe7yCATvQ0KidGzLp3plAloITn7Y=$XXqlWkpSZcXKiRWnrWh1nCtia9yOuAinjU6t+fXIQqc";
		if(db.IsValidUser(id, data)) throw new Exception("Invalide data or id");

	}
	
}
