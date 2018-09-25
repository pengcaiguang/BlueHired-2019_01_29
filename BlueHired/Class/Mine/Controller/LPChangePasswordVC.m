//
//  LPChangePasswordVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPChangePasswordVC.h"

@interface LPChangePasswordVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UIView *phoneLineView;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UIView *passwordLineView;
@property(nonatomic,strong) UITextField *repasswordTextField;
@property(nonatomic,strong) UIView *repasswordLineView;
@end

@implementation LPChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI{
    self.navigationItem.title = @"密码修改";
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
    self.phoneTextField.placeholder = @"请输入旧密码";
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
    self.passwordTextField.placeholder = @"请输入新密码";
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
    
    UIView *repasswordBgView = [[UIView alloc]init];
    [self.view addSubview:repasswordBgView];
    [repasswordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(passwordBgView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    UIImageView *repasswordImg = [[UIImageView alloc]init];
    [repasswordBgView addSubview:repasswordImg];
    [repasswordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(repasswordBgView);
        make.size.mas_equalTo(CGSizeMake(15, 18));
    }];
    repasswordImg.image = [UIImage imageNamed:@"password_img"];
    
    self.repasswordTextField = [[UITextField alloc]init];
    [repasswordBgView addSubview:self.repasswordTextField];
    [self.repasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(repasswordBgView);
    }];
    self.repasswordTextField.delegate = self;
    self.repasswordTextField.placeholder = @"请再次输入新密码";
    self.repasswordTextField.tintColor = [UIColor baseColor];
    self.repasswordTextField.secureTextEntry = YES;
    
    
    UIButton *showrePasswordButton = [[UIButton alloc]init];
    [repasswordBgView addSubview:showrePasswordButton];
    [showrePasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(22, 16));
        make.centerY.equalTo(repasswordBgView);
    }];
    [showrePasswordButton setImage:[UIImage imageNamed:@"show_eye_img"] forState:UIControlStateNormal];
    [showrePasswordButton setImage:[UIImage imageNamed:@"hide_eye_img"] forState:UIControlStateSelected];
    [showrePasswordButton addTarget:self action:@selector(touchShowrePasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.repasswordLineView = [[UIView alloc]init];
    [repasswordBgView addSubview:self.repasswordLineView];
    [self.repasswordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(repasswordBgView.mas_bottom).offset(80);
        make.height.mas_equalTo(40);
    }];
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    loginButton.backgroundColor = [UIColor baseColor];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 20;
    [loginButton addTarget:self action:@selector(touchLoginButton) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - target
-(void)touchShowPasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
}
-(void)touchShowrePasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.repasswordTextField.secureTextEntry = !button.isSelected;
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
        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
        self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];

    }else if ([textField isEqual:self.passwordTextField]) {
        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
        self.passwordLineView.backgroundColor = [UIColor baseColor];
        self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];
    }else {
        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
        self.repasswordLineView.backgroundColor = [UIColor baseColor];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
    self.repasswordLineView.backgroundColor = [UIColor lightGrayColor];

}

#pragma mark - request
-(void)touchLoginButton{
    
    if (self.phoneTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入正确的旧密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请输入新密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.repasswordTextField.text.length < 6) {
        [self.view showLoadingMeg:@"请再次输新密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
        [self.view showLoadingMeg:@"两次输入的密码不一致" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    NSString *phonemd5 = [self.phoneTextField.text md5];
    NSString *newphonemd5 = [[NSString stringWithFormat:@"%@lanpin123.com",phonemd5] md5];
    
    NSString *passwordmd5 = [self.passwordTextField.text md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"newPsw":newPasswordmd5,
                          @"password":newphonemd5
                          };
    
    [NetApiManager requestModifyPswWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self.view showLoadingMeg:@"密码修改成功" time:MESSAGE_SHOW_TIME];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"注册失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
