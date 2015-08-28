//
//  CollectionTest.m
//  IPhoneDemo
//
//  Created by wx on 15-6-10.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "CollectionTest.h"

@implementation CollectionTest

-(void)doBlockTest:(void (^)(int))testBlock
{
    if (testBlock) {
        testBlock(5);
    }
}

@end
