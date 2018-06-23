//
//  BRDownLoadConfiguration.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "BRDownLoadConfiguration.h"

@implementation BRDownLoadConfiguration

- (instancetype)init {
    self = [super init];
    if(self){
        self.maxDownLoadCount = 1;
        self.verifyMD5 = YES;
        self.configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.operationQueue = [NSOperationQueue mainQueue];
    }
    return self;
}


- (void)setMaxDownLoadCount:(int)maxDownLoadCount {
    
    if (maxDownLoadCount > 9) {
        maxDownLoadCount = 9;
    }
    
    if (maxDownLoadCount != _maxDownLoadCount) {
        _maxDownLoadCount = maxDownLoadCount > 0 ? maxDownLoadCount : 1;
    }
    
}


@end
