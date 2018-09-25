//
//  LPMineCardCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMineCardCell.h"
#import "LPBusinessReviewVC.h"
#import "LPWorkHourVC.h"
#import "LPSalaryBreakdownVC.h"
#import "LPLendVC.h"
#import "LPWorkorderListVC.h"

@implementation LPMineCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    NSArray *imgArray = @[@"workingRecord",@"salaryDetail",@"borrow",@"resignation",@"businessReview",@"interview",@"invitationReward",@"inviteFriends"];
    NSArray *titleArray = @[@"工时记录",@"工资明细",@"蓝聘借支",@"离职通知",@"企业点评",@"面试预约",@"邀请奖励",@"邀请好友"];
    
    for (int i = 0; i < 8; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, floor(i/4)*86, SCREEN_WIDTH/4, 86);
//        bgView.backgroundColor = randomColor;
        bgView.userInteractionEnabled = YES;
        bgView.tag = i;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake((SCREEN_WIDTH/4-37)/2, 15, 37, 37);
//        imageView.backgroundColor = randomColor;
        imageView.image = [UIImage imageNamed:imgArray[i]];
        [bgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 60, SCREEN_WIDTH/4, 20);
//        label.backgroundColor = randomColor;
        label.textColor = [UIColor colorWithHexString:@"#343434"];
        label.font = [UIFont systemFontOfSize:12];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        [self.cellBgView addSubview:bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBgView:)];
        [bgView addGestureRecognizer:tap];
    }
}

-(void)touchBgView:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    if (index == 4) {
        NSLog(@"企业点评");
        LPBusinessReviewVC *vc = [[LPBusinessReviewVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }else{
        if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
            if (index == 0) {
                LPWorkHourVC *vc = [[LPWorkHourVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 1){
                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 2){
                LPLendVC *vc = [[LPLendVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 5){
                LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
