package org.example;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Page {
	public String title, redirect;
	public String infoboxType;
	public HashMap<String, String> properties;
	public ArrayList<String> aliases;
	public ArrayList<String> categories;
	public HashMap<String, String> forienAliases;
	public String sha1;
	public String lang;
	
	public Page(String title, String redirect, String infoboxType, String properties, 
			String aliases, String categories, String forienAliases, String sha1, String lang) {
		this.title = title;
		this.redirect = redirect;
		this.infoboxType = infoboxType;
		this.properties = convertPropertyStr2Map(properties);
		this.forienAliases = convertForienAliasesStr2Map(forienAliases);
		this.aliases = convertStr2List(aliases);
		this.categories = convertStr2List(categories);
		this.sha1 = sha1;
		this.lang = lang;
	}
	
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append(String.format("title: %s\n", this.title));
		builder.append(String.format("lang: %s\n", this.lang));
		builder.append(String.format("redirect: %s\n", this.redirect));
		builder.append(String.format("sha1: %s\n", this.sha1));
		builder.append(String.format("infoboxType: %s\n", this.infoboxType));
		builder.append("\n");
		builder.append("properties: \n");
		Iterator<Entry<String, String>> propIter = this.properties.entrySet().iterator();
		while (propIter.hasNext()) {
			Map.Entry<String, String> entry = propIter.next();
			String key = entry.getKey();
			String value = entry.getValue();
			builder.append(String.format("%s: %s\n", key, value));
		}
		builder.append("\n");
		
		builder.append("aliases: \n");
		Iterator<String> aliasesIter = this.aliases.iterator();
		while(aliasesIter.hasNext()) {
			String alias = aliasesIter.next();
			builder.append(alias);
			builder.append("\n");
		}
		builder.append("\n");
		
		builder.append("forienAliases: \n");
		Iterator<Entry<String, String>> forienIter = this.forienAliases.entrySet().iterator();
		while (forienIter.hasNext()) {
			Map.Entry<String, String> entry = forienIter.next();
			String key = entry.getKey();
			String value = entry.getValue();
			builder.append(String.format("%s: %s\n", key, value));
		}
		builder.append("\n");
		
		builder.append("categories: \n");
		Iterator<String> categoriesIter = this.aliases.iterator();
		while(categoriesIter.hasNext()) {
			String category = categoriesIter.next();
			builder.append(category);
			builder.append("\n");
		}
		
		return builder.toString();	
	}
	
	private HashMap<String, String> convertPropertyStr2Map(final String properties) {
		HashMap<String, String> props = new HashMap<String, String>();
		Pattern pattern = Pattern.compile("\"(.*?)\"=>\"(.*?)\"[,\\}]", Pattern.MULTILINE);
		Matcher matcher = pattern.matcher(properties);
		while (matcher.find()) {
			String key = matcher.group(1);
			String value = matcher.group(2);
			props.put(key, value);
		}
		return props;
	}
	
	private ArrayList<String> convertStr2List(final String aliases) {
		ArrayList<String> alias = new ArrayList<String>();
		Pattern pattern = Pattern.compile("\\[\"(.*?)\"\\]", Pattern.MULTILINE);
		Matcher matcher = pattern.matcher(aliases);
		while (matcher.find()) {
			String str = matcher.group(1);
			alias.add(str);
		}
		return alias;
	}
	
	private HashMap<String, String> convertForienAliasesStr2Map(final String forienAliases) {
		HashMap<String, String> foriens = new HashMap<String, String>();
		Pattern pattern = Pattern.compile(":(.*?)=>\"(.*?)\"[,\\}]", Pattern.MULTILINE);
		Matcher matcher = pattern.matcher(forienAliases);
		while (matcher.find()) {
			String key = matcher.group(1);
			String value = matcher.group(2);
			foriens.put(key, value);
		}
		return foriens;
	}

}
