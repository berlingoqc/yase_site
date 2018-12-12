/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

import com.google.gson.Gson;
import com.google.gson.JsonIOException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

/**
 *
 * @author william
 */
public class SettingsDB {

    public ConnectionInfo getConnectionInfo() {
        return ConnectionInfo;
    }

    public void setConnectionInfo(ConnectionInfo ConnectionInfo) {
        this.ConnectionInfo = ConnectionInfo;
    }

    public Boolean getIsInit() {
        return IsInit;
    }

    public Exception getLastException() {
        return LastException;
    }

    
    public static final String FileName = "dbsettings.json";
    
    private ConnectionInfo ConnectionInfo = null;
    private Boolean IsInit = false;
    private Exception LastException = null;
    
    public SettingsDB() {
       
    }
    
    public Boolean Exists() {
       return new File(FileName).exists();
    }
    
    public Boolean Delete() {
	    File f = new File(FileName);
	    return f.delete();
    }
    
    public Boolean OpenConfig() {
        File f = new File(FileName);
        IsInit = f.exists();
        if(IsInit) {
            // essaye de lire le continue des settings
                BufferedReader br = null;
                ConnectionInfo ci = null;
		try {
			br = new BufferedReader(new FileReader(f));
                        Gson g = new Gson();
                        ci = g.fromJson(br, ConnectionInfo.class);
		} catch (Exception e) {
			LastException = e;
			return false;
		}  finally {
			try {
				if (br != null) {
					br.close();
				}
			} catch (IOException e) {
				LastException = e;
                                return false;
			}
		}
                ConnectionInfo = ci;
                return true;
        }
        return false;
    }
    
    public Boolean SaveConfig(ConnectionInfo con) {
        
        String v = "";
        Gson g = new Gson();
        v = g.toJson(con,ConnectionInfo.class);
        
        Exception e = FileUtils.WriteToFile(FileName, v);
        if (e != null) {
            LastException = e;
            return false;
        }
        ConnectionInfo = con;
        return true;
    }
}
