//
//  LPRapidInductionVC.m
//  BlueHired
//
//  Created by iMac on 2020/1/6.
//  Copyright © 2020 lanpin. All rights reserved.
//

#import "LPRapidInductionVC.h"
#import "AddressPickerView.h"

@interface LPRapidInductionVC ()<AddressPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *inductionTF;
@property (weak, nonatomic) IBOutlet UITextField *wageTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UIView *SuccessView;

@property(nonatomic,strong) NSString *nianxian;

@property(nonatomic,strong) NSString *xinzi;

@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic ,strong) AddressPickerView *AddpickerView;

@property(nonatomic,strong) NSArray *pickerArray;
@property(nonatomic,assign) NSInteger selectIndex;


@end

@implementation LPRapidInductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快速入职";
    [self.inductionTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.AddpickerView];

}
- (IBAction)TouchTB:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if (sender.tag == 1000) {   //期望地址
        [self.AddpickerView show];
    }else if (sender.tag == 1001){      //期望薪资
        [self alertView:6];
    }else if (sender.tag == 1002){      //年龄
        [self alertView:5];
    }else if (sender.tag == 1003){      //性别
        [self selectUserSex];
    }else if (sender.tag == 1004){      //提交
        self.inductionTF.text = [self.inductionTF.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (self.addressTF.text.length == 0 ) {
            [self.view showLoadingMeg:@"请选择期望地址" time:MESSAGE_SHOW_TIME];
            return;
        }
        if (self.inductionTF.text.length == 0) {
            [self.view showLoadingMeg:@"请输入期望职位" time:MESSAGE_SHOW_TIME];
            return;
        }
        [self requestInsertquickWrok];
    }else if (sender.tag == 1005){      //确定
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)textFieldChanged:(UITextField *)textField
{
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    static int kMaxLength = 10;
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


-(void)selectUserSex{
    UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *Alert1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text = @"男";
    }];
    UIAlertAction *Alert2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text = @"女";
    }];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"取  消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [AlertController addAction:Alert1];
    [AlertController addAction:Alert2];
    [AlertController addAction:Cancel];
    
    [self presentViewController:AlertController animated:YES completion:^{}];
}



#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.AddpickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    NSString *strCity = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if ([province isEqualToString:strCity]) {
        if ([area isEqualToString:@"全市"]) {
            self.addressTF.text = [NSString stringWithFormat:@"%@",city];
        }else{
            self.addressTF.text = [NSString stringWithFormat:@"%@%@",city,area];
        }
    }else{
        if ([area isEqualToString:@"全市"]) {
            self.addressTF.text = [NSString stringWithFormat:@"%@%@",province,city];
        }else{
            self.addressTF.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        }
    }
    
    
    [self.AddpickerView hide];
    
    
}


- (AddressPickerView *)AddpickerView{
    if (!_AddpickerView) {
        _AddpickerView = [[AddressPickerView alloc]init];
        _AddpickerView.delegate = self;
        [_AddpickerView setTitleHeight:30 pickerViewHeight:276];
        _AddpickerView.isShowArea = YES;
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _AddpickerView;
}


 -(void)alertView:(NSInteger)index{
     self.selectIndex = index;
     self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
     self.bgView.backgroundColor = [UIColor lightGrayColor];
     self.bgView.alpha = 0;
     [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
     
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
     [self.bgView addGestureRecognizer:tap];
     
     self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
     self.popView.backgroundColor = [UIColor whiteColor];
     [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
     
     UILabel *label = [[UILabel alloc]init];
     label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
     label.font = [UIFont systemFontOfSize:16];
     label.textAlignment = NSTextAlignmentCenter;
 //    [self.popView addSubview:label];
     
     UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,  10, SCREEN_WIDTH/2, 20)];
     cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
     [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
     [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
     cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
     [self.popView addSubview:cancelButton];
     
     UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,  10, SCREEN_WIDTH/2, 20)];
     confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
     [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
     [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
     [confirmButton addTarget:self action:@selector(confirmBirthday) forControlEvents:UIControlEventTouchUpInside];
     confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
     [self.popView addSubview:confirmButton];
     
   if (index == 5 || index == 6){
         UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
         pickerView.backgroundColor = [UIColor whiteColor];
         pickerView.delegate = self;
         pickerView.dataSource = self;
         [self.popView addSubview:pickerView];
         self.pickerView = pickerView;
         
         if (index == 5){
             label.text = @"年龄";
             self.pickerArray = @[@"18-25",@"25-35",@"35-45",@"45以上"];
             self.nianxian = self.pickerArray[0];

         }else if (index == 6){
             label.text = @"期望薪资(月薪，单位：千元)";
             self.pickerArray = @[@"3k~4k",@"4k~5k",@"5k~6k",@"6k~7k",@"7k~8k",@"8k~9k",@"9k~10k",@"10+k"];
             self.xinzi = self.pickerArray[0];
         }
         [self.pickerView reloadAllComponents];
     }
     
     [UIView animateWithDuration:0.5 animations:^{
         self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
         self.bgView.alpha = 0.3;
     } completion:^(BOOL finished) {
         nil;
     }];
 }



-(void)confirmBirthday{
     
    if(self.selectIndex == 5){
        self.ageTF.text = self.nianxian;
    }else if(self.selectIndex == 6){
        self.wageTF.text = self.xinzi;
    }
    
    [self removeView];
   
}

-(void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self.bgView removeFromSuperview];
        
    }];
}


#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerArray count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
 
       
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = [self.pickerArray objectAtIndex:row];
    [view addSubview:text];
   
    //隐藏上下直线
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    return view;
}
//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [self.pickerArray objectAtIndex:row];
    return str;
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [self.pickerArray objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.selectIndex == 5){
        self.nianxian = self.pickerArray[row];
    }else if (self.selectIndex == 6){
        self.xinzi = self.pickerArray[row];
    }
}

#pragma mark - request
-(void)requestInsertquickWrok{
    //"1"//性别 1男 2女

    NSString *sexStr = @"0";
    if (self.sexTF.text.length) {
        if ([self.sexTF.text isEqualToString:@"男"]) {
            sexStr = @"1";
        }else{
            sexStr = @"2";
        }
        
    }
           
    NSDictionary *dic = @{@"workAddress":self.addressTF.text,
                          @"workPost":self.inductionTF.text,
                          @"workWage":self.wageTF.text,
                          @"age":self.ageTF.text,
                          @"sex":sexStr
    };
    
 
     
    
    [NetApiManager requestInsertquickWrok:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    self.SuccessView.hidden = NO;
                }else{
                    [self.view showLoadingMeg:responseObject[@"提交失败,稍后再试"] time:MESSAGE_SHOW_TIME];
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
