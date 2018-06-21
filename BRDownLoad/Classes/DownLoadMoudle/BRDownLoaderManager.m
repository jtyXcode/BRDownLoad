//
//  BRDownLoaderManager.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "BRDownLoaderManager.h"
#import "BRDownLoadConfiguration.h"
#import "NSString+BRMD5.h"

static inline BRDownLoader *  getDownLoader(NSURL *url) {
    if(url == nil) return nil;
    NSString *urlMD5 = [url.absoluteString br_md5];
    BRDownLoader *downLoader = [BRDownLoaderManager shareInstance].downLoadInfo[urlMD5];
    return downLoader;
}

@interface BRDownLoaderManager ()
@property (nonatomic, strong, readwrite) BRDownLoadConfiguration *      configuration;
@end


@implementation BRDownLoaderManager

static BRDownLoaderManager *_shareInstance;

+ (instancetype)initWithDownLoadConfiguration: (BRDownLoadConfiguration*)configuration{
    BRDownLoaderManager * instance = [BRDownLoaderManager shareInstance];
    if (configuration == nil) {
        instance.configuration = [[BRDownLoadConfiguration alloc] init];
    }else {
        instance.configuration = configuration;
    }
    return instance;
}

+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}

// key md5(url) :  value(BRDownLoader)
- (NSMutableDictionary *)downLoadInfo {
    if (!_downLoadInfo) {
        _downLoadInfo = [NSMutableDictionary dictionary];
    }
    return _downLoadInfo;
}


#pragma mark - 下载相关

- (void)br_DownLoader:(NSURL *)url
         		downLoadInfo:(br_DownLoadInfoTypeBlock)downLoadInfo
             	progress:(br_ProgressBlock)progress
              	success:(br_SuccessBlock)success
               	failed:(br_FailedBlock)failed {
    
   
    BRDownLoader *downLoader = getDownLoader(url);
    NSString *urlMD5 = [url.absoluteString br_md5];
    
    if(downLoader == nil) {
        downLoader = [[BRDownLoader alloc] init];
        self.downLoadInfo[urlMD5] = downLoader;
    }
    
    //判断 是否正在下载逻辑  成功或者失败
    
    __weak typeof(self) weakself = self;
    [downLoader br_DownLoader:url
                 		downLoadInfo:downLoadInfo
                        progress:progress
                      	success:^(NSString *filePath) {
        [weakself.downLoadInfo removeObjectForKey:urlMD5];
        success(filePath);
    } failed:failed];
    
}

- (void)br_pauseWithURL:(NSURL *)url {
    BRDownLoader *downLoader = getDownLoader(url);
    [downLoader br_pauseCurrentTask];
}

- (void)br_resumeWithURL:(NSURL *)url {
    BRDownLoader *downLoader = getDownLoader(url);
    [downLoader br_resumeCurrentTask];
}

- (void)br_cancelWithURL:(NSURL *)url {
    BRDownLoader *downLoader = getDownLoader(url);
    [downLoader br_cancelCurrentTask];
}

- (void)br_pauseAll {
    [self.downLoadInfo.allValues performSelector:@selector(br_pauseCurrentTask) withObject:nil];
}

- (void)br_resumeAll {
     [self.downLoadInfo.allValues performSelector:@selector(br_resumeCurrentTask) withObject:nil];
}








@end
