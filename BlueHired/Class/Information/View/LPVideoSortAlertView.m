//
//  LPVideoSortAlertView.m
//  BlueHired
//
//  Created by iMac on 2018/11/16.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPVideoSortAlertView.h"

static NSInteger rowHeight = 44;

@interface LPVideoSortAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,copy) NSString *selectTitle;

@end

@implementation LPVideoSortAlertView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleArray = @[@"视频",@"资讯"];
        
        self.selectTitle = @"";
        
        self.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.tableview];
    }
    return self;
}



 

@end
