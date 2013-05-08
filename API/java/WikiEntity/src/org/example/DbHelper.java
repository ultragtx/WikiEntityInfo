package org.example;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.Statement;

public class DbHelper {
	
	private Connection conn;
	public DbHelper() throws ClassNotFoundException, SQLException {
		String driver = "com.mysql.jdbc.Driver";
		String url = "jdbc:mysql://localhost/wikientity?characterEncoding=utf8";
		String user = "root";
		String passwd = "";
		Class.forName(driver);
		conn = (Connection) DriverManager.getConnection(url, user, passwd);
	}
	
	public Page pageWithTitleLang(String title, String lang) throws SQLException {
		Page page = null;
		StringBuilder builder = new StringBuilder();
		builder.append(String.format("select * from  %s_pages where title = \"%s\"", lang, title));
		// System.out.println(builder.toString());
		Statement statement = (Statement) conn.createStatement();
		ResultSet rs = statement.executeQuery(builder.toString());
		if (rs.next()) {
			page = pageWithResultSet(rs, lang);
		}
		
		return page;
	}
	
	public ArrayList<Page> searchPagesWithTitleLang(String title, String lang) throws SQLException {
		ArrayList<Page> pages = new ArrayList<Page>();
		StringBuilder builder = new StringBuilder();
		builder.append(String.format("select * from  %s_pages where title like \"%s\"", lang, title));
		// System.out.println(builder.toString());
		Statement statement = (Statement) conn.createStatement();
		ResultSet rs = statement.executeQuery(builder.toString());
		while(rs.next()) {
			pages.add(pageWithResultSet(rs, lang));
		}
		return pages;
	}
	
	public ArrayList<Page> searchPagesWithAliasNameLang(String aliasName, String lang) throws SQLException {
		ArrayList<Page> pages = new ArrayList<Page>();
		StringBuilder builder = new StringBuilder();
		builder.append(String.format("select * from  %s_pages where aliases like \"%s\"", lang, aliasName));
		// System.out.println(builder.toString());
		Statement statement = (Statement) conn.createStatement();
		ResultSet rs = statement.executeQuery(builder.toString());
		while(rs.next()) {
			pages.add(pageWithResultSet(rs, lang));
		}
		return pages;
	}
	
	public ArrayList<Page> searchPagesWithTypeLang(String type, String lang) throws SQLException {
		ArrayList<Page> pages = new ArrayList<Page>();
		StringBuilder builder = new StringBuilder();
		builder.append(String.format("select * from  %s_pages where infobox_type like \"%s\"", lang, type));

		// System.out.println(builder.toString());
		Statement statement = (Statement) conn.createStatement();
		ResultSet rs = statement.executeQuery(builder.toString());
		while(rs.next()) {
			pages.add(pageWithResultSet(rs, lang));
		}
		return pages;
	}
	
	
	private Page pageWithResultSet(ResultSet rs, String lang) throws SQLException {
		String title = rs.getString("title");
		String redirect = rs.getString("redirect");
		String infoboxType = rs.getString("infobox_type");
		String properties = rs.getString("properties");
		String aliases = rs.getString("aliases");
		String categories = rs.getString("categories");
		String forienAliases = rs.getString("aliases_forien");
		String sha1 = rs.getString("sha1");
		Page page = new Page(title, redirect, infoboxType, properties, aliases, categories, forienAliases, sha1, lang);
		return page;
	}
	
}
