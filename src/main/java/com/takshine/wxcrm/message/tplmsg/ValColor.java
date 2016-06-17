package com.takshine.wxcrm.message.tplmsg;

public class ValColor {
	
	private String value = "";
	private String color = "";
	
	public ValColor(String v, String c){
		this.value = v;
		this.color = c;
	}
	
	public ValColor(){
	
	}
	
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	
	
}
