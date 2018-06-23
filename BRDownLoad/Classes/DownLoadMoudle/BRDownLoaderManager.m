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

static NSString * const BRDownLoadSuccedNotification = @"BRDownLoader.BRDownLoadSuccedNotification.com";
static NSString * _Nullable const BRDownLoadFailedNotification = @"BRDownLoader.BRDownLoadFailedNotification.com";
static NSString * _Nullable const BRDownLoadPauseNotification = @"BRDownLoader.BRDownLoadPauseNotification.com";



@interface BRDownLoaderManager ()
@property (nonatomic, strong, readwrite) BRDownLoadConfiguration *      downLoadConfiguration;

@property (nonatomic, strong) NSMutableArray *downLoadings;
@property (nonatomic, strong) NSMutableArray *waitingDowns;
@property (nonatomic, strong) NSMutableArray *succesDowns;
@property (nonatomic, strong) NSMutableArray *failedDowns;

@property (nonatomic, strong) NSLock *lock;
@end


@implementation BRDownLoaderManager

static BRDownLoaderManager *_shareInstance;

+ (instancetype)instanceWithDownLoadConfiguration: (BRDownLoadConfiguration*)configuration{
    BRDownLoaderManager * instance = [BRDownLoaderManager shareInstance];
    if (configuration == nil) {
        instance.downLoadConfiguration = [[BRDownLoadConfiguration alloc] init];
    }else {
        if (instance.downLoadConfiguration == nil) {
            instance.downLoadConfiguration = configuration;
        }
    }
    
    return instance;
}

+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
        _shareInstance.lock = [[NSLock alloc] init];
        [_shareInstance setUpNotification];
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

- (NSMutableArray *)downLoadings {
    if (_downLoadings == nil) {
        _downLoadings = [NSMutableArray arrayWithCapacity:self.downLoadConfiguration.maxDownLoadCount];
    }
    return _downLoadings;
}

- (NSMutableArray *)waitingDowns {
    if (_waitingDowns == nil){
        _waitingDowns = [NSMutableArray arrayWithCapacity:5];
    }
    return _waitingDowns;
}

- (NSMutableArray *)succesDowns {
    if (_succesDowns == nil) {
        _succesDowns = [NSMutableArray arrayWithCapacity:5];
    }
    return _succesDowns;
}

- (NSMutableArray *)failedDowns {
    if(_failedDowns == nil){
        _failedDowns = [NSMutableArray arrayWithCapacity:5];
    }
    return _failedDowns;
}


- (void)setUpNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackSuccedNotification:) name:BRDownLoadSuccedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackFaliedNotification:) name:BRDownLoadFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackPausedNotification:) name:BRDownLoadPauseNotification object:nil];
    
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
        [_lock lock];
        downLoader = [[BRDownLoader alloc] init];
        self.downLoadInfo[urlMD5] = downLoader;
        [_lock  unlock];
        
        if (_downLoadConfiguration.maxDownLoadCount > self.downLoadings.count ) {
           [self.downLoadings addObject:downLoader];
        }else {
            [self.waitingDowns addObject:downLoader];
        }
        
        
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


#pragma mark - 通知回调
- (void)callBackSuccedNotification:(NSNotification *)notification {
    
}

- (void)callBackFaliedNotification:(NSNotification *)notification {
    
}

- (void)callBackPausedNotification:(NSNotification *)notification {
    
}




@end
