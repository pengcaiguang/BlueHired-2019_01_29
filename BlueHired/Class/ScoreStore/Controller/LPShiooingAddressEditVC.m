//
//  LPShiooingAddressEditVC.m
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPShiooingAddressEditVC.h"
#import "AddressPickerView.h"


@interface LPShiooingAddressEditVC ()<AddressPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userTelTF;
@property (weak, nonatomic) IBOutlet UITextField *userAddressTF;
@property (weak, nonatomic) IBOutlet IQTextView *userAddressDetailsTV;
@property (weak, nonatomic) IBOutlet UIButton *SaveBtn;

@property (weak, nonatomic) IBOutlet UISwitch *DefaultSwitch;

@property (nonatomic ,strong) AddressPickerView * pickerView;

@property (nonatomic, strong) LPOrderAddressDataModel *model;


@end

@implementation LPShiooingAddressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑地址";
    [self.view addSubview:self.pickerView];

    if (self.Type == 1) {
        [self.SaveBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
    }else{
        [self.SaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    
    self.userNameTF.delegate = self;
    self.userTelTF.delegate = self;
    self.userAddressTF.delegate = self;
    self.userAddressDetailsTV.delegate = self;
    
    self.userAddressDetailsTV.textContainer.lineFragmentPadding = 0.0;
    self.userAddressDetailsTV.textContainerInset = UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, 0, 0);
    self.userAddressDetailsTV.placeholderTextColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    
    if (self.ListModel) {
        self.model = [LPOrderAddressDataModel mj_objectWithKeyValues:[self.ListModel mj_JSONObject]] ;

        [self initView];
    }else{
        self.model = [[LPOrderAddressDataModel alloc] init];
    }
 
}

- (void)initView{
    self.userNameTF.text = self.ListModel.name;
    self.userTelTF.text = self.ListModel.phone;
    self.userAddressDetailsTV.text = self.ListModel.detailAddress;
    
    NSString *strCity = [self.ListModel.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if ([self.ListModel.province isEqualToString:strCity]) {
        if ([self.ListModel.region isEqualToString:@"全市"]) {
            self.userAddressTF.text = [NSString stringWithFormat:@"%@",self.ListModel.city];
        }else{
            self.userAddressTF.text = [NSString stringWithFormat:@"%@%@",self.ListModel.city,self.ListModel.region];
        }
    }else{
        if ([self.ListModel.region isEqualToString:@"全市"]) {
            self.userAddressTF.text = [NSString stringWithFormat:@"%@%@",self.ListModel.province,self.ListModel.city];
        }else{
            self.userAddressTF.text = [NSString stringWithFormat:@"%@%@%@",self.ListModel.province,self.ListModel.city,self.ListModel.region];
        }
    }
    
    self.DefaultSwitch.on = self.ListModel.sendStatus.integerValue;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(TouchesRightBar)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#333333"]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(13),NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(13),NSFontAttributeName, nil] forState:UIControlStateSelected];
    
}

#pragma mark --Touches
-(void)TouchesRightBar{
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否删除该地址？" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#808080"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            [self requestDeleteOrderAddress];
        }
    }];
    [alert show];
    
}

- (IBAction)touchSave:(id)sender {

    self.userNameTF.text = [self.userNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.userTelTF.text = [self.userTelTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
 

    if (self.userNameTF.text.length<=0) {
        [self.view showLoadingMeg:@"请输入收货人姓名" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.userTelTF.text.length == 0) {
        [self.view showLoadingMeg:@"请输入收货人手机号" time:MESSAGE_SHOW_TIME];
        return;
    }

    if (![NSString isMobilePhoneNumber:self.userTelTF.text] && self.userTelTF.text.length!=0) {
        [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.userAddressTF.text.length<=0) {
        [self.view showLoadingMeg:@"请选择收货地址" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.userAddressDetailsTV.text.length<=0) {
        [self.view showLoadingMeg:@"请输入详细地址" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    self.model.name = self.userNameTF.text;
    self.model.phone = self.userTelTF.text;
    self.model.detailAddress = self.userAddressDetailsTV.text;
    self.model.sendStatus = self.DefaultSwitch.on ? @"1" : @"0";
    
    [self requestUpdateOrderAddress:self.model];
    
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    if (textField == self.userAddressTF ) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self.pickerView show];
        return NO;
        
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textField{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 50;
    
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

- (IBAction)fieldTextDidChange:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 12;
    if (textField == self.userNameTF) {
        kMaxLength = 6;
    }else if (textField == self.userTelTF){
        kMaxLength = 11;
    }
    
    
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


#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    NSString *strCity = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if ([province isEqualToString:strCity]) {
        if ([area isEqualToString:@"全市"]) {
            self.userAddressTF.text = [NSString stringWithFormat:@"%@",city];
        }else{
            self.userAddressTF.text = [NSString stringWithFormat:@"%@%@",city,area];
        }
    }else{
        if ([area isEqualToString:@"全市"]) {
            self.userAddressTF.text = [NSString stringWithFormat:@"%@%@",province,city];
        }else{
            self.userAddressTF.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        }
    }
    self.model.province = province;
    self.model.city = city;
    self.model.region = area;
    
    [self.pickerView hide];
    
    
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:30 pickerViewHeight:276];
        _pickerView.isShowArea = YES;
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}


#pragma mark - request
-(void)requestUpdateOrderAddress:(LPOrderAddressDataModel *) m{
    NSDictionary *dic = [m mj_JSONObject];
    [NetApiManager requestUpdateOrderAddress:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    if (m.sendStatus.integerValue == 1) {
                        for (LPOrderAddressDataModel *DataM in self.SuperVC.listArray) {
                            if (DataM.sendStatus.integerValue == 1) {
                                DataM.sendStatus = @"0";
                            }
                        }
                    }
                    if (self.ListModel) {   //修改
                        self.ListModel.name = m.name;
                        self.ListModel.phone = m.phone;
                        self.ListModel.province = m.province;
                        self.ListModel.city = m.city;
                        self.ListModel.region = m.region;
                        self.ListModel.detailAddress = m.detailAddress;
                        self.ListModel.sendStatus = m.sendStatus;
                         
                    }else{
                        m.id = responseObject[@"data"];
                        
                        [self.SuperVC.listArray insertObject:m atIndex: 0 ];
                        [self.SuperVC addNodataViewHidden:self.SuperVC.listArray.count == 0 ? NO : YES];
                    }
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
                    if (self.SuperVC.SelectModel && self.Type == 1) {
 
                        LPOrderAddressModel *OrderM = [[LPOrderAddressModel alloc] init];
                        OrderM.data = [[NSMutableArray alloc] initWithObjects:m, nil];
                        [self.SuperVC.SupreVC setAddressModel: OrderM];
                  
                        [self.navigationController popToViewController:self.SuperVC.SupreVC animated:YES];
                        return ;
                    }
                    [self.SuperVC.tableview reloadData];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                }else{
                    [self.view showLoadingMeg:@"保存失败,请稍后再试" time:MESSAGE_SHOW_TIME];

                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestDeleteOrderAddress{
    NSString *urlStr = [NSString stringWithFormat:@"order/del_address?addressId=%@",self.ListModel.id];
    [NetApiManager requestDeleteOrderAddress:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    [self.SuperVC.listArray removeObject:self.ListModel];
                    [self.SuperVC addNodataViewHidden:self.SuperVC.listArray.count == 0 ? NO : YES];
                    [self.SuperVC.tableview reloadData];
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                    [self.navigationController popViewControllerAnimated:YES];

                }else{
                    [self.view showLoadingMeg:@"删除失败,请稍后再试" time:MESSAGE_SHOW_TIME];

                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
