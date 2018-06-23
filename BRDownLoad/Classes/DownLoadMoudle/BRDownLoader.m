//
//  BRDownLoader.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "BRDownLoader.h"
#import "BRFileTool.h"
#import "BRDownLoaderManager.h"
#import "BRDownLoadConfiguration.h"

inline NSString *BR_CacheFilePath () {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

inline NSString *BR_TempCacheFilePath () {
    return NSTemporaryDirectory();
}

@interface BRDownLoader () <NSURLSessionDataDelegate>
@property (nonatomic, assign) long long 				tmpSize;
@property (nonatomic, assign) long long 				totalSize;
@property (nonatomic, assign) float 					progress;
//@property (nonatomic, assign) float                        

@property (nonatomic, strong, readwrite) NSURL *		url;
@property (nonatomic, strong, readwrite) NSString *		fileMD5;
@property (nonatomic, strong) NSURLSession *			session;
@property (nonatomic, strong) NSString *				downLoadFilePath;
@property (nonatomic, strong) NSString *				tempDownLoadFilePath;
@property (nonatomic, strong) NSOutputStream *			outputStream;
@property (nonatomic, strong) NSURLSessionDataTask *	sessionDataTask;

@end


@implementation BRDownLoader

- (NSURLSession *)session {
    if(_session == nil) {
        _session = [NSURLSession sessionWithConfiguration:[BRDownLoaderManager shareInstance].downLoadConfiguration.configuration delegate:self delegateQueue:[BRDownLoaderManager shareInstance].downLoadConfiguration.operationQueue];
    }
    return _session;
}


- (void)br_DownLoader:(NSURL *)url
         		downLoadInfo:(br_DownLoadInfoTypeBlock)downLoadInfo
             	progress:(br_ProgressBlock)progress
              	success:(br_SuccessBlock)success
               	failed:(br_FailedBlock)failed {
    
    self.url = url;
    //需要添加逻辑
    self.downLoadInfo = downLoadInfo;
    self.progressChange = progress;
    self.successBlock = success;
    self.faildBlock = failed;
    [self br_downLoader:url];
}

- (void)br_downLoader:(NSURL *)url {
    
    if([url isEqual:self.sessionDataTask.originalRequest.URL]){
        
        if(self.state == BRDownLoadStatePause){
            [self br_resumeCurrentTask];
            return;
        }
    }
    
    [self br_cancelCurrentTask];
    
    NSString *fileName = url.lastPathComponent;
    self.downLoadFilePath = [BR_CacheFilePath() stringByAppendingPathComponent:fileName];
    self.tempDownLoadFilePath = [BR_TempCacheFilePath() stringByAppendingPathComponent:fileName];
    
    if([BRFileTool br_fileExists:self.downLoadFilePath]) {
        self.state = BRDownLoadStatePauseSuccess;
        [[NSNotificationCenter defaultCenter] postNotificationName:BRDownLoadSuccedNotification object:self];
        return;
    }
    
//    self.state = BRDownLoadStateDownLoading;
    if(![BRFileTool br_fileExists:self.tempDownLoadFilePath]){
        [self downLoadWithURL:url offset:0];
        return;
    }
    
    _tmpSize = [BRFileTool br_fileSize:self.tempDownLoadFilePath];
    [self downLoadWithURL:url offset:_tmpSize];
    
}

- (void)br_pauseCurrentTask {
    if(self.state == BRDownLoadStateDownLoading) {
        self.state = BRDownLoadStatePause;
        [self.sessionDataTask suspend];
        [[NSNotificationCenter defaultCenter] postNotificationName:BRDownLoadFailedNotification object:self];
    }
}

- (void)br_resumeCurrentTask {

    /*
		如果自己点击 需要实现
     1.需要获取
     */
    if(self.sessionDataTask && (self.state == BRDownLoadStatePause || self.state == BRDownLoadStateWaiting || self.state == BRDownLoadStatePauseFailed)) {
        [self.sessionDataTask resume];
        self.state = BRDownLoadStateDownLoading;
    }
}

- (void)br_cancelCurrentTask {
    if(self.state == BRDownLoadStatePauseSuccess) return;
    [self.session invalidateAndCancel];
    [self clearUnusable];
}


- (void)br_cancelAndClean {
    [self br_cancelCurrentTask];
   	self.state == BRDownLoadStatePauseSuccess ? [BRFileTool br_removeFile:self.downLoadFilePath complete:nil] : [BRFileTool br_removeFile:self.tempDownLoadFilePath complete:nil];
    
}

- (void)clearUnusable{
    self.session = nil;
    self.stateChange = nil;
    self.progressChange = nil;
    self.successBlock = nil;
    self.faildBlock = nil;
}


#pragma mark - NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session
        		 dataTask:(NSURLSessionDataTask *)dataTask
				didReceiveResponse:(NSHTTPURLResponse *)response
				completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    _totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    if(self.downLoadInfo != nil){
        self.downLoadInfo(_totalSize);
    }
    
    if(_tmpSize > _totalSize) {
        [BRFileTool br_removeFile:self.tempDownLoadFilePath complete:nil];
        completionHandler(NSURLSessionResponseCancel);
//        [self downLoadWithURL:response.URL offset:0];
        return;
    }
    
    if(_tmpSize == _totalSize) {
        
        //先获取是否需要MD5校验
        if([BRDownLoaderManager shareInstance].downLoadConfiguration.isVerifyMD5 && ![[BRFileTool br_FileMD5HashCreateWithPath:_tempDownLoadFilePath chunkSizeForReadingData:[BRFileTool br_fileSize:_tempDownLoadFilePath]] isEqualToString:_fileMD5]){
            //清除重新下载  需要重新添加下载队列  添加进入失败队列中
            //
            [BRFileTool br_removeFile:self.tempDownLoadFilePath complete:nil];
            completionHandler(NSURLSessionResponseCancel);
            self.state = BRDownLoadStatePauseFailed;
            return;
        }
        
        [BRFileTool br_moveFile:self.tempDownLoadFilePath toPath:self.downLoadFilePath complete:nil];
        completionHandler(NSURLSessionResponseCancel);
        self.state = BRDownLoadStatePauseSuccess;
        return;
  
    }
    
    
    self.state = BRDownLoadStateDownLoading;
    // 继续接受数据
    // 确定开始下载数据
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.tempDownLoadFilePath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
    
}


- (void)URLSession:(NSURLSession *)session
          	dataTask:(NSURLSessionDataTask *)dataTask
    		didReceiveData:(NSData *)data {
    
    _tmpSize += data.length;
    self.progress = 1.0 * _tmpSize / _totalSize;
    [self.outputStream write:data.bytes maxLength:data.length];
}

- (void)URLSession:(NSURLSession *)session
              	task:(NSURLSessionTask *)task
				didCompleteWithError:(NSError *)error {
    if(error == nil) {
        [BRFileTool br_moveFile:self.tempDownLoadFilePath toPath:self.downLoadFilePath complete:^(NSError *error) {
            NSLog(@"remove error --- %@",error);
        }];
        self.state = BRDownLoadStatePauseSuccess;
    }else {
        
        if (-999 == error.code) {
            self.state = BRDownLoadStatePause;
        }else {
            self.state = BRDownLoadStatePauseFailed;
        }
        
    }
    [self.outputStream close];
}



#pragma mark - 下载任务
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    
    self.sessionDataTask = [self.session dataTaskWithRequest:request];
    [self br_resumeCurrentTask];
}


#pragma mark -
- (void)setState:(BRDownLoadState)state {
    if(_state == state) return;
    
    _state = state;
    
    if(self.stateChange){
        self.stateChange(_state);
    }
    
    if (_state == BRDownLoadStatePauseSuccess && self.successBlock) {
        self.successBlock(self.downLoadFilePath);
        [self.session finishTasksAndInvalidate];
    }
    
    if (_state == BRDownLoadStatePauseFailed && self.faildBlock) {
        self.faildBlock(self.tempDownLoadFilePath);
    }
}

- (void)setProgress:(float)progress {
    _progress = progress;
    if(self.progressChange){
        self.progressChange(_progress);
    }
}





@end
