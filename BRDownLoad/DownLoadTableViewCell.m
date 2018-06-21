//
//  DownLoadTableViewCell.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "DownLoadTableViewCell.h"
#import "BRDownLoaderManager.h"
#import "BRDownLoader.h"
#import "NSString+BRMD5.h"

@implementation DownLoadTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _label = [[UILabel alloc] init];
    [self.contentView addSubview:_label];
    _label.backgroundColor = [UIColor redColor];
    
    _donwLoadBtn = [[UIButton alloc] init];
    [_donwLoadBtn addTarget:self action:@selector(downLoadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_donwLoadBtn setTitle:@"开始" forState:UIControlStateNormal];
    [_donwLoadBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [self.contentView addSubview:_donwLoadBtn];
    _donwLoadBtn.backgroundColor = [UIColor redColor];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.textColor = [UIColor purpleColor];
    [self.contentView addSubview:_stateLabel];
    _stateLabel.backgroundColor = [UIColor redColor];
    
}

- (void)downLoadBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
//    BRDownLoader *downLoader = getDownLoader(_url);
//    if(sender.isSelected) {
//        downLoader
//    }
    
    BRDownLoader *downLaod = [BRDownLoaderManager shareInstance].downLoadInfo[[_url br_md5]];
    if(sender.isSelected){
        downLaod.state = BRDownLoadStateDownLoading;
    }else {
        downLaod.state = BRDownLoadStatePause;
    }
    
//    [[BRDownLoaderManager shareInstance] br_DownLoader:[NSURL URLWithString:_url] downLoadInfo:^(long long totalSize) {
//
//    } progress:^(float progress) {
//        _label.text = [NSString stringWithFormat:@".2f",progress];
//    } success:^(NSString *filePath) {
//        NSLog(@"%@",filePath);
//    } failed:^(NSString *tmpFilePath) {
//        NSLog(@"%@",tmpFilePath);
//    }];
  
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    NSString *urlMD5 = [url br_md5];
 
    
    [[BRDownLoaderManager shareInstance] br_DownLoader:[NSURL URLWithString:url] downLoadInfo:^(long long totalSize) {
        
    } progress:^(float progress) {
        UITableView *tableView = (UITableView *)self.superview;
        _label.text = [NSString stringWithFormat:@".2f",progress];
        [tableView reloadData];
    } success:^(NSString *filePath) {
        NSLog(@"%@",filePath);
         _stateLabel.text = [NSString stringWithFormat:@"成功"];
    } failed:^(NSString *tmpFilePath) {
         NSLog(@"%@",tmpFilePath);
         _stateLabel.text = [NSString stringWithFormat:@"失败"];
    }];
    
    BRDownLoader *downLoader = [BRDownLoaderManager shareInstance].downLoadInfo[urlMD5];
    //    BRDownLoader *downLoader = getDownLoader([NSURL URLWithString:url]);
    if(downLoader.state == BRDownLoadStateWaiting){
        [_donwLoadBtn setTitle:@"开始" forState:UIControlStateNormal];
    }else {
        [_donwLoadBtn setTitle:@"继续" forState:UIControlStateNormal];
    }
    
    if(downLoader.state == BRDownLoadStateDownLoading) {
        _donwLoadBtn.selected = YES;
    }else {
        _donwLoadBtn.selected = NO;
    }
    
    _stateLabel.text = [NSString stringWithFormat:@"%d",downLoader.state];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(0, 0, 60, self.contentView.frame.size.height);
    _donwLoadBtn.frame = CGRectMake(70, 7, 80, 30);
    _stateLabel.frame = CGRectMake(160, 7, 90, 30);
}



@end
