//
//  LPMineCardCell.m
//  BlueHired
//
//  Created by peng on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMineCardCell.h"
#import "LPBusinessReviewVC.h"
#import "LPWorkHourVC.h"
#import "LPSalaryBreakdownVC.h"
#import "LPLendVC.h"
#import "LPWorkorderListVC.h"
#import "LPDimissionFirmVC.h"
#import "LPRegisterVC.h"
#import "LPInviteVC.h"

#import "LPWorkHour2VC.h"
#import "LPSalarycCard2VC.h"
#import "LPAwardVC.h"


@implementation LPMineCardCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cellBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *imgArray = @[];
    NSArray *titleArray = @[];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
 
        imgArray = @[@"salaryDetail",@"award",@"borrow",@"invitationReward",@"interview",@"workingRecord",@"businessReview",@"resignation"];
        titleArray = @[@"工资领取",@"奖励领取",@"蓝聘借支",@"邀请奖励",@"面试预约",@"工时记录",@"企业点评",@"离职通知"];
 
    
    for (int i = 0; i < imgArray.count; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(i%4 * (SCREEN_WIDTH-LENGTH_SIZE(20) )/4, floor(i/4)*LENGTH_SIZE(80), (SCREEN_WIDTH-LENGTH_SIZE(20))/4, LENGTH_SIZE(80));
         bgView.userInteractionEnabled = YES;
        bgView.tag = i;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(((SCREEN_WIDTH-LENGTH_SIZE(20))/4-LENGTH_SIZE(26))/2, LENGTH_SIZE(16), LENGTH_SIZE(26), LENGTH_SIZE(26));
         imageView.image = [UIImage imageNamed:imgArray[i]];
        [bgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, LENGTH_SIZE(50), (SCREEN_WIDTH-LENGTH_SIZE(20))/4, LENGTH_SIZE(20));
         label.textColor = [UIColor colorWithHexString:@"#343434"];
        label.font = FONT_SIZE(13);
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
    NSLog(@"重复点击次数");
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
 
            if (index == 0) {

                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.RecordDate = self.RecordArr.count?self.RecordArr[0]:nil;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
     
            }else if (index == 1){
                LPAwardVC *vc = [[LPAwardVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
//                vc.type = 1;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                
            }else if (index == 2){
                LPLendVC *vc = [[LPLendVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 3){
                LPRegisterVC *vc = [[LPRegisterVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 4){
                LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 5){
                LPWorkHour2VC *vc = [[LPWorkHour2VC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.isPush = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 6){
                LPBusinessReviewVC *vc = [[LPBusinessReviewVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 7){

                LPDimissionFirmVC *vc = [[LPDimissionFirmVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
 
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
