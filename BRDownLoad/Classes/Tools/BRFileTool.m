//
//  BRFileTool.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "BRFileTool.h"


@implementation BRFileTool
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


@end
