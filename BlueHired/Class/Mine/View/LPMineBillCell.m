//
//  LPMineBillCell.m
//  BlueHired
//
//  Created by iMac on 2019/1/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMineBillCell.h"
#import "LPBillRecordVC.h"
#import "LPWithDrawalVC.h"
 
#import "LPSalarycCard2VC.h"
#import "LPUndergoWebVC.h"
#import "LPScoreMoneyVC.h"

@interface LPMineBillCell()
 

@end

@implementation LPMineBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    self.showMoneyButton.layer.cornerRadius = 4;
    self.showMoneyButton.layer.borderColor = [UIColor baseColor].CGColor;
    [self.showMoneyButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    self.showMoneyButton.layer.borderWidth = 1;

    self.moneyLabel.font = FONT_SIZE(14);
    self.scoreLabel.font = FONT_SIZE(13);
    self.RecordLabel.font = FONT_SIZE(13);
    self.showMoneyButton.titleLabel.font = FONT_SIZE(14);

    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,LENGTH_SIZE(130),LENGTH_SIZE(18));
    gl.startPoint = CGPointMake(0, 1);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF9148"].CGColor,
                  (__bridge id)[UIColor colorWithHexString:@"#FF6643"].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.scoreTitleLabel.layer insertSublayer:gl atIndex:0];
    self.scoreTitleLabel.layer.cornerRadius = 4;
 
    
}

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
 
     if (userMaterialModel.data.money) {
        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",userMaterialModel.data.money.floatValue];
    }else{
        self.moneyLabel.text = @"账户余额：---";
    }
//    _showMoneyButton.selected = NO;
    self.scoreLabel.text = [NSString stringWithFormat:@"我的积分:%@",userMaterialModel.data.score ? userMaterialModel.data.score : @"--"];
}

- (IBAction)selectShowMoneyButton:(UIButton *)sender {
//    if (!AlreadyLogin) {
//        return;
//    }
//    sender.selected = !sender.selected;
//    if (!sender.selected) {
//        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",self.userMaterialModel.data.money.floatValue];
//    }else{
//        self.moneyLabel.text = @"账户余额：***";
//    }
    [self touchwithdrawalLabel:sender];
}


//个人账单
-(IBAction)touchbillRecordLabel:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPBillRecordVC *vc = [[LPBillRecordVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}
//提现
-(IBAction)touchwithdrawalLabel:(id)sender{
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        
//        if (self.userMaterialModel.data.isUserProblem.integerValue == 0) {
//            [self initSetSecretVC];
//            return;
//        }
//        self.showMoneyButton.enabled = NO;
        
        if (self.userMaterialModel.data.isBank.integerValue == 0) {        //添加银行卡
            GJAlertMessage *alert = [[GJAlertMessage alloc]
                                     initWithTitle:@"您还未绑定工资卡，请先绑定再提现"
                                     message:nil
                                     textAlignment:NSTextAlignmentCenter
                                     buttonTitles:@[@"取消",@"去绑定"]
                                     buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                     buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                     buttonClick:^(NSInteger buttonIndex) {
                                         if (buttonIndex) {
                                             LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                                         }
                                     }];
            [alert show];
        }else{
             
        }
        
       
    }
}

- (IBAction)TouchScore:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
       LPScoreMoneyVC *vc = [[LPScoreMoneyVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
    
}



 


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
