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

static NSString * _Nullable const BRDownLoadSuccedNotification;
static NSString * _Nullable const BRDownLoadFailedNotification;
static NSString * _Nullable const BRDownLoadPauseNotification;
//static NSString * _
//extern BRDownLoader * _Nullable  getDownLoader(NSURL * _Nullable url);

@interface BRDownLoaderManager : NSObject

/**
 	key(md5(url)) url MD5值 : vaule (BRDownLoader) 下载器
 */
@property (nonatomic,strong) NSMutableDictionary * _Nullable 				downLoadInfo;

/**
 	key(md5(url)) url MD5值 : vaule (fileMD5) 文件的MD5值
 */
@property (nonatomic,strong,) NSMutableDictionary *_Nullable						    downFileMD5Info;

/**
 配置下载管理
 */
@property (nonatomic, strong, readonly) BRDownLoadConfiguration *_Nullable  downLoadConfiguration;


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

 @return 
 */
+ (instancetype)shareInstance;


/**
 初始化  返回单例对象

 @param configuration 下载配置 
 @return 单例对象
 */
+ (instancetype)instanceWithDownLoadConfiguration: (BRDownLoadConfiguration* ) configuration;
//+ (instancetype)

@end
