//
//  LPForgetPassWordVC.m
//  BlueHired
//
//  Created by peng on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPForgetPassWordVC.h"

@interface LPForgetPassWordVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *phoneBgView;
@property(nonatomic,strong) UITextField *phoneTextField;

@property(nonatomic,strong) UIView *passwordBgView;
@property(nonatomic,strong) UITextField *passwordTextField;

@property(nonatomic,strong) UIView *repasswordBgView;
@property(nonatomic,strong) UITextField *repasswordTextField;

@property(nonatomic,strong) UIView *verificationCodeBgView;
@property(nonatomic,strong) UITextField *verificationCodeTextField;

@property(nonatomic,strong) UIButton *getVerificationCodeButton;

@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *phone;

@end

@implementation LPForgetPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)setupUI{
    self.navigationItem.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImg = [[UIImageView alloc]init];
    [self.view addSubview:logoImg];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.top.mas_equalTo(27);
        make.centerX.equalTo(self.view);
    }];
//    logoImg.backgroundColor = [UIColor baseColor];
    logoImg.image = [UIImage imageNamed:@"logo_Information"];
    
    UILabel *textLabel = [[UILabel alloc]init];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImg.mas_bottom).offset(21);
        make.centerX.equalTo(logoImg);
        make.height.mas_equalTo(18);
    }];
    textLabel.text = @"蓝聘,专注于服务蓝领人士";
    textLabel.font = [UIFont systemFontOfSize:19];
    textLabel.textColor = [UIColor baseColor];
    
    self.phoneBgView = [[UIView alloc]init];
    [self.view addSubview:self.phoneBgView];
    if (SCREEN_WIDTH == 320) {
        [self.phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.equalTo(textLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(44);
        }];
    }else{
        [self.phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(textLabel.mas_bottom).offset(50);
            make.height.mas_equalTo(44);
        }];
    }
    
    self.phoneBgView.layer.masksToBounds = YES;
    self.phoneBgView.layer.cornerRadius = 6;
    self.phoneBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneBgView.layer.borderWidth = 0.5;
    
    UIImageView *phoneImg = [[UIImageView alloc]init];
    [self.phoneBgView addSubview:phoneImg];
    [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.phoneBgView);
        make.size.mas_equalTo(CGSizeMake(34, 44));
    }];
    phoneImg.image = [UIImage imageNamed:@"forget_phone"];
    
    self.phoneTextField = [[UITextField alloc]init];
    [self.phoneBgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.phoneBgView);
        
    }];
    self.phoneTextField.delegate = self;
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.tintColor = [UIColor baseColor];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.passwordBgView = [[UIView alloc]init];
    [self.view addSubview:self.passwordBgView];
    if (SCREEN_WIDTH == 320) {
        [self.passwordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.equalTo(self.phoneBgView.mas_bottom).offset(22);
            make.height.mas_equalTo(44);
        }];
    }else{
        [self.passwordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(self.phoneBgView.mas_bottom).offset(22);
            make.height.mas_equalTo(44);
        }];
    }
    
    self.passwordBgView.layer.masksToBounds = YES;
    self.passwordBgView.layer.cornerRadius = 6;
    self.passwordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordBgView.layer.borderWidth = 0.5;
    
    UIImageView *passwordImg = [[UIImageView alloc]init];
    [self.passwordBgView addSubview:passwordImg];
    [passwordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.passwordBgView);
        make.size.mas_equalTo(CGSizeMake(34, 44));
    }];
    passwordImg.image = [UIImage imageNamed:@"forget_password"];
    
    self.passwordTextField = [[UITextField alloc]init];
    [self.passwordBgView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.passwordBgView);
        
    }];
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = @"请输入6-16位密码";
    self.passwordTextField.tintColor = [UIColor baseColor];
    self.passwordTextField.secureTextEntry = YES;
    
    UIButton *showPasswordButton = [[UIButton alloc]init];
    [self.passwordBgView addSubview:showPasswordButton];
    [showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(22, 16));
        make.centerY.equalTo(self.passwordBgView);
    }];
    [showPasswordButton setImage:[UIImage imageNamed:@"show_eye_img"] forState:UIControlStateNormal];
    [showPasswordButton setImage:[UIImage imageNamed:@"hide_eye_img"] forState:UIControlStateSelected];
    [showPasswordButton addTarget:self action:@selector(touchShowPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.repasswordBgView = [[UIView alloc]init];
    [self.view addSubview:self.repasswordBgView];
    if (SCREEN_WIDTH == 320) {
        [self.repasswordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.equalTo(self.passwordBgView.mas_bottom).offset(22);
            make.height.mas_equalTo(44);
        }];
    }else{
        [self.repasswordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(self.passwordBgView.mas_bottom).offset(22);
            make.height.mas_equalTo(44);
        }];
    }
    
    self.repasswordBgView.layer.masksToBounds = YES;
    self.repasswordBgView.layer.cornerRadius = 6;
    self.repasswordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.repasswordBgView.layer.borderWidth = 0.5;
    
    UIImageView *repasswordImg = [[UIImageView alloc]init];
    [self.repasswordBgView addSubview:repasswordImg];
    [repasswordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.repasswordBgView);
        make.size.mas_equalTo(CGSizeMake(34, 44));
    }];
    repasswordImg.image = [UIImage imageNamed:@"forget_password"];
    
    self.repasswordTextField = [[UITextField alloc]init];
    [self.repasswordBgView addSubview:self.repasswordTextField];
    [self.repasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.repasswordBgView);
        
    }];
    self.repasswordTextField.delegate = self;
    self.repasswordTextField.placeholder = @"请再次输入6-16位密码";
    self.repasswordTextField.tintColor = [UIColor baseColor];
    self.repasswordTextField.secureTextEntry = YES;
    
    UIButton *showRepasswordButton = [[UIButton alloc]init];
    [self.repasswordBgView addSubview:showRepasswordButton];
    [showRepasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(22, 16));
        make.centerY.equalTo(self.repasswordBgView);
    }];
    [showRepasswordButton setImage:[UIImage imageNamed:@"show_eye_img"] forState:UIControlStateNormal];
    [showRepasswordButton setImage:[UIImage imageNamed:@"hide_eye_img"] forState:UIControlStateSelected];
    [showRepasswordButton addTarget:self action:@selector(touchShowRepasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.verificationCodeBgView = [[UIView alloc]init];
    [self.view addSubview:self.verificationCodeBgView];
    if (SCREEN_WIDTH == 320) {
        [self.verificationCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.equalTo(self.repasswordBgView.mas_bottom).offset(22);
            make.height.mas_equalTo(44);
        }];
    }else{
        [self.verificationCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.equalTo(self.repasswordBgView.mas_bottom).offset(22);
            make.height.mas_equalTo(44);
        }];
    }
    
    self.verificationCodeBgView.layer.masksToBounds = YES;
    self.verificationCodeBgView.layer.cornerRadius = 6;
    self.verificationCodeBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.verificationCodeBgView.layer.borderWidth = 0.5;
 
    
    UIImageView *verificationCodeImg = [[UIImageView alloc]init];
    [self.verificationCodeBgView addSubview:verificationCodeImg];
    [verificationCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.verificationCodeBgView);
        make.size.mas_equalTo(CGSizeMake(34, 44));
    }];
    verificationCodeImg.image = [UIImage imageNamed:@"forget_verificationcode"];
    
    self.verificationCodeTextField = [[UITextField alloc]init];
    [self.verificationCodeBgView addSubview:self.verificationCodeTextField];
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.verificationCodeBgView);
        
    }];
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.placeholder = @"请输入验证码";
    self.verificationCodeTextField.tintColor = [UIColor baseColor];
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *lineView = [[UIView alloc]init];
    [self.verificationCodeBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.left.equalTo(self.verificationCodeTextField.mas_right).offset(1);
        make.width.mas_equalTo(0.5);
    }];
    lineView.backgroundColor = [UIColor baseColor];

    UIButton *getVerificationCodeButton = [[UIButton alloc]init];
    [self.verificationCodeBgView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 16));
        make.centerY.equalTo(self.verificationCodeBgView);
    }];
    getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [getVerificationCodeButton addTarget:self action:@selector(touchGetVerificationCodeButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    self.getVerificationCodeButton = getVerificationCodeButton;
    
    UIButton *confirmButton = [[UIButton alloc]init];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(self.verificationCodeBgView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    confirmButton.backgroundColor = [UIColor baseColor];
    confirmButton.layer.masksToBounds = YES;
    confirmButton.layer.cornerRadius = 20;
    [confirmButton addTarget:self action:@selector(touchConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - target
-(void)touchShowPasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
}
-(void)touchShowRepasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.repasswordTextField.secureTextEntry = !button.isSelected;
}
-(void)touchGetVerificationCodeButtonButton:(UIButton *)button{
    NSLog(@"获取验证码");
    self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.repasswordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请再次输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
        [self.view showLoadingMeg:@"两次输入的密码不一致" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestSendCode];
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
-(void)touchConfirmButton:(UIButton *)button{
    NSLog(@"确认");
    self.phoneTextField.text = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.verificationCodeTextField.text = [self.verificationCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.repasswordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请再次输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
        [self.view showLoadingMeg:@"两次输入的密码不一致" time:MESSAGE_SHOW_TIME];
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
    
    if (![self.phoneTextField.text isEqualToString:self.phone]) {
        [self.view showLoadingMeg:@"手机号错误" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    [self requestMateCode];
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
    if (textField == self.repasswordTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.repasswordTextField.text.length >= 16) {
            self.repasswordTextField.text = [textField.text substringToIndex:16];
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
    if ([textField isEqual:self.phoneTextField]) {
        self.phoneBgView.layer.borderColor = [UIColor baseColor].CGColor;
        self.passwordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.repasswordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.verificationCodeBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }else if ([textField isEqual:self.passwordTextField]) {
        self.phoneBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.passwordBgView.layer.borderColor = [UIColor baseColor].CGColor;
        self.repasswordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.verificationCodeBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }else if ([textField isEqual:self.repasswordTextField]) {
        self.phoneBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.passwordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.repasswordBgView.layer.borderColor = [UIColor baseColor].CGColor;
        self.verificationCodeBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }else if ([textField isEqual:self.verificationCodeTextField]) {
        self.phoneBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.passwordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.repasswordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.verificationCodeBgView.layer.borderColor = [UIColor baseColor].CGColor;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.repasswordBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.verificationCodeBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - request
-(void)requestSendCode{
    NSDictionary *dic = @{
                          @"i":@(1),
                          @"phone":self.phoneTextField.text,
                          };
    [NetApiManager requestSendCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    self.token = responseObject[@"data"];
                    self.phone = self.phoneTextField.text;
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
-(void)requestSetPswWithParam{
    NSString *passwordmd5 = [self.passwordTextField.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    NSDictionary *dic = @{
                          @"phone":self.phoneTextField.text,
                          @"password":newPasswordmd5
                          };
    [NetApiManager requestSetPswWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self.view showLoadingMeg:@"密码重置成功" time:MESSAGE_SHOW_TIME];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
//                });
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"重置失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestMateCode{
    NSDictionary *dic = @{
                          @"i":@(1),
                          @"phone":self.phoneTextField.text,
                          @"code":self.verificationCodeTextField.text
                          };
    [NetApiManager requestMateCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self requestSetPswWithParam];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
