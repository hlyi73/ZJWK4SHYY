package com.takshine.wxcrm.template;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import org.beetl.core.Configuration;
import org.beetl.core.GroupTemplate;
import org.beetl.core.Template;
import org.beetl.core.resource.ClasspathResourceLoader;

public class TemplateUtils {
	public static final ClasspathResourceLoader resourceLoader = new ClasspathResourceLoader();
	public static GroupTemplate grouptemplate = null;
	
	
	private static final GroupTemplate getGroupTemplate() throws IOException{
		if (grouptemplate == null){
			Configuration cfg = Configuration.defaultConfiguration();
			grouptemplate = new GroupTemplate(resourceLoader, cfg);
		}
		return grouptemplate;
	}
	
	public static final Template getTemplate(String templatefile) throws IOException{
		return getGroupTemplate().getTemplate(String.format("/com/takshine/wxcrm/template/%s",templatefile));
	}

	
	public static final String getTemplateResult(String templatefile,Map<String,Object> data) throws IOException{
		Template t = getTemplate(templatefile);
		t.binding(data);
		return t.render();
	}

	
	public static final void main(String[] args) throws IOException{
		//StringTemplateResourceLoader resourceLoader = new StringTemplateResourceLoader();
		Map<String,Object> shared = new HashMap<String,Object>();
		shared.put("name", "beetl");
		System.out.println(getTemplateResult("test.btl",shared));
		System.out.println(getTemplateResult("test1.btl",shared));

	}
}
