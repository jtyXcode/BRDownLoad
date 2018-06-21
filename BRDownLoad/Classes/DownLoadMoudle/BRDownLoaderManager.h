//
//  BRDownLoaderManager.h
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRDownLoader.h"
@class BRDownLoadConfiguration;


//extern BRDownLoader * _Nullable  getDownLoader(NSURL * _Nullable url);

@interface BRDownLoaderManager : NSObject

/**
 	key(md5(url)) : vaule (BRDownLoader)
 */
@property (nonatomic,strong) NSMutableDictionary * 					downLoadInfo;

/**
 配置下载管理
 */
@property (nonatomic, strong, readonly) BRDownLoadConfiguration *  	configuration;


- (void)br_DownLoader:(NSURL * _Nullable)url
         downLoadInfo:(br_DownLoadInfoTypeBlock _Nullable )downLoadInfo
             progress:(br_ProgressBlock _Nullable )progress
              success:(br_SuccessBlock _Nullable )success
               failed:(br_FailedBlock _Nullable )failed;


- (void)br_pauseWithURL:(NSURL *_Nonnull)url;
- (void)br_resumeWithURL:(NSURL *_Nonnull)url;
- (void)br_cancelWithURL:(NSURL *_Nonnull)url;

- (void)br_pauseAll;
- (void)br_resumeAll;


/**
 获取实例对象

 @return <#return value description#>
 */
+ (instancetype)shareInstance;


/**
 初始化  返回单例对象

 @param configuration 下载配置
 @return 单例对象
 */
+ (instancetype)initWithDownLoadConfiguration: (BRDownLoadConfiguration* ) configuration;
//+ (instancetype)

@end
