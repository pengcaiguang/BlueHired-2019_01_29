//
//  LPLoginVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPLoginVC.h"

@interface LPLoginVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *phoneTextField;
@property(nonatomic,strong) UIView *phoneLineView;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UIView *passwordLineView;

@end

@implementation LPLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
    
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(textLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
    UIImageView *img = [[UIImageView alloc]init];
    [bgView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(13, 21));
    }];
    img.image = [UIImage imageNamed:@"phone_img"];
    
    self.phoneTextField = [[UITextField alloc]init];
    [bgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(bgView);

    }];
    self.phoneTextField.delegate = self;
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.tintColor = [UIColor baseColor];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.phoneLineView = [[UIView alloc]init];
    [bgView addSubview:self.phoneLineView];
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    UIView *bgView1 = [[UIView alloc]init];
    [self.view addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(bgView.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
    UIImageView *img1 = [[UIImageView alloc]init];
    [bgView1 addSubview:img1];
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(bgView1);
        make.size.mas_equalTo(CGSizeMake(15, 18));
    }];
    img1.image = [UIImage imageNamed:@"password_img"];
    
    self.passwordTextField = [[UITextField alloc]init];
    [bgView1 addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(bgView1);
    }];
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = @"请输入6-16位密码";
    self.passwordTextField.tintColor = [UIColor baseColor];
    self.passwordTextField.secureTextEntry = YES;

    UIButton *showPasswordButton = [[UIButton alloc]init];
    [bgView1 addSubview:showPasswordButton];
    [showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(22, 16));
        make.centerY.equalTo(bgView1);
    }];
    [showPasswordButton setImage:[UIImage imageNamed:@"show_eye_img"] forState:UIControlStateNormal];
    [showPasswordButton setImage:[UIImage imageNamed:@"hide_eye_img"] forState:UIControlStateSelected];
    [showPasswordButton addTarget:self action:@selector(touchShowPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.passwordLineView = [[UIView alloc]init];
    [bgView1 addSubview:self.passwordLineView];
    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
    
    
    UIButton *keepPassWord = [[UIButton alloc]init];
    [self.view addSubview:keepPassWord];
    [keepPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.equalTo(bgView1.mas_bottom).offset(20);
    }];
    [keepPassWord setTitle:@"记住密码" forState:UIControlStateNormal];
    [keepPassWord setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [keepPassWord setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    keepPassWord.titleLabel.font = [UIFont systemFontOfSize:12];
    [keepPassWord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [keepPassWord addTarget:self action:@selector(touchKeepPassWord:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *forgetPassWord = [[UIButton alloc]init];
    [self.view addSubview:forgetPassWord];
    [forgetPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.top.equalTo(bgView1.mas_bottom).offset(20);
    }];
    [forgetPassWord setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPassWord.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetPassWord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [forgetPassWord addTarget:self action:@selector(touchForgetPassWord:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(bgView1.mas_bottom).offset(80);
        make.height.mas_equalTo(40);
    }];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
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
    [registeredButton setTitle:@"注册" forState:UIControlStateNormal];
    [registeredButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    registeredButton.titleLabel.font = [UIFont systemFontOfSize:17];
    registeredButton.backgroundColor = [UIColor whiteColor];
    registeredButton.layer.masksToBounds = YES;
    registeredButton.layer.cornerRadius = 20;
    registeredButton.layer.borderColor = [UIColor baseColor].CGColor;
    registeredButton.layer.borderWidth = 0.5;
    [registeredButton addTarget:self action:@selector(touchRegisteredButton:) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - target
-(void)touchShowPasswordButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
}

-(void)touchKeepPassWord:(UIButton *)button{
    NSLog(@"记住密码");
}
-(void)touchForgetPassWord:(UIButton *)button{
    NSLog(@"忘记密码");
}

-(void)touchLoginButton:(UIButton *)button{
    NSLog(@"登陆");
}

-(void)touchRegisteredButton:(UIButton *)button{
    NSLog(@"注册");
}




#pragma mark - textfield
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if ([textField isEqual:self.phoneTextField]) {
//        self.phoneLineView.backgroundColor = [UIColor baseColor];
//        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
//    }else{
//        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
//        self.passwordLineView.backgroundColor = [UIColor baseColor];
//    }
//    return YES;
//}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
//    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
//    return YES;
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneTextField]) {
        self.phoneLineView.backgroundColor = [UIColor baseColor];
        self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
        self.passwordLineView.backgroundColor = [UIColor baseColor];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneLineView.backgroundColor = [UIColor lightGrayColor];
    self.passwordLineView.backgroundColor = [UIColor lightGrayColor];
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
