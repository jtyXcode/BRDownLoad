//
//  BRFileTool.h
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BRMoveFileCompleteBlock)(NSError *error);
typedef void(^BRRemoveFileCompleteBlock)(NSError *error);

@interface BRFileTool : NSObject

/**
 文件是否存在

 @param filePath 文件路径
 @return 
 */
+ (BOOL)br_fileExists:(NSString *)filePath;


/**
 文件大小

 @param filePath 文件路径
 @return 文件大小
 */
+ (long long)br_fileSize:(NSString *)filePath;


/**
 移动文件

 @param fromPath 文件起始路径
 @param toPath 文件移动位置
 @param complete 移动回调
 */
+ (void)br_moveFile:(NSString *)fromPath toPath:(NSString *)toPath complete:(BRMoveFileCompleteBlock)complete;


/**
 删除单个文件

 @param filePath 文件路径
 @param complete 删除回调
 */
+ (void)br_removeFile:(NSString *)filePath complete:(BRMoveFileCompleteBlock)complete;


/**
 获取路径文件的MD5

 @param filePath 文件地址
 @param dataSize 文件大小
 @return 文件的MD5 可能为nil
 */
+ (NSString *)br_FileMD5HashCreateWithPath:(NSString *)filePath chunkSizeForReadingData:(size_t)dataSize;
@end
