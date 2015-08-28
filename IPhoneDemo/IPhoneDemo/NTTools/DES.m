//
//  DES.m
//  IPhoneDemo
//
//  Created by wangxiang on 15/7/29.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"
#import "DES.h"

#define kChosenCipherBlockSize kCCBlockSize3DES
#define kChosenCipherKeySize kCCKeySize3DES

@implementation DES

+ (NSData *)doEncryptWithData:(NSData *)plainData key:(NSData *)key
{

    //    CCOptions pad = kCCOptionECBMode | kCCOptionPKCS7Padding;
    CCOptions pad = kCCOptionPKCS7Padding;
    NSData *data = [DES doCipher:plainData key:key context:kCCEncrypt padding:&pad];
    NSData *base64Data = [GTMBase64 encodeData:data];
    return base64Data;
}

+ (NSData *)doEncryptWithString:(NSString *)plainText key:(NSString *)key
{

    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    return [DES doEncryptWithData:plainData key:keyData];
}

+ (NSData *)doEncryptWithStringAndData:(NSString *)plainText key:(NSData *)key
{

    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    return [DES doEncryptWithData:plainData key:key];
}

+ (NSData *)doDecryptWithStringAndData:(NSString *)cipherText key:(NSData *)key
{

    NSData *cipherData = [cipherText dataUsingEncoding:NSUTF8StringEncoding];
    return [DES doDecryptWithData:cipherData key:key];
}

+ (NSData *)doDecryptWithData:(NSData *)cipherData key:(NSData *)key
{

    //    CCOptions pad = kCCOptionECBMode | kCCOptionPKCS7Padding;
    CCOptions pad = kCCOptionECBMode;
    NSData *base64Data = [GTMBase64 decodeData:cipherData];
    [DES logNSData:base64Data];
    NSData *data = [DES doCipher:base64Data key:key context:kCCDecrypt padding:&pad];
    return data;
}

+ (void)logNSData:(NSData *)data
{
    const char *bytes = (const char *)[data bytes];
    int length = (int)[data length];
    for (int i = 0; i < length; i++) {
        printf("%c", bytes[i]);
    }
    printf("\n");
}

+ (NSData *)doDecryptWithString:(NSString *)cipherText key:(NSString *)key
{

    NSData *cipherData = [cipherText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    return [DES doDecryptWithData:cipherData key:keyData];
}

+ (NSData *)doCipher:(NSData *)plainText key:(NSData *)symmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7
{

    CCCryptorStatus ccStatus = kCCSuccess;
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData *cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t *bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t *ptr;

    // Initialization vector; dummy in this case 0\'s.
    uint8_t iv[kChosenCipherBlockSize];
    memset((void *)iv, 0x8, (size_t)sizeof(iv));

    if (plainText == nil) {
        NSLog(@"PlainText object cannot be nil.");
    }

    if (symmetricKey == nil) {
        NSLog(@"Symmetric key object cannot be nil.");
    }

    if (pkcs7 == NULL) {
        NSLog(@"CCOptions * pkcs7 cannot be NULL.");
    }

    if ([symmetricKey length] != kChosenCipherKeySize) {
        NSLog(@"Disjoint choices for key size.");
    }

    plainTextBufferSize = [plainText length];

    if (plainTextBufferSize <= 0) {
        NSLog(@"Empty plaintext passed in.");
    }

    // We don\'t want to toss padding on if we don\'t need to
    //if(encryptOrDecrypt == kCCEncrypt) {
    // if(*pkcs7 != kCCOptionECBMode) {
    // if((plainTextBufferSize % kChosenCipherBlockSize) == 0) {
    // *pkcs7 = 0x0000;
    // } else {
    // *pkcs7 = kCCOptionPKCS7Padding;
    // }
    // }
    // } else if(encryptOrDecrypt != kCCDecrypt) {
    // //LOGGING_FACILITY1( 0, @\"Invalid CCOperation parameter [%d] for cipher context.\", *pkcs7 );
    // NSLog(@\"Invalid CCOperation parameter [%d] for cipher context.\", *pkcs7);
    // }

    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
                               kCCAlgorithm3DES,
                               *pkcs7,
                               (const void *)[symmetricKey bytes],
                               kChosenCipherKeySize,
                               (const void *)iv,
                               &thisEncipher);

    if (ccStatus != kCCSuccess) {
        NSLog(@"Problem creating the context, ccStatus == %d", ccStatus);
    }

    // Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);

    // Allocate buffer.
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));

    // Zero out buffer.
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    // Initialize some necessary book keeping.

    ptr = bufferPtr;

    // Set up initial size.
    remainingBytes = bufferPtrSize;

    // Actually perform the encryption or decryption.
    ccStatus = CCCryptorUpdate(thisEncipher,
                               (const void *)[plainText bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes);

    if (ccStatus != kCCSuccess) {
        NSLog(@"Problem with CCCryptorUpdate, ccStatus == %d", ccStatus);
    }

    // Handle book keeping.
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;

    // Finalize everything to the output buffer.
    ccStatus = CCCryptorFinal(thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes);

    totalBytesWritten += movedBytes;

    if (thisEncipher) {
        (void)CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }

    if (ccStatus != kCCSuccess) {
        NSLog(@"Problem with encipherment ccStatus == %d", ccStatus);
    }

    cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];

    if (bufferPtr)
        free(bufferPtr);

    return cipherOrPlainText;
}
@end
