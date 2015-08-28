//
//  NSData+NTBase64Coding.m
//  BasicLibrary
//
//  Created by LiuLiming on 14-2-19.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import "NSData+NTBasicAdditions.h"
#import <CommonCrypto/CommonDigest.h>
#import "zlib.h"
#define LOG(...) NSLog(__VA_ARGS__)
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (NTBase64Coding)

- (NSString *)md5Hash
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], result);

    return [NSString stringWithFormat:
                         @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSData *)base64Encoding;
{
    if ([self length] == 0) {
        return nil;
    }

    char *characters = malloc((([self length] + 2) / 3) * 4);

    if (characters == NULL) {
        return nil;
    }

    NSUInteger length = 0;
    NSUInteger i = 0;

    while (i < [self length]) {
        char buffer[3] = {0, 0, 0};
        short bufferLength = 0;

        while (bufferLength < 3 && i < [self length]) {
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        }
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];

        if (bufferLength > 1) {
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        }
        else {
            characters[length++] = '=';
        }

        if (bufferLength > 2) {
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        }
        else {
            characters[length++] = '=';
        }
    }

    NSData *encodedData = [NSData dataWithBytes:characters length:length];
    free(characters);
    return encodedData;
}

- (NSData *)base64Decoding
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;

    ixtext = 0;
    tempcstring = (const unsigned char *)[self bytes];
    lentext = [self length];
    theData = [NSMutableData dataWithCapacity:lentext];
    ixinbuf = 0;

    while (true) {

        if (ixtext >= lentext) {
            break;
        }

        ch = tempcstring[ixtext++];
        flignore = false;

        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        }
        else if (ch == '+') {
            ch = 62;
        }
        else if (ch == '=') {
            flendtext = true;
        }
        else if (ch == '/') {
            ch = 63;
        }
        else {
            flignore = true;
        }

        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;

            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }

                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                }
                else {
                    ctcharsinbuf = 2;
                }

                ixinbuf = 3;

                flbreak = true;
            }

            inbuf[ixinbuf++] = ch;

            if (ixinbuf == 4) {
                ixinbuf = 0;

                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);

                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes:&outbuf[i] length:1];
                }
            }

            if (flbreak) {
                break;
            }
        }
    }
    return theData;
}

- (NSString *)stringByEncodingDataBase64
{
    NSString *result = nil;
    NSData *converted = [self base64Encoding];
    if (converted) {
        result = [[NSString alloc] initWithData:converted
                                       encoding:NSUTF8StringEncoding];
    }
    return result;
}

@end

@implementation NSData (Gzip)
- (BOOL)isGzippedData
{
    const UInt8 *bytes = (const UInt8 *)self.bytes;
    return (self.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}
- (NSData *)gzipData
{
    if (!self || [self length] == 0) {
        LOG(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }

    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc = Z_NULL;                        // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree = Z_NULL;                         // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque = Z_NULL;                        // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0;                          // Total number of output bytes produced so far
    zlibStreamStruct.next_in = (Bytef *)[self bytes];        // Pointer to input bytes
    zlibStreamStruct.avail_in = (unsigned int)[self length]; // Number of input bytes left to process

    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15 + 16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK) {
        NSString *errorMsg = nil;
        switch (initError) {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        LOG(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        //[errorMsg release];
        return nil;
    }

    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[self length] * 1.01 + 12];

    int deflateStatus;
    do {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;

        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = (unsigned int)([compressedData length] - zlibStreamStruct.total_out);
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);

    } while (deflateStatus == Z_OK);

    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END) {
        NSString *errorMsg = nil;
        switch (deflateStatus) {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        LOG(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);

        // Free data structures that were dynamically created for the stream.
        deflateEnd(&zlibStreamStruct);

        return nil;
    }
    // Free data structures that were dynamically created for the stream.
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength:zlibStreamStruct.total_out];
    LOG(@"%s: Compressed file from %.2f KB to %.2f KB", __func__, [self length] / 1024.0f, [compressedData length] / 1024.0f);

    return compressedData;
}

- (NSData *)ungzipData
{
    if ([self length] == 0)
        return self;

    unsigned full_length = (unsigned int)[self length];
    unsigned half_length = (unsigned int)[self length] / 2;

    NSMutableData *decompressed = [NSMutableData dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;

    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (unsigned int)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15 + 32)) != Z_OK)
        return nil;

    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy:half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (unsigned int)([decompressed length] - strm.total_out);
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        }
        else if (status != Z_OK) {
            break;
        }
    }

    if (inflateEnd(&strm) != Z_OK)
        return nil;
    // Set real length.
    if (done) {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    }
    return nil;
}

@end
