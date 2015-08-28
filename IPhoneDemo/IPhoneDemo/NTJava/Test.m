//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: NTJava/Test.java
//


#include "IOSClass.h"
#include "IOSObjectArray.h"
#include "J2ObjC_source.h"
#include "NTJava/Other.h"
#include "NTJava/Test.h"
#include "java/io/PrintStream.h"
#include "java/lang/Exception.h"
#include "java/lang/Package.h"
#include "java/lang/Runnable.h"
#include "java/lang/System.h"
#include "java/lang/Thread.h"
#include "java/lang/reflect/Field.h"
#include "java/lang/reflect/Method.h"
#include "java/util/ArrayList.h"

#import "ApplicationTools.h"

@interface NTJavaTest () {
 @public
  NTJavaOther *other_;
}

@end

J2OBJC_FIELD_SETTER(NTJavaTest, other_, NTJavaOther *)

@interface NTJavaTest_$1 : NSObject < JavaLangRunnable >

- (void)run;

- (instancetype)init;

@end

J2OBJC_EMPTY_STATIC_INIT(NTJavaTest_$1)

__attribute__((unused)) static void NTJavaTest_$1_init(NTJavaTest_$1 *self);

__attribute__((unused)) static NTJavaTest_$1 *new_NTJavaTest_$1_init() NS_RETURNS_RETAINED;

J2OBJC_TYPE_LITERAL_HEADER(NTJavaTest_$1)

@implementation NTJavaTest

- (instancetype)init {
  NTJavaTest_init(self);
  return self;
}

- (void)doSomethingDetail {
  [((JavaIoPrintStream *) nil_chk(JavaLangSystem_get_out_())) printlnWithNSString:@"do something detail!"];
}

- (void)doSomeThing {
  NSLog(@"test dosomething");
  
  [[ApplicationTools tools] showStatusBar:NO];
}

- (jint)getIntegerValueWithInt:(jint)a {
  @try {
    [((JavaIoPrintStream *) nil_chk(JavaLangSystem_get_out_())) printlnWithNSString:JreStrcat("I$", a, @"=======")];
    NSString *str = nil;
    [JavaLangSystem_get_out_() printlnWithNSString:JreStrcat("$I", @"=======", ((jint) [((NSString *) nil_chk(str)) length]))];
  }
  @catch (JavaLangException *ex) {
    [((JavaLangException *) nil_chk(ex)) printStackTrace];
  }
  return a * a;
}

+ (void)staticFuncTest {
  NTJavaTest_staticFuncTest();
}

- (void)callOtherJava {
  if (other_ == nil) {
    NTJavaTest_setAndConsume_other_(self, new_NTJavaOther_init());
  }
  [self doSomeThing];
  [((NTJavaOther *) nil_chk(other_)) doSomething];
  [self doSomethingDetail];
}

- (void)doReflectionTest {
  [((JavaIoPrintStream *) nil_chk(JavaLangSystem_get_out_())) printlnWithNSString:@"Reflection Test"];
  if (other_ == nil) {
    NTJavaTest_setAndConsume_other_(self, new_NTJavaOther_init());
  }
  IOSClass *otherClass = [((NTJavaOther *) nil_chk(other_)) getClass];
  [JavaLangSystem_get_out_() printlnWithNSString:JreStrcat("@C$", [otherClass getPackage], '|', [otherClass getName])];
  [JavaLangSystem_get_out_() printlnWithNSString:@"get other class method"];
  IOSObjectArray *method = [otherClass getMethods];
  for (jint i = 0; i < ((IOSObjectArray *) nil_chk(method))->size_; i++) {
    [JavaLangSystem_get_out_() printlnWithNSString:[((NSString *) nil_chk([((JavaLangReflectMethod *) nil_chk(IOSObjectArray_Get(method, i))) getName])) description]];
  }
  [JavaLangSystem_get_out_() printlnWithNSString:@"get other class fields"];
  IOSObjectArray *fields = [otherClass getFields];
  for (jint i = 0; i < ((IOSObjectArray *) nil_chk(fields))->size_; i++) {
    [JavaLangSystem_get_out_() printlnWithNSString:[((JavaLangReflectField *) nil_chk(IOSObjectArray_Get(fields, i))) getName]];
  }
}

- (void)doThreadTest {
  JavaLangThread *thread = [new_JavaLangThread_initWithJavaLangRunnable_([new_NTJavaTest_$1_init() autorelease]) autorelease];
  [thread start];
}

- (void)onClick {
  [((JavaIoPrintStream *) nil_chk(JavaLangSystem_get_out_())) printlnWithNSString:@"MyInterface Onclick"];
}

- (void)dealloc {
  RELEASE_(other_);
  [super dealloc];
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "init", "Test", NULL, 0x1, NULL, NULL },
    { "doSomethingDetail", NULL, "V", 0x4, NULL, NULL },
    { "doSomeThing", NULL, "V", 0x101, NULL, NULL },
    { "getIntegerValueWithInt:", "getIntegerValue", "I", 0x1, NULL, NULL },
    { "staticFuncTest", NULL, "V", 0x9, NULL, NULL },
    { "callOtherJava", NULL, "V", 0x1, NULL, NULL },
    { "doReflectionTest", NULL, "V", 0x1, NULL, NULL },
    { "doThreadTest", NULL, "V", 0x1, NULL, NULL },
    { "onClick", NULL, "V", 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "other_", NULL, 0x2, "LNTJava.Other;", NULL, NULL,  },
  };
  static const J2ObjcClassInfo _NTJavaTest = { 2, "Test", "NTJava", NULL, 0x1, 9, methods, 1, fields, 0, NULL, 0, NULL, NULL, NULL };
  return &_NTJavaTest;
}

@end

void NTJavaTest_init(NTJavaTest *self) {
  NSObject_init(self);
  [((JavaIoPrintStream *) nil_chk(JavaLangSystem_get_out_())) printlnWithNSString:@"this is a construct function"];
  JavaUtilArrayList *array = [new_JavaUtilArrayList_init() autorelease];
  [array addWithId:@"1"];
}

NTJavaTest *new_NTJavaTest_init() {
  NTJavaTest *self = [NTJavaTest alloc];
  NTJavaTest_init(self);
  return self;
}

void NTJavaTest_staticFuncTest() {
  NTJavaTest_initialize();
  [((JavaIoPrintStream *) nil_chk(JavaLangSystem_get_out_())) printlnWithNSString:@"this is a static function"];
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(NTJavaTest)

@implementation NTJavaTest_$1

- (void)run {
  jint i = 0;
  while (i < 1000) {
    [((JavaIoPrintStream *) nil_chk(JavaLangSystem_get_out_())) printlnWithInt:i++];
  }
  ;
}

- (instancetype)init {
  NTJavaTest_$1_init(self);
  return self;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "run", NULL, "V", 0x1, NULL, NULL },
    { "init", "", NULL, 0x0, NULL, NULL },
  };
  static const J2ObjCEnclosingMethodInfo enclosing_method = { "NTJavaTest", "doThreadTest" };
  static const J2ObjcClassInfo _NTJavaTest_$1 = { 2, "", "NTJava", "Test", 0x8008, 2, methods, 0, NULL, 0, NULL, 0, NULL, &enclosing_method, NULL };
  return &_NTJavaTest_$1;
}

@end

void NTJavaTest_$1_init(NTJavaTest_$1 *self) {
  NSObject_init(self);
}

NTJavaTest_$1 *new_NTJavaTest_$1_init() {
  NTJavaTest_$1 *self = [NTJavaTest_$1 alloc];
  NTJavaTest_$1_init(self);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(NTJavaTest_$1)