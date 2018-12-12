/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import sun.security.util.Length;

/**
 *
 * @author wq
 */
public class FileUtils {

	public class OnIoException {

		public void IoException(IOException e) {
			System.out.print("IOException : " + e.getLocalizedMessage());
		}
	}
	
	public static Boolean IsDirectoryValid(String path) {
		File f = new File(path);
		return f.isDirectory();
	}

	public static String FileContent(String file) throws IOException {
		StringBuilder b = new StringBuilder();
		BufferedReader br = new BufferedReader(new FileReader(file));
		String readLine;
		while ((readLine = br.readLine()) != null) {
			b.append(readLine);
		}
		return b.toString();
	}

	public enum FileType {
		Folder,
		File,
		Both;
	}

	private String mRootDirectory;

	private OnIoException mOnIoException;

	public String getmRootDirectory() {
		return mRootDirectory;
	}

	public void setmRootDirectory(String mRootDirectory) {
		this.mRootDirectory = mRootDirectory;
	}

	public OnIoException getmOnIoException() {
		return mOnIoException;
	}

	public void setmOnIoException(OnIoException mOnIoException) {
		this.mOnIoException = mOnIoException;
	}

	public FileUtils() {
		mRootDirectory = System.getProperty("user.dir");
		mOnIoException = new OnIoException();
	}

	public FileUtils(String root) {
		mRootDirectory = root;
	}

	public File[] GetFilesWorkspace() {
		File folder = new File(mRootDirectory);
		if (!folder.isDirectory()) {
			return null;
		}
		return folder.listFiles();
	}

	public File CreateNewDirectory(String name, Boolean overwrite) {
		return CreateNewFile(name, overwrite, FileType.Folder);
	}

	public File CreateNewFile(String file, Boolean overwrite, FileType type) {
		File fileLog = new File(mRootDirectory, file);
		if (!fileLog.exists()) {
			try {
				switch (type) {
					case Folder:
						if (fileLog.mkdir()) {
							return fileLog;
						}
						break;
					case File:
						if (fileLog.createNewFile()) {
							return fileLog;
						}
						break;
					default:
						// invalide type wtf 
						break;
				}
			} catch (IOException e) {
				return null;
			}
		} else if (overwrite) {
			if (fileLog.delete()) {
				return CreateNewFile(file, false);
			}
			return null;
		}

		return fileLog;
	}

	public File CreateNewFile(String file, Boolean overwrite) {
		return CreateNewFile(file, overwrite, FileType.File);
	}

	public Boolean Mv(String file, String newRoot) {
		File f = CreateNewFile(file, false);
		if (f == null)
			return false;
		File fn = new File(mRootDirectory+"/"+newRoot, f.getName());

		return f.renameTo(fn);
	}

	public Boolean Cp(String file, String newRoot) {
		File f = CreateNewFile(file, false);
		if(f == null) {
			return false;
		}
		File dst = CreateNewFile(newRoot+"/"+f.getName(), true);
		if (dst == null) {
			return false;
		}
		InputStream is = null;
		OutputStream os = null;
		try {
			is = new FileInputStream(f);
			os = new FileOutputStream(dst);
			byte[] buffer = new byte[1024];
			int l;
			while ((l = is.read(buffer)) > 0) {
				os.write(buffer, 0, l);
			}

		} catch (IOException e) {

		} finally {
			try {
				if (is != null)
					is.close();
				if (os != null)
					os.close();
			} catch (IOException e) {

			}
		}
		return false;
	}

	public Boolean RenameFile(String oldname, String newname) {
		File f = CreateNewFile(oldname, false);
		File fnew = CreateNewFile(oldname, false);
		if (f == null || fnew == null) {
			return false;
		}
		return f.renameTo(fnew);
	}

	public Boolean DeleteFile(String name) {
		File f = CreateNewFile(name, false);
		if (f != null) {
			return f.delete();
		}
		return false;
	}

	public String[] GetAllLinesFile(String file) {
		BufferedReader br = null;
		String readLine = "";
		List<String> listString = new ArrayList();

		try {
			File f = CreateNewFile(file, false);
			br = new BufferedReader(new FileReader(f));
			while ((readLine = br.readLine()) != null) {
				listString.add(readLine);
			}
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				if (br != null) {
					br.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return listString.toArray(new String[0]);
	}
	
	public String GetContentFile(String file) {
		File f = new File(mRootDirectory,file);
		StringBuilder b = new StringBuilder();
		try {
		BufferedReader br = new BufferedReader(new FileReader(f));
		String readLine;
		while ((readLine = br.readLine()) != null) {
			b.append(readLine);
		}
		} catch(Exception e) {
			return "";
		}
		return b.toString();
	}

	public Boolean WriteLineFile(String file, String line) {
		File f = new File(mRootDirectory,file);
		FileWriter fw = null;
		BufferedWriter bw = null;
		PrintWriter out = null;
		try {
			fw = new FileWriter(f,true);
			bw = new BufferedWriter(fw);
			bw.append(line);
			bw.newLine();
			bw.flush();
		} catch (IOException e) {
			return false;
		} finally {
			try {
				if (fw != null) {
					fw.close();
				}
				if (bw != null) {
					bw.close();
				}
			} catch (IOException e) {
				// log erreur de close
			}
		}
		return true;
	}
        
        
        public static Exception WriteToFile(String file, String content) {
                File f = new File(file);
		FileWriter fw = null;
		BufferedWriter bw = null;
		PrintWriter out = null;
		try {
			fw = new FileWriter(f,true);
			bw = new BufferedWriter(fw);
			bw.write(content);
			bw.newLine();
			bw.flush();
		} catch (IOException e) {
			return e;
		} finally {
			try {
				if (fw != null) {
					fw.close();
				}
				if (bw != null) {
					bw.close();
				}
			} catch (IOException e) {
				// log erreur de close
                                return e;
                        }
		}
		return null;
        }

}
