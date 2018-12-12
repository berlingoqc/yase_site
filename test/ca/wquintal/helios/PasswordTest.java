/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author wq
 */
public class PasswordTest {
	
	public PasswordTest() {
	}

	@Test
	public void testGetSaltedHash() throws Exception {
		String s = Password.getSaltedHash("petancle");
		if(s == null || s.length() == 0) throw new Exception("fail to generate hash");
		if(!Password.check("petancle",s)) throw new Exception("failt to check pw");
		if(Password.check("petanc",s)) throw new Exception("validate invalide pw");
		
	}

	
}
