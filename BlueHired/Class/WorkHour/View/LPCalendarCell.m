//
//  LPCalendarCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/12.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCalendarCell.h"

@implementation LPCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-8);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        self.label.backgroundColor = [UIColor baseColor];
        self.label.layer.masksToBounds = YES;
        self.label.layer.cornerRadius = 6;
        self.label.text = @"记";
        self.label.font = [UIFont systemFontOfSize:9];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
