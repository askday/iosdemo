//
//  DES.h
//  IPhoneDemo
//
//  Created by wangxiang on 15/7/29.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES : NSObject

+ (NSData *)doEncryptWithString:(NSString *)plainText key:(NSString *)key;
+ (NSData *)doDecryptWithString:(NSString *)cipherText key:(NSString *)key;

@end
