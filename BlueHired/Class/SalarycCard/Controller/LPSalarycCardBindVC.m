//
//  LPSalarycCardBindVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSalarycCardBindVC.h"

@interface LPSalarycCardBindVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *idcard;
@property(nonatomic,strong) NSString *card;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *password;

@end

@implementation LPSalarycCardBindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工资卡绑定";
    
    self.nameTextField.delegate = self;
    self.idcardTextField.delegate = self;
    self.cardTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    
    [self requestSelectBindbankcard];
}
- (IBAction)touchButton:(UIButton *)sender {
    if (self.nameTextField.text.length <= 0) {
        [self.view showLoadingMeg:@"请输入持卡人姓名" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.idcardTextField.text.length <= 0 || ![NSString isIdentityCard:self.idcardTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的身份证号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.cardTextField.text.length <= 0 || ![NSString isBankCard:self.cardTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.phoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.phoneTextField.text]) {
        [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    if (self.passwordTextField.text.length <= 0) {
        [self.view showLoadingMeg:@"请输入6位体现密码" time:MESSAGE_SHOW_TIME];
        return;
    }
}


#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.nameTextField.text.length >= 6) {
            self.nameTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    if (textField == self.idcardTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.idcardTextField.text.length >= 18) {
            self.idcardTextField.text = [textField.text substringToIndex:18];
            return NO;
        }
    }
    if (textField == self.cardTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.cardTextField.text.length >= 19) {
            self.cardTextField.text = [textField.text substringToIndex:19];
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
    if (textField == self.passwordTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.passwordTextField.text.length >= 6) {
            self.passwordTextField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
    
}




#pragma mark - request
-(void)requestSelectBindbankcard{
    [NetApiManager requestSelectBindbankcardWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
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
