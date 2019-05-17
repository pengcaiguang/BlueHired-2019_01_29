//
//  LPWorkHourBaseSalaryVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourBaseSalaryVC.h"
#import "LPBaseSalaryModel.h"

@interface LPWorkHourBaseSalaryVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *UnitLabel1;
@property (weak, nonatomic) IBOutlet UILabel *UnitLabel2;
@property (weak, nonatomic) IBOutlet UILabel *UnitLabel3;

@property (weak, nonatomic) IBOutlet UITextField *UnitTextField1;
@property (weak, nonatomic) IBOutlet UITextField *UnitTextField2;
@property (weak, nonatomic) IBOutlet UITextField *UnitTextField3;

@property (weak, nonatomic) IBOutlet UITextField *CountTextField1;
@property (weak, nonatomic) IBOutlet UITextField *CountTextField2;
@property (weak, nonatomic) IBOutlet UITextField *CountTextField3;

@property (weak, nonatomic) IBOutlet UITextField *BaseSalaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *SalaryUnitTextField;

@property (nonatomic,strong) UIView *ToolTextView;
@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *setdate;
@property (weak, nonatomic) IBOutlet UILabel *setdateTitel;
@property (weak, nonatomic) IBOutlet UIImageView *setdateImage;
@property (weak, nonatomic) IBOutlet UIView *setdateVline;

@property(nonatomic,strong) LPBaseSalaryModel *model;

@end

@implementation LPWorkHourBaseSalaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业底薪设置";
    
    self.UnitLabel1.text = @"正常加班单价\n(元/小时)";
    self.UnitLabel2.text = @"周末加班单价\n(元/小时)";
    self.UnitLabel3.text = @"节假日加班单价\n(元/小时)";
    
    [self setTextFieldView];
    [self setTextField];
    [self requestQueryGetHoursWorkBaseSalary];
    
    if (self.WorkHourType == 2) {
        self.setdate.hidden = YES;
        self.setdateTitel.hidden = YES;
        self.setdateImage.hidden = YES;
        self.setdateVline.hidden = YES;
    }else{
        self.setdate.hidden = NO;
        self.setdateTitel.hidden = NO;
        self.setdateImage.hidden = NO;
        self.setdateVline.hidden = NO;
    }
    [self.setdate setTitle:[DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

}


-(void)setTextField{
    self.UnitTextField1.layer.borderColor = [UIColor colorWithHexString:@"#00BD78"].CGColor;
    self.UnitTextField1.layer.cornerRadius = 2;
    self.UnitTextField1.layer.borderWidth = 0.5;
    self.UnitTextField2.layer.borderColor = [UIColor colorWithHexString:@"#3CAFFF"].CGColor;
    self.UnitTextField2.layer.cornerRadius = 2;
    self.UnitTextField2.layer.borderWidth = 0.5;
    self.UnitTextField3.layer.borderColor = [UIColor colorWithHexString:@"#8F6AFF"].CGColor;
    self.UnitTextField3.layer.cornerRadius = 2;
    self.UnitTextField3.layer.borderWidth = 0.5;
    
    self.CountTextField1.layer.borderColor = [UIColor colorWithHexString:@"#00BD78"].CGColor;
    self.CountTextField1.layer.cornerRadius = 2;
    self.CountTextField1.layer.borderWidth = 0.5;
    self.CountTextField2.layer.borderColor = [UIColor colorWithHexString:@"#3CAFFF"].CGColor;
    self.CountTextField2.layer.cornerRadius = 2;
    self.CountTextField2.layer.borderWidth = 0.5;
    self.CountTextField3.layer.borderColor = [UIColor colorWithHexString:@"#8F6AFF"].CGColor;
    self.CountTextField3.layer.cornerRadius = 2;
    self.CountTextField3.layer.borderWidth = 0.5;
    
    self.UnitTextField1.inputAccessoryView = self.ToolTextView;
    self.UnitTextField1.delegate = self;
    self.UnitTextField2.inputAccessoryView = self.ToolTextView;
    self.UnitTextField2.delegate = self;
    self.UnitTextField3.inputAccessoryView = self.ToolTextView;
    self.UnitTextField3.delegate = self;
    
    self.CountTextField1.inputAccessoryView = self.ToolTextView;
    self.CountTextField1.delegate = self;
    self.CountTextField2.inputAccessoryView = self.ToolTextView;
    self.CountTextField2.delegate = self;
    self.CountTextField3.inputAccessoryView = self.ToolTextView;
    self.CountTextField3.delegate = self;
    
    self.BaseSalaryTextField.inputAccessoryView = self.ToolTextView;
    self.BaseSalaryTextField.delegate = self;
    self.SalaryUnitTextField.inputAccessoryView = self.ToolTextView;
    self.SalaryUnitTextField.delegate = self;
}

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


#pragma mark - tagter
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    
    if (textField == self.UnitTextField1 ||
        textField == self.UnitTextField2 ||
        textField == self.UnitTextField3 ||
        textField == self.BaseSalaryTextField ||
        textField == self.SalaryUnitTextField) {
        NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        //匹配以0开头的数字
        NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
        //匹配两位小数、整数
        NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
        return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7? YES : NO;
    }else if (textField == self.CountTextField1 ||
              textField == self.CountTextField2 ||
              textField == self.CountTextField3){
        NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        //匹配以0开头的数字
        NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
        //匹配两位小数、整数
        NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
        return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=4? YES : NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.BaseSalaryTextField) {
        self.SalaryUnitTextField.text = [NSString stringWithFormat:@"%.2f",self.BaseSalaryTextField.text.floatValue/21.75/8];
        self.UnitTextField1.text = [NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue*self.CountTextField1.text.floatValue];
        self.UnitTextField2.text = [NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue*self.CountTextField2.text.floatValue];
        self.UnitTextField3.text = [NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue*self.CountTextField3.text.floatValue];
    }else if (textField == self.SalaryUnitTextField){
        self.UnitTextField1.text = [NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue*self.CountTextField1.text.floatValue];
        self.UnitTextField2.text = [NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue*self.CountTextField2.text.floatValue];
        self.UnitTextField3.text = [NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue*self.CountTextField3.text.floatValue];
    }else if (textField == self.UnitTextField1){
        if (self.SalaryUnitTextField.text.floatValue == 0.0) {
            [self.view showLoadingMeg:@"请设置工资单价" time:2.0];
            textField.text = @"0.0";
            return;
        }
        self.CountTextField1.text = [NSString stringWithFormat:@"%.2f",self.UnitTextField1.text.floatValue/self.SalaryUnitTextField.text.floatValue];
    }else if (textField == self.UnitTextField2){
        if (self.SalaryUnitTextField.text.floatValue == 0.0) {
            [self.view showLoadingMeg:@"请设置工资单价" time:2.0];
            textField.text = @"0.0";
            return;
        }
        self.CountTextField2.text = [NSString stringWithFormat:@"%.2f",self.UnitTextField2.text.floatValue/self.SalaryUnitTextField.text.floatValue];
    }else if (textField == self.UnitTextField3){
        if (self.SalaryUnitTextField.text.floatValue == 0.0) {
            [self.view showLoadingMeg:@"请设置工资单价" time:2.0];
            textField.text = @"0.0";
            return;
        }
        self.CountTextField3.text = [NSString stringWithFormat:@"%.2f",self.UnitTextField3.text.floatValue/self.SalaryUnitTextField.text.floatValue];
    }else if (textField == self.CountTextField1){
        self.UnitTextField1.text = [NSString stringWithFormat:@"%.2f",self.CountTextField1.text.floatValue*self.SalaryUnitTextField.text.floatValue];
    }else if (textField == self.CountTextField2){
        self.UnitTextField2.text = [NSString stringWithFormat:@"%.2f",self.CountTextField2.text.floatValue*self.SalaryUnitTextField.text.floatValue];
    }else if (textField == self.CountTextField3){
        self.UnitTextField3.text = [NSString stringWithFormat:@"%.2f",self.CountTextField3.text.floatValue*self.SalaryUnitTextField.text.floatValue];
    }
}




-(void)alertView:(NSInteger)index{
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
    confirmButton.tag = index;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBirthday:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self.popView addSubview:confirmButton];
    
 
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [DataTimeTool dateFromString:@"2000-01-01" DateFormat:@"yyyy-MM-dd"];
    _datePicker.maximumDate = [NSDate date];
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //    _datePicker.locale = [NSLocale systemLocale];
    _datePicker.date = [NSDate date];
    [self.popView addSubview:_datePicker];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        nil;
    }];
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
-(void)confirmBirthday:(UIButton *)sender{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    
    [_setdate setTitle:dateString forState:UIControlStateNormal];
 
    [self removeView];
}
- (IBAction)selectDateTouch:(UIButton *)sender {
    [self alertView:0];
}

- (IBAction)SaveTouch:(UIButton *)sender {
    if (self.SalaryUnitTextField.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请设置工资单价" time:2.0];
         return;
    }
    if (self.BaseSalaryTextField.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请设置企业底薪" time:2.0];
        return;
    }
    if (self.setdate.currentTitle.length== 0 && self.WorkHourType == 1) {
        [self.view showLoadingMeg:@"请设置生效日期" time:2.0];
        return;
    }
    
    if (self.UnitTextField1.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请设置正常加班单价" time:2.0];
        return;
    }
    
    if (self.UnitTextField2.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请设置周末加班单价" time:2.0];
        return;
    }
    
    if (self.UnitTextField3.text.floatValue == 0.0) {
        [self.view showLoadingMeg:@"请设置节假日加班单价" time:2.0];
        return;
    }
    
    
    
    [self requestQueryUpdateBaseSalary];
}

- (void)setModel:(LPBaseSalaryModel *)model
{
    _model = model;
    if (model.data.count) {
        self.BaseSalaryTextField.text = reviseString(model.data[0].salary);
        self.SalaryUnitTextField.text = reviseString(model.data[0].price);
        
        self.CountTextField1.text = reviseString(model.data[0].overtimeMultiples);
        self.CountTextField2.text = reviseString(model.data[0].weekendOvertimeMultiples);
        self.CountTextField3.text = reviseString(model.data[0].holidayOvertimeMultiples);
        
        self.UnitTextField1.text = reviseString(model.data[0].overtime);
        self.UnitTextField2.text = reviseString(model.data[0].weekendOvertime);
        self.UnitTextField3.text = reviseString(model.data[0].holidayOvertime);
        
        if (self.WorkHourType == 1) {
            NSArray *dateArr = [model.data[0].beginTime componentsSeparatedByString:@"#"];
            if ([dateArr[0] isEqualToString:@"2000-01-01"]) {
                [self.setdate setTitle:[DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            }else{
                [self.setdate setTitle:dateArr[0] forState:UIControlStateNormal];
            }
        }
    }else{
        self.setdate.hidden = YES;
        self.setdateTitel.hidden = YES;
        self.setdateImage.hidden = YES;
        self.setdateVline.hidden = YES;
    }
}

#pragma mark - request
-(void)requestQueryUpdateBaseSalary{
    NSDictionary *dic;
    
    if (self.WorkHourType == 2) {
        dic = @{
                @"id":self.model.data.count?self.model.data[0].id:@"",
                @"salary":[NSString stringWithFormat:@"%.2f",self.BaseSalaryTextField.text.floatValue],
                @"price":[NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue],
                @"overtimeMultiples":[NSString stringWithFormat:@"%.2f",self.CountTextField1.text.floatValue],
                @"overtime":[NSString stringWithFormat:@"%.2f",self.UnitTextField1.text.floatValue],
                @"weekendOvertimeMultiples":[NSString stringWithFormat:@"%.2f",self.CountTextField2.text.floatValue],
                @"weekendOvertime":[NSString stringWithFormat:@"%.2f",self.UnitTextField2.text.floatValue],
                @"holidayOvertimeMultiples":[NSString stringWithFormat:@"%.2f",self.CountTextField3.text.floatValue],
                @"holidayOvertime":[NSString stringWithFormat:@"%.2f",self.UnitTextField3.text.floatValue],
                @"type":@(self.WorkHourType),
                };
    }else{
        dic = @{
                @"id":self.model.data.count?self.model.data[0].id:@"",
                @"salary":[NSString stringWithFormat:@"%.2f",self.BaseSalaryTextField.text.floatValue],
                @"price":[NSString stringWithFormat:@"%.2f",self.SalaryUnitTextField.text.floatValue],
                @"overtimeMultiples":[NSString stringWithFormat:@"%.2f",self.CountTextField1.text.floatValue],
                @"overtime":[NSString stringWithFormat:@"%.2f",self.UnitTextField1.text.floatValue],
                @"weekendOvertimeMultiples":[NSString stringWithFormat:@"%.2f",self.CountTextField2.text.floatValue],
                @"weekendOvertime":[NSString stringWithFormat:@"%.2f",self.UnitTextField2.text.floatValue],
                @"holidayOvertimeMultiples":[NSString stringWithFormat:@"%.2f",self.CountTextField3.text.floatValue],
                @"holidayOvertime":[NSString stringWithFormat:@"%.2f",self.UnitTextField3.text.floatValue],
                @"beginTime":self.setdate.currentTitle,
                @"type":@(self.WorkHourType),
                };
    }
    
    [NetApiManager requestQueryUpdateBaseSalary:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1){
                    [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
                    if (self.Block) {
                        self.Block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.view showLoadingMeg:@"保存失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}

-(void)requestQueryGetHoursWorkBaseSalary{
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"status":@(1),
                          };
    [NetApiManager requestQueryGetHoursWorkBaseSalary:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPBaseSalaryModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
