package com.takshine.wxcrm.base.util.runtime;

import java.util.List;
import java.util.Queue;

import com.takshine.core.service.exception.CRMException;

public class ThreadExecute {
	protected static final Queue<ThreadRun> threadQueue = new java.util.concurrent.ConcurrentLinkedQueue<ThreadRun>();
	protected static final List<ThreadRun> threadrunning = new java.util.concurrent.CopyOnWriteArrayList<ThreadRun>();
	public static final int MAX_POOL_SIZE = 200;
	
	private static boolean stop = false;
	
	static{
		new Thread(){
			public void run(){
				while(!stop){
					try {
						ThreadExecute.run();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}.start();
	}
	
	public static void setStop(boolean stop) {
		ThreadExecute.stop = stop;
	}
	public static final void push(ThreadRun run){
		threadQueue.add(run);
	}
	protected static final void run() throws Exception{
		while(threadQueue.size() > 0){
			while(threadrunning.size()>=MAX_POOL_SIZE){
				Thread.sleep(2);
			}
			final ThreadRun run = threadQueue.poll();
			new Thread(){
				public void run(){
					try {
						run.run();
					} catch (CRMException e) {
						e.printStackTrace();
					}finally{
						threadrunning.remove(run);
					}
				}
			}.start();
			threadrunning.add(run);
		}
		Thread.sleep(100);
	}
	
	public static final void main(String[] args) throws InterruptedException{
		class MyThreadRun implements ThreadRun{
			public String key;
			public MyThreadRun(String key){
				this.key = key;
			}
			public void run() throws CRMException {
				System.out.println(String.format("=================> %s", key));
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
		}
		for(int i = 0 ;i < 100; i++){
			ThreadRun run = new MyThreadRun(String.format("%d", i));
			ThreadExecute.push(run);
		}
		while(true){
			System.out.println(String.format("------------ %d     %d", threadQueue.size(),threadrunning.size()));
			Thread.sleep(10);
		}
		//ThreadRun r=new SMSSentThread("12313","15399900611","你好！！！！"); 
		//ThreadExecute.push(r);
		//Thread.sleep(20000);
		//ThreadExecute.setStop(true);
	}
}
