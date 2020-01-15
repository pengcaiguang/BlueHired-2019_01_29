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
#import "LPMyMoodVC.h"
#import "LPConcerNumVC.h"
#import "LPInfoVC.h"
#import "LPUndergoWebVC.h"



@implementation LPMine2Cell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.signInButton.layer.cornerRadius = LENGTH_SIZE(14);
    self.user_urlImgView.layer.cornerRadius = LENGTH_SIZE(28);
    self.user_ImgViewBg.layer.cornerRadius = LENGTH_SIZE(29);
    self.BackView1.layer.cornerRadius = 4;
    self.backView2.layer.cornerRadius = 4;
    
    self.user_urlImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBgView)];
    [self.user_urlImgView addGestureRecognizer:tap];

    if (IS_iPhoneX) {
        self.BackView1_Height.constant = LENGTH_SIZE(139) + 24;
        self.Edit_Top.constant = LENGTH_SIZE(30) +24;
    }else{
        self.BackView1_Height.constant = LENGTH_SIZE(139);
        self.Edit_Top.constant = LENGTH_SIZE(30);
    }
    
    [self.Slider setThumbImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    
    
    UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchMoodNum)];
    self.moodNumLabel.userInteractionEnabled = YES;
    [self.moodNumLabel addGestureRecognizer:TapGestureRecognizerimageBg];
    
    UITapGestureRecognizer *TapGestureRecognizerimageBg2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchconcernNum)];
    self.concernNumLabel.userInteractionEnabled = YES;
    [self.concernNumLabel addGestureRecognizer:TapGestureRecognizerimageBg2];
    
    UITapGestureRecognizer *TapGestureRecognizerimageBg3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchworkStatus)];
    self.workStatusLabel.userInteractionEnabled = YES;
    [self.workStatusLabel addGestureRecognizer:TapGestureRecognizerimageBg3];
    
//    self.user_urlImgView.layer.borderWidth = 10;
//    self.user_urlImgView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.15].CGColor;
    
//    UIView *view = self.moodNumLabel.superview;
    self.contentView.backgroundColor = [UIColor colorWithRed:60/255.0 green:175/255.0 blue:255/255.0 alpha:1.0];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,Screen_Width,LENGTH_SIZE(200));
    gl.startPoint = CGPointMake(1, 1);
    gl.endPoint = CGPointMake(0, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:31/255.0 green:163/255.0 blue:255/255.0 alpha:1.0].CGColor,
                  (__bridge id)[UIColor colorWithRed:67/255.0 green:204/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.contentView.layer insertSublayer:gl atIndex:0];
    
    self.MessageButton.layer.cornerRadius = 6.5;
    
 
    self.Slider_right.constant = LENGTH_SIZE(108);
  
    //字体大小适配
    self.user_nameLabel.font = FONT_SIZE(16);
    self.signInButton.titleLabel.font = FONT_SIZE(15);
    self.scoreCurrentLabel.font = FONT_SIZE(10);
    self.scoreLabel.font = FONT_SIZE(10);
    self.moodNumLabel.font = FONT_SIZE(14);
    self.concernNumLabel.font = FONT_SIZE(14);
    self.workStatusLabel.font = FONT_SIZE(14);
    self.LoginLabel.font = FONT_SIZE(16);
    
}

-(void)TouchMoodNum{
    if (AlreadyLogin) {
        LPMyMoodVC *vc = [[LPMyMoodVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

-(void)TouchconcernNum{
    if (AlreadyLogin) {
        LPConcerNumVC *vc = [[LPConcerNumVC alloc] init];
        vc.Type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}
-(void)TouchworkStatus{
    if (AlreadyLogin) {
        LPConcerNumVC *vc = [[LPConcerNumVC alloc] init];
        vc.Type = 2;
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
    if (AlreadyLogin) {
        self.redactButton.hidden = NO;
        self.user_nameLabel.text =  [LPTools isNullToString:userMaterialModel.data.user_name];
        
        if (userMaterialModel.data.role.integerValue == 0) {
            if ([userMaterialModel.data.workStatus integerValue] == 0) { //0待业1在职2入职中
                self.user_nameLabel.text = [NSString stringWithFormat:@"%@ (待业)",[LPTools isNullToString:userMaterialModel.data.user_name]];
            } else if ([userMaterialModel.data.workStatus integerValue] == 1){
                self.user_nameLabel.text = [NSString stringWithFormat:@"%@ (在职)",[LPTools isNullToString:userMaterialModel.data.user_name]];
            } else if ([userMaterialModel.data.workStatus integerValue] == 2){
                self.user_nameLabel.text = [NSString stringWithFormat:@"%@ (入职中)",[LPTools isNullToString:userMaterialModel.data.user_name]];
            }
        }else{
            self.user_nameLabel.text = [NSString stringWithFormat:@"%@",[LPTools isNullToString:userMaterialModel.data.user_name]];
        }

        
        self.Slider.hidden = NO;
        self.scoreCurrentLabel.hidden = NO;
        self.scoreLabel.hidden = NO;
        self.scoreImage.hidden = NO;
        self.LoginLabel.hidden = YES;
        self.user_nameLabel.hidden = NO;
    }else{
        self.Slider.hidden = YES;
        self.scoreCurrentLabel.hidden = YES;
        self.scoreLabel.hidden = YES;
        self.scoreImage.hidden = YES;

        self.redactButton.hidden = YES;
        self.user_nameLabel.hidden = YES;
        self.LoginLabel.hidden = NO;

    }
    NSLog(@"头像宽度 = %f",self.user_urlImgView.lx_width);
    [self.user_urlImgView sd_setImageWithURL:[NSURL URLWithString:userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"UserImage"]];
//    self.gradingLabel.text = userMaterialModel.data.grading ? userMaterialModel.data.grading : @"登录后可享受更多特权";
    self.moodNumLabel.text = [NSString stringWithFormat:@"动态: %@",userMaterialModel.data.moodNum ? userMaterialModel.data.moodNum : @"--"];
    self.concernNumLabel.text = [NSString stringWithFormat:@"粉丝: %@",userMaterialModel.data.concernNum ? userMaterialModel.data.concernNum : @"--"];
    self.workStatusLabel.text = [NSString stringWithFormat:@"关注: %@",userMaterialModel.data.attentionNum ? userMaterialModel.data.attentionNum : @"--"];

 
    
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
        
//        CGFloat scoreMax = 0;
//        CGFloat scoreMin = 0;
//                if (userMaterialModel.data.score.integerValue >=0 && userMaterialModel.data.score.integerValue <3000) {
////                    self.gradingiamge.image = [UIImage imageNamed:@"见习职工"];
//                    scoreMin = 0;
//                    scoreMax = 3000;
//                }else if (userMaterialModel.data.score.integerValue >= 3000 && userMaterialModel.data.score.integerValue < 6000){
////                    self.gradingiamge.image = [UIImage imageNamed:@"初级职工"];
//                    scoreMin = 3000;
//                    scoreMax = 6000;
//                }else if (userMaterialModel.data.score.integerValue >= 6000 && userMaterialModel.data.score.integerValue < 12000){
//                    scoreMin = 6000;
//                    scoreMax = 12000;
////                    self.gradingiamge.image = [UIImage imageNamed:@"中级职工"];
//                }else if (userMaterialModel.data.score.integerValue >= 12000 && userMaterialModel.data.score.integerValue < 18000){
//                    scoreMin = 12000;
//                    scoreMax = 18000;
////                    self.gradingiamge.image = [UIImage imageNamed:@"高级职工"];
//                }else if (userMaterialModel.data.score.integerValue >= 18000 && userMaterialModel.data.score.integerValue < 24000){
//                    scoreMin = 18000;
//                    scoreMax = 24000;
////                    self.gradingiamge.image = [UIImage imageNamed:@"部门精英"];
//                }else if (userMaterialModel.data.score.integerValue >= 24000 && userMaterialModel.data.score.integerValue < 30000){
//                    scoreMin = 24000;
//                    scoreMax = 30000;
////                    self.gradingiamge.image = [UIImage imageNamed:@"部门经理"];
//                }else if (userMaterialModel.data.score.integerValue >= 30000 && userMaterialModel.data.score.integerValue < 36000){
//                    scoreMin = 30000;
//                    scoreMax = 36000;
////                    self.gradingiamge.image = [UIImage imageNamed:@"区域经理"];
//                }else if (userMaterialModel.data.score.integerValue >= 36000 && userMaterialModel.data.score.integerValue < 45000){
////                    self.gradingiamge.image = [UIImage imageNamed:@"总经理"];
//                    scoreMin = 36000;
//                    scoreMax = 45000;
//                }else{
////                    self.gradingiamge.image = [UIImage imageNamed:@"董事长"];
//                    scoreMin = 45000;
//                    scoreMax = 45000;
//                }
 
        self.Slider.value = (userMaterialModel.data.emValue.floatValue-userMaterialModel.data.downEmValue.floatValue)/(userMaterialModel.data.upEmValue.floatValue-userMaterialModel.data.downEmValue.floatValue);
        self.scoreCurrentLabel.text = [NSString stringWithFormat:@"当前经验值:%ld",(long)userMaterialModel.data.emValue.integerValue];
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)userMaterialModel.data.upEmValue.integerValue];

        self.Slider.value = userMaterialModel.data.emValue.integerValue>=45000?1.0:self.Slider.value;
        self.scoreImage.hidden = userMaterialModel.data.emValue.integerValue>=45000;
        self.scoreLabel.hidden = userMaterialModel.data.emValue.integerValue>=45000;
     
        
        
    }else{
         self.gradingiamge.hidden = YES;
    }
    
    if ([userMaterialModel.data.user_sex integerValue] == 0) {//0未知1男2女
        self.user_sexImgView.hidden = YES;
    }else if ([userMaterialModel.data.user_sex integerValue] == 1) {
        self.user_sexImgView.image = [UIImage imageNamed:@"male"];
    }else if ([userMaterialModel.data.user_sex integerValue] == 2) {
        self.user_sexImgView.image = [UIImage imageNamed:@"female"];
    }
 
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
        [self.signInButton setImage:nil forState:UIControlStateNormal];
    }else{
        [self.signInButton setTitle:@"签到" forState:UIControlStateNormal];
        [self.signInButton setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
        [self.signInButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, LENGTH_SIZE(-14), 0.0, 0.0)];
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

- (IBAction)TouchMessageButton:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPInfoVC *vc = [[LPInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
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
    
    }
}
 
- (IBAction)TouchScore:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPUndergoWebVC *vc = [[LPUndergoWebVC alloc]init];
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
