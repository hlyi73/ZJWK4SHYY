package com.takshine.wxcrm.domain;

import java.io.Serializable;

public class Pair<A, B> implements Serializable {
	private static final long serialVersionUID = 1L; 
	// need to change
	private A first;
	private B second;
	public Pair (A first, B second){
		this.first = first;
		this.second = second;
	}
	public A first(){
		return first;
	}
	
	public B second(){
		return second;
	}
}