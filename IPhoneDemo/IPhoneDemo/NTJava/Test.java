package NTJava;

//引用来自oc的头文件
/*-[
 #import "ApplicationTools.h"
 ]-*/

import java.util.ArrayList;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
//import import com.netease.wx.NTTools;

public class Test implements MyInterface
{
    private Other other;

    public Test(){
        System.out.println("this is a construct function");
        
        ArrayList<String> array = new ArrayList<String>();
        array.add("1");
        
        //第三方jar代码测试
        //        NTTools tools = new NTTools();
        //        tools.doSomething();
    }
    
    
    protected void doSomethingDetail(){
        System.out.println("do something detail!");
    }
    
    //java 调用oc代码
    public native void doSomeThing()/*-[
                                     NSLog(@"test dosomething");
                                     
                                     [[ApplicationTools tools] showStatusBar:NO];
                                     ]-*/;
    
    //java原声函数 附带返回值 参数
    public int getIntegerValue(int a){
        //异常代码段翻译测试
        try{
            System.out.println(a+"=======");
            String str = null;
            System.out.println("=======" + str.length());
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
        return a*a;
    }
    
    //静态函数测试
    public static void staticFuncTest(){
        System.out.println("this is a static function");
    }
    
    //java函数内部调用测试
    public void callOtherJava(){
        if (other == null){
            other = new Other();
        }
        doSomeThing();
        other.doSomething();
        doSomethingDetail();
    }
    
    //反射测试
    public void doReflectionTest(){
        System.out.println("Reflection Test");
        if (other == null){
            other = new Other();
        }
        Class<?> otherClass = other.getClass();
        System.out.println(otherClass.getPackage()+"|"+otherClass.getName());
        System.out.println("get other class method");
        Method[] method = otherClass.getMethods();
        for(int i=0;i<method.length;i++){
            System.out.println(method[i].getName().toString());
        }
        
        System.out.println("get other class fields");
        Field[] fields = otherClass.getFields();
        for(int i=0;i<fields.length;i++){
            System.out.println(fields[i].getName());
        }
    }
    
    //线程测试
    public void doThreadTest(){
        Thread thread = new Thread(new Runnable() {
            
            @Override
            public void run() {
                // TODO Auto-generated method stub
                int i=0;
                while(i<1000){
                    System.out.println(i++);
                };
            }
        });
        thread.start();
    }
    
    @Override
    public void onClick() {
        // TODO Auto-generated method stub
        System.out.println("MyInterface Onclick");
    }
}