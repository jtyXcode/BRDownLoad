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
        self.DownLoadCount = 1;
        self.verifyMD5 = YES;
        self.configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return self;
}

@end
