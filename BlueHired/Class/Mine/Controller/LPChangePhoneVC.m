//
//  LPChangePhoneVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPChangePhoneVC.h"

@interface LPChangePhoneVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UIView *phoneLineView;
@property(nonatomic,strong) UITextField *verificationCodeTextField;
@property(nonatomic,strong) UIView *verificationCodeLineView;

@property(nonatomic,strong) UIButton *getVerificationCodeButton;

@property(nonatomic,strong) NSString *token;

@end

@implementation LPChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI{
    self.navigationItem.title = @"手机号修改";
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    UIView *phoneBgView = [[UIView alloc]init];
    [self.view addSubview:phoneBgView];
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(100);
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
    
    UIView *verificationCodeBgView = [[UIView alloc]init];
    [self.view addSubview:verificationCodeBgView];
    [verificationCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(phoneBgView.mas_bottom).offset(40);
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
    
   
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(verificationCodeBgView.mas_bottom).offset(80);
        make.height.mas_equalTo(40);
    }];
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    loginButton.backgroundColor = [UIColor baseColor];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 20;
    [loginButton addTarget:self action:@selector(touchLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registeredButton = [[UIButton alloc]init];
    [self.view addSubview:registeredButton];
    [registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    [registeredButton setTitle:@"取消" forState:UIControlStateNormal];
    [registeredButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    registeredButton.titleLabel.font = [UIFont systemFontOfSize:17];
    registeredButton.backgroundColor = [UIColor whiteColor];
    registeredButton.layer.masksToBounds = YES;
    registeredButton.layer.cornerRadius = 20;
    registeredButton.layer.borderColor = [UIColor baseColor].CGColor;
    registeredButton.layer.borderWidth = 0.5;
    [registeredButton addTarget:self action:@selector(touchRegisteredButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(registeredButton.mas_bottom).offset(20);
    }];
    label.numberOfLines = 0;
    label.text = @"温馨提示：更换手机后，之前的手机号将被注销，请谨慎修改！";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    
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
-(void)touchGetVerificationCodeButtonButton:(UIButton *)button{
    NSLog(@"获取验证码");
    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestSendCode];
}

-(void)touchLoginButton:(UIButton *)button{
    NSLog(@"确定");
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
    [self requestMateCode];
    
}
#pragma mark - reuqest
-(void)requestUpdateUsertel{
    NSDictionary *dic = @{
                          @"newUserTel":self.phoneTextField.text,
                          };
    
    [NetApiManager requestUpdateUsertelWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self.view showLoadingMeg:@"修改成功" time:MESSAGE_SHOW_TIME];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"修改失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
            [self requestUpdateUsertel];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)touchRegisteredButton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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
