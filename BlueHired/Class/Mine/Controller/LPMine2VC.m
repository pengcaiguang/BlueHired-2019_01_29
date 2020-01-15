//
//  LPMine2VC.m
//  BlueHired
//
//  Created by iMac on 2020/1/3.
//  Copyright © 2020 lanpin. All rights reserved.
//

#import "LPMine2VC.h"
#import "LPInfoVC.h"
#import "LPUserInfoVC.h"
#import "LPUndergoWebVC.h"
#import "LPSignInfoVC.h"
#import "LPScoreMoneyVC.h"
#import "LPBillRecordVC.h"
#import "LPSalaryBreakdownVC.h"
#import "LPReMoneyDrawVC.h"
#import "LPCollectionVC.h"
#import "LPActivityVC.h"
#import "LPBlackUserVC.h"
#import "LPHXCustomerServiceVC.h"
#import "LPSetVC.h"
#import "LPAddressBookVC.h"
#import "LPScoreStore.h"
#import <Contacts/Contacts.h>
#import "LPMyWalletVC.h"
#import "LPInviteRewardsVC.h"


@interface LPMine2VC ()
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *gradingiamge;
@property (weak, nonatomic) IBOutlet UILabel *LoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *UpgradesScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitGetLabel;

@property (weak, nonatomic) IBOutlet UILabel *awardRedLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityRedLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeRedLabel;

 
@property (nonatomic,strong) NSArray *RecordArr;
@property (nonatomic,strong) UILabel *MessageLabel;

@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;

@end

@implementation LPMine2VC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setCornerRadiusView];
    [self setNavArrView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

      if (AlreadyLogin) {
          [self requestUserMaterial];
          [self requestQueryInfounreadNum];
          [self requestQueryGetBillRecordList];
          [self requestSelectCurIsSign];
          
          self.userName.hidden = NO;
          self.gradingiamge.hidden = NO;
          self.UpgradesScoreLabel.hidden = NO;
          self.signInButton.hidden = NO;
          self.LoginLabel.hidden = YES;
          
        } else {
            self.RecordArr = [NSArray new];
            self.userMaterialModel = nil;
            
            self.MessageLabel.hidden = YES;
            self.moneyLabel.text = @"未登录";
            self.userName.hidden = YES;
            self.gradingiamge.hidden = YES;
            self.UpgradesScoreLabel.hidden = YES;
            self.signInButton.hidden = YES;
            self.waitGetLabel.hidden = YES;

            self.LoginLabel.hidden = NO;

        }

}


- (void)setNavArrView{
        
     
    UIView *leftBarButtonView = [[UIView alloc]init];
    leftBarButtonView.userInteractionEnabled = YES;
//    leftBarButtonView.backgroundColor = [UIColor redColor];

    
//    if (@available(iOS 11.0, *)) {
//        if (@available(iOS 13.0, *)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              self.navigationItem.titleView = leftBarButtonView;
              [self.navigationItem.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                  if ([DeviceUtils systemVersion] <10.0) {
                      make.width.mas_offset(SCREEN_WIDTH);
                      make.height.mas_offset(64);
                  }else{
                      make.width.mas_offset(SCREEN_WIDTH - LENGTH_SIZE(32));
                      make.height.mas_offset(44);
                  }
              }];
       });
            
//        }else{
//            leftBarButtonView.frame = CGRectMake(0, 0, SCREEN_WIDTH -LENGTH_SIZE(32) , 44);
//            self.navigationItem.titleView = leftBarButtonView;
//        }
//
//    }else{
//        self.navigationItem.titleView = leftBarButtonView;
//        [self.navigationItem.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_offset(SCREEN_WIDTH - LENGTH_SIZE(32));
//            make.height.mas_offset(44);
//        }];
//    }
    
    
    UIButton *infoBtn = [[UIButton alloc] init];
    [leftBarButtonView addSubview:infoBtn];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(44);
        make.bottom.mas_offset(0);
        if ([DeviceUtils systemVersion]<10) {
            make.left.mas_offset(16);
        }else{
            make.left.mas_offset(LENGTH_SIZE(0));
        }
    }];
    [infoBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    infoBtn.titleLabel.font = FONT_SIZE(15);
    [infoBtn addTarget:self action:@selector(TouchEditButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchEditButton:)];
    self.UserImage.userInteractionEnabled = YES;
    [self.UserImage addGestureRecognizer:Tap];
    
    
    UIButton *MessageBtn = [[UIButton alloc] init];
    [leftBarButtonView addSubview:MessageBtn];
    [MessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.height.mas_offset(44);
        if ([DeviceUtils systemVersion]<10.0) {
            make.right.mas_offset(LENGTH_SIZE(-16));
        }else{
            make.right.mas_offset(LENGTH_SIZE(0));
        }
    }];
    [MessageBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [MessageBtn addTarget:self action:@selector(TouchMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *MessageLabel = [[UILabel alloc] init];
    [leftBarButtonView addSubview:MessageLabel];
    self.MessageLabel = MessageLabel;
    [MessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MessageBtn.mas_top);
        make.right.equalTo(MessageBtn.mas_right).offset(LENGTH_SIZE(4));
        make.height.mas_offset(LENGTH_SIZE(14));
        make.width.greaterThanOrEqualTo(LENGTH_SIZE(14));

    }];
    MessageLabel.textAlignment = NSTextAlignmentCenter;
    MessageLabel.font = [UIFont boldSystemFontOfSize:8];
    MessageLabel.backgroundColor = [UIColor colorWithHexString:@"#EB4444"];
    MessageLabel.layer.cornerRadius = LENGTH_SIZE(7);
    MessageLabel.layer.borderWidth = 0.f;
    MessageLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    MessageLabel.layer.masksToBounds = YES;

    MessageLabel.clipsToBounds = YES;
    MessageLabel.textColor = [UIColor whiteColor];
    MessageLabel.hidden = YES;
 
}

- (void)setCornerRadiusView{
    //圆角
       self.UserImage.layer.cornerRadius = LENGTH_SIZE(33);
     
       self.sexImage.layer.cornerRadius = LENGTH_SIZE(9);
       self.sexImage.layer.borderWidth = 1;
       self.sexImage.layer.borderColor = [UIColor whiteColor].CGColor;
       
       self.waitGetLabel.layer.cornerRadius = LENGTH_SIZE(7);
       self.waitGetLabel.layer.borderWidth = 0;
       self.waitGetLabel.layer.borderColor = [UIColor whiteColor].CGColor;
       
       
       self.awardRedLabel.layer.cornerRadius = LENGTH_SIZE(9);
       self.awardRedLabel.layer.borderWidth = 0;
       self.awardRedLabel.layer.borderColor = [UIColor whiteColor].CGColor;
       
       self.awardRedLabel.layer.cornerRadius = 5;
       self.awardRedLabel.layer.borderWidth = 0;
       self.awardRedLabel.layer.borderColor = [UIColor whiteColor].CGColor;
       
       self.activityRedLabel.layer.cornerRadius = 5;
       self.activityRedLabel.layer.borderWidth = 0;
       self.activityRedLabel.layer.borderColor = [UIColor whiteColor].CGColor;
       
       self.storeRedLabel.layer.cornerRadius = 5;
       self.storeRedLabel.layer.borderWidth = 0;
       self.storeRedLabel.layer.borderColor = [UIColor whiteColor].CGColor;
       
       self.signInButton.layer.cornerRadius = LENGTH_SIZE(4);
}

#pragma mark Touch
//消息
- (void)TouchMessageButton:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPInfoVC *vc = [[LPInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}
//个人资料
 - (void)TouchEditButton:(UIButton *)sender {
     if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
         LPUserInfoVC *vc = [[LPUserInfoVC alloc]init];
         vc.hidesBottomBarWhenPushed = YES;
         [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
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

- (IBAction)touchSignInButton:(UIButton *)sender {
    LPSignInfoVC *vc = [[LPSignInfoVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)TouchMoneyCell:(UIButton *)sender {
    
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        if (sender.tag == 1000) {           //钱包
            LPMyWalletVC *vc = [[LPMyWalletVC alloc] init];
            vc.userMaterialModel = self.userMaterialModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (sender.tag == 1001){      //积分
            LPScoreMoneyVC *vc = [[LPScoreMoneyVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }else if (sender.tag == 1002){      //账单
            LPBillRecordVC *vc = [[LPBillRecordVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }else if (sender.tag == 1003){      //工资
            LPSalaryBreakdownVC *vc = [[LPSalaryBreakdownVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.RecordDate = self.RecordArr.count?self.RecordArr[0]:nil;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }else if (sender.tag == 1004){      //返费
            LPReMoneyDrawVC *vc = [[LPReMoneyDrawVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (IBAction)TouchFunctionCell:(UIButton *)sender {
    
    if (sender.tag == 1001){      //积分商城
        LPScoreStore *vc = [[LPScoreStore alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        if (sender.tag == 1000) {           //收藏
            LPCollectionVC *vc = [[LPCollectionVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (sender.tag == 1002){      //活动中心
            LPActivityVC *vc = [[LPActivityVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (sender.tag == 1003){      //邀请奖励
            LPInviteRewardsVC *vc = [[LPInviteRewardsVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (IBAction)TouchTableViewCell:(UIButton *)sender {
    
    if (sender.tag == 1000) {           //通讯录
        if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
            [self  requestContactAuthorAfterSystemVersion9];
        }
    }else if (sender.tag == 1001){      //黑名单
        if ([LoginUtils validationLogin:[UIWindow visibleViewController]]){
            LPBlackUserVC *vc = [[LPBlackUserVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (sender.tag == 1002){      //客服
        if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
            LPHXCustomerServiceVC *vc = [[LPHXCustomerServiceVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (sender.tag == 1003){      //设置
//        if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
            LPSetVC *vc = [[LPSetVC alloc]init];
            vc.userMaterialModel = self.userMaterialModel;
            vc.hidesBottomBarWhenPushed = YES;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//        }
    }
    
   
    
}


//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        WEAK_SELF()
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"授权失败");
                    [weakSelf showAlertViewAboutNotAuthorAccessContact];
                }else {
                    NSLog(@"成功授权");
                    LPAddressBookVC *vc = [[LPAddressBookVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            });
            
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        LPAddressBookVC *vc = [[LPAddressBookVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [alertController addAction:CancelAction];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark lazy
-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
    [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
    kUserDefaultsSave(userMaterialModel.data.role, USERDATA);
//    if (userMaterialModel.data) {
        if (userMaterialModel.data.role.integerValue == 0) {
            if ([userMaterialModel.data.workStatus integerValue] == 0) { //0待业1在职2入职中
                self.userName.text = [NSString stringWithFormat:@"%@ (待业)",[LPTools isNullToString:userMaterialModel.data.user_name]];
            } else if ([userMaterialModel.data.workStatus integerValue] == 1){
                self.userName.text = [NSString stringWithFormat:@"%@ (在职)",[LPTools isNullToString:userMaterialModel.data.user_name]];
            } else if ([userMaterialModel.data.workStatus integerValue] == 2){
                self.userName.text = [NSString stringWithFormat:@"%@ (入职中)",[LPTools isNullToString:userMaterialModel.data.user_name]];
            }
        }else{
            self.userName.text = [NSString stringWithFormat:@"%@",[LPTools isNullToString:userMaterialModel.data.user_name]];
        }
        
         [self.UserImage sd_setImageWithURL:[NSURL URLWithString:userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"avatar"]];
        self.moneyLabel.text = [NSString stringWithFormat:@"余额：￥%.2f",userMaterialModel.data.money.floatValue];
        
        if ([userMaterialModel.data.user_sex integerValue] == 0) {//0未知1男2女
            self.sexImage.hidden = YES;
        }else if ([userMaterialModel.data.user_sex integerValue] == 1) {
            self.sexImage.image = [UIImage imageNamed:@"male"];
        }else if ([userMaterialModel.data.user_sex integerValue] == 2) {
            self.sexImage.image = [UIImage imageNamed:@"female"];
        }
        if (userMaterialModel.data.grading) {
            self.gradingiamge.hidden = NO;
            self.gradingiamge.image = [UIImage imageNamed:userMaterialModel.data.grading];
        }else{
            self.gradingiamge.hidden = YES;
        }
        
        if (userMaterialModel.data.emValue.integerValue>=45000) {
            self.UpgradesScoreLabel.text = @"已达到最高等级";
        } else {
            self.UpgradesScoreLabel.text = [NSString stringWithFormat:@"升级还需：%ld经验值",userMaterialModel.data.upEmValue.integerValue - userMaterialModel.data.emValue.integerValue];
        }
        
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)userMaterialModel.data.score.integerValue];
        self.awardRedLabel.hidden = !userMaterialModel.data.rewardRecord.integerValue;
//    }

}

#pragma mark - request
-(void)requestUserMaterial{
    NSString *string = kUserDefaultsValue(LOGINID);
    NSDictionary *dic = @{
                          @"id":string
                          };
    [NetApiManager requestUserMaterialWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                if (!responseObject[@"code"]) {
                    [LPTools UserDefaulatsRemove];
                }
                self.userMaterialModel = [LPUserMaterialModel mj_objectWithKeyValues:responseObject];
            }else{              //返回不成功,清空
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
             }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
    
-(void)requestSelectCurIsSign{
    [NetApiManager requestSelectCurIsSignWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (!ISNIL(responseObject[@"data"])) {
                    if ([responseObject[@"data"] integerValue] == 0) {
                        [self.signInButton setTitle:@"签到 >" forState:UIControlStateNormal];
                    }else if ([responseObject[@"data"] integerValue] == 1) {
                        [self.signInButton setTitle:@"已签到 >" forState:UIControlStateNormal];
                    }
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryInfounreadNum{
    NSDictionary *dic = @{@"type":@(1)
                          };
    [NetApiManager requestQueryUnreadNumWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSInteger num = [responseObject[@"data"] integerValue];
                if (num == 0) {
                    self.MessageLabel.hidden = YES;
                }
                else if (num>99)
                {
                    self.MessageLabel.hidden = NO;
                    self.MessageLabel.text = @" 99+ ";
                }
                else
                {
                    self.MessageLabel.hidden = NO;
                    self.MessageLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
                }
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetBillRecordList{
    [NetApiManager requestQueryGetBillRecordList:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                 self.RecordArr = [responseObject[@"data"] mj_JSONObject];
                if (self.RecordArr.count) {
                    self.waitGetLabel.hidden = NO;
                }else{
                    self.waitGetLabel.hidden = YES;
                }
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
 
@end
