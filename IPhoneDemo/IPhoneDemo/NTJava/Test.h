//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: NTJava/Test.java
//

#ifndef _NTJavaTest_H_
#define _NTJavaTest_H_

#include "J2ObjC_header.h"
#include "NTJava/MyInterface.h"

@interface NTJavaTest : NSObject < NTJavaMyInterface >

#pragma mark Public

- (instancetype)init;

- (void)callOtherJava;

- (void)doReflectionTest;

- (void)doSomeThing;

- (void)doThreadTest;

- (jint)getIntegerValueWithInt:(jint)a;

- (void)onClick;

+ (void)staticFuncTest;

#pragma mark Protected

- (void)doSomethingDetail;

@end

J2OBJC_EMPTY_STATIC_INIT(NTJavaTest)

FOUNDATION_EXPORT void NTJavaTest_init(NTJavaTest *self);

FOUNDATION_EXPORT NTJavaTest *new_NTJavaTest_init() NS_RETURNS_RETAINED;

FOUNDATION_EXPORT void NTJavaTest_staticFuncTest();

J2OBJC_TYPE_LITERAL_HEADER(NTJavaTest)

#endif // _NTJavaTest_H_
