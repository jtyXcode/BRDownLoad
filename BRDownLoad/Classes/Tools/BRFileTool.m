//
//  BRFileTool.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "BRFileTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BRFileTool

#pragma mark - private

void closeStream (CFReadStreamRef stream){
    if (stream) {
        CFReadStreamClose(stream);
        CFRelease(stream);
    }
}

void closeTypeRefObject (CFTypeRef ref) {
    if (ref) {
        CFRelease(ref);
    }
}

size_t FileHashDefaultChunkSizeForReadingData (void){
    return 1024*8;
}


#pragma mark -
+ (BOOL)br_fileExists:(NSString *)filePath {
    if(filePath.length == 0) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (long long)br_fileSize:(NSString *)filePath {
    if(![self br_fileExists:filePath]) return 0;
    
    NSError *error;
    NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if(error) return 0;
    return [info[NSFileSize] longLongValue];
}

+ (void)br_moveFile:(NSString *)fromPath toPath:(NSString *)toPath complete:(BRMoveFileCompleteBlock)complete{
    if(![self br_fileExists:fromPath]) return;
    if([fromPath isEqualToString:toPath]) return;
    
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:&error];
    
    if(complete) complete(error);
}

+ (void)br_removeFile:(NSString *)filePath complete:(BRMoveFileCompleteBlock)complete{
    if(![self br_fileExists:filePath]) return;
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    
    if(complete) complete(error);
}


+ (NSString *)br_FileMD5HashCreateWithPath:(NSString *)filePath chunkSizeForReadingData:(size_t)dataSize{
    
    NSString *result = nil;
    CFReadStreamRef readStream = NULL;
    
    if (![BRFileTool br_fileExists:filePath]) {
        return result;
    }
    
    CFURLRef fileURLRef = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)filePath, kCFURLPOSIXPathStyle, (Boolean)false);
    if(!fileURLRef) return result;
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURLRef);
    if (!readStream) return result;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) {
        closeStream(readStream);
        closeTypeRefObject(fileURLRef);
         return result;
    };
  
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    size_t chunkSizeForReadingData = dataSize;
    
    if(chunkSizeForReadingData == 0) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData();
    }
    
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream, (UInt8 *)buffer, (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject, (const void *)buffer, (CC_LONG)readBytesCount);
    }
    
    didSucceed = !hasMoreData;
    
    if(!didSucceed) {
        closeStream(readStream);
        closeTypeRefObject(fileURLRef);
        return result;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    
    result = (__bridge NSString *)CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    
    if (fileURLRef) {
        closeTypeRefObject(fileURLRef);
    }
    
    return result;
}



@end
