//
//  LPCalendarSignCell.m
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCalendarSignCell.h"

@implementation LPCalendarSignCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(21, 23));
            make.center.equalTo(self.contentView);
        }];
//        self.imgView.image = [UIImage imageNamed:@"sign_img"];
        self.imgView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
