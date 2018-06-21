//
//  DownLoadTableViewCell.h
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *donwLoadBtn;
@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) NSString *url;
@end
