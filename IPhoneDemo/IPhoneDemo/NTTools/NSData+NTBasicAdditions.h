//
//  NSData+NTBase64Coding.h
//  BasicLibrary
//
//  Created by LiuLiming on 14-2-19.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NTBasicAddtions)

/**
 * Calculate the md5 hash of the data using CC_MD5.
 *
 * @return md5 hash of the data
 */
@property (nonatomic, readonly) NSString *md5Hash;

- (NSData *)base64Encoding;
- (NSData *)base64Decoding;
- (NSString *)stringByEncodingDataBase64;

@end

@interface NSData (Gzip)

- (NSData *)gzipData;
- (NSData *)ungzipData;
- (BOOL)isGzippedData;
@end