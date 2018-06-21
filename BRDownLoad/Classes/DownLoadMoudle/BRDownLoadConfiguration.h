//
//  BRDownLoadConfiguration.h
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDownLoadConfiguration : NSObject

/**
 默认为1个 同时下载的个数
 */
@property (nonatomic, assign) int DownLoadCount;

/**
 默认是YES 下载的文件是否需要检验MD5
 */
@property (nonatomic, assign, getter=isVerifyMD5) BOOL verifyMD5;


/**
 设置下载的配置
 */
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@end
