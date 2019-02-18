//
//  LPMine2Cell.m
//  BlueHired
//
//  Created by iMac on 2019/1/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMine2Cell.h"
#import "LPSetVC.h"
#import "LPSignInfoVC.h"
#import "LPUserInfoVC.h"
#import "LPBillRecordVC.h"
#import "LPWithDrawalVC.h"
@implementation LPMine2Cell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.signInButton.layer.cornerRadius = 14;
    self.user_urlImgView.layer.cornerRadius = 28;
    self.BackView1.layer.cornerRadius = 4;
    self.backView2.layer.cornerRadius = 4;
    
    self.user_urlImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBgView)];
    [self.user_urlImgView addGestureRecognizer:tap];

    if ([DeviceUtils deviceType] == IPhone_X) {
        self.BackView1_Height.constant = 139.0 + 24;
    }else{
        self.BackView1_Height.constant = 139;
    }
    
}

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
    if (AlreadyLogin) {
        self.redactButton.hidden = NO;
    }else{
        self.redactButton.hidden = YES;
    }
    
    [self.user_urlImgView sd_setImageWithURL:[NSURL URLWithString:userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"UserImage"]];
    self.user_nameLabel.text = userMaterialModel.data.user_name ? userMaterialModel.data.user_name : @"登录/注册";
//    self.gradingLabel.text = userMaterialModel.data.grading ? userMaterialModel.data.grading : @"登录后可享受更多特权";
    self.moodNumLabel.text = [NSString stringWithFormat:@"帖子：%@",userMaterialModel.data.moodNum ? userMaterialModel.data.moodNum : @"--"];
    self.concernNumLabel.text = [NSString stringWithFormat:@"粉丝：%@",userMaterialModel.data.concernNum ? userMaterialModel.data.concernNum : @"--"];
    if (userMaterialModel.data.money) {
        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",userMaterialModel.data.money.floatValue];
    }else{
        self.moneyLabel.text = @"账户余额：---";
    }
    self.user_sexImgView.hidden = NO;
    
    if (userMaterialModel.data.grading) {
//        self.gradingLabel.hidden = YES;
        self.gradingiamge.hidden = NO;
        self.gradingiamge.image = [UIImage imageNamed:userMaterialModel.data.grading];
        //
        //        if (userMaterialModel.data.score.integerValue >=0 && userMaterialModel.data.score.integerValue <3000) {
        //            self.gradingiamge.image = [UIImage imageNamed:@"见习职工"];
        //
        //        }else if (userMaterialModel.data.score.integerValue >= 3000 && userMaterialModel.data.score.integerValue < 6000){
        //            self.gradingiamge.image = [UIImage imageNamed:@"初级职工"];
        //
        //        }else if (userMaterialModel.data.score.integerValue >= 6000 && userMaterialModel.data.score.integerValue < 12000){
        //            self.gradingiamge.image = [UIImage imageNamed:@"中级职工"];
        //
        //        }else if (userMaterialModel.data.score.integerValue >= 12000 && userMaterialModel.data.score.integerValue < 18000){
        //            self.gradingiamge.image = [UIImage imageNamed:@"高级职工"];
        //
        //        }else if (userMaterialModel.data.score.integerValue >= 18000 && userMaterialModel.data.score.integerValue < 24000){
        //            self.gradingiamge.image = [UIImage imageNamed:@"部门精英"];
        //
        //        }else if (userMaterialModel.data.score.integerValue >= 24000 && userMaterialModel.data.score.integerValue < 30000){
        //            self.gradingiamge.image = [UIImage imageNamed:@"部门经理"];
        //
        //        }else if (userMaterialModel.data.score.integerValue >= 30000 && userMaterialModel.data.score.integerValue < 36000){
        //            self.gradingiamge.image = [UIImage imageNamed:@"区域经理"];
        //
        //        }else if (userMaterialModel.data.score.integerValue >= 36000 && userMaterialModel.data.score.integerValue < 45000){
        //            self.gradingiamge.image = [UIImage imageNamed:@"总经理"];
        //
        //        }else{
        //            self.gradingiamge.image = [UIImage imageNamed:@"董事长"];
        //
        //        }
    }else{
//        self.gradingLabel.hidden = NO;
        self.gradingiamge.hidden = YES;
    }
    
    if ([userMaterialModel.data.user_sex integerValue] == 0) {//0未知1男2女
        self.user_sexImgView.hidden = YES;
    }else if ([userMaterialModel.data.user_sex integerValue] == 1) {
        self.user_sexImgView.image = [UIImage imageNamed:@"male"];
    }else if ([userMaterialModel.data.user_sex integerValue] == 2) {
        self.user_sexImgView.image = [UIImage imageNamed:@"female"];
    }
    if (userMaterialModel.data.workStatus) {
        if ([userMaterialModel.data.workStatus integerValue] == 0) { //0待业1在职2入职中
            self.workStatusLabel.text = @"状态：待业";
        } else if ([userMaterialModel.data.workStatus integerValue] == 1){
            self.workStatusLabel.text = @"状态：在职";
        } else if ([userMaterialModel.data.workStatus integerValue] == 2){
            self.workStatusLabel.text = @"状态：入职中";
        }
    }else{
        self.workStatusLabel.text = @"状态：--";
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"积分：%@",userMaterialModel.data.score ? userMaterialModel.data.score : @"--"];
}
-(void)setSignin:(BOOL)signin{
    _signin = signin;
    if (AlreadyLogin) {
        self.signInButton.hidden = NO;
    }else{
        self.signInButton.hidden = YES;
    }
    if (signin) {
        [self.signInButton setTitle:@"已签到" forState:UIControlStateNormal];
    }else{
        [self.signInButton setTitle:@"签到" forState:UIControlStateNormal];
    }
}


- (IBAction)selectShowMoneyButton:(UIButton *)sender {
    if (!AlreadyLogin) {
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",self.userMaterialModel.data.money.floatValue];
    }else{
        self.moneyLabel.text = @"账户余额：***";
    }
}


- (IBAction)touchSignInButton:(UIButton *)sender {
    LPSignInfoVC *vc = [[LPSignInfoVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}



- (IBAction)touchEditButton:(UIButton *)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPUserInfoVC *vc = [[LPUserInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)touchSetButton:(id)sender {
    LPSetVC *vc = [[LPSetVC alloc]init];
    vc.userMaterialModel = self.userMaterialModel;
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}
-(void)touchBgView{
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPUserInfoVC *vc = [[LPUserInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
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
        LPWithDrawalVC *vc = [[LPWithDrawalVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.balance = self.userMaterialModel.data.money;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
