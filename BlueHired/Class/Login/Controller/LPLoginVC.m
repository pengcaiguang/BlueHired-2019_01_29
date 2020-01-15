//
//  LPLoginVC.m
//  BlueHired
//
//  Created by peng on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPLoginVC.h"
#import "LPRegisteredVC.h"
#import "LPForgetPassWordVC.h"
#import "LPHongBaoVC.h"
#import "AppDelegate.h"
#import "LPWXLoginBindingVC.h"

static NSString *PHONEUSERSAVE = @"PHONEUSERSAVE";
static NSString *PASSWORDUSERSAVE = @"PASSWORDUSERSAVE";

static NSString *WXAPPID = @"wx566f19a70d573321";

@interface LPLoginVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UIView *phoneLineView;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UIView *passwordLineView;

@property(nonatomic,assign) BOOL keepPassword;
@end

@implementation LPLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.WXdelegate = self;
    [self setupUI];
    [UIWindow visibleViewController];
    
 
}

-(void)setupUI{
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIImageView *logoImg = [[UIImageView alloc]init];
    [self.view addSubview:logoImg];
    if (SCREEN_WIDTH== 320) {
        [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.top.mas_equalTo(35);
            make.centerX.equalTo(self.view);
        }];
    }else{
        [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.top.mas_equalTo((Screen_Height-555-49-20)/2);
            make.centerX.equalTo(self.view);
        }];
    }
    
//    logoImg.backgroundColor = [UIColor baseColor];
    logoImg.image = [UIImage imageNamed:@"logo_Information"];
    
    UILabel *textLabel = [[UILabel alloc]init];
    [self.view addSubview:textLabel];
    if (SCREEN_WIDTH == 320) {
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logoImg.mas_bottom).offset(8);
            make.centerX.equalTo(logoImg);
            make.height.mas_equalTo(18);
        }];
    }else{
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logoImg.mas_bottom).offset(21);
            make.centerX.equalTo(logoImg);
            make.height.mas_equalTo(18);
        }];
    }
    
    textLabel.text = @"蓝聘,专注于服务蓝领人士";
    textLabel.font = [UIFont systemFontOfSize:19];
    textLabel.textColor = [UIColor baseColor];
    
    UIView *phoneBgView = [[UIView alloc]init];
    [self.view addSubview:phoneBgView];
    if (SCREEN_WIDTH == 320 ) {
        [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(35);
            make.right.mas_equalTo(-35);
            make.top.equalTo(textLabel.mas_bottom).offset(18);
            make.height.mas_equalTo(40);
        }];
    }else{
        [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(textLabel.mas_bottom).offset(50);
            make.height.mas_equalTo(40);
        }];
    }
    
    UIImageView *phoneImg = [[UIImageView alloc]init];
    [phoneBgView addSubview:phoneImg];
    [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(phoneBgView);
        make.size.mas_equalTo(CGSizeMake(13, 21));
    }];
    phoneImg.image = [UIImage imageNamed:@"phone_img"];
    
    self.phoneTextField = [[UITextField alloc]init];
    [phoneBgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(phoneBgView);
     }];
    self.phoneTextField.delegate = self;
    self.phoneTextField.placeholder = @"请输入手机号码";
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
    self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
    
    
    UIView *passwordBgView = [[UIView alloc]init];
    [self.view addSubview:passwordBgView];
    if (SCREEN_WIDTH == 320) {
        [passwordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(35);
            make.right.mas_equalTo(-35);
            make.top.equalTo(phoneBgView.mas_bottom).offset(8);
            make.height.mas_equalTo(40);
        }];
    }else{
        [passwordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(phoneBgView.mas_bottom).offset(40);
            make.height.mas_equalTo(40);
        }];
    }
    
    UIImageView *passwordImg = [[UIImageView alloc]init];
    [passwordBgView addSubview:passwordImg];
    [passwordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(passwordBgView);
        make.size.mas_equalTo(CGSizeMake(15, 18));
    }];
    passwordImg.image = [UIImage imageNamed:@"password_img"];
    
    self.passwordTextField = [[UITextField alloc]init];
    [passwordBgView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(passwordBgView);
    }];
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = @"请输入6-16位密码";
    self.passwordTextField.tintColor = [UIColor baseColor];
    self.passwordTextField.secureTextEntry = YES;

    
    UIButton *showPasswordButton = [[UIButton alloc]init];
    [passwordBgView addSubview:showPasswordButton];
    [showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(22, 16));
        make.centerY.equalTo(passwordBgView);
    }];
    [showPasswordButton setImage:[UIImage imageNamed:@"show_eye_img"] forState:UIControlStateNormal];
    [showPasswordButton setImage:[UIImage imageNamed:@"hide_eye_img"] forState:UIControlStateSelected];
    [showPasswordButton addTarget:self action:@selector(touchShowPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.passwordLineView = [[UIView alloc]init];
    [passwordBgView addSubview:self.passwordLineView];
    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.passwordLineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
    
    
    UIButton *keepPassWord = [[UIButton alloc]init];
    [self.view addSubview:keepPassWord];

    [keepPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.equalTo(passwordBgView.mas_bottom).offset(20);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(13);
    }];
    [keepPassWord setTitle:@"记住密码" forState:UIControlStateNormal];
    [keepPassWord setImage:[UIImage imageNamed:@"button_noselected"] forState:UIControlStateNormal];
    [keepPassWord setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateSelected];
    keepPassWord.titleLabel.font = [UIFont systemFontOfSize:12];
    [keepPassWord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [keepPassWord addTarget:self action:@selector(touchKeepPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [keepPassWord setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0.0)];
    
 
    UIButton *forgetPassWord = [[UIButton alloc]init];
    [self.view addSubview:forgetPassWord];
    [forgetPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.top.equalTo(passwordBgView.mas_bottom).offset(20);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(13);
    }];
    [forgetPassWord setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPassWord.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetPassWord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [forgetPassWord addTarget:self action:@selector(touchForgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPassWord setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0.0)];
 
    
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    if (SCREEN_WIDTH == 320 ) {
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.equalTo(passwordBgView.mas_bottom).offset(60);
            make.height.mas_equalTo(35);
        }];
        loginButton.layer.cornerRadius = 17.5;
    }else{
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(passwordBgView.mas_bottom).offset(60);
            make.height.mas_equalTo(40);
        }];
        loginButton.layer.cornerRadius = 20;

    }
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    loginButton.backgroundColor = [UIColor baseColor];
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(touchLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registeredButton = [[UIButton alloc]init];
    [self.view addSubview:registeredButton];
    if (SCREEN_WIDTH == 320) {
        [registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.equalTo(loginButton.mas_bottom).offset(15);
            make.height.mas_equalTo(35);
        }];
        registeredButton.layer.cornerRadius = 17.5;
    }else{
        [registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(loginButton.mas_bottom).offset(20);
            make.height.mas_equalTo(40);
        }];
        registeredButton.layer.cornerRadius = 20;

    }
    
    [registeredButton setTitle:@"注册" forState:UIControlStateNormal];
    [registeredButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    registeredButton.titleLabel.font = [UIFont systemFontOfSize:17];
    registeredButton.backgroundColor = [UIColor whiteColor];
    registeredButton.layer.masksToBounds = YES;
    registeredButton.layer.borderColor = [UIColor baseColor].CGColor;
    registeredButton.layer.borderWidth = 0.5;
    [registeredButton addTarget:self action:@selector(touchRegisteredButton:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *otherLoginback = [[UIView alloc] init];
    [self.view addSubview:otherLoginback];
    [otherLoginback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(67);
        make.right.mas_equalTo(-67);
        make.height.mas_equalTo(1);
        make.top.equalTo(registeredButton.mas_bottom).offset(36);
    }];
    otherLoginback.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    //第三方登入
    UILabel *OtherloginLabel = [[UILabel alloc] init];
    [self.view addSubview:OtherloginLabel];
    [OtherloginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(otherLoginback);
       }];
    OtherloginLabel.text =@"第三方登录";
    OtherloginLabel.textColor = [UIColor colorWithHexString:@"#FF929292"];
    OtherloginLabel.backgroundColor = [UIColor whiteColor];
    
    UIButton *OtherLoginBt = [[UIButton alloc] init];
    [self.view addSubview:OtherLoginBt];
    [OtherLoginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(OtherloginLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(49);
    }];
    [OtherLoginBt setImage:[UIImage imageNamed:@"weixinLogo"] forState:UIControlStateNormal];
    [OtherLoginBt addTarget:self action:@selector(touchWeiXinLoginButton:) forControlEvents:UIControlEventTouchUpInside];

    
    //如果用户没有安装微信.隐藏微信登入
//    if ([WXApi isWXAppInstalled]==NO) {
//        OtherLoginBt.hidden = YES;
//        OtherloginLabel.hidden = YES;
//        otherLoginback.hidden = YES;

//    }else{
//        OtherLoginBt.hidden = NO;
//        OtherloginLabel.hidden = NO;
//        otherLoginback.hidden = NO;
//    }
    
    
    NSString *phone = kUserDefaultsValue(PHONEUSERSAVE);
    if (!kStringIsEmpty(phone)) {
        self.phoneTextField.text = phone;
    }
    NSString *password = kUserDefaultsValue(PASSWORDUSERSAVE);
    if (!kStringIsEmpty(password)) {
        self.passwordTextField.text = password;
        keepPassWord.selected = YES;
        self.keepPassword = YES;
    }
}


#pragma mark - target
-(void)touchShowPasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
}

-(void)touchKeepPassWord:(UIButton *)button{
    NSLog(@"记住密码");
    button.selected = !button.isSelected;
    self.keepPassword = button.isSelected;
}
-(void)touchForgetPassWord:(UIButton *)button{
    NSLog(@"忘记密码");
    LPForgetPassWordVC * vc = [[LPForgetPassWordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchLoginButton:(UIButton *)button{
    NSLog(@"登录");
    self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    NSString *passwordmd5 = [self.passwordTextField.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"phone":self.phoneTextField.text,
                          @"password":newPasswordmd5
                          };
    
    [NetApiManager requestLoginWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] isEqualToString:@"null"]) {
                    [self.view showLoadingMeg:@"用户不存在" time:MESSAGE_SHOW_TIME];
                }else if ([responseObject[@"data"] isEqualToString:@"error"]) {
                    [self.view showLoadingMeg:@"密码错误" time:MESSAGE_SHOW_TIME];
                }else{
                    kUserDefaultsSave(responseObject[@"data"], LOGINID);
                    if ([kUserDefaultsValue(LOGINID) integerValue]  != [kUserDefaultsValue(OLDLOGINID) integerValue]) {
                        kUserDefaultsRemove(ERRORTIMES);
                    }
                    if (self.keepPassword) {
                        [self save];
                    }else{
                        kUserDefaultsSave(@"", PASSWORDUSERSAVE);
                    }
                    kUserDefaultsSave(@"1", kLoginStatus);
                    kUserDefaultsSave(self.phoneTextField.text, PHONEUSERSAVE);
                    if (self.isRedpackVC == YES) {
                        LPHongBaoVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                        vc.isLogin = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                    } else{
                        [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - LPWxLoginHBBack
- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo{
    NSDictionary *dic = @{@"openid":wxUserInfo.unionid};
    [NetApiManager requestQueryWXUserStatus:dic  withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 0) {
                    LPWXLoginBindingVC *vc = [[LPWXLoginBindingVC alloc] init];
                    vc.userModel = wxUserInfo;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:NO];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"登录成功" time:MESSAGE_SHOW_TIME];
                    [[UIWindow visibleViewController].navigationController popViewControllerAnimated:NO];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)save{
    kUserDefaultsSave(self.phoneTextField.text, PHONEUSERSAVE);
    kUserDefaultsSave(self.passwordTextField.text, PASSWORDUSERSAVE);
}

-(void)touchWeiXinLoginButton:(UIButton *)button{
    
    if ([WXApi isWXAppInstalled]==NO) {
//        [self.view showLoadingMeg:@"请安装微信" time:MESSAGE_SHOW_TIME];
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123x";
        [WXApi sendAuthReq:req viewController:self delegate:[WXApiManager sharedManager]];
         return;
    }
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo"
                                        State:@"123x"
                                       OpenID:WXAPPID
                             InViewController:self];
 }


-(void)touchRegisteredButton:(UIButton *)button{
    LPRegisteredVC *vc = [[LPRegisteredVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.passwordTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.passwordTextField.text.length >= 16) {
            self.passwordTextField.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
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
    return YES;

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneTextField]) {
        self.phoneLineView.backgroundColor = [UIColor baseColor];
        self.passwordLineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
    }else{
        self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
        self.passwordLineView.backgroundColor = [UIColor baseColor];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
    self.passwordLineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
