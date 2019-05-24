//
//  LPWithDrawalVC.m
//  BlueHired
//
//  Created by peng on 2018/9/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPWithDrawalVC.h"
#import "LPBankcardwithDrawModel.h"
#import "LPSalarycCardBindVC.h"
#import "LPSalarycCardChangePasswordVC.h"
#import "LPSalarycCardBindPhoneVC.h"
#import "LPSalarycCard2VC.h"


@interface LPWithDrawalVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property (weak, nonatomic) IBOutlet UIView *DrawalView;
@property (weak, nonatomic) IBOutlet UIView *SuccessView;
@property (weak, nonatomic) IBOutlet UIImageView *bankImage;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *BankNoLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *TitleTF;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;

@property(nonatomic,strong) LPBankcardwithDrawModel *model;
@property(nonatomic,assign) NSInteger errorTimes;

@property (nonatomic,strong) LPUserProblemModel *Pmodel;

@end

@implementation LPWithDrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工资提现";
    _determineButton.layer.cornerRadius = 4;
    _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.delegate = self;

    [self requestQueryBankcardwithDraw];
//    [self requestQueryGetUserProdlemList];

}

-(void)AdapterView{
    _bankLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    _BankNoLabel.font = [UIFont systemFontOfSize:FontSize(13)];
    _TitleTF.font = [UIFont systemFontOfSize:FontSize(14)];
    _balanceLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    _allButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];

}

-(void)textFieldChanged:(UITextField *)textField{
    if (textField.text.floatValue>[_balance floatValue]) {
        _balanceLabel.text = @"金额超出可提余额";
        _balanceLabel.textColor = [UIColor redColor];
        _determineButton.enabled = NO;
    }else{
        _balanceLabel.text = [NSString stringWithFormat:@"可提余额%.2f元",[_balance floatValue]];
        _balanceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _determineButton.enabled = YES;

    }
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    //匹配以0开头的数字
    NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
    //匹配两位小数、整数
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] ? YES : NO;
}

-(void)setModel:(LPBankcardwithDrawModel *)model{
    _model = model;
    if (model.data) {
        [self initDrawlView];
    }
//    [self initDrawlView];
    
//    if (model.data.type.integerValue == 1) {
//        self.addCardButton.hidden = NO;
//        self.DrawalView.hidden = YES;
//        self.navigationItem.title = @"添加银行卡";
//    }else{
//        self.navigationItem.title = @"工资提现";
//        self.addCardButton.hidden = YES;
//        self.DrawalView.hidden = NO;
//        [self initDrawlView];
//    }
    
}
-(void)initDrawlView
{
    _bankLabel.text = _model.data.bankName;
    _BankNoLabel.text = [NSString stringWithFormat:@"尾号%@%@",_model.data.bankNumber,_model.data.cardType];
    _balanceLabel.text = [NSString stringWithFormat:@"可提余额%.2f元",[_balance floatValue]];
}

- (IBAction)touchAddCardButton:(UIButton *)sender {
//    LPSalarycCardBindVC *vc = [[LPSalarycCardBindVC alloc]init];
    LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchAllButton:(id)sender {
    self.textField.text = [NSString stringWithFormat:@"%@", _balance];
    NSLog(@"iamge = %f     %f ",self.bankImage.lx_width,self.bankImage.lx_height);
    
}
- (IBAction)touchBt:(id)sender {
    if (_textField.text.length == 0 || _textField.text.floatValue == 0.0)
    {
        [self.view showLoadingMeg:@"请输入金额" time:MESSAGE_SHOW_TIME];
        return;
    }else if (_textField.text.floatValue < 20.0){
        [LPTools AlertMessageView:@"提现金额最低20元！"];
        return;
    }else if ([_textField.text floatValue]>[_balance floatValue]){
        [self.view showLoadingMeg:@"提现金额超出可提余额" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
    if (kUserDefaultsValue(ERRORTIMES)) {
        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
        if(errorString.length<17){
            kUserDefaultsRemove(ERRORTIMES);
        }else{
            NSString *d = [errorString substringToIndex:16];
            NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
            NSString *t = [errorString substringFromIndex:17];
            self.errorTimes = [t integerValue];
            if ([t integerValue] >= 3 && [str integerValue] < 10) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                }];
                [alert show];
                return;
            }
            else
            {
                kUserDefaultsRemove(ERRORTIMES);
            }
        }
       
    }
    
    float money = [_textField.text floatValue];
    
    
    NSString *str1 = [NSString stringWithFormat:@"金额%.2f元将提现至尾号为%@%@，请注意查收",money,_model.data.bankNumber,_model.data.bankName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    //设置：在3~length-3个单位长度内的内容显示色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[str1 rangeOfString:[NSString stringWithFormat:@"%.2f",money]]];
    
    
    GJAlertWithDrawPassword *alert = [[GJAlertWithDrawPassword alloc] initWithTitle:str
                                                           message:@""
                                                      buttonTitles:@[]
                                                      buttonsColor:@[[UIColor baseColor]]
                                                       buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                           
                                                           NSString *passwordmd5 = [string md5];
                                                           NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
                                                           
                                                           NSDictionary *dic = @{@"bankName":self.model.data.bankName,
                                                                                 @"bankNum":self.model.data.bankNumber,
                                                                                 @"money":[NSString stringWithFormat:@"%.2f",money]
                                                                                 };
                                                           NSString *url = [NSString stringWithFormat:@"billrecord/withdraw_deposit?drawPwd=%@",newPasswordmd5];
       [NetApiManager requestQueryBankcardwithDrawDepositWithParam:url WithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
           NSLog(@"%@",responseObject);
           if (isSuccess) {
               if ([responseObject[@"code"] integerValue] ==0)
               {
                   if ([responseObject[@"data"] integerValue] ==1) {
//                       [self.view showLoadingMeg:@"提现成功" time:MESSAGE_SHOW_TIME];
//                        [self.navigationController popViewControllerAnimated:YES];
                       self.SuccessView.hidden = NO;
                   }else{
                       [self.view showLoadingMeg:@"提现申请失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                   }
               }
               else
               {
                   if ([responseObject[@"code"] integerValue] == 20027) {
                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                       dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                       NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                       
                       if (kUserDefaultsValue(ERRORTIMES)) {
                           NSString *errorString = kUserDefaultsValue(ERRORTIMES);
                           NSString *d = [errorString substringToIndex:16];
                           NSString *t = [errorString substringFromIndex:17];
                           NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
                           
                           self.errorTimes = [t integerValue];
                           if ([t integerValue] >= 3&& [str integerValue] < 10) {
                               GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
                               [alert show];
                           }else{
                                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes]
                                                                                    message:nil
                                                                              textAlignment:NSTextAlignmentCenter
                                                                               buttonTitles:@[@"忘记密码",@"重新输入"]
                                                                               buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                                                    buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                                buttonClick:^(NSInteger buttonIndex) {
                                                                                    if (buttonIndex == 0) {
                                                                                        LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                        vc.type = 1;
                                                                                        vc.Phone = self.model.data.phone;
                                                                                        [self.navigationController pushViewController:vc animated:YES];
                                                                                    }else if (buttonIndex == 1){
                                                                                        [self touchBt:nil];
                                                                                    }
                                                                                    //                               [self.navigationController popViewControllerAnimated:YES];
                                                                                }];
                               
                               [alert show];
                               
                               self.errorTimes += 1;
                               NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                               kUserDefaultsSave(str, ERRORTIMES);
                           }
                       }else{
                            if (self.errorTimes >2) {
                               self.errorTimes = 0;
                           }
                           
                           GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes]
                                                                                message:nil
                                                                          textAlignment:NSTextAlignmentCenter
                                                                           buttonTitles:@[@"忘记密码",@"重新输入"]
                                                                           buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                                                buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                            buttonClick:^(NSInteger buttonIndex) {
                                                                                if (buttonIndex == 0) {
                                                                                    LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                    vc.type = 1;
                                                                                    vc.Phone = self.model.data.phone;
                                                                                    [self.navigationController pushViewController:vc animated:YES];
                                                                                }else if (buttonIndex == 1){
                                                                                    [self touchBt:nil];
                                                                                }
                                                                            }];
                           
                           [alert show];
                           self.errorTimes += 1;
                           NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                           kUserDefaultsSave(str, ERRORTIMES);
                       }
                   }else{
                        [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                   }
//                   [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
               }

           }else{
               [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
           }
       }];
    }];
    [alert show];
    
    
}

- (IBAction)SuccessTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - request
-(void)requestQueryBankcardwithDraw{
    [NetApiManager requestQueryBankcardwithDrawWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                  self.model = [LPBankcardwithDrawModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
          
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

- (void)setPmodel:(LPUserProblemModel *)Pmodel{
    _Pmodel = Pmodel;
    if (Pmodel.data.count == 0) {
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


-(void)requestQueryGetUserProdlemList{
    
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetUserProdlemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Pmodel = [LPUserProblemModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
