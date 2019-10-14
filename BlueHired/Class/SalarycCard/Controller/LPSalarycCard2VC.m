//
//  LPSalarycCard2VC.m
//  BlueHired
//
//  Created by iMac on 2019/1/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPSalarycCard2VC.h"
#import "LPSelectBindbankcardModel.h"
#import "RSAEncryptor.h"
#import "AddressPickerView.h"
#import "LPSalarycCardBindPhoneVC.h"
#import "LPSalarycCardChangePasswordVC.h"
#import "LPDurationView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


 


static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

@interface LPSalarycCard2VC ()<UITextFieldDelegate,AddressPickerViewDelegate>
@property (nonatomic,strong) NSArray *HeadTitleArr;
@property (nonatomic,strong) NSMutableArray *headViewArr;
@property (nonatomic,assign) NSInteger IntStep;
@property (nonatomic,assign) NSInteger ClassType;
@property (nonatomic,assign) CardType CardType;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic ,strong) AddressPickerView * pickerView;

@property (weak, nonatomic) IBOutlet UIView *ScanningView;
@property (weak, nonatomic) IBOutlet UILabel *ScanningTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *ManualTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *AddressTitleLable;

@property (weak, nonatomic) IBOutlet UIView *TextFieldView;
@property (weak, nonatomic) IBOutlet UIView *SetPassView;
@property (weak, nonatomic) IBOutlet UIButton *TextFieldViewTopBt;
@property (weak, nonatomic) IBOutlet UIButton *TextFieldViewNextBt;
@property (weak, nonatomic) IBOutlet UIButton *TextFieldViewNext2Bt;

@property (weak, nonatomic) IBOutlet UIView *HBTextFieldView;

@property (weak, nonatomic) IBOutlet UIView *SucceedView;

@property (weak, nonatomic) IBOutlet UIButton *ScanningViewTopBt;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;

@property (weak, nonatomic) IBOutlet UITextField *BankNameField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic,strong) UIView *ToolTextView;


@property(nonatomic,strong) LPDurationView *durationView;
@property(nonatomic,strong) NSArray *TypeArray;


@property (nonatomic,strong) UIView *StepHeadView;

@property(nonatomic,strong) LPSelectBindbankcardModel *model;
@property(nonatomic,assign) NSInteger errorTimes;
@property(nonatomic,strong) NSString *passwordString;


@end

@implementation LPSalarycCard2VC{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextFieldView];

    self.headViewArr = [[NSMutableArray alloc] init];
    self.IntStep = 1;
    self.navigationItem.title = @"工资卡绑定";
    self.TypeArray = @[@"招商银行",
                       @"兴业银行",
                       @"中国建设银行",
                       @"中国工商银行",
                       @"中国农业银行",
                       @"中国银行",
                       @"交通银行",
                       @"中国邮政储蓄银行",
                       @"光大银行",
                       @"广发银行",
                       @"平安银行",
                       @"华夏银行",
                       @"浙商银行"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFF2F2F2"];
    
    self.TextFieldViewTopBt.layer.cornerRadius = 4;
    self.TextFieldViewTopBt.layer.borderWidth = 1;
    self.TextFieldViewTopBt.layer.borderColor = [UIColor baseColor].CGColor;
    self.ScanningViewTopBt.layer.cornerRadius = 4;
    self.ScanningViewTopBt.layer.borderWidth = 1;
    self.ScanningViewTopBt.layer.borderColor = [UIColor baseColor].CGColor;
    [self configCallback];
    [self requestSelectBindbankcard];
    [self.nameTextField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nameTextField.inputAccessoryView = self.ToolTextView;

    self.idcardTextField.delegate = self;
    self.idcardTextField.inputAccessoryView = self.ToolTextView;

    self.cardTextField.delegate = self;
    self.cardTextField.inputAccessoryView = self.ToolTextView;

    self.phoneTextField.delegate = self;
    self.phoneTextField.inputAccessoryView = self.ToolTextView;

    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.inputAccessoryView = self.ToolTextView;
    
    self.BankNameField.delegate = self;
    self.BankNameField.inputAccessoryView = self.ToolTextView;

    
    self.idcardTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.cardTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
//    self.nameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    UIButton *userNameClearButton = [self.idcardTextField valueForKey:@"_clearButton"];
    [userNameClearButton setImage:[UIImage imageNamed:@"deleteCard"] forState:UIControlStateNormal];
    
    UIButton *userNameClearButton1 = [self.cardTextField valueForKey:@"_clearButton"];
    [userNameClearButton1 setImage:[UIImage imageNamed:@"deleteCard"] forState:UIControlStateNormal];
    
    UIButton *userNameClearButton2 = [self.nameTextField valueForKey:@"_clearButton"];
    [userNameClearButton2 setImage:[UIImage imageNamed:@"deleteCard"] forState:UIControlStateNormal];
    
 
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.ispass){
        self.IntStep++;
        [self UpdateHeadViewColor];
        self.ispass = NO;
    }
}



#pragma mark - 编辑view
-(void)setTextFieldView{
    //输入框编辑view
    UIView *ToolTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.ToolTextView = ToolTextView;
    ToolTextView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    UIButton *DoneBt = [[UIButton alloc] init];
    [ToolTextView addSubview:DoneBt];
    [DoneBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [DoneBt setTitle:@"确定" forState:UIControlStateNormal];
    [DoneBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    DoneBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    DoneBt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [DoneBt addTarget:self action:@selector(TouchTextDone:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *CancelBt = [[UIButton alloc] init];
    [ToolTextView addSubview:CancelBt];
    [CancelBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.equalTo(DoneBt.mas_left).offset(0);
        make.width.equalTo(DoneBt.mas_width);
    }];
    [CancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [CancelBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CancelBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CancelBt.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [CancelBt addTarget:self action:@selector(TouchTextCancel:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)TouchTextDone:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)TouchTextCancel:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}






-(void)setHeadView{
    UIView *HeadView = [[UIView alloc] init];
    [self.view addSubview:HeadView];
    self.StepHeadView = HeadView;
    [HeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    HeadView.backgroundColor = [UIColor whiteColor];
    CGFloat stepWhith = SCREEN_WIDTH/320*18;
//    CGFloat LineViewWhith = (SCREEN_WIDTH-44-stepWhith)/(self.HeadTitleArr.count-1) - stepWhith;
 
    UILabel *TopstepView ;
    UILabel *TopstepLabel ;

    for (int i= 0 ; i<self.HeadTitleArr.count; i++) {        
        UILabel *StepNameLabel = [[UILabel alloc] init];
        [HeadView addSubview:StepNameLabel];
//        [StepNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
//            make.centerX.equalTo(StepLabel);
//            make.top.equalTo(StepLabel.mas_bottom).offset(8);
////            make.width.mas_equalTo(SCREEN_WIDTH/self.HeadTitleArr.count-70);
//            make.width.mas_equalTo(stepWhith*2.5);
//            make.bottom.mas_equalTo(-17);
//        }];
        [StepNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            if (TopstepView) {
                make.left.equalTo(TopstepLabel.mas_right).offset(20);
                make.width.equalTo(TopstepLabel.mas_width);
            }else{
                make.left.mas_equalTo(13);
            }
            if (i==self.HeadTitleArr.count-1) {
                make.right.mas_equalTo(-13);
            }
            
            make.top.mas_equalTo(18+stepWhith+8);
            make.bottom.mas_equalTo(-17);
        }];
        
        StepNameLabel.textColor = i?[UIColor blackColor]:[UIColor baseColor];
        StepNameLabel.text = self.HeadTitleArr[i];
        StepNameLabel.numberOfLines = 0;
        StepNameLabel.textAlignment = NSTextAlignmentCenter;
        StepNameLabel.font = [UIFont systemFontOfSize:13];
        StepNameLabel.tag = 100*i+3;
        TopstepLabel = StepNameLabel;
        
        UILabel *StepLabel = [[UILabel alloc] init];
        [HeadView addSubview:StepLabel];
        //        [StepLabel mas_makeConstraints:^(MASConstraintMaker *make){
        //            if (TopstepView) {
        //                make.left.equalTo(TopstepView.mas_right).offset(LineViewWhith);
        //            }else{
        //                make.left.mas_equalTo(22);
        //            }
        //            make.top.mas_equalTo(18);
        //            make.size.mas_equalTo(CGSizeMake(stepWhith, stepWhith));
        //        }];
        [StepLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(StepNameLabel);
            make.top.mas_equalTo(18);
            make.size.mas_equalTo(CGSizeMake(stepWhith, stepWhith));
        }];
        StepLabel.layer.cornerRadius = stepWhith/2;
        StepLabel.clipsToBounds = YES;
        StepLabel.font = [UIFont systemFontOfSize:13];
        StepLabel.backgroundColor = i?[UIColor colorWithHexString:@"#FFF2F2F2"]:[UIColor baseColor];
        StepLabel.textColor = [UIColor colorWithHexString:@"#FFFEFEFE"];
        StepLabel.text = [NSString stringWithFormat:@"%d",i+1];
        StepLabel.textAlignment = NSTextAlignmentCenter;
        StepLabel.tag = 100*i+1;
        
        if (TopstepView) {
            UIView *lineView = [[UIView alloc] init];
            [HeadView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make){
                make.centerY.equalTo(StepLabel);
                make.left.equalTo(TopstepView.mas_right).offset(0);
                make.right.equalTo(StepLabel.mas_left).offset(0);
                make.height.mas_equalTo(3);
            }];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#FFF2F2F2"];
            lineView.tag = 100*i+2;

            [self.headViewArr addObject:lineView];
        }
        TopstepView = StepLabel;
        
        [self.headViewArr addObject:StepLabel];
        [self.headViewArr addObject:StepNameLabel];

    }
    [HeadView layoutIfNeeded];


    [self.ScanningView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(HeadView.mas_bottom).offset(10);
        make.top.mas_equalTo(HeadView.frame.size.height+10);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    [self.TextFieldView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(HeadView.mas_bottom).offset(10);
        make.top.mas_equalTo(HeadView.frame.size.height+10);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    [self.SetPassView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(HeadView.mas_bottom).offset(10);
        make.top.mas_equalTo(HeadView.frame.size.height+10);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        
    }];
    [self.HBTextFieldView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(HeadView.mas_bottom).offset(10);
        make.top.mas_equalTo(HeadView.frame.size.height+10);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    UIView *BottomBar = [[UIView alloc] init];
    [self.view addSubview:BottomBar];
    [BottomBar mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.HBTextFieldView.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }] ;
    BottomBar.backgroundColor = [UIColor whiteColor];
    //加载地区选择器
    [self.view addSubview:self.pickerView];

//    self.contentView = [[UIView alloc] init];
//    [self.view addSubview:self.contentView];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(HeadView.mas_bottom).offset(10);
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    [self initIDCardScanning];
    
//
//    UIButton *TopBt =[[UIButton alloc] init];
//    [self.view addSubview:TopBt];
//    [TopBt mas_makeConstraints:^(MASConstraintMaker *make){
//        make.bottom.mas_equalTo(-13);
//        make.left.mas_equalTo(13);
//        make.height.mas_equalTo(48);
//    }];
//    [TopBt setTitle:@"上一步" forState:UIControlStateNormal];
//    [TopBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
//    TopBt.layer.cornerRadius = 4;
//    TopBt.layer.borderColor = [UIColor baseColor].CGColor;
//    TopBt.layer.borderWidth = 1;
//    [TopBt addTarget:self action:@selector(TouchTopBt:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *NextBt = [[UIButton alloc] init];
//    [self.view addSubview:NextBt];
//    [NextBt mas_makeConstraints:^(MASConstraintMaker *make){
//        make.bottom.mas_equalTo(-13);
//        make.right.mas_equalTo(-13);
//        make.left.equalTo(TopBt.mas_right).offset(7);
//        make.height.mas_equalTo(48);
//        make.width.equalTo(TopBt.mas_width);
//    }];
//    [NextBt setTitle:@"下一步" forState:UIControlStateNormal];
//    [NextBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    NextBt.backgroundColor = [UIColor baseColor];
//    NextBt.layer.cornerRadius = 4;
//    [NextBt addTarget:self action:@selector(TouchNextBt:) forControlEvents:UIControlEventTouchUpInside];

}


-(IBAction)TouchTopBt:(UIButton *)sender{
    if (self.IntStep > 1) {
        self.IntStep--;
        [self UpdateHeadViewColor];
    }
}

-(IBAction)TouchNextBt:(UIButton *)sender{
    
    //self.classType == 3 和 self.IntStep == 3 特殊处理
    
    if (self.IntStep == 3 && self.ClassType == 3) {
        if (self.cardTextField.text.length <= 0 || ![NSString isBankCard:self.cardTextField.text]) {
            [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.phoneTextField.text.length <= 0 ) {
            //                [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
            [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
            return;
        }
        self.model.data.bankNumber = [RSAEncryptor encryptString:self.cardTextField.text publicKey:RSAPublickKey];
        self.model.data.openBankAddr = self.phoneTextField.text;
        [self requestBindunbindBankcard];
        return;
    }
    
    if (self.IntStep<self.HeadTitleArr.count) {
        if (self.ClassType == 1) {
            if (self.IntStep == 2) {
                if (self.nameTextField.text.length <= 0) {
                    [self.view showLoadingMeg:@"请输入持卡人姓名" time:MESSAGE_SHOW_TIME];
                    return;
                }
                if (self.idcardTextField.text.length <= 0 || ![NSString isIdentityCard:self.idcardTextField.text]) {
                    [self.view showLoadingMeg:@"请输入正确的身份证号" time:MESSAGE_SHOW_TIME];
                    return;
                }
                self.model.data.identityNo =[RSAEncryptor encryptString:self.idcardTextField.text publicKey:RSAPublickKey];
                self.model.data.userName =[LPTools removeSpaceAndNewline: self.nameTextField.text];
                [self requestCardNOoccupy];
                return;
            }
            if (self.IntStep == 4){
                if (self.cardTextField.text.length <= 0 || ![NSString isBankCard:self.cardTextField.text]) {
                    [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
                    return;
                }
                
                if (self.BankNameField.text.length <= 0 ) {
                    [self.view showLoadingMeg:@"请选择银行名称" time:MESSAGE_SHOW_TIME];
                    return;
                }
                
                if (self.phoneTextField.text.length <= 0 ) {
                    [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
                    return;
                }
                self.model.data.bankNumber = [RSAEncryptor encryptString:self.cardTextField.text publicKey:RSAPublickKey];
                self.model.data.openBankAddr = self.phoneTextField.text;
                self.model.data.bankName = self.BankNameField.text;
            }
        }else if (self.ClassType == 2){
            if (self.IntStep == 3){
                if (self.cardTextField.text.length <= 0 || ![NSString isBankCard:self.cardTextField.text]) {
                    [self.view showLoadingMeg:@"请输入正确的银行卡号" time:MESSAGE_SHOW_TIME];
                    return;
                }
                if (self.phoneTextField.text.length <= 0 ) {
                    //                [self.view showLoadingMeg:@"请输入正确的银行卡预留手机号" time:MESSAGE_SHOW_TIME];
                    [self.view showLoadingMeg:@"请选择银行卡归属地" time:MESSAGE_SHOW_TIME];
                    return;
                }
                
                if (self.BankNameField.text.length <= 0 ) {
                    [self.view showLoadingMeg:@"请选择银行名称" time:MESSAGE_SHOW_TIME];
                    return;
                }
                
                self.model.data.bankNumber = [RSAEncryptor encryptString:self.cardTextField.text publicKey:RSAPublickKey];
                self.model.data.openBankAddr = self.phoneTextField.text;
                self.model.data.bankName = self.BankNameField.text;

            }
        }else if (self.ClassType == 3){
            if (self.IntStep == 1) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                
                if (kUserDefaultsValue(ERRORTIMES)) {
                    NSString *errorString = kUserDefaultsValue(ERRORTIMES);
                    if(errorString.length<17){
                        kUserDefaultsRemove(ERRORTIMES);
                    }else{
                        NSString *d = [errorString substringToIndex:16];
                        NSString *t = [errorString substringFromIndex:17];
                        NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
                        self.errorTimes = [t integerValue];
                        if ([t integerValue] >= 3 && [str integerValue] < 10) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                            }];
                            [alert show];
                            return;
                        }else{
                            kUserDefaultsRemove(ERRORTIMES);
//                            NSString *str = [NSString stringWithFormat:@"%@-0",string];
//                            kUserDefaultsSave(str, ERRORTIMES);
                        }
                    }
                    
                }
                
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@""];
                GJAlertWithDrawPassword *alert = [[GJAlertWithDrawPassword alloc] initWithTitle:str
                                                                                        message:@""
                                                                                   buttonTitles:@[]
                                                                                   buttonsColor:@[[UIColor baseColor]]
                                                                                    buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                                                        if (string.length==6) {
                                                                                            self.passwordString = string;
                                                                                            [self requestUpdateDrawpwd];
                                                                                        }else{
                                                                                            LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                            vc.type = 1;
                                                                                            vc.Phone = self.model.data.phone;
                                                                                            [self.navigationController pushViewController:vc animated:YES];
                                                                                        }
                                                                                        
                                                                                    }];
                [alert show];
                
                
                
//                GJAlertPassword *alert = [[GJAlertPassword alloc]initWithTitle:@"请输入提现密码，完成身份验证" message:nil buttonTitles:@[@"忘记密码?请点击这里"] buttonsColor:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex, NSString *string) {
//                    NSLog(@"%ld",buttonIndex);
//                    self.passwordString = string;
//                    if (string.length != 6) {
//                        LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
//                        vc.type = 1;
//                        vc.Phone = self.model.data.phone;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                    else
//                    {
//                        [self requestUpdateDrawpwd];
//                    }
//
//                }];
//                [alert show];
                return;
            }else if (self.IntStep == 3){
               
            }
        }        
        self.IntStep++;
        [self UpdateHeadViewColor];
    }
    
}
- (IBAction)TouchFinish:(id)sender {
    if (self.passwordTextField.text.length != 6) {
        [self.view showLoadingMeg:@"请输入6位提现密码" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestBindunbindBankcard];
}

-(void)initIDCardScanning{
    UIView *view = [[UIView alloc] init];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIButton *ScannBt = [[UIButton alloc] init];
    [view addSubview:ScannBt];
    [ScannBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(29);
        make.centerX.equalTo(view);
        make.width.mas_equalTo(SCREEN_WIDTH/360*253);
        make.height.mas_equalTo(SCREEN_WIDTH/360*130);
    }];
    ScannBt.layer.cornerRadius = 8;
    ScannBt.layer.borderColor = [UIColor colorWithHexString:@"#FFE6E6E6"].CGColor;
    ScannBt.layer.borderWidth = 1;
    [ScannBt setTitle:@"点击扫描身份证" forState:UIControlStateNormal];
    [ScannBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal ];
    [ScannBt setImage:[UIImage imageNamed:@"IDCardScannImage"] forState:UIControlStateNormal];
    CGFloat gap = -20.f;
    CGFloat labelWidth = ScannBt.titleLabel.bounds.size.width;
    CGFloat imageWidth = ScannBt.imageView.bounds.size.width;
    CGFloat imageHeight = ScannBt.imageView.bounds.size.height;
    CGFloat labelHeight = ScannBt.titleLabel.bounds.size.height;
    CGFloat imageOffSetX = labelWidth / 2;
    CGFloat imageOffSetY = imageHeight / 2 + gap / 2;
    CGFloat labelOffSetX = imageWidth / 2;
    CGFloat labelOffSetY = labelHeight / 2 + gap / 2;
 
    CGFloat maxWidth = MAX(imageWidth,labelWidth); // 上下排布宽度肯定变小 获取最大宽度的那个
    CGFloat changeWidth = imageWidth + labelWidth - maxWidth; // 横向缩小的总宽度
    CGFloat maxHeight = MAX(imageHeight,labelHeight); // 获取最大高度那个 （就是水平默认排布的时候的原始高度）
    CGFloat changeHeight = imageHeight + labelHeight + gap - maxHeight; // 总高度减去原始高度就是纵向宽大宗高度
    ScannBt.imageEdgeInsets = UIEdgeInsetsMake(-imageOffSetY, imageOffSetX, imageOffSetY, -imageOffSetX);
    ScannBt.titleEdgeInsets = UIEdgeInsetsMake(labelOffSetY, -labelOffSetX, -labelOffSetY, labelOffSetX);
    ScannBt.contentEdgeInsets = UIEdgeInsetsMake(changeHeight - labelOffSetY, - changeWidth / 2, labelOffSetY, -changeWidth / 2);
 
    
    
    UIButton *manualBt = [[UIButton alloc] init];
    [view addSubview:manualBt];
    [manualBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(ScannBt.mas_bottom).offset(20);
        make.centerX.equalTo(view);
        make.width.mas_equalTo(SCREEN_WIDTH/360*253);
        make.height.mas_equalTo(SCREEN_WIDTH/360*130);
    }];
    manualBt.layer.cornerRadius = 8;
    manualBt.layer.borderColor = [UIColor colorWithHexString:@"#FFE6E6E6"].CGColor;
    manualBt.layer.borderWidth = 1;
    [manualBt setTitle:@"忘带身份证，点击手动输入" forState:UIControlStateNormal];
    [manualBt setImage:[UIImage imageNamed:@"IDCardManualImage"] forState:UIControlStateNormal];
    [manualBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal ];

}

-(void)UpdateContentView{
    self.ScanningView.hidden = YES;
    self.SetPassView.hidden = YES;
    self.TextFieldView.hidden = YES;
    self.HBTextFieldView.hidden = YES;
    
    self.nameTextField.enabled = YES;
    self.idcardTextField.enabled = YES;
    self.TextFieldViewNext2Bt.hidden = YES;
    self.TextFieldViewNextBt.hidden = NO;
    self.TextFieldViewTopBt.hidden = NO;
    if (self.ClassType == 1) {          //绑定
        if (self.IntStep == 1) {        //身份证扫描
            self.ScanningView.hidden = NO;
            UIButton *bt = (UIButton *)[self.ScanningView viewWithTag:1000];
            bt.hidden = YES;
            UIButton *bt2 = (UIButton *)[self.ScanningView viewWithTag:1001];
            bt2.hidden = YES;
            self.ScanningTitleLable.text = @"点击扫描身份证";
            self.ManualTitleLable.text = @"忘带身份证，点击手动输入";
        }else if (self.IntStep == 2){       //身份证信息
            self.TextFieldView.hidden = NO;
            for (UIView *view in self.TextFieldView.subviews) {
                if (view.tag >= 1000) {
                    view.hidden = YES;
                }
                
                if (view.tag<3000&& view.tag >=1000) {
                    view.hidden = NO;
                }
            }
            self.nameTextField.text = self.model.data.userName;
            self.idcardTextField.text = [RSAEncryptor decryptString:self.model.data.identityNo privateKey:RSAPrivateKey];
 
        }else if (self.IntStep == 3){       //银行卡扫描
            self.ScanningView.hidden = NO;
            UIButton *bt = (UIButton *)[self.ScanningView viewWithTag:1000];
            bt.hidden = NO;
            UIButton *bt2 = (UIButton *)[self.ScanningView viewWithTag:1001];
            bt2.hidden = NO;
            self.ScanningTitleLable.text = @"点击扫描银行卡";
            self.ManualTitleLable.text = @"忘带银行卡，点击手动输入";
        }else if (self.IntStep == 4){       //银行卡信息
            self.TextFieldView.hidden = NO;
            for (UIView *view in self.TextFieldView.subviews) {
                if (view.tag >= 1000) {
                    view.hidden = YES;
                }
                if (view.tag >=3000) {
                    view.hidden = NO;
                }
            }
             self.cardTextField.text = [RSAEncryptor decryptString:self.model.data.bankNumber privateKey:RSAPrivateKey];
            self.BankNameField.text = self.model.data.bankName;

        }else if (self.IntStep == 5){       //设置提现密码
            self.SetPassView.hidden = NO;
        }
    }else if (self.ClassType == 2){             //半实名
        if (self.IntStep == 1) {        //身份证信息
            self.TextFieldView.hidden = NO;
            
            for (UIView *view in self.TextFieldView.subviews) {
                if (view.tag >= 1000) {
                    view.hidden = YES;
                }
                
                if (view.tag<3000&& view.tag >=1000) {
                    view.hidden = NO;
                }
            }
            self.nameTextField.text = self.model.data.userName;
            self.idcardTextField.text = [RSAEncryptor decryptString:self.model.data.identityNo privateKey:RSAPrivateKey];
            self.nameTextField.enabled = NO;
            self.idcardTextField.enabled = NO;
            [self.TextFieldViewNext2Bt setTitle:@"下一步" forState:UIControlStateNormal];
            self.TextFieldViewNext2Bt.hidden = NO;
            self.TextFieldViewNextBt.hidden = YES;
            self.TextFieldViewTopBt.hidden = YES;
        }else if (self.IntStep == 2){       //银行卡扫描
            self.ScanningView.hidden = NO;
            UIButton *bt = (UIButton *)[self.ScanningView viewWithTag:1000];
            bt.hidden = NO;
            UIButton *bt2 = (UIButton *)[self.ScanningView viewWithTag:1001];
            bt2.hidden = NO;
            self.ScanningTitleLable.text = @"点击扫描银行卡";
            self.ManualTitleLable.text = @"忘带银行卡，点击手动输入";
        }else if (self.IntStep == 3){       //银行卡信息
            self.TextFieldView.hidden = NO;
            for (UIView *view in self.TextFieldView.subviews) {
                if (view.tag >= 1000) {
                    view.hidden = YES;
                }
                if (view.tag >=3000) {
                    view.hidden = NO;
                }
            }
            self.cardTextField.text = [RSAEncryptor decryptString:self.model.data.bankNumber privateKey:RSAPrivateKey];
            self.BankNameField.text = self.model.data.bankName;

        }else if (self.IntStep == 4){       //提现密码
            self.SetPassView.hidden = NO;
        }
    }else if (self.ClassType == 3){         //换绑
        if (self.IntStep == 1) {            //工资卡信息
            self.HBTextFieldView.hidden = NO;
            UITextField *NameTF = [self.HBTextFieldView viewWithTag:1001];
            UITextField *idcardNOTF = [self.HBTextFieldView viewWithTag:1002];
            UITextField *CardNOTF = [self.HBTextFieldView viewWithTag:1003];
            UITextField *PhoneTF = [self.HBTextFieldView viewWithTag:1004];
            UITextField *BankNameTF = [self.HBTextFieldView viewWithTag:1005];
            
            NameTF.text = self.model.data.userName;
            idcardNOTF.text = [RSAEncryptor decryptString:self.model.data.identityNo privateKey:RSAPrivateKey];
            CardNOTF.text = [RSAEncryptor decryptString:self.model.data.bankNumber privateKey:RSAPrivateKey];
            PhoneTF.text = self.model.data.openBankAddr;
            BankNameTF.text = self.model.data.bankName;

        }else if (self.IntStep == 2){       //银行卡扫描
            self.ScanningView.hidden = NO;
            UIButton *bt = (UIButton *)[self.ScanningView viewWithTag:1000];
            bt.hidden = NO;
            UIButton *bt2 = (UIButton *)[self.ScanningView viewWithTag:1001];
            bt2.hidden = NO;
            self.ScanningTitleLable.text = @"点击扫描银行卡";
            self.ManualTitleLable.text = @"忘带银行卡，点击手动输入";
        }else if (self.IntStep == 3){       //银行卡信息
            self.TextFieldView.hidden = NO;
            for (UIView *view in self.TextFieldView.subviews) {
                if (view.tag >= 1000) {
                    view.hidden = YES;
                }
                if (view.tag >=3000) {
                    view.hidden = NO;
                }
            }
            self.cardTextField.text = [RSAEncryptor decryptString:self.model.data.bankNumber privateKey:RSAPrivateKey];
            
//            NSString *Bname = self.model.data.bankName;
//            if ([Bname containsString:@"建设"]) {
//                self.model.data.bankName = @"中国建设银行";
//            }else if ([Bname containsString:@"招商"]){
//                self.model.data.bankName = @"招商银行";
//            }else if ([Bname containsString:@"兴业"]){
//                self.model.data.bankName = @"兴业银行";
//            }
            self.BankNameField.text = self.model.data.bankName;

            
            self.phoneTextField.text = self.model.data.openBankAddr;
            [self.TextFieldViewNext2Bt setTitle:@"确定换绑" forState:UIControlStateNormal];
            self.TextFieldViewNext2Bt.hidden = NO;
            self.TextFieldViewNextBt.hidden = YES;
            self.TextFieldViewTopBt.hidden = YES;
        }
    }
    
}

-(void)UpdateHeadViewColor{
    for (UIView *view in self.headViewArr) {
        if (view.tag >self.IntStep*100 ) {
            if (view.tag%100 == 3) {
                UILabel *nameLable= (UILabel *)view;
                nameLable.textColor = [UIColor blackColor];
            }else{
                view.backgroundColor= [UIColor colorWithHexString:@"#FFF2F2F2"];
            }
        }else{
            if (view.tag%100 == 3) {
                UILabel *nameLable= (UILabel *)view;
                nameLable.textColor = [UIColor baseColor];
            }else{
                view.backgroundColor= [UIColor baseColor];
            }
        }
    }
    [self UpdateContentView];
}



- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSMutableString *message = [NSMutableString string];
        NSMutableArray *messageArr = [[NSMutableArray alloc] init];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                        [messageArr addObject:[NSString stringWithFormat:@"%@: %@\n", key, obj[@"words"]]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                        [messageArr addObject:[NSString stringWithFormat:@"%@: %@\n", key, obj]];
                    }
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                        [messageArr addObject:[NSString stringWithFormat:@"%@\n", obj[@"words"]]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                        [messageArr addObject:[NSString stringWithFormat:@"%@\n", obj]];
                    }
                    
                }
            }
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            NSLog(@"%@    %@", result[@"words_result"][@"公民身份号码"][@"words"] , result[@"words_result"][@"姓名"][@"words"]);
            NSString *Identity = result[@"words_result"][@"公民身份号码"][@"words"];
            NSString *IdentityName = result[@"words_result"][@"姓名"][@"words"];

            if (weakSelf.CardType == CardTypeIdCardFont) {      //身份证
                if (Identity.length || IdentityName.length ) {
                    weakSelf.model.data.identityNo =[RSAEncryptor encryptString:Identity publicKey:RSAPublickKey];
                    weakSelf.model.data.userName = IdentityName;
                    [weakSelf TouchNextBt:nil];
                }else{
                    [weakSelf.view showLoadingMeg:@"扫描失败，请重新扫描！" time:MESSAGE_SHOW_TIME];
                }
            }else{
                NSString *strBank = [result[@"result"][@"bank_card_number"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSLog(@"%@",result[@"result"][@"bank_name"]);
                    if (strBank.length) {
                        if ([result[@"result"][@"bank_card_type"] integerValue] == 1) {
//                            weakSelf.model.data.bankName = result[@"result"][@"bank_name"];
                            //判断银行卡
                            NSString *name =result[@"result"][@"bank_name"];
                            if ([name containsString:@"建设"]) {
                                weakSelf.model.data.bankName = @"中国建设银行";
                            }else if ([name containsString:@"招商"]){
                                weakSelf.model.data.bankName = @"招商银行";
                            }else if ([name containsString:@"兴业"]){
                                weakSelf.model.data.bankName = @"兴业银行";
                            }else{
                                GJAlertMessage *alert = [[GJAlertMessage alloc] initWithTitle:@"本平台工资卡绑定仅支持中国建设银行、招商银行或者兴业银行的银行卡，若没有此三种银行卡，请联系驻厂老师或者客服人员为您办理。"
                                                                                      message:nil
                                                                                textAlignment:NSTextAlignmentCenter
                                                                                 buttonTitles:@[@"确定"]
                                                                                 buttonsColor:@[[UIColor baseColor]]
                                                                      buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                                  buttonClick:^(NSInteger buttonIndex) {
                                                                                  }];
                                [alert show];
                                return ;
                            }
                            weakSelf.model.data.bankNumber = [RSAEncryptor encryptString:strBank publicKey:RSAPublickKey];

                            [weakSelf TouchNextBt:nil];
                        }else{
                            [weakSelf.view showLoadingMeg:@"工资卡必须为借记卡！" time:MESSAGE_SHOW_TIME];
                        }
                    }else{
                        [weakSelf.view showLoadingMeg:@"扫描失败，请重新扫描！" time:MESSAGE_SHOW_TIME];
                    }
            }
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
//        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
//            [weakSelf.view showLoadingMeg:msg time:MESSAGE_SHOW_TIME];
            
            if (error.code == 283602) {
                [weakSelf.view showLoadingMeg:@"手机时间与当前时间不符，请手动校准后重试！" time:MESSAGE_SHOW_TIME];
            }else{
                [weakSelf.view showLoadingMeg:@"扫描失败，请重新扫描！" time:MESSAGE_SHOW_TIME];
            }
            
        }];
    };
}

- (IBAction)bankCardOCROnline{
     #if !TARGET_IPHONE_SIMULATOR
    if ((self.IntStep == 1 && self.ClassType)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请进入设置-隐私-相机-中打开相机权限"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            return;
        }
        
        self.CardType = CardTypeIdCardFont;
        UIViewController * vc =
        [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                               Title:@""
                                     andImageHandler:^(UIImage *image) {
                                         [self requestQueryGetBiaduBankAccessToken:image];
                                         
//                                         [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
                                        
                                     }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ((self.ClassType == 1 && self.IntStep == 3) ||
              (self.ClassType == 2 && self.IntStep == 2) ||
              (self.ClassType == 3 && self.IntStep == 2)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请进入设置-隐私-相机-中打开相机权限"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            return;
        }
        
        self.CardType = CardTypeBankCard;
        UIViewController * vc =
        [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                               Title:@""
                                     andImageHandler:^(UIImage *image) {
                                         [self requestQueryGetBiaduBankAccessToken:image];

//                                         [[AipOcrService shardService] detectBankCardFromImage:image  successHandler:_successHandler failHandler:_failHandler];
                                         
                                     }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
     #endif
    
}


- (IBAction)touchBackBt:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    if (textField == self.phoneTextField) {
        //        self.CompanyTableView.hidden = !self.CompanyTableView.hidden;
        //        self.bgView.hidden = self.CompanyTableView.hidden;
        [self.nameTextField resignFirstResponder];
        [self.idcardTextField resignFirstResponder];
        [self.cardTextField resignFirstResponder];
        [self.phoneTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.BankNameField resignFirstResponder];
 
        [self.pickerView show];
        
        return NO;
    }
    if (textField == self.BankNameField) {
        //        self.CompanyTableView.hidden = !self.CompanyTableView.hidden;
        //        self.bgView.hidden = self.CompanyTableView.hidden;
        [self.nameTextField resignFirstResponder];
        [self.idcardTextField resignFirstResponder];
        [self.cardTextField resignFirstResponder];
        [self.phoneTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.BankNameField resignFirstResponder];
        self.durationView.titleString = @"请选择银行名称";
        self.durationView.typeArray = self.TypeArray;
        WEAK_SELF()
        self.durationView.block = ^(NSInteger index) {
            weakSelf.BankNameField.text = weakSelf.TypeArray[index];
            weakSelf.model.data.bankName = weakSelf.TypeArray[index];
        };
        self.durationView.hidden = NO;

        return NO;
    }
    return YES;
}


- (void)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 6;
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}



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
        return [self validateNumber:string];
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
        //        if (range.length == 1 && string.length == 0) {
        //            return YES;
        //        }
        //        //so easy
        //        else if (self.phoneTextField.text.length >= 11) {
        //            self.phoneTextField.text = [textField.text substringToIndex:11];
        //            return NO;
        //        }
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

- (BOOL)validateNumber:(NSString*)number

{
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789X"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
#pragma mark - request
-(void)requestSelectBindbankcard{
    [NetApiManager requestSelectBindbankcardWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPSelectBindbankcardModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



-(void)requestBindunbindBankcard{
    [self.nameTextField resignFirstResponder];
    [self.idcardTextField resignFirstResponder];
    [self.cardTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
//    NSString *identityNoString = [RSAEncryptor encryptString:self.model.data.identityNo publicKey:RSAPublickKey];
//    NSString *bankNumberString = [RSAEncryptor encryptString:self.model.data.bankNumber publicKey:RSAPublickKey];
    NSString *identityNoString = self.model.data.identityNo;
    NSString *bankNumberString = self.model.data.bankNumber;
    NSString *passwordString = [[NSString stringWithFormat:@"%@lanpin123.com",[self.passwordTextField.text md5]] md5];
    
    NSDictionary *dic ;
    if (self.ClassType == 1 ) {
        dic =  @{
                 @"userName":self.model.data.userName,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.model.data.openBankAddr,
                 @"moneyPassword":passwordString,
                 @"bankName":self.model.data.bankName,
                 @"type":@"1", //1绑定 2变更
                 };
    }
    else if (self.ClassType == 3  ){
        dic =  @{
                 @"userName":self.model.data.userName,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.model.data.openBankAddr,
                 @"bankName":self.model.data.bankName,
                 @"type":@"2", //1绑定 2变更
                 };
    }else if (self.ClassType == 2){
        dic =  @{
                 @"userName":self.model.data.userName,
                 @"identityNo":identityNoString,
                 @"bankNumber":bankNumberString,
                 @"openBankAddr":self.model.data.openBankAddr,
                 @"moneyPassword":passwordString,
                 @"bankName":self.model.data.bankName,
                 @"type":@"2", //1绑定 2变更
                 };
    }
    WEAK_SELF()
    [NetApiManager requestBindunbindBankcardWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                    if ([responseObject[@"data"][@"res_code"] integerValue] == 0) {
                        LPUserMaterialModel *userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
                        userMaterialModel.data.isBank = @"1";
                        [LPUserDefaults  saveObject:userMaterialModel byFileName:USERINFO];
                    
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 [weakSelf.view bringSubviewToFront:weakSelf.SucceedView];
                                weakSelf.SucceedView.hidden = NO;
//                            });
                            return ;
                    }else{
//                        [self.view showLoadingMeg:responseObject[@"data"][@"res_msg"] time:MESSAGE_SHOW_TIME];
                        if ([responseObject[@"data"][@"res_error_num"] integerValue]) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc] initWithTitle:[NSString stringWithFormat:@"您今日还剩%ld次绑定机会，请仔细核对您的信息！(%@)",(long)[responseObject[@"data"][@"res_error_num"] integerValue],responseObject[@"data"][@"res_msg"]]
                                                                                  message:nil
                                                                            textAlignment:NSTextAlignmentCenter
                                                                             buttonTitles:@[@"确定"]
                                                                             buttonsColor:@[[UIColor whiteColor]]
                                                                  buttonsBackgroundColors:@[[UIColor baseColor]]
                                                                              buttonClick:^(NSInteger buttonIndex) {
                                                                              }];
                            [alert show];
                        }else{
                            GJAlertMessage *alert = [[GJAlertMessage alloc] initWithTitle:responseObject[@"data"][@"res_msg"]
                                                                                  message:nil
                                                                            textAlignment:NSTextAlignmentCenter
                                                                             buttonTitles:@[@"确定"]
                                                                             buttonsColor:@[[UIColor whiteColor]]
                                                                  buttonsBackgroundColors:@[[UIColor baseColor]]
                                                                              buttonClick:^(NSInteger buttonIndex) {
                                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                                              }];
                            [alert show];
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

-(void)requestCardNOoccupy{
    NSString *identityNoString = [RSAEncryptor encryptString:self.idcardTextField.text publicKey:RSAPublickKey];
    NSDictionary *dic = @{@"identityNo":identityNoString};
    [NetApiManager requestCardNOoccupy:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 20026) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"msg"]
                                                                     message:nil
                                                               textAlignment:NSTextAlignmentCenter
                                                                buttonTitles:@[@"确定"]
                                                                buttonsColor:@[[UIColor blackColor]]
                                                     buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                 buttonClick:^(NSInteger buttonIndex) {
//                    if (buttonIndex) {
//                        self.IntStep++;
//                        [self UpdateHeadViewColor];
//                    }
                }];
                [alert show];
            }else{
                if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                    self.IntStep++;
                    [self UpdateHeadViewColor];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestUpdateDrawpwd{
    
    NSString *passwordmd5 = [self.passwordString md5];
    NSString *newpasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"oldPwd":newpasswordmd5,
                          };
    [NetApiManager requestUpdateDrawpwdWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"code"]) {
                if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                    self.IntStep++;
                    [self UpdateHeadViewColor];
                }else{
                    //                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                    
                    if (kUserDefaultsValue(ERRORTIMES)) {
                        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
                        NSString *d = [errorString substringToIndex:16];
                        //                        if ([d isEqualToString:string]) {
                        NSString *t = [errorString substringFromIndex:17];
                        NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
                        self.errorTimes = [t integerValue];
                        if ([t integerValue] >= 3&& [str integerValue] < 10) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试"
                                                                                 message:nil
                                                                           textAlignment:NSTextAlignmentCenter
                                                                            buttonTitles:@[@"确定"]
                                                                            buttonsColor:@[[UIColor baseColor]]
                                                                 buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                             buttonClick:^(NSInteger buttonIndex) {
                            }];
                            [alert show];
                        }else{
                            NSString *s = [NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes];
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:s
                                                                                 message:nil
                                                                           textAlignment:NSTextAlignmentCenter
                                                                            buttonTitles:@[@"取消",@"重试"]
                                                                            buttonsColor:@[[UIColor lightGrayColor],[UIColor baseColor]]
                                                                 buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                                                             buttonClick:^(NSInteger buttonIndex) {
                                                                                 if (buttonIndex == 0) {
                                                                                     [self.navigationController  popViewControllerAnimated:YES];
                                                                                 }
                                if (buttonIndex == 1) {
                                    [self TouchNextBt:nil];
                                }
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
                        NSString *s = [NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes];
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:s message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"取消",@"重试"] buttonsColor:@[[UIColor lightGrayColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                            if (buttonIndex == 0) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            if (buttonIndex == 1) {

                                [self TouchNextBt:nil];
                            }
                        }];
                        [alert show];
                        self.errorTimes += 1;
                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                        kUserDefaultsSave(str, ERRORTIMES);
                    }
                    //                    kUserDefaultsRemove(ERRORTIMES);
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetBiaduBankAccessToken:(UIImage *) Image{
    WEAK_SELF()
    [NetApiManager requestQueryGetBiaduBankAccessToken:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    [weakSelf requestQueryGetBiaduUserBankScan:Image Token:responseObject[@"data"]];
                }else{
                    [self.view showLoadingMeg:@"获取Token失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetBiaduUserBankScan:(UIImage *) Image Token:(NSString *) token{
    
    
    NSString *virValue = [DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd-HH-mm"];
    NSString *virValueData = [NSString stringWithFormat:@"%@-%@-lp",virValue,kUserDefaultsValue(LOGINID)];

    NSData *imageData = [self jpgDataWithImage:Image sizeLimit:512000];
    NSLog(@"imageData = %lu",(unsigned long)imageData.length);
    
    NSDictionary *dic = @{@"image":[imageData base64EncodedStringWithOptions:0],
                          @"id_card_side":@"front",
                          @"accessToken":[RSAEncryptor decryptString:token privateKey:RSAPrivateKey],
                          @"deviceType":@(1),
                          @"virValue":[RSAEncryptor encryptString:virValueData publicKey:RSAPublickKey]
                          };
    NSString * appendURLString = [NSString stringWithFormat:@"userbank/scan?type=%@",self.CardType == CardTypeIdCardFont?@"1":@"2"];

    WEAK_SELF()
    [NetApiManager requestQueryGetBiaduUserBankScan:dic  URLString:appendURLString withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [weakSelf.navigationController popViewControllerAnimated:YES];

            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"]) {
                    if (weakSelf.CardType == CardTypeIdCardFont) {      //身份证
                        
                        NSString *Identity = responseObject[@"data"][@"IdCard"][@"words"];
                        NSString *IdentityName = responseObject[@"data"][@"name"][@"words"];
                        
                        if (Identity.length || IdentityName.length ) {
                            weakSelf.model.data.identityNo =[RSAEncryptor encryptString:Identity publicKey:RSAPublickKey];
                            weakSelf.model.data.userName = IdentityName;
                            [weakSelf TouchNextBt:nil];
                        }else{
                            [weakSelf.view showLoadingMeg:@"扫描失败，请重新扫描！" time:MESSAGE_SHOW_TIME];
                        }
                    }else{
                        NSString *strBank = [responseObject[@"data"][@"result"][@"bank_card_number"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSLog(@"%@",strBank);
                        if (strBank.length) {
                            if ([responseObject[@"data"][@"result"][@"bank_card_type"] integerValue] == 1) {
                                //                            weakSelf.model.data.bankName = result[@"result"][@"bank_name"];
                                //判断银行卡
                                NSString *name =responseObject[@"data"][@"result"][@"bank_name"];
                                if ([name containsString:@"建设"]) {
                                    weakSelf.model.data.bankName = @"中国建设银行";
                                }else if ([name containsString:@"招商"]){
                                    weakSelf.model.data.bankName = @"招商银行";
                                }else if ([name containsString:@"兴业"]){
                                    weakSelf.model.data.bankName = @"兴业银行";
                                }else if ([name containsString:@"工商"]){
                                    weakSelf.model.data.bankName = @"中国工商银行";
                                }else if ([name containsString:@"农业"]){
                                    weakSelf.model.data.bankName = @"中国农业银行";
                                }else if ([name containsString:@"中国银行"]){
                                    weakSelf.model.data.bankName = @"中国银行";
                                }else if ([name containsString:@"交通"]){
                                    weakSelf.model.data.bankName = @"交通银行";
                                }else if ([name containsString:@"邮储"]){
                                    weakSelf.model.data.bankName = @"中国邮政储蓄银行";
                                }else if ([name containsString:@"光大"]){
                                    weakSelf.model.data.bankName = @"光大银行";
                                }else if ([name containsString:@"广发"]){
                                    weakSelf.model.data.bankName = @"广发银行";
                                }else if ([name containsString:@"平安"]){
                                    weakSelf.model.data.bankName = @"平安银行";
                                }else if ([name containsString:@"华夏"]){
                                    weakSelf.model.data.bankName = @"华夏银行";
                                }else if ([name containsString:@"浙商"]){
                                    weakSelf.model.data.bankName = @"浙商银行";
                                }else{
                                    GJAlertMessage *alert = [[GJAlertMessage alloc] initWithTitle:@"本平台工资卡绑定不支持该银行的银行卡！"
                                                                                          message:nil
                                                                                    textAlignment:NSTextAlignmentCenter
                                                                                     buttonTitles:@[@"确定"]
                                                                                     buttonsColor:@[[UIColor baseColor]]
                                                                          buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                                      buttonClick:^(NSInteger buttonIndex) {
                                                                                      }];
                                    [alert show];
                                    return ;
                                }
                                weakSelf.model.data.bankNumber = [RSAEncryptor encryptString:strBank publicKey:RSAPublickKey];
                                
                                [weakSelf TouchNextBt:nil];
                            }else{
                                [weakSelf.view showLoadingMeg:@"工资卡必须为借记卡！" time:MESSAGE_SHOW_TIME];
                            }
                        }else{
                            [weakSelf.view showLoadingMeg:@"扫描失败，请重新扫描！" time:MESSAGE_SHOW_TIME];
                        }
                    }
                }else{
                    [self.view showLoadingMeg:@"图像识别失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                if ([responseObject[@"code"] integerValue] == 10000 ||
                    [responseObject[@"code"] integerValue] == 20055 ||
                    [responseObject[@"code"] integerValue] == 10002 ||
                    [responseObject[@"code"] integerValue] == 10004 ) {
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }else{
                    if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                        [self.view showLoadingMeg:responseObject[@"data"][@"error_msg"] time:MESSAGE_SHOW_TIME];
                    }else{
                        [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                    }
                }
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(LPDurationView *)durationView{
    if (!_durationView) {
        _durationView = [[LPDurationView alloc]init];
    }
    return _durationView;
}

-(void)setModel:(LPSelectBindbankcardModel *)model{
    _model = model;
    if (model.data) {
         NSString *identityNoString = [RSAEncryptor decryptString:model.data.identityNo privateKey:RSAPrivateKey];
         NSString *bankNumberString = [RSAEncryptor decryptString:model.data.bankNumber privateKey:RSAPrivateKey];
        if (bankNumberString.length!=0) {           //换绑
            self.HeadTitleArr = @[@"工资卡信息",@"银行卡扫描",@"银行卡信息"];
            self.ClassType = 3;
        }
        else        //绑定
        {
            self.HeadTitleArr = @[@"身份证信息",@"银行卡扫描",@"银行卡信息",@"设置提现密码"];
            self.ClassType = 2;
        }
    }else{      //绑定
        self.HeadTitleArr = @[@"身份证扫描",@"身份证信息",@"银行卡扫描",@"银行卡信息",@"设置提现密码"];
        model.data = [LPSelectBindbankcardDataModel new];
        self.ClassType = 1;
    }
    [self setHeadView];

    [self UpdateContentView];

}
#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    NSString *strCity = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if ([province isEqualToString:strCity]) {
        NSString *CityStr = [NSString stringWithFormat:@"%@",city];
        self.phoneTextField.text = CityStr;
    }else{
        NSString *CityStr = [NSString stringWithFormat:@"%@%@",province,city];
        self.phoneTextField.text = CityStr;
    }
    
    [self.pickerView hide];
    
    //    [self btnClick:_addressBtn];
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:30 pickerViewHeight:276];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}



- (NSData *)jpgDataWithImage:(UIImage *)image sizeLimit:(NSUInteger)maxSize {
    CGFloat compressionQuality = 1.0;
    NSData *imageData = nil;
    
    int i = 0;
    do{
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
        compressionQuality -= 0.1;
        i += 1;
    }while(i < 3 && imageData.length > maxSize);
    return imageData;
}

@end
