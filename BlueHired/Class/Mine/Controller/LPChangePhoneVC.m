//
//  LPChangePhoneVC.m
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPChangePhoneVC.h"
#import "LPLoginVC.h"
#import "LPSecurityQuestionVC.h"
#import "LPSetSecretVC.h"
#import "AppDelegate.h"
static NSString *WXAPPID = @"wx566f19a70d573321";

@interface LPChangePhoneVC ()<UITextFieldDelegate,LPWxLoginHBDelegate>

@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UIView *phoneLineView;
@property(nonatomic,strong) UITextField *verificationCodeTextField;
@property(nonatomic,strong) UIView *verificationCodeLineView;

@property(nonatomic,strong) UIButton *getVerificationCodeButton;

@property(nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *Openid;
@property (nonatomic,strong) LPUserMaterialModel *userData;

@end

@implementation LPChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.WXdelegate = self;
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    self.userData = user;
    self.Openid = [LPTools isNullToString:user.data.openid];;
    
    [self setupUI];
}
-(void)setupUI{
    if (self.type == 1 || self.type == 2 || self.type == 4) {
        self.navigationItem.title = @"手机号验证";
    }else if (self.type == 3){
        self.navigationItem.title = @"绑定新手机号";
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    UIView *phoneBgView = [[UIView alloc]init];
    [self.view addSubview:phoneBgView];
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(48);
    }];
    phoneBgView.backgroundColor = [UIColor whiteColor];
    UIImageView *phoneImg = [[UIImageView alloc]init];
    [phoneBgView addSubview:phoneImg];
    [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(phoneBgView);
        make.size.mas_equalTo(CGSizeMake(13, 21));
    }];
    phoneImg.image = [UIImage imageNamed:@"phone_img"];
    
    UIView *PhoneImgLine = [[UIView alloc] init];
    [phoneBgView addSubview:PhoneImgLine];
    [PhoneImgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneImg.mas_right).offset(8);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(phoneBgView);
    }];
//    PhoneImgLine.backgroundColor = [UIColor colorWithHexString:@"#FF939393"];
    
    self.phoneTextField = [[UITextField alloc]init];
    [phoneBgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PhoneImgLine.mas_right).offset(8);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(phoneBgView);
        
    }];
    self.phoneTextField.delegate = self;
    self.phoneTextField.placeholder = self.type== 3? @"请输入新手机号":@"请输入当前登录的手机号";
    self.phoneTextField.tintColor = [UIColor baseColor];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.phoneLineView = [[UIView alloc]init];
    [phoneBgView addSubview:self.phoneLineView];
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
 
    
    UIView *verificationCodeBgView = [[UIView alloc]init];
    [self.view addSubview:verificationCodeBgView];
    [verificationCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.equalTo(phoneBgView.mas_bottom).offset(15);
        make.height.mas_equalTo(48);
    }];
    verificationCodeBgView.backgroundColor = [UIColor whiteColor];

    UIImageView *verificationCodeImg = [[UIImageView alloc]init];
    [verificationCodeBgView addSubview:verificationCodeImg];
    [verificationCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(verificationCodeBgView);
        make.size.mas_equalTo(CGSizeMake(15, 18));
    }];
    verificationCodeImg.image = [UIImage imageNamed:@"verificationCode"];
    
    UIView *PverificationCodeImgLine = [[UIView alloc] init];
    [verificationCodeBgView addSubview:PverificationCodeImgLine];
    [PverificationCodeImgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(verificationCodeImg.mas_right).offset(8);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(verificationCodeBgView);
    }];
//    PverificationCodeImgLine.backgroundColor = [UIColor colorWithHexString:@"#FF939393"];
    
    self.verificationCodeTextField = [[UITextField alloc]init];
    [verificationCodeBgView addSubview:self.verificationCodeTextField];
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PverificationCodeImgLine.mas_right).offset(8);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(verificationCodeBgView);
    }];
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.placeholder = @"请输入验证码";
    self.verificationCodeTextField.tintColor = [UIColor baseColor];
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;

    UIButton *getVerificationCodeButton = [[UIButton alloc]init];
    [verificationCodeBgView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 16));
        make.centerY.equalTo(verificationCodeBgView);
    }];
    getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [getVerificationCodeButton addTarget:self action:@selector(touchGetVerificationCodeButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    self.getVerificationCodeButton = getVerificationCodeButton;
    
    self.verificationCodeLineView = [[UIView alloc]init];
    [verificationCodeBgView addSubview:self.verificationCodeLineView];
    [self.verificationCodeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.verificationCodeLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    
   
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
//        make.top.equalTo(verificationCodeBgView.mas_bottom).offset(121);
//        make.bottom.mas_equalTo(-18);
        make.height.mas_equalTo(48);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-18);
        } else {
            make.bottom.mas_equalTo(-18);
        }
    }];
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    loginButton.backgroundColor = [UIColor baseColor];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 4;
    [loginButton addTarget:self action:@selector(touchLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *OthenBt = [[UIButton alloc] init];
    [self.view addSubview:OthenBt];
    [OthenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(loginButton.mas_top).offset(-35);
     }];
    [OthenBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    OthenBt.titleLabel.font = [UIFont systemFontOfSize:14];
    OthenBt.hidden = NO;
    if (self.type == 1 ) {
        if (self.userData.data.isUserProblem.integerValue == 0) {
            [OthenBt setTitle:@"当前手机号已丢失，请联系客服 >>" forState:UIControlStateNormal];
        }else{
            [OthenBt setTitle:@"当前手机号已丢失，回答密保问题修改绑定 >>" forState:UIControlStateNormal];
        }
    }else if (self.type == 2 || self.type == 4){
        [OthenBt setTitle:@"当前手机号已丢失，回答密保问题修改绑定 >>" forState:UIControlStateNormal];
    }else if (self.type == 3){
        OthenBt.hidden = YES;
    }
    [OthenBt addTarget:self action:@selector(touchOthenBt:) forControlEvents:UIControlEventTouchUpInside];

    
    
    UIButton *registeredButton = [[UIButton alloc]init];
//    [self.view addSubview:registeredButton];
//    [registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(50);
//        make.right.mas_equalTo(-50);
//        make.top.equalTo(loginButton.mas_bottom).offset(27);
//        make.height.mas_equalTo(48);
//    }];
    [registeredButton setTitle:@"取消" forState:UIControlStateNormal];
    [registeredButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    registeredButton.titleLabel.font = [UIFont systemFontOfSize:17];
    registeredButton.backgroundColor = [UIColor whiteColor];
    registeredButton.layer.masksToBounds = YES;
    registeredButton.layer.cornerRadius = 4;
    registeredButton.layer.borderColor = [UIColor baseColor].CGColor;
    registeredButton.layer.borderWidth = 0.5;
    [registeredButton addTarget:self action:@selector(touchRegisteredButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(verificationCodeBgView.mas_bottom).offset(10);
    }];
    label.numberOfLines = 0;
    label.text = @"温馨提示：更换新的手机号后，可使用新的手机号进行登录，之前的手机号将无法登录，请谨慎修改！";
    label.textColor = [UIColor colorWithHexString:@"#FF5353"];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.type == 3) {
        label.hidden = NO;
    }else{
        label.hidden = YES;
    }
    
}
-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getVerificationCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                self.getVerificationCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                self.getVerificationCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

-(void)touchOthenBt:(UIButton *)button{
    if (self.type == 1) {
        if (self.userData.data.isUserProblem.integerValue == 0) {
            button.enabled = NO;
            [self requestQueryGetCustomerTel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
            });
        }else{
            LPSecurityQuestionVC *vc = [[LPSecurityQuestionVC alloc] init];
            vc.type = self.type;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if (self.type == 2 || self.type == 4) {
        LPSecurityQuestionVC *vc = [[LPSecurityQuestionVC alloc] init];
        vc.type = self.type;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)touchGetVerificationCodeButtonButton:(UIButton *)button{
    NSLog(@"获取验证码");
    self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestSendCode];
}

-(void)touchLoginButton:(UIButton *)button{
    NSLog(@"确定");
    self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.verificationCodeTextField.text.length <= 0) {
        [self.view showLoadingMeg:@"请输入验证码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (!self.token) {
        [self.view showLoadingMeg:@"请输入正确的验证码" time:MESSAGE_SHOW_TIME];
        return;
    }

//    [self requestMateCode];
    [self requestUpdateUsertel];

    
}
#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.phoneTextField.text.length >= 11) {
            self.phoneTextField.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    
    if (textField == self.verificationCodeTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.verificationCodeTextField.text.length >= 6) {
            self.verificationCodeTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if ([textField isEqual:self.phoneTextField]) {
//        self.phoneLineView.backgroundColor = [UIColor baseColor];
//        self.verificationCodeLineView.backgroundColor = [UIColor lightGrayColor];
//    }else{
//        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
//        self.verificationCodeLineView.backgroundColor = [UIColor baseColor];
//    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
//    self.verificationCodeLineView.backgroundColor = [UIColor lightGrayColor];
}
#pragma mark - reuqest
-(void)requestUpdateUsertel{
//    @"i":@(2),
//    @"phone":self.phoneTextField.text,
//    @"code":self.verificationCodeTextField.text,
//    @"token":self.token
    
    
    NSString * url;
    if (self.type == 1||self.type == 2 ||self.type == 4) {
        url =[NSString stringWithFormat:@"userMaterial/get_tel_old?oldUserTel=%@&i=2&code=%@&token=%@",
              self.phoneTextField.text,
              self.verificationCodeTextField.text,
              self.token];
    }else{
//        url =[NSString stringWithFormat:@"userMaterial/update_usertel?newUserTel=%@&type=%ld",self.phoneTextField.text,(long)self.Newtype];
        url =[NSString stringWithFormat:@"userMaterial/update_tel_new?newUserTel=%@&type=%ld&i=2&code=%@&token=%@",
              self.phoneTextField.text,(long)self.Newtype,
              self.verificationCodeTextField.text,
              self.token];
    }
    
    [NetApiManager requestUpdateUsertelWithParam:url  WithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    if (self.type == 3) {
                        [self.view showLoadingMeg:@"修改成功" time:MESSAGE_SHOW_TIME];
                        [LPTools UserDefaulatsRemove];
                        [self requestSignout];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //                    [self.navigationController popViewControllerAnimated:YES];
                            LPLoginVC *vc = [[LPLoginVC alloc]init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                        });
                    }else{
                        if (self.type == 1) {
                            LPSetSecretVC *vc = [[LPSetSecretVC alloc]init];
                            //                                vc.model = self.model;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if (self.type == 2){
                            LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
                            vc.Newtype = 1;
                            vc.type = 3;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if (self.type == 4){
                            
                            [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
                                                                State:@"123x"
                                                               OpenID:WXAPPID
                                                     InViewController:self];
//                                    if ([self.Openid isEqualToString:@""]) {
//                                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否前去绑定微信号？" message:nil textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//                                            if (buttonIndex) {
//                                                [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
//                                                                                    State:@"123x"
//                                                                                   OpenID:WXAPPID
//                                                                         InViewController:self];
//                                            }
//                                        }];
//                                        [alert show];
//                                    }else{
//                                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否换绑微信号？" message:nil textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//                                            if (buttonIndex) {
//                                                [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
//                                                                                    State:@"123x"
//                                                                                   OpenID:WXAPPID
//                                                                         InViewController:self];
//                                            }
//                                        }];
//                                        [alert show];
//                                    }

                        }
                    }
                }else{
                    [self.view showLoadingMeg:@"手机号验证不通过" time:MESSAGE_SHOW_TIME];
                }
               
            }else{
                if (self.type == 1||self.type == 2) {
                    [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"操作失败" time:MESSAGE_SHOW_TIME];
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"修改失败" time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



#pragma mark - LPWxLoginHBBack
- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo{
    if (![self.Openid isEqualToString:wxUserInfo.unionid]) {
        NSDictionary *dic = @{
                              @"sgin":[LPTools isNullToString:wxUserInfo.unionid],
                              @"phone":self.userData.data.userTel,
                              @"userUrl":[LPTools isNullToString:wxUserInfo.headimgurl],
                              @"userName":@"0fc23ce3bc0e1ee5e5e"
                              };
        [NetApiManager requestQueryWXSetPhone:dic withHandle:^(BOOL isSuccess, id responseObject) {
            NSLog(@"%@",responseObject);
            if (isSuccess) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    if ([self.Openid isEqualToString:@""]) {
                        [self.view showLoadingMeg:@"绑定成功" time:MESSAGE_SHOW_TIME];
                    }else{
                        [self.view showLoadingMeg:@"换绑成功，请之后用新微信号进行登录！" time:MESSAGE_SHOW_TIME];
                    }
                    self.userData.data.openid = wxUserInfo.unionid;
//                    self.WXLabel.text = @"已绑定";
                    [self.navigationController   popToRootViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"注册失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
            }
        }];
        
    }else{
        [self.view showLoadingMeg:@"此次微信号与之前绑定的一致，请更换微信号重试！" time:MESSAGE_SHOW_TIME];
    }
    
}



-(void)requestSendCode{
    NSDictionary *dic = @{
                          @"i":@(2),
                          @"phone":self.phoneTextField.text,
                          };
    [NetApiManager requestSendCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    self.token = responseObject[@"data"];
                }
                [self.view showLoadingMeg:@"验证码发送成功" time:MESSAGE_SHOW_TIME];
                [self openCountdown];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestMateCode{
    NSDictionary *dic = @{
                          @"i":@(2),
                          @"phone":self.phoneTextField.text,
                          @"code":self.verificationCodeTextField.text,
                          @"token":self.token
                          };
    [NetApiManager requestMateCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0)
            {
                [self requestUpdateUsertel];
            }
            else
            {
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestSignout{
    [NetApiManager requestSignoutWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            //            kUserDefaultsRemove(LOGINID);
            //            kUserDefaultsRemove(kLoginStatus);
            //            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetCustomerTel{
    NSDictionary *dic = @{};
    //    NSLog(@"%@",dic);
    
    [NetApiManager requestQueryGetCustomerTel:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0 ) {
                NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",responseObject[@"data"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
                
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



-(void)touchRegisteredButton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
 

@end
