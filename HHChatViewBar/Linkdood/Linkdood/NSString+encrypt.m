//
//  NSString+encrypt.m
//  Linkdood
//
//  Created by yue on 8/23/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "NSString+encrypt.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (encrypt)

- (NSString*)des3:(CCOperation)descc withPass:(NSString*)pass
{
    if (pass.isEmpty) {
        return nil;
    }
    if (pass.length <= 8) {
        pass = [pass stringByAppendingString:@"$#365#$*[`@$(#$#36#"];
    }
    const void *bytes;
    size_t byteSize;
    if (descc == kCCDecrypt)//解密
    {
        NSData *data = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
        byteSize = data.length;
        bytes = data.bytes;
    }else{
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        byteSize = data.length;
        bytes = data.bytes;
    }
    
    size_t movedBytes = 0;
    size_t bufferSize = (byteSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    void *buffer = malloc(bufferSize * sizeof(uint8_t));
    memset((void *)buffer, 0x0, bufferSize);
    
    const void *vkey = (const void *) [pass UTF8String];
    const void *vi = (const void *) [@"vrvxaIvS" UTF8String];
    CCCryptorStatus ccStatus = CCCrypt(descc,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       vi,
                                       bytes,
                                       byteSize,
                                       buffer,
                                       bufferSize,
                                       &movedBytes);
    
    NSString *result = nil;
    if (ccStatus == kCCSuccess) {
        if (descc == kCCDecrypt){
            result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes]
                                           encoding:NSUTF8StringEncoding];
        }else{
            result = [GTMBase64 stringByEncodingData:[NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes]];
        }
    }
    
    free(buffer);
    return result;
}

@end
