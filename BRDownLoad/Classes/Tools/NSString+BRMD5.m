//
//  NSString+BRMD5.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "NSString+BRMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (BRMD5)
- (NSString *)br_md5 {
    const char *data = self.UTF8String;
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data, (CC_LONG)StrLength(data), md);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", md[i]];
    }

    return result;    
}
@end
