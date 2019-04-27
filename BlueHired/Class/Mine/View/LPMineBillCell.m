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
    
}

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
 
     if (userMaterialModel.data.money) {
        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",userMaterialModel.data.money.floatValue];
    }else{
        self.moneyLabel.text = @"账户余额：---";
    }
//    _showMoneyButton.selected = NO;
    self.scoreLabel.text = [NSString stringWithFormat:@"积分：%@",userMaterialModel.data.score ? userMaterialModel.data.score : @"--"];
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
        
        if (self.userMaterialModel.data.isUserProblem.integerValue == 0) {
            [self initSetSecretVC];
            return;
        }
        
        LPWithDrawalVC *vc = [[LPWithDrawalVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.balance = self.userMaterialModel.data.money;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)initSetSecretVC{
    
    NSString *str1 = @"为了您的账号安全，请先设置密保问题。";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    WEAK_SELF()
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str
                                                         message:nil
                                                      IsShowhead:YES
                                                     backDismiss:YES
                                                   textAlignment:0
                                                    buttonTitles:@[@"去设置"]
                                                    buttonsColor:@[[UIColor baseColor]]
                                         buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                     buttonClick:^(NSInteger buttonIndex){
        if (buttonIndex == 0) {
            LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
            vc.type = 1;
            vc.hidesBottomBarWhenPushed = YES;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }
    }];
    [alert show];
    
}


@end
