//
//  ViewController.m
//  BRDownLoad
//
//  Created by 袁涛 on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadTableViewCell.h"
#import "BRDownLoaderManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController


- (NSArray *)dataSource {
    return @[@"http://img2.ph.126.net/9-qV6qgQtwBN47gos_LpxA==/2851904464132694954.jpg",@"http://free2.macx.cn:8281/tools/photo/SnapNDragPro418.dmg"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    _tableView = [[UITableView alloc] init];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [[BRDownLoaderManager shareInstance] br_DownLoader:[NSURL URLWithString:@"http://free2.macx.cn:8281/tools/photo/SnapNDragPro418.dmg"]
//                                          downLoadInfo:^(long long totalSize) {
//                                                NSLog(@"totalSize = %lld",totalSize);
//                                            } progress:^(float progress) {
//                                                NSLog(@"hh = %.2f",progress);
//                                            } success:^(NSString *filePath) {
//                                                NSLog(@"s = %@",filePath);
//                                            } failed:^(NSString *tmpFilePath) {
//                                                NSLog(@"error = %@",tmpFilePath);
//
//                                            }];
    
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    _tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self dataSource].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[DownLoadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.url = [self dataSource][indexPath.section];
    
    return cell;
}





@end
