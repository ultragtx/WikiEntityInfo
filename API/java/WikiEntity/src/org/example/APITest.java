package org.example;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

public class APITest {
	private static DbHelper dbhelper;
	
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		dbhelper = new DbHelper();
		
		test1();
		test2();
		test3();
	}
	
	private static void test1() throws SQLException {
		System.out.println("=======Single Page=======");
		Page page = dbhelper.pageWithTitleLang("中国移动", "zh");
		System.out.println(page);
		System.out.println("=========================\n");
	}
	
	private static void test2() throws SQLException {
		System.out.println("=======Search Page=======");
		ArrayList<Page> pages = dbhelper.searchPagesWithTitleLang("%中国%", "zh");
		int i = 0;
		Iterator<Page> iter = pages.iterator();
		while(iter.hasNext()) {
			System.out.println(String.format("--[%d]--", i));
			Page p = iter.next();
			System.out.println(p);
		}
		
		System.out.println("=========================");
	}
	
	private static void test3() throws SQLException {
		System.out.println("=======Search Type=======");
		ArrayList<Page> pages = dbhelper.searchPagesWithTypeLang("Company", "zh");
		int i = 0;
		Iterator<Page> iter = pages.iterator();
		while(iter.hasNext()) {
			System.out.println(String.format("--[%d]--", i));
			Page p = iter.next();
			System.out.println(p);
		}
		
		System.out.println("=========================");
	}
}
