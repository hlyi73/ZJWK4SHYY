package com.takshine.wxcrm.base.util.cache;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import com.takshine.wxcrm.base.util.MailUtils;
import com.takshine.wxcrm.base.util.PropertiesUtil;

/**
 * redis 缓存工具类
 * @author liulin
 *
 */

public class RedisCacheUtil {
	
	private static String host = PropertiesUtil.getAppContext("redis.server.host");
	private static String port = PropertiesUtil.getAppContext("redis.server.port");
	private static String maxIdle = PropertiesUtil.getAppContext("redis.server.maxIdle");
	private static String passwd = PropertiesUtil.getAppContext("redis.server.pass");
	private static String testOnBorrow = PropertiesUtil.getAppContext("redis.server.pool.testOnBorrow");
	private static String testOnReturn = PropertiesUtil.getAppContext("redis.server.pool.testOnReturn");
	
	private static JedisPool jedisPool;
	private static boolean ALIVE = true;
	private static String serverName;
    private static boolean EXCEPTION_FALG = false;
    
    protected static Logger log = Logger.getLogger(MailUtils.class);
	
	static {
		
	    JedisPoolConfig config = new JedisPoolConfig(); 
	    
	    config.setMaxIdle(Integer.valueOf(maxIdle));  
	    config.setTestOnBorrow(Boolean.valueOf(testOnBorrow));  
	    config.setTestOnReturn(Boolean.valueOf(testOnReturn));  
	    
	    jedisPool = new JedisPool(config, host, Integer.valueOf(port),0,passwd);  
	}
	protected static final Map<String,String> cacheMap = new java.util.concurrent.ConcurrentHashMap<String, String>();

	public static void main(String[] args) {
		class B implements java.io.Serializable{
			String ccc = "111111";
		}
		for(int i = 0;i<1; i++){
			try{
				long l = System.currentTimeMillis();
				cacheMap.put("aaa", "aaaaaa");
				
				System.out.println(String.format("1============>>  %d", System.currentTimeMillis() - l));
				l = System.currentTimeMillis();
				
				Object v = cacheMap.get("aaa");
				
				System.out.println(String.format("2============>>  %d  %s", System.currentTimeMillis() - l,v));
			}catch(Exception ec){
				
			}
		}
	}
	
	public void demo(){
		
		// 从池中获取一个Jedis对象  
		Jedis jedis = jedisPool.getResource();  
		String keys = "name";  
		  
		// 删数据  
		jedis.del(keys);  
		// 存数据  
		jedis.set(keys, "snowolf");  
		// 取数据  
		String value = jedis.get(keys);  
		  
		System.out.println(value);  
		  
		// 释放对象池  
		jedisPool.returnResource(jedis);  
		
		//  KEY操作 
        
        //KEYS 
/*        Set keys = redis.keys("*");//列出所有的key，查找特定的key如：redis.keys("foo") 
        Iterator t1=keys.iterator() ; 
        while(t1.hasNext()){ 
            Object obj1=t1.next(); 
            System.out.println(obj1); 
        } 
         
        //DEL 移除给定的一个或多个key。如果key不存在，则忽略该命令。 
        redis.del("name1"); 
         
        //TTL 返回给定key的剩余生存时间(time to live)(以秒为单位) 
        redis.ttl("foo"); 
         
        //PERSIST key 移除给定key的生存时间。 
        redis.persist("foo"); 
         
        //EXISTS 检查给定key是否存在。    
        redis.exists("foo"); 
         
        //MOVE key db  将当前数据库(默认为0)的key移动到给定的数据库db当中。如果当前数据库(源数据库)和给定数据库(目标数据库)有相同名字的给定key，或者key不存在于当前数据库，那么MOVE没有任何效果。 
        redis.move("foo", 1);//将foo这个key，移动到数据库1 
         
        //RENAME key newkey  将key改名为newkey。当key和newkey相同或者key不存在时，返回一个错误。当newkey已经存在时，RENAME命令将覆盖旧值。 
        redis.rename("foo", "foonew"); 
         
        //TYPE key 返回key所储存的值的类型。 
        System.out.println(redis.type("foo"));//none(key不存在),string(字符串),list(列表),set(集合),zset(有序集),hash(哈希表) 
           
        //EXPIRE key seconds 为给定key设置生存时间。当key过期时，它会被自动删除。 
        redis.expire("foo", 5);//5秒过期 
        //EXPIREAT EXPIREAT的作用和EXPIRE一样，都用于为key设置生存时间。不同在于EXPIREAT命令接受的时间参数是UNIX时间戳(unix timestamp)。 
         
        //一般SORT用法 最简单的SORT使用方法是SORT key。 
        redis.lpush("sort", "1"); 
        redis.lpush("sort", "4"); 
        redis.lpush("sort", "6"); 
        redis.lpush("sort", "3"); 
        redis.lpush("sort", "0"); 
         
        List list = redis.sort("sort");//默认是升序 
        for(int i=0;i<list.size();i++){ 
            System.out.println(list.get(i)); 
        }*/   
		
		
    /**  STRING 操作 
     
    //SET key value将字符串值value关联到key。 
    redis.set("name", "wangjun1"); 
    redis.set("id", "123456"); 
    redis.set("address", "guangzhou"); 
     
    //SETEX key seconds value将值value关联到key，并将key的生存时间设为seconds(以秒为单位)。 
    redis.setex("foo", 5, "haha"); 
     
    //MSET key value [key value ...]同时设置一个或多个key-value对。 
    redis.mset("haha","111","xixi","222"); 
      
    //redis.flushAll();清空所有的key 
    System.out.println(redis.dbSize());//dbSize是多少个key的个数 
     
    //APPEND key value如果key已经存在并且是一个字符串，APPEND命令将value追加到key原来的值之后。 
    redis.append("foo", "00");//如果key已经存在并且是一个字符串，APPEND命令将value追加到key原来的值之后。 
     
    //GET key 返回key所关联的字符串值 
    redis.get("foo"); 
     
    //MGET key [key ...] 返回所有(一个或多个)给定key的值 
    List list = redis.mget("haha","xixi"); 
    for(int i=0;i<list.size();i++){ 
        System.out.println(list.get(i)); 
    } 
     
    //DECR key将key中储存的数字值减一。 
    //DECRBY key decrement将key所储存的值减去减量decrement。 
    //INCR key 将key中储存的数字值增一。 
    //INCRBY key increment 将key所储存的值加上增量increment。 
     
    */  
		
		
    /**  Hash 操作 
     
    //HSET key field value将哈希表key中的域field的值设为value。 
    redis.hset("website", "google", "www.google.cn"); 
    redis.hset("website", "baidu", "www.baidu.com"); 
    redis.hset("website", "sina", "www.sina.com"); 
     
    //HMSET key field value [field value ...] 同时将多个field - value(域-值)对设置到哈希表key中。 
    Map map = new HashMap(); 
    map.put("cardid", "123456"); 
    map.put("username", "jzkangta"); 
    redis.hmset("hash", map); 
     
    //HGET key field返回哈希表key中给定域field的值。 
    System.out.println(redis.hget("hash", "username")); 
     
    //HMGET key field [field ...]返回哈希表key中，一个或多个给定域的值。 
    List list = redis.hmget("website","google","baidu","sina"); 
    for(int i=0;i<list.size();i++){ 
        System.out.println(list.get(i)); 
    } 
     
    //HGETALL key返回哈希表key中，所有的域和值。 
    Map<String,String> map = redis.hgetAll("hash"); 
    for(Map.Entry entry: map.entrySet()) { 
         System.out.print(entry.getKey() + ":" + entry.getValue() + "\t"); 
    } 
     
    //HDEL key field [field ...]删除哈希表key中的一个或多个指定域。 
    //HLEN key 返回哈希表key中域的数量。 
    //HEXISTS key field查看哈希表key中，给定域field是否存在。 
    //HINCRBY key field increment为哈希表key中的域field的值加上增量increment。 
    //HKEYS key返回哈希表key中的所有域。 
    //HVALS key返回哈希表key中的所有值。 
      
     */  

		
    /**  LIST 操作 
    //LPUSH key value [value ...]将值value插入到列表key的表头。 
    redis.lpush("list", "abc"); 
    redis.lpush("list", "xzc"); 
    redis.lpush("list", "erf"); 
    redis.lpush("list", "bnh"); 
     
    //LRANGE key start stop返回列表key中指定区间内的元素，区间以偏移量start和stop指定。下标(index)参数start和stop都以0为底，也就是说，以0表示列表的第一个元素，以1表示列表的第二个元素，以此类推。你也可以使用负数下标，以-1表示列表的最后一个元素，-2表示列表的倒数第二个元素，以此类推。 
    List list = redis.lrange("list", 0, -1); 
    for(int i=0;i<list.size();i++){ 
        System.out.println(list.get(i)); 
    } 
     
    //LLEN key返回列表key的长度。 
    //LREM key count value根据参数count的值，移除列表中与参数value相等的元素。 
     */  
		
		
    /**  SET 操作 
    //SADD key member [member ...]将member元素加入到集合key当中。 
    redis.sadd("testSet", "s1"); 
    redis.sadd("testSet", "s2"); 
    redis.sadd("testSet", "s3"); 
    redis.sadd("testSet", "s4"); 
    redis.sadd("testSet", "s5"); 
     
    //SREM key member移除集合中的member元素。 
    redis.srem("testSet", "s5"); 
     
    //SMEMBERS key返回集合key中的所有成员。 
    Set set = redis.smembers("testSet"); 
    Iterator t1=set.iterator() ; 
    while(t1.hasNext()){ 
        Object obj1=t1.next(); 
        System.out.println(obj1); 
    } 
     
    //SISMEMBER key member判断member元素是否是集合key的成员。是（true），否则（false） 
    System.out.println(redis.sismember("testSet", "s4")); 
     
    //SCARD key返回集合key的基数(集合中元素的数量)。 
    //SMOVE source destination member将member元素从source集合移动到destination集合。 
      
    //SINTER key [key ...]返回一个集合的全部成员，该集合是所有给定集合的交集。 
    //SINTERSTORE destination key [key ...]此命令等同于SINTER，但它将结果保存到destination集合，而不是简单地返回结果集 
    //SUNION key [key ...]返回一个集合的全部成员，该集合是所有给定集合的并集。 
    //SUNIONSTORE destination key [key ...]此命令等同于SUNION，但它将结果保存到destination集合，而不是简单地返回结果集。 
    //SDIFF key [key ...]返回一个集合的全部成员，该集合是所有给定集合的差集 。 
    //SDIFFSTORE destination key [key ...]此命令等同于SDIFF，但它将结果保存到destination集合，而不是简单地返回结果集。 
     
     */  
		
		
	}

	public static class MonitorThread extends Thread {
         
        public void run() {
            int sleepTime = 30000;
            int baseSleepTime = 1000;
            while (true) {
                try {
                    // 30秒执行监听
                    int n = sleepTime / baseSleepTime;
                    for (int i = 0; i<n; i++) {
                        if (EXCEPTION_FALG) {// 检查到异常，立即进行检测处理
                            break;
                        }
                        Thread.sleep(baseSleepTime);
                    }
                    // 连续做3次连接获取
                    int errorTimes = 0;
                    for (int i = 0; i < 3; i++) {
                        try {
                            Jedis jedis = jedisPool.getResource();
                            if (jedis == null) {
                                errorTimes++;
                                continue;
                            }
                            returnConnection(jedis);
                            break;
                        } catch (Exception e) {
                            log.error("redis[" + serverName + "] 服务器连接不上！ ！ ！:" + e.getMessage() );
                           errorTimes++;
                            continue;
                        }
                    }
                    if (errorTimes == 3) {// 3次全部出错，表示服务器出现问题
                        ALIVE = false;
                        log.error("redis[" + serverName + "] 服务器连接不上！ ！ ！" );
                        // 修改休眠时间为5秒，尽快恢复服务
                        sleepTime = 5000;
                    } else {
                        if (ALIVE == false) {
                            ALIVE = true;
                            // 修改休眠时间为30秒，尽快恢复服务
                            sleepTime = 30000;
                            log.info("redis[" + serverName + "] 服务器恢复正常！ ！ ！" );
                        }
                        EXCEPTION_FALG = false;
                        Jedis jedis = jedisPool.getResource();
                        log.info("redis[" + serverName + "] 当前记录数：" + jedis.dbSize());
                        returnConnection(jedis);
                    }
                } catch (Exception e) {
                }
            }
        }
    }
     
    /**       
     * 设置连接池       
     * @param 数据源      
     */    
    public void monitorJedisPool(JedisPool JedisPool) {
        // 启动监听线程
        new MonitorThread().start();
    }       
     
    /**       
     * 获取连接池       
     * @return 数据源       
     */    
    public static JedisPool getJedisPool() {
        return jedisPool;      
    }
 
    /**
     * 判断服务器是否活动
     * @return
     */
    public boolean isServerAlive() {
        return ALIVE;
    }
 
    /**
     * 获取连接
     * @return
     */
    public static Jedis getConnection() {
        Jedis jedis = null;
        try {
            if (ALIVE) {// 当前状态为活跃才获取连接，否则直接返回null
                jedis = jedisPool.getResource();
            }
        } catch (Exception e) {
            EXCEPTION_FALG = true;
            new MonitorThread().start();
        }
        return jedis;
    }
     
    /**       
     * 关闭数据库连接       
     * @param conn       
     */    
    public static void returnConnection(Jedis jedis) {          
        if (null != jedis) {             
            try {                  
                jedisPool.returnResource(jedis);              
            } catch (Exception e) {
                jedisPool.returnBrokenResource(jedis);
            }          
        }      
    }  
     
    /**
     * 关闭错误连接
     * @param jedis
     */
    public static void returnBorkenConnection(Jedis jedis) {
        if (null != jedis) {              
            jedisPool.returnBrokenResource(jedis);
        }      
    }
     
     
    /**
     * 设置key-value失效时间，序列化类型key
     * @param key
     * @param seconds
     * @return
     */
    public static long expireObjectKey(Object key, int seconds) {
        return expire(serializable(key), seconds);
    }
     
    /**
     * 设置key-value失效时间，字符串类型key
     * @param key
     * @param seconds
     * @return
     */
    public static long expire(String key, int seconds) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.expire(key, seconds);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
    /**
     * 设置key-value失效时间，字节类型key
     * @param key
     * @param seconds
     * @return
     */
    public static long expire(byte[] key, int seconds) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.expire(key, seconds);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
    /**
     * 检查key是否存在缓存  
     * @param key
     * @return
     */
    public static boolean checkKeyExisted(Object key) {
        Jedis conn = getConnection();
        if (conn == null) {
            return false;
        }
        boolean result = false;
        try {
            if (key instanceof String) {
                if (conn.exists((String)key)) {// 字符串key存在，直接返回
                    returnConnection(conn);
                    return true;
                }
            }
            result = conn.exists(serializable(key));
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return result;
    }
     
    /**
     * 检查key是否存在
     * @param key
     * @return 返回操作后的值
     */
    public static boolean checkKeyExisted(byte[] key) {
        Jedis conn = getConnection();
        if (conn == null) {
            return false;
        }
        boolean result = false;
        try {
            result = conn.exists(key);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return result;
    }
     
    /**
     * 加1操作
     * @param key
     * @return 返回操作后的值
     */
    public static long increase(String key) {
        return increase(key, 1);
    }
     
    /**
     * 加操作，指定加的量
     * @param key
     * @param num
     * @return 返回操作后的值
     */
    public static long increase(String key, int num) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.incrBy(key, num);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
    /**
     * 加1操作
     * @param key
     * @return 返回操作后的值
     */
    public static long increase(byte[] key) {
        return increase(key, 1);
    }
     
    /**
     * 加操作，指定加的量
     * @param key
     * @param num
     * @return
     */
    public static long increase(byte[] key, int num) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.incrBy(key, num);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
    /**
     * 减1操作
     * @param key
     * @return 返回操作后的值
     */
    public static long decrease(String key) {
        return decrease(key, 1);
    }
     
    /**
     * 减操作，指定减的值
     * @param key
     * @param num
     * @return 返回操作后的值
     */
    public static long decrease(String key, int num) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.decrBy(key, num);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
    /**
     * 减1操作
     * @param key
     * @return 返回操作后的值
     */
    public static long decrease(byte[] key) {
        return decrease(key, 1);
    }
     
    /**
     * 减操作，指定减的值
     * @param key
     * @param num
     * @return 返回操作后的值
     */
    public static long decrease(byte[] key, int num) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.decrBy(key, num);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
     
    /**
     * 删除缓存记录，先做字符串判断，不存在再对key做序列化处理
     * @param key
     */
    public static long delete(String key) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.del(key);
            if (result == 0) {
                result = conn.del(serializable(key));
            }
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
    /**
     * 删除缓存记录，直接对key做序列化处理
     * @param key
     * @return
     */
    public static long deleteObjectKey(Object key) {
        return delete(serializable(key));
    }
     
    /**
     * 删除记录
     * @param key
     * @return
     */
    public static long delete(byte[] key) {
        Jedis conn = getConnection();
        if (conn == null) {
            return -1;
        }
        try {
            long result = conn.del(key);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return -1;
    }
     
    /**
     * 设置对象类型缓存项，无失效时间
     * @param key
     * @param value
     */
    public static void set(Object key, Object value) {
        set(serializable(key), serializable(value), -1);
    }
     
    /**
     * 设置对象类型缓存项，加入失效时间，单位为秒
     * @param key
     * @param value
     * @param exp
     */
    public static void set(Object key, Object value, int exp) {
        set(serializable(key), serializable(value), exp);
    }
     
    /**
     * 设置key-value项，字节类型
     * @param key
     * @param value
     */
    public static void set(byte[] key, byte[] value, int exp) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            if (exp > 0) {
                conn.setex(key, exp, value);
            } else {
                conn.set(key, value);
            }
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
 
    /**
     * 获取对象类型
     * @param key
     * @return
     */
    public static  Object get(Object key) {
        byte[] data = get(serializable(key));
        if (data != null) {
            return unserialize(data);
        }
        return null;
    }
     
    /**
     * 获取key value
     * @param key
     * @return
     */
    public static  byte[] get(byte[] key) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            byte[] data = conn.get(key);
            returnConnection(conn);
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 设置字符串类型缓存项
     * @param key
     * @param value
     */
    public static  void setString(String key, String value) {
        setString(key, value, -1);
    }
     
    /**
     * 存储字符串类型缓存项，加入失效时间，单位为秒
     * @param key
     * @param value
     * @param exp
     */
    public static  void setString(String key, String value, int exp) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            if (exp > 0) {
                conn.setex(key, exp, value);
            } else {
                conn.set(key, value);
            }
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 获取字符串类型
     * @param key
     * @return
     */
    public static  String getString(String key) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            String value = conn.get(key);
            returnConnection(conn);
            return value;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 获取所有列表(默认从左边第一个开始)
     * @param listKey
     * @return
     */
    public static  List<Object> getListAll(Object listKey) {
        List<byte[]> data = getListAll(serializable(listKey));
        List<Object> result = new ArrayList<Object>();
        if (data != null && data.size() > 0) {
            for (byte[] item : data) {
                result.add(unserialize(item));
            }
            return result;
        }
        return null;
    }
     
    /**
     * 获取列表所有数据
     * @param listKey
     * @return
     */
    public static  List<byte[]> getListAll(byte[] listKey) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            List<byte[]> data = conn.lrange(serializable(listKey), 0, 1000000000);    // 默认设置一个大数
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 从左边添加到list
     * @param listKey
     * @param value
     */
    public static  void addToListLeft(Object listKey, Object value) {
        addToListLeft(serializable(listKey), serializable(value));
    }
    
    /**
     * 从左边添加到list
     * @param listKey
     * @param value
     */
    public static  void addToListLeft(String listKey, String value) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.lpush(listKey, value);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 从左边添加到list
     * @param listKey
     * @param value
     */
    public static  void addToListLeft(byte[] listKey, byte[] value) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.lpush(listKey, value);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 从右边添加到list
     * @param listKey
     * @param value
     */
    public static  void addToListRight(Object listKey, Object value) {
        addToListRight(serializable(listKey), serializable(value));
    }
     
    /**
     * 从右边添加到list
     * @param listKey
     * @param value
     */
    public static  void addToListRight(byte[] listKey, byte[] value) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.rpush(listKey, value);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
     
    /**
     * 从左边移除一个对象，并返回该对象
     * @param listKey
     * @return
     */
    public static  Object popFromListLeft(Object listKey) {
        return unserialize(popFromListLeft(serializable(listKey)));
    }
     
    /**
     * 从左边移除一个对象，并返回该对象
     * @param listKey
     * @return
     */
    public static  byte[] popFromListLeft(byte[] listKey) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            byte[] data = conn.lpop(listKey);
            returnConnection(conn);
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 从右边移除一个对象，并返回该对象
     * @param listKey
     * @return
     */
    public static  Object popFromListRight(Object listKey) {
        return unserialize(popFromListRight(serializable(listKey)));
    }
     
    /**
     * 从右边移除一个对象，并返回该对象
     * @param listKey
     * @return
     */
    public static  byte[] popFromListRight(byte[] listKey) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            byte[] data = conn.rpop(listKey);
            returnConnection(conn);
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 获取列表长度
     * @param listKey
     * @return
     */
    public static  int getLengthOfList(Object listKey) {
        return getLengthOfList(serializable(listKey));
    }
     
    /**
     * 获取列表长度
     * @param listKey
     * @return
     */
    public static  int getLengthOfList(byte[] listKey) {
        Jedis conn = getConnection();
        if (conn == null) {
            return 0;
        }
        try {
            int length = conn.llen(listKey).intValue();
            returnConnection(conn);
            return length;
        } catch (Exception e) {
            returnBorkenConnection(conn);
            return 0;
        }
    }
     
    /**
     * 获取list某一范围的段
     * @param listKey
     * @param start
     * @param size
     * @return
     */
    public static  List<Object> getListRange(Object listKey, int start, int size) {
        List<byte[]> data = getListRange(serializable(listKey), start, start + size - 1);
        if (data != null && data.size() > 0) {
            List<Object> result = new ArrayList<Object>();
            for (byte[] item : data) {
                result.add(unserialize(item));
            }
            return result;
        }
        return null;
    }
     
    /**
     * 获取list某一范围的段
     * @param listKey
     * @param start
     * @param size
     * @return
     */
    public static  List<byte[]> getListRange(byte[] listKey, int start, int size) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            List<byte[]> data = conn.lrange(listKey, start, start + size - 1);
            returnConnection(conn);
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
            return null;
        }
    }
     
    /**
     * 获取Map结构所有数据
     * @param mapKey
     * @return
     */
    public static  Map<Object, Object> getMapAll(Object mapKey) {
        Map<byte[], byte[]> data = getMapAll(serializable(mapKey));
        if (data != null && data.size() > 0) {
            Map<Object, Object> result = new HashMap<Object, Object>();
            Set<byte[]> keys = data.keySet();
            for (byte[] key : keys) {
                result.put(unserialize(key), unserialize(data.get(key)));
            }
            return result;
        }
        return null;
    }
     
    /**
     * 获取Map结构所有数据
     * @param mapKey
     * @return
     */
    public static  Map<byte[], byte[]> getMapAll(byte[] mapKey) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            Map<byte[], byte[]> data = conn.hgetAll(mapKey);
            returnConnection(conn);
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
            return null;
        }
    }
     
    /**
     * 获取Map结构所有数据(key为String)
     * @param mapKey
     * @return
     */
    public static  Map<String, String> getStringMapAll(String mapKey) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            Map<String,String> result = conn.hgetAll(mapKey);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
            return null;
        }
    }
     
    /**
     * 获取Map所有数据，直接返回未序列化的结果，对一些特殊的应用场景更高效
     * @param mapKey
     * @return
     */
    public static  Map<byte[], byte[]> getMapAllByte(Object mapKey) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            Map<byte[], byte[]> result = conn.hgetAll(serializable(mapKey));
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
            return null;
        }
    }
     
    /**
     * 添加到Map结构
     * @param mapKey
     * @param field
     * @param value
     */
    public static  void putToMap(Object mapKey, Object field, Object value) {
        putToMap(serializable(mapKey), serializable(field), serializable(value));
    }
     
    /**
     * 添加到Map结构
     * @param mapKey
     * @param field
     * @param value
     */
    public static  void putToMap(byte[] mapKey, byte[] field, byte[] value) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.hset(mapKey, field, value);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 添加到Map结构(key为String)
     * @param mapKey
     * @param field
     * @param value
     */
    public static  void putStringToMap(String mapKey, String field, String value) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.hset(mapKey,field,value);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 批量设置到hash数据结果，采用byte类型存储，
     * 取的时候得注意数据类型转换（例如：Map<key,value>中put数据时key的类型为String，那么get的时候需严格用String类型,否则get时会得不到你想要的）
     * @param mapKey
     * @param data
     */
    public static  void putToMap(Object mapKey, Map<Object, Object> data) {
        putToMap(serializable(mapKey), serializeMap(data));
    }
     
    /**
     * 批量设置到hash数据结果，采用byte类型存储
     * @param mapKey
     * @param data
     */
    public static  void putToMap(byte[] mapKey, Map<byte[], byte[]> data) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.hmset(mapKey, data);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 添加到Map结构（key为String）
     * @param mapKey
     * @param data
     */
    public static  void putStringToMap(String mapKey, Map<String, String> data) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.hmset(mapKey, data);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 从Map结构中获取数据
     * @param mapKey
     * @param field
     * @return
     */
    public static  Object getFromMap(Object mapKey, Object field) {
        return unserialize(getFromMap(serializable(mapKey), serializable(field)));
    }
     
    /**
     * 从Map结构中获取数据
     * @param mapKey
     * @param field
     * @return
     */
    public static  byte[] getFromMap(byte[] mapKey, byte[] field) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            byte[] data = conn.hget(mapKey, field);
            returnConnection(conn);
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
            return null;
        }
    }
    
    /**
     * 从Map结构中获取数据
     * @param mapKey
     * @param field
     * @return
     */
    public static  String getStringFromMap(String mapKey, String field) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            String data = conn.hget(mapKey, field);
            returnConnection(conn);
            return data;
        } catch (Exception e) {
            returnBorkenConnection(conn);
            return null;
        }
    }
     
    /**
     * 从map中移除记录
     * @param mapKey
     * @param field
     */
    public static  void removeFromMap(Object mapKey, Object field) {
        removeFromMap(serializable(mapKey), serializable(field));
    }
     
    /**
     * 从map中移除记录
     * @param mapKey
     * @param field
     */
    public static  void removeFromMap(byte[] mapKey, byte[] field) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.hdel(mapKey, field);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 添加到sorted set队列，字符串类型
     * @param setKey
     * @param value
     * @param score
     */
    public static  void addToSortedSet(String setKey, String value, double score) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.zadd(setKey, score, value);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 添加到sorted set队列，java序列化对象类型
     * @param setKey
     * @param value
     * @param score
     */
    public static  void addToSortedSet(Object setKey, Object value, double score) {
        addToSortedSet(serializable(setKey), serializable(value), score);
    }
     
    /**
     * 添加到sorted set队列，字节类型
     * @param setKey
     * @param value
     * @param score
     */
    public static  void addToSortedSet(byte[] setKey, byte[] value, double score) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.zadd(setKey, score, value);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 批量添加到sorted set队列，字符串类型
     * @param setKey
     * @param valueMap
     */
    public static  void addToSortedSet(String setKey, Map<String, Double> valueMap) {
        Jedis conn = getConnection();
        if (conn == null) {
            return;
        }
        try {
            conn.zadd(setKey, valueMap);
            returnConnection(conn);
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
    }
     
    /**
     * 从sorted set中获取一定范围的段，按score从低到高
     * @param sortKey
     * @param start
     * @param size
     * @return
     */
    public static  Set<String> getSortedSetRange(String sortKey, int start, int size) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            Set<String> result = conn.zrange(sortKey, start, start + size - 1);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 从sorted set中获取一定范围的段，按score从高到低
     * @param sortKey
     * @param start
     * @param size
     * @return
     */
    public static  Set<String> getSortedSetRangeReverse(String sortKey, int start, int size) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            Set<String> result = conn.zrevrange(sortKey, start, start + size - 1);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 从sorted set中获取一定范围的段，字节类型，按score从低到高
     * @param sortKey
     * @param start
     * @param size
     * @return
     */
    public static  Set<byte[]> getSortedSetRange(byte[] sortKey, int start, int size) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            Set<byte[]> result = conn.zrange(sortKey, start, start + size - 1);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 从sorted set中获取一定范围的段，字节类型，按score从高到低
     * @param sortKey
     * @param start
     * @param size
     * @return
     */
    public static  Set<byte[]> getSortedSetRangeReverse(byte[] sortKey, int start, int size) {
        Jedis conn = getConnection();
        if (conn == null) {
            return null;
        }
        try {
            Set<byte[]> result = conn.zrevrange(sortKey, start, start + size - 1);
            returnConnection(conn);
            return result;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return null;
    }
     
    /**
     * 根据score从sorted set中移除记录
     * @param keySet
     * @param score
     */
    public static  long removeFromSortedSetByScore(String keySet, double score) {
        Jedis conn = getConnection();
        if (conn == null) {
            return 0;
        }
        try {
            long cnt = conn.zremrangeByScore(keySet, score, score);
            returnConnection(conn);
            return cnt;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return 0;
    }
     
    /**
     * 根据score从sorted set中移除记录
     * @param keySet
     * @param score
     * @return
     */
    public static  long removeFromSortedSetByScore(byte[] keySet, double score) {
        Jedis conn = getConnection();
        if (conn == null) {
            return 0;
        }
        try {
            long cnt = conn.zremrangeByScore(keySet, score, score);
            returnConnection(conn);
            return cnt;
        } catch (Exception e) {
            returnBorkenConnection(conn);
        }
        return 0;
    }
     
     
    /**
     * map数据序列化转换
     * @param data
     * @return
     */
    public  static Map<byte[], byte[]> serializeMap(Map<Object, Object> data) {
        Map<byte[], byte[]> result = new HashMap<byte[], byte[]>();
        try {
            Set<Object> keys = data.keySet();
            if (keys != null && keys.size() > 0) {
                for (Object key : keys) {
                    result.put(serializable(key), serializable(data.get(key)));
                }
            }
        } catch (Exception e) {
        }
        return result;
    }
     
    /**
     * 序列化处理
     * @param obj
     * @return
     */
    public static byte[] serializable(Object obj) {
        if (obj == null) {
            return null;
        }
        ObjectOutputStream oos = null;
        ByteArrayOutputStream baos = null;
        try {
            // 序列化
            baos = new ByteArrayOutputStream();
            oos = new ObjectOutputStream(baos);
            oos.writeObject(obj);
            byte[] bytes = baos.toByteArray();
            return bytes;
        } catch (Exception e) {
        }
        return null;
    }
     
    /**
     * 反序列化处理
     * @param bytes
     * @return
     */
    public static Object unserialize(byte[] bytes) {
        if (bytes == null) {
            return null;
        }
        ByteArrayInputStream bais = null;
        try {
            // 反序列化
            bais = new ByteArrayInputStream(bytes);
            ObjectInputStream ois = new ObjectInputStream(bais);
            return ois.readObject();
        } catch (Exception e) {
        }
        return null;
    }
	protected static final Map<String,String> lovCacheMap = new java.util.concurrent.ConcurrentHashMap<String, String>();
	/**
	 * 获取缓存值
	 * @param orgId
	 * @param key
	 * @return
	 */
	public static final String getLovCacheVal(String orgId,String name, String key){
		String keyStr = "WKLOV_" + orgId + "_" + name;
		//log.info("keyStr = >" + keyStr);
		String mykey = String.format("%s - %s", keyStr, key);
		String myvalue = lovCacheMap.get(mykey);
		if (myvalue != null && "".equals(myvalue.trim()) == false){
			return myvalue;
		}
		String ko = RedisCacheUtil.getStringFromMap(keyStr, key);
		if(ko == null || "".equals(ko)){
			return "";
		}
		lovCacheMap.put(mykey, ko);
		return ko;
	}
}
