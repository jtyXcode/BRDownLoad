//
//  BRDownLoader.h
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *BR_CacheFilePath (void);
extern NSString *BR_TempCacheFilePath(void);

typedef NS_ENUM(NSUInteger,BRDownLoadState) {
    BRDownLoadStateWaiting,
    BRDownLoadStatePause,
    BRDownLoadStateDownLoading,
    BRDownLoadStatePauseSuccess,
    BRDownLoadStatePauseFailed
};

typedef void(^br_DownLoadInfoTypeBlock)(long long totalSize);
typedef void(^br_ProgressBlock)(float progress);
typedef void(^br_SuccessBlock)(NSString *filePath);
typedef void(^br_FailedBlock)(NSString *tmpfilePath);
typedef void(^br_StateChangeBlock)(BRDownLoadState state);


@interface BRDownLoader : NSObject

/**
 获取当前文件的下载状态
 */
@property (nonatomic, assign) 			BRDownLoadState state;

/**
 获取当前文件下载进度
 */
@property (nonatomic, assign, readonly) float progress;

/**
 获取当前下载的大小
 */
@property (nonatomic, assign, readonly) NSUInteger currentSize;

/**
 当前下载的url
 */
@property (nonatomic, strong, readonly) NSURL *url;

/**
 当前下载 或者完成文件的MD5  可以为空
 */
@property (nonatomic, strong, readonly) NSString *fileMD5;

/**
 下载完成移动到那个文件夹
 */
@property (nonatomic, strong, readonly) NSString *downLoadFilePath;

@property (nonatomic, copy) br_DownLoadInfoTypeBlock downLoadInfo;
@property (nonatomic, copy) br_StateChangeBlock stateChange;
@property (nonatomic, copy) br_ProgressBlock progressChange;
@property (nonatomic, copy) br_SuccessBlock successBlock;
@property (nonatomic, copy) br_FailedBlock faildBlock;


/**


 @param url 资源路径
 @param downLoadInfo 获取资源总大小
 @param progress 获取下载进度
 @param success 获取成功信息
 @param failed 获取失败信息
 */
- (void)br_DownLoader:(NSURL *)url
         		downLoadInfo:(br_DownLoadInfoTypeBlock)downLoadInfo
             	progress:(br_ProgressBlock)progress
              	success:(br_SuccessBlock)success
               	failed:(br_FailedBlock)failed;

//- (void)br_DownLoader:(NSURL *)url
//
//         downLoadInfo:(br_DownLoadInfoTypeBlock)downLoadInfo
//             progress:(br_ProgressBlock)progress
//              success:(br_SuccessBlock)success
//               failed:(br_FailedBlock)failed;


/**
 判断当前URL 下载资源是否存在 存在继续下载

 @param url 下载资源路径
 */
- (void)br_downLoader:(NSURL *)url;
- (void)br_resumeCurrentTask;


/**
  暂停下载 不推荐直接使用 请使用BRDownLoadState
 */
- (void)br_pauseCurrentTask;


/**
 取消当前下载任务
 */
- (void)br_cancelCurrentTask;


/**
 取消下载任务,并且清除当前下载资源
 */
- (void)br_cancelAndClean;
@end
