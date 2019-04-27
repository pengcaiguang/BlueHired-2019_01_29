//
//  LPAccountManageVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAccountManageVC.h"
#import "LPChangePhoneVC.h"
#import "LPChangePasswordVC.h"
#import "LPSetSecretVC.h"
#import "AppDelegate.h"
#import "LPSecurityQuestionVC.h"
#import "LPUserProblemModel.h"



@interface LPAccountManageVC ()<LPWxLoginHBDelegate>
@property (weak, nonatomic) IBOutlet UILabel *WXLabel;

@property (nonatomic,strong) NSString *Openid;
@property (nonatomic,strong) LPUserMaterialModel *userData;
@property (nonatomic,strong) LPUserProblemModel *model;

@end

@implementation LPAccountManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.WXdelegate = self;
    
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    self.userData = user;
    self.Openid = [LPTools isNullToString:user.data.openid];;
    
    self.navigationItem.title = @"账号管理";
    if ([self.Openid  isEqualToString:@""]) {
        self.WXLabel.text = @"未绑定";
    }else{
        self.WXLabel.text = @"已绑定";
    }
    
//    [self requestQueryGetUserProdlemList];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self requestQueryGetUserProdlemList];
}

- (IBAction)TouchBT:(UIButton *)sender {
    if (sender.tag == 1001) {   //手机号修改
        LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
        vc.type = 2;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1002){      //密码修改
        LPChangePasswordVC *vc = [[LPChangePasswordVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1003){      //密保问题修改
//        LPSecurityQuestionVC *vc = [[LPSecurityQuestionVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.model = self.model;
        LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (sender.tag == 1004){      //微信绑定
        if ([WXApi isWXAppInstalled]==NO) {
            [self.view showLoadingMeg:@"请安装微信" time:MESSAGE_SHOW_TIME];
            return;
        }
        
        LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
        vc.type = 4;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        

//        if ([self.Openid isEqualToString:@""]) {
//            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否前去绑定微信号？" message:nil textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//                if (buttonIndex) {
//                    [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
//                                                        State:@"123x"
//                                                       OpenID:WXAPPID
//                                             InViewController:self];
//                }
//            }];
//            [alert show];
//        }else{
//            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否换绑微信号？" message:nil textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//                if (buttonIndex) {
//                    [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
//                                                        State:@"123x"
//                                                       OpenID:WXAPPID
//                                             InViewController:self];
//                }
//            }];
//            [alert show];
//        }
    }
    
}

//#pragma mark - LPWxLoginHBBack
//- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo{
//    if (![self.Openid isEqualToString:wxUserInfo.unionid]) {
//        NSDictionary *dic = @{
//                              @"sgin":[LPTools isNullToString:wxUserInfo.unionid],
//                              @"phone":self.userData.data.userTel,
//                              @"userUrl":[LPTools isNullToString:wxUserInfo.headimgurl],
//                              @"userName":@"0fc23ce3bc0e1ee5e5e"
//                              };
//        [NetApiManager requestQueryWXSetPhone:dic withHandle:^(BOOL isSuccess, id responseObject) {
//            NSLog(@"%@",responseObject);
//            if (isSuccess) {
//                if ([responseObject[@"data"] integerValue] > 0) {
//                    if ([self.Openid isEqualToString:@""]) {
//                        [self.view showLoadingMeg:@"绑定成功" time:MESSAGE_SHOW_TIME];
//                    }else{
//                        [self.view showLoadingMeg:@"换绑成功，请之后用新微信号进行登录！" time:MESSAGE_SHOW_TIME];
//                    }
//                    self.userData.data.openid = wxUserInfo.unionid;
//                    self.WXLabel.text = @"已绑定";
//                }else{
//                    [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"注册失败" time:MESSAGE_SHOW_TIME];
//                }
//            }else{
//                [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
//            }
//        }];
//        
//    }else{
//        [self.view showLoadingMeg:@"此次微信号与之前绑定的一致，请更换微信号重试！" time:MESSAGE_SHOW_TIME];
//    }
//    
//}

- (void)setModel:(LPUserProblemModel *)model{
    _model = model;
    if (model.data.count == 0) {
        NSString *str1 = @"为了您的账号安全，请先设置密保问题。";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
        WEAK_SELF()
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"去设置"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
                vc.type = 1;

//                [self.navigationController pushViewController:vc animated:YES];
                NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
                for (UIViewController *vc in naviVCsArr) {
                    if ([vc isKindOfClass:[weakSelf class]]) {
                        [naviVCsArr removeObject:vc];
                        break;
                    }
                }
                [naviVCsArr addObject:vc];
                vc.hidesBottomBarWhenPushed = YES;

                [weakSelf.navigationController  setViewControllers:naviVCsArr animated:YES];

            }
        }];
        [alert show];
    }
}

#pragma mark - request
-(void)requestQueryGetUserProdlemList{
    
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetUserProdlemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPUserProblemModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
