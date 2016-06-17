package com.takshine.wxcrm.base.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class HtmlParser {
	public static void main(String[] args) throws IOException {
		for(String url : getAllLink("http://www.sina.com.cn")){
			print("%s",url);
		}
	}
	
    public static Set<String> getAllLink(String url) throws IOException {
//        Validate.isTrue(args.length == 1, "usage: supply url to fetch");
    	Set<String> retset  = new HashSet<String>();
 
        Document doc = Jsoup.connect(url).get();
        Elements links = doc.select("a[href]");
        Elements media = doc.select("[src]");
        Elements imports = doc.select("link[href]");
 
        //print("\\nMedia: (%d)", media.size());
        for (Element src : media) {
        	retset.add( src.attr("abs:src"));
            //if (src.tagName().equals("img"))
               // print(" * %s: <%s> %sx%s (%s)",
                 //       src.tagName(), src.attr("abs:src"), src.attr("width"), src.attr("height"),
                   //     trim(src.attr("alt"), 20));
            	
           // else
                //print(" * %s: <%s>", src.tagName(), src.attr("abs:src"));
        }
 
        //print("\\nImports: (%d)", imports.size());
        for (Element link : imports) {
        	retset.add( link.attr("abs:href"));
            //print(" * %s <%s> (%s)", link.tagName(),link.attr("abs:href"), link.attr("rel"));
        }
 
        //print("\\nLinks: (%d)", links.size());
        for (Element link : links) {
        	retset.add( link.attr("abs:href"));
          //  print(" * a: <%s>  (%s)", link.attr("abs:href"), trim(link.text(), 35));
        }
        return retset;
    }
 
    private static void print(String msg, Object... args) {
        System.out.println(String.format(msg, args));
    }
 
    private static String trim(String s, int width) {
        if (s.length() > width)
            return s.substring(0, width-1) + ".";
        else
            return s;
    }
}
