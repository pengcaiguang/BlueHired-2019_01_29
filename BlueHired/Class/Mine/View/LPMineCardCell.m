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
#import "LPDimissionFirmVC.h"
#import "LPRegisterVC.h"
#import "LPInviteVC.h"
#import "LPRecruitmentVC.h"
#import "LPLendAuditVC.h"
#import "LPStaffManageViewController.h"
#import "LPWStoreManageVC.h"


@implementation LPMineCardCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cellBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *imgArray = @[];
    NSArray *titleArray = @[];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
//    if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
//        kUserDefaultsValue(USERDATA).integerValue >= 8){
//        imgArray = @[@"Recruitment",@"Personnel",@"borrow",@"invitationReward",@"InviteCode"];
//        titleArray = @[@"招聘管理",@"人员管理",@"借支审核",@"邀请奖励",@"邀请二维码"];
//    }else if (kUserDefaultsValue(USERDATA).integerValue == 1 || kUserDefaultsValue(USERDATA).integerValue == 2){
//        imgArray = @[@"workingRecord",@"salaryDetail",@"borrow",@"resignation",@"businessReview",@"interview",@"storeImage"];
//        titleArray = @[@"工时记录",@"工资明细",@"蓝聘借支",@"离职通知",@"企业点评",@"面试预约",@"门店管理"];
//    }else if (kUserDefaultsValue(USERDATA).integerValue == 6){
//        imgArray = @[@"workingRecord",@"salaryDetail",@"borrow",@"resignation",@"businessReview",@"interview",@"invitationReward",@"storefront"];
//        titleArray = @[@"工时记录",@"工资明细",@"蓝聘借支",@"离职通知",@"企业点评",@"面试预约",@"邀请奖励",@"门店管理"];
//    }else{
//        imgArray = @[@"workingRecord",@"salaryDetail",@"borrow",@"resignation",@"businessReview",@"interview",@"invitationReward",@"inviteFriends"];
//        titleArray = @[@"工时记录",@"工资明细",@"蓝聘借支",@"离职通知",@"企业点评",@"面试预约",@"邀请奖励",@"邀请好友"];
//    }
    self.cellBghigh.constant = 172;

    if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
        kUserDefaultsValue(USERDATA).integerValue >= 8){
        imgArray = @[@"Recruitment",@"Personnel",@"borrow",@"invitationReward",@"inviteFriends"];
        titleArray = @[@"招聘管理",@"人员管理",@"借支审核",@"邀请奖励",@"邀请二维码"];
    }else if (kUserDefaultsValue(USERDATA).integerValue == 1 || kUserDefaultsValue(USERDATA).integerValue == 2){
        imgArray = @[@"salaryDetail",@"borrow",@"resignation",@"storeImage"];
        titleArray = @[@"工资明细",@"蓝聘借支",@"离职通知",@"门店管理"];
        self.cellBghigh.constant = 86;
    }else if (kUserDefaultsValue(USERDATA).integerValue == 6){
        imgArray = @[@"salaryDetail",@"borrow",@"resignation",@"invitationReward",@"storefront"];
        titleArray = @[@"工资明细",@"蓝聘借支",@"离职通知",@"邀请奖励",@"门店管理"];
    }else{
        imgArray = @[@"salaryDetail",@"borrow",@"resignation",@"invitationReward",@"inviteFriends"];
        titleArray = @[@"工资明细",@"蓝聘借支",@"离职通知",@"邀请奖励",@"邀请好友"];
    }
    
    
    for (int i = 0; i < imgArray.count; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(i%4 * (SCREEN_WIDTH-20)/4, floor(i/4)*86, (SCREEN_WIDTH-20)/4, 86);
//        bgView.backgroundColor = randomColor;
        bgView.userInteractionEnabled = YES;
        bgView.tag = i;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(((SCREEN_WIDTH-20)/4-26)/2, 16, 26, 26);
//        imageView.backgroundColor = randomColor;
        imageView.image = [UIImage imageNamed:imgArray[i]];
        [bgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 50, (SCREEN_WIDTH-20)/4, 20);
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
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        if (kUserDefaultsValue(USERDATA).integerValue == 4  ||
            kUserDefaultsValue(USERDATA).integerValue >= 8) {           //驻厂
            if (index == 0) {
                if (kUserDefaultsValue(USERDATA).integerValue == 4  ||
                    kUserDefaultsValue(USERDATA).integerValue == 9  ||
                    kUserDefaultsValue(USERDATA).integerValue == 10 ||
                    kUserDefaultsValue(USERDATA).integerValue == 13 ||
                    kUserDefaultsValue(USERDATA).integerValue == 14 ||
                    kUserDefaultsValue(USERDATA).integerValue == 17 ||
                    kUserDefaultsValue(USERDATA).integerValue == 18 ||
                    kUserDefaultsValue(USERDATA).integerValue == 21 ) {
                    LPRecruitmentVC *vc = [[LPRecruitmentVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                }else{
                    [LPTools AlertMessageView:@"权限不足"];
                }

            }else if (index == 1){
                LPStaffManageViewController *vc = [[LPStaffManageViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 2){
                if (kUserDefaultsValue(USERDATA).integerValue == 4  ||
                    kUserDefaultsValue(USERDATA).integerValue == 8  ||
                    kUserDefaultsValue(USERDATA).integerValue == 10 ||
                    kUserDefaultsValue(USERDATA).integerValue == 12 ||
                    kUserDefaultsValue(USERDATA).integerValue == 14 ||
                    kUserDefaultsValue(USERDATA).integerValue == 16 ||
                    kUserDefaultsValue(USERDATA).integerValue == 18 ||
                    kUserDefaultsValue(USERDATA).integerValue == 20 ) {
                    LPLendAuditVC *vc = [[LPLendAuditVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                }else{
                    [LPTools AlertMessageView:@"权限不足"];
                }

            }else if (index == 3){
                LPRegisterVC *vc = [[LPRegisterVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 4){
                LPInviteVC *vc = [[LPInviteVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
        } else if (kUserDefaultsValue(USERDATA).integerValue == 1 ||
                   kUserDefaultsValue(USERDATA).integerValue == 2) {  //店主
            if (index == 0) {
//                LPWorkHourVC *vc = [[LPWorkHourVC alloc]init];
                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 1){
//                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                LPLendVC *vc = [[LPLendVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 2){
//                LPLendVC *vc = [[LPLendVC alloc]init];
                LPDimissionFirmVC *vc = [[LPDimissionFirmVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 3){
//                LPDimissionFirmVC *vc = [[LPDimissionFirmVC alloc]init];
                LPWStoreManageVC *vc = [[LPWStoreManageVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
//            else if (index == 4){
//                LPBusinessReviewVC *vc = [[LPBusinessReviewVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }else if (index == 5){
//                LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }else if (index == 6){              //门店管理
//                LPWStoreManageVC *vc = [[LPWStoreManageVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }
            
        }else if (kUserDefaultsValue(USERDATA).integerValue == 6){
            if (index == 0) {
//                LPWorkHourVC *vc = [[LPWorkHourVC alloc]init];
                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 1){
//                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                LPLendVC *vc = [[LPLendVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 2){
//                LPLendVC *vc = [[LPLendVC alloc]init];
                LPDimissionFirmVC *vc = [[LPDimissionFirmVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 3){
//                LPDimissionFirmVC *vc = [[LPDimissionFirmVC alloc]init];
                LPRegisterVC *vc = [[LPRegisterVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 4){
//                LPBusinessReviewVC *vc = [[LPBusinessReviewVC alloc]init];
                LPWStoreManageVC *vc = [[LPWStoreManageVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
//            else if (index == 5){
//                LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }else if (index == 6){
//                LPRegisterVC *vc = [[LPRegisterVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }else if (index == 7){      //门店管理
//                LPWStoreManageVC *vc = [[LPWStoreManageVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }
        }else{
            if (index == 0) {
//                LPWorkHourVC *vc = [[LPWorkHourVC alloc]init];
                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 1){
//                LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
                LPLendVC *vc = [[LPLendVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 2){
//                LPLendVC *vc = [[LPLendVC alloc]init];
                LPDimissionFirmVC *vc = [[LPDimissionFirmVC alloc]init];

                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 3){
//                LPDimissionFirmVC *vc = [[LPDimissionFirmVC alloc]init];
                LPRegisterVC *vc = [[LPRegisterVC alloc]init];

                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (index == 4){
//                LPBusinessReviewVC *vc = [[LPBusinessReviewVC alloc]init];
                LPInviteVC *vc = [[LPInviteVC alloc]init];

                vc.hidesBottomBarWhenPushed = YES;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
//            else if (index == 5){
//                LPWorkorderListVC *vc = [[LPWorkorderListVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }else if (index == 6){
//                LPRegisterVC *vc = [[LPRegisterVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }else if (index == 7){
//                LPInviteVC *vc = [[LPInviteVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//            }
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
