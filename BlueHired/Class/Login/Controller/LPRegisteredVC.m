//
//  LPRegisteredVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPRegisteredVC.h"

@interface LPRegisteredVC ()<UITextFieldDelegate>
@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UIView *phoneLineView;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UIView *passwordLineView;
@property(nonatomic,strong) UITextField *verificationCodeTextField;
@property(nonatomic,strong) UIView *verificationCodeLineView;

@property(nonatomic,strong) UIButton *getVerificationCodeButton;
@end

@implementation LPRegisteredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)setupUI{
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImg = [[UIImageView alloc]init];
    [self.view addSubview:logoImg];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.top.mas_equalTo(104);
        make.centerX.equalTo(self.view);
    }];
    logoImg.backgroundColor = [UIColor baseColor];
    
    UILabel *textLabel = [[UILabel alloc]init];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImg.mas_bottom).offset(21);
        make.centerX.equalTo(logoImg);
        make.height.mas_equalTo(18);
    }];
    textLabel.text = @"为企业寻求人才";
    textLabel.font = [UIFont systemFontOfSize:19];
    textLabel.textColor = [UIColor baseColor];
    
    UIView *phoneBgView = [[UIView alloc]init];
    [self.view addSubview:phoneBgView];
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(textLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
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
    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    UIView *passwordBgView = [[UIView alloc]init];
    [self.view addSubview:passwordBgView];
    [passwordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(phoneBgView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
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
    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    UIView *verificationCodeBgView = [[UIView alloc]init];
    [self.view addSubview:verificationCodeBgView];
    [verificationCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(passwordBgView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    UIImageView *verificationCodeImg = [[UIImageView alloc]init];
    [verificationCodeBgView addSubview:verificationCodeImg];
    [verificationCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(verificationCodeBgView);
        make.size.mas_equalTo(CGSizeMake(15, 18));
    }];
    verificationCodeImg.image = [UIImage imageNamed:@"verificationCode"];
    
    self.verificationCodeTextField = [[UITextField alloc]init];
    [verificationCodeBgView addSubview:self.verificationCodeTextField];
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(verificationCodeBgView);
    }];
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.placeholder = @"请输入验证码";
    self.verificationCodeTextField.tintColor = [UIColor baseColor];
    
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
    self.verificationCodeLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    UIButton *userAgreementButton = [[UIButton alloc]init];
    [self.view addSubview:userAgreementButton];
    [userAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(verificationCodeBgView.mas_bottom).offset(20);
    }];
    [userAgreementButton setTitle:@"我已阅读，并同意《用户注册协议》" forState:UIControlStateNormal];
    [userAgreementButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [userAgreementButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    userAgreementButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [userAgreementButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [userAgreementButton addTarget:self action:@selector(touchUserAgreementButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *registeredButton = [[UIButton alloc]init];
    [self.view addSubview:registeredButton];
    [registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(verificationCodeBgView.mas_bottom).offset(80);
        make.height.mas_equalTo(40);
    }];
    [registeredButton setTitle:@"确认" forState:UIControlStateNormal];
    [registeredButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registeredButton.titleLabel.font = [UIFont systemFontOfSize:17];
    registeredButton.backgroundColor = [UIColor baseColor];
    registeredButton.layer.masksToBounds = YES;
    registeredButton.layer.cornerRadius = 20;
    [registeredButton addTarget:self action:@selector(touchRegisteredButton:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - target
-(void)touchShowPasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
}
-(void)touchGetVerificationCodeButtonButton:(UIButton *)button{
    NSLog(@"获取验证码");
    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self openCountdown];
//    [self requestSendCode];
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
-(void)touchUserAgreementButton:(UIButton *)button{
    NSLog(@"用户协议");
}

-(void)touchRegisteredButton:(UIButton *)button{
    NSLog(@"确认");
    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入6-16位密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.verificationCodeTextField.text.length <= 0) {
        [self.view showLoadingMeg:@"请输入验证码" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestAddUser];
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
        self.phoneLineView.backgroundColor = [UIColor baseColor];
        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
        self.verificationCodeLineView.backgroundColor = [UIColor lightGrayColor];
    }else if ([textField isEqual:self.passwordTextField]) {
        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
        self.passwordLineView.backgroundColor = [UIColor baseColor];
        self.verificationCodeLineView.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
        self.verificationCodeLineView.backgroundColor = [UIColor baseColor];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
    self.verificationCodeLineView.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - request
-(void)requestAddUser{
    NSString *passwordmd5 = [self.passwordTextField.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"phone":self.phoneTextField.text,
                          @"password":newPasswordmd5
                          };
    [NetApiManager requestAddUserWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestSendCode{
    NSDictionary *dic = @{
                          @"i":@(0),
                          @"phone":self.phoneTextField.text,
                          };
    [NetApiManager requestSendCodeWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self.view showLoadingMeg:@"验证码发送成功" time:MESSAGE_SHOW_TIME];
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
