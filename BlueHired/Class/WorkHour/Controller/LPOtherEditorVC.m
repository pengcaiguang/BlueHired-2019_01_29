//
//  LPOtherEditorVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPOtherEditorVC.h"

@interface LPOtherEditorVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *MoneyTF;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_TopViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *TopViewTitle;
@property (weak, nonatomic) IBOutlet UISwitch *TopViewSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *TextFieldImage;

@end

@implementation LPOtherEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.ClassType == 1) {
        self.navigationItem.title  = @"企业底薪编辑";
        self.TitleLabel.text = @"企业底薪(元/月)";
        self.TopViewTitle.text = @"获取企业底薪";
        self.LayoutConstraint_TopViewHeight.constant = 47;
        if (self.WageDetailsModel.data.monthWage.autoSalaryStatus.integerValue == 0) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoSalary);
            self.TopViewSwitch.on = YES;
            self.MoneyTF.enabled = NO;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(0);
            }];
            self.TitleLabel2.text = @"提示:当前获取的是您已设置好的企业底薪";
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.salary);
            self.TopViewSwitch.on = NO;
            self.MoneyTF.enabled = YES;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(16);
            }];
            self.TitleLabel2.text = @"提示:请自定义输入您本月的企业底薪";
        }
    }else if (self.ClassType == 2){
        self.navigationItem.title  = @"加班工资编辑";
        self.TitleLabel.text = @"加班工资合计(元)";
        self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary);
        self.LayoutConstraint_TopViewHeight.constant = 47;
        self.TopViewTitle.text = @"获取加班工资";
        if (self.WageDetailsModel.data.monthWage.autoOvertimeSalaryStatus.integerValue == 0) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoOvertimeSalary);
            self.TopViewSwitch.on = YES;
            self.MoneyTF.enabled = NO;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(0);
            }];
            self.TitleLabel2.text = @"提示:当前显示的加班工资是根据您记录的加班数据计算得出的";
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary);
            self.TopViewSwitch.on = NO;
            self.MoneyTF.enabled = YES;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(16);
            }];
            self.TitleLabel2.text = @"提示:请自定义输入您本月的加班工资";
        }

    }else if (self.ClassType == 3){
        self.navigationItem.title  = @"公积金编辑";
        self.TitleLabel.text = @"公积金编辑(元/月)";
        self.TitleLabel2.text = @"提示:请输入您需要缴纳的公积金金额";
//        NSArray *strArr = [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//        NSArray *typeArr = [strArr[self.row] componentsSeparatedByString:@"-"];
        NSString *TypeMoney = self.WageDetailsModel.data.monthWage.reserve;
        self.MoneyTF.text =  reviseString(TypeMoney);
        self.LayoutConstraint_TopViewHeight.constant = 0;

    }else if (self.ClassType == 4){
        self.navigationItem.title  = @"社保编辑";
        self.TitleLabel.text = @"社保金额(元/月)";
        self.TitleLabel2.text = @"提示:请输入您需要缴纳的社保金额";
//        NSArray *strArr = [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//        NSArray *typeArr = [strArr[self.row] componentsSeparatedByString:@"-"];
        NSString *TypeMoney = self.WageDetailsModel.data.monthWage.socialInsurance;
        self.MoneyTF.text =  reviseString(TypeMoney);
        self.LayoutConstraint_TopViewHeight.constant = 0;
    }else if (self.ClassType == 5){
        self.navigationItem.title  = @"所得税编辑";
        self.TitleLabel.text = @"个人所得税合计(元)";
        self.TopViewTitle.text = @"自动计算个人所得税";
        self.TitleLabel2.text = @"提示:请自定义输入您的个人所得税";
//        NSArray *strArr = [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//        NSArray *typeArr = [strArr[self.row] componentsSeparatedByString:@"-"];
        NSString *TypeMoney = self.WageDetailsModel.data.monthWage.personalTax;
        self.MoneyTF.text =  reviseString(TypeMoney);
        self.LayoutConstraint_TopViewHeight.constant = 47;
        
        if (self.WageDetailsModel.data.monthWage.taxStatus.integerValue == 0) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoPersonalTax);
            self.TopViewSwitch.on = YES;
            self.MoneyTF.enabled = NO;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(0);
            }];
            self.TitleLabel2.text = @"提示:当前显示的个人所得税是按照最新税法计算得出的";
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.personalTax);
            self.TopViewSwitch.on = NO;
            self.MoneyTF.enabled = YES;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(16);
            }];
            self.TitleLabel2.text = @"提示:请自定义输入您的个人所得税";
        }
        
    }else if (self.ClassType == 6){
        self.navigationItem.title  = @"工作工资编辑";
        self.TitleLabel.text = @"工作工资合计(元)";
        self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary);
        self.LayoutConstraint_TopViewHeight.constant = 47;
        self.TopViewTitle.text = @"获取工作工资";
        if (self.WageDetailsModel.data.monthWage.autoOvertimeSalaryStatus.integerValue == 0) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoOvertimeSalary);
            self.TopViewSwitch.on = YES;
            self.MoneyTF.enabled = NO;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(0);
            }];
            self.TitleLabel2.text = @"提示:当前显示的工作工资是根据您记录的加班数据计算得出的";
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary);
            self.TopViewSwitch.on = NO;
            self.MoneyTF.enabled = YES;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(16);
            }];
            self.TitleLabel2.text = @"提示:请自定义输入您本月的工作工资";
        }
        
    }else if (self.ClassType == 7){
        self.navigationItem.title  = @"计件工资编辑";
        self.TitleLabel.text = @"计件工资合计(元)";
        self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary);
        self.LayoutConstraint_TopViewHeight.constant = 47;
        self.TopViewTitle.text = @"获取计件工资";
        if (self.WageDetailsModel.data.monthWage.autoOvertimeSalaryStatus.integerValue == 0) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoOvertimeSalary);
            self.TopViewSwitch.on = YES;
            self.MoneyTF.enabled = NO;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(0);
            }];
            self.TitleLabel2.text = @"提示:当前显示的计件工资是根据您记录的计件信息计算得出的";
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary);
            self.TopViewSwitch.on = NO;
            self.MoneyTF.enabled = YES;
            [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
                make.width.mas_offset(16);
            }];
            self.TitleLabel2.text = @"提示:请自定义输入您本月的计件工资";
        }
    }
    
    self.MoneyTF.delegate = self;
    
}

- (IBAction)TouchSwitch:(UISwitch *)sender {
    sender.on = !sender.on;
    if (self.ClassType == 1) {
        if (sender.on) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoSalary);
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.salary);
         }
    }else if (self.ClassType == 5){
        if (sender.on) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoPersonalTax);
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.personalTax);
        }
    } else{
        if (sender.on) {
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.autoOvertimeSalary);
        }else{
            self.MoneyTF.text =  reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary);
        }
    }
    
    [self.TextFieldImage mas_updateConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(sender.isOn?0:16);
    }];
    if (self.ClassType == 1) {
        self.TitleLabel2.text = sender.isOn?@"提示:当前获取的是您已设置好的企业底薪":@"提示:请自定义输入您本月的企业底薪";
    }else if (self.ClassType == 2){
        self.TitleLabel2.text = sender.isOn?@"提示:当前显示的加班工资是根据您记录的加班数据计算得出的":@"提示:请自定义输入您本月的加班工资";
    }else if (self.ClassType == 6){
        self.TitleLabel2.text = sender.isOn?@"提示:当前显示的工作工资是根据您记录的加班数据计算得出的":@"提示:请自定义输入您本月的工作工资";
    }else if (self.ClassType == 7){
        self.TitleLabel2.text = sender.isOn?@"提示:当前显示的计件工资是根据您记录的计件信息计算得出的":@"提示:请自定义输入您本月的计件工资";
    }else if (self.ClassType == 5){
        self.TitleLabel2.text = sender.isOn?@"提示:当前显示的个人所得税是按照最新税法计算得出的":@"提示:请自定义输入您的个人所得税";
    }
    
    self.MoneyTF.enabled = !sender.on;

}

-(void)butClick:(UIButton *)sender{
    NSString *str2 = @"";
    if ( self.ClassType == 2 || self.ClassType == 6 ||self.ClassType == 7) {
        str2 =reviseString(self.WageDetailsModel.data.monthWage.autoOvertimeSalary);
    }else{
        str2 =reviseString(self.WageDetailsModel.data.monthWage.autoSalary);
    }

    NSString *str1 = [NSString stringWithFormat:@"获取到设置中心企业底薪为 %@ ,是否修改?",str2];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    //设置：在3~length-3个单位长度内的内容显示成橙色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[str1 rangeOfString:str2]];
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            self.MoneyTF.text = @"0";
            [self requestQueryGetOvertimeAddMonthWage];
//            [self requestQuerySetHoursWorkYset];
        }
    }];
    [alert show];
}

#pragma mark - tagter
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
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7? YES : NO;
}

- (IBAction)SaveTouch:(id)sender {
//    if (self.MoneyTF.text.floatValue == 0.0 &&
//        (self.ClassType == 1 ||
//        self.ClassType == 2 ||
//        self.ClassType == 6  )) {
//        if (self.ClassType == 1) {
//            [self.view showLoadingMeg:@"请输入企业底薪" time:2.0];
//        }else if (self.ClassType == 2){
//            [self.view showLoadingMeg:@"请输入加班工资" time:2.0];
//        }else if (self.ClassType == 6){
//            [self.view showLoadingMeg:@"请输入工作工资" time:2.0];
//        }else if (self.ClassType == 7){
//            [self.view showLoadingMeg:@"请输入计件工资" time:2.0];
//        }
//        return;
//    }
    
    if (self.WorkHourType == 1  || self.WorkHourType == 2) {
        if (self.MoneyTF.text.floatValue == 0.0) {
            if (self.ClassType == 1&& !self.TopViewSwitch.on) {
                [self.view showLoadingMeg:@"请输入企业底薪" time:2.0];
                return;
            }
            if (self.ClassType == 2&& !self.TopViewSwitch.on) {
                [self.view showLoadingMeg:@"请输入加班工资" time:2.0];
                return;
            }
        }
    }else if (self.WorkHourType == 3) {
        if (self.MoneyTF.text.floatValue == 0.0 && !self.TopViewSwitch.on) {
            if (self.ClassType == 6) {
                [self.view showLoadingMeg:@"请输入工作工资" time:2.0];
                return;
            }
        }
    }else if (self.WorkHourType == 4){
        if (self.MoneyTF.text.floatValue == 0.0 && !self.TopViewSwitch.on) {
            if (self.ClassType == 1) {
                [self.view showLoadingMeg:@"请输入企业底薪" time:2.0];
                return;
            }
            if (self.ClassType == 7) {
                [self.view showLoadingMeg:@"请输入计件工资" time:2.0];
                return;
            }
        }
    }
    
 
    
    [self requestQueryGetOvertimeAddMonthWage];
}


-(void)requestQueryGetOvertimeAddMonthWage{
    NSDictionary  *dic;
    if (self.ClassType == 1) {
        dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                @"type":@(self.WorkHourType),
                @"time":self.KQDateString,
                @"salary": self.TopViewSwitch.on?@"0":[NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue]
                };
    }else if (self.ClassType == 2 || self.ClassType == 6 ||self.ClassType == 7){
        dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                @"type":@(self.WorkHourType),
                @"time":self.KQDateString,
                @"overtimeSalary":self.TopViewSwitch.on?@"0":[NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue]
                };
    }else if (self.ClassType == 3){         //公积金
        dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                @"type":@(self.WorkHourType),
                @"time":self.KQDateString,
                @"reserve":[NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue]
                };
    }else if (self.ClassType == 4){     //社保
        dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                @"type":@(self.WorkHourType),
                @"time":self.KQDateString,
                @"socialInsurance":[NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue]
                };
    }else if (self.ClassType == 5){     //个人所得税-
        if (self.TopViewSwitch.isOn) {
            dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                    @"type":@(self.WorkHourType),
                    @"time":self.KQDateString,
//                    @"personalTax":[NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue],
                    @"taxStatus":@(0)
                    };
        }else{
            dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                    @"type":@(self.WorkHourType),
                    @"time":self.KQDateString,
                    @"personalTax":[NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue],
                    @"taxStatus":@(1)
                    };
        }
        
    }


    WEAK_SELF();
    [NetApiManager requestQueryGetOvertimeAddMonthWage:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0){
                    if (!self.WageDetailsModel.data.monthWage.id) {
                        self.WageDetailsModel.data.monthWage.id = responseObject[@"data"];
                    }
                    if (self.ClassType == 1) {
                        if (self.TopViewSwitch.on) {
                            self.WageDetailsModel.data.monthWage.salary =  self.WageDetailsModel.data.monthWage.autoSalary;
                            self.WageDetailsModel.data.monthWage.autoSalaryStatus = @"0";
                        }else{
                            self.WageDetailsModel.data.monthWage.salary = [NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue];
                            self.WageDetailsModel.data.monthWage.autoSalaryStatus = @"1";
                        }
                    }else if (self.ClassType == 2 || self.ClassType == 6 ||self.ClassType == 7){
                        if (self.TopViewSwitch.on) {
                            self.WageDetailsModel.data.monthWage.overtimeSalary = self.WageDetailsModel.data.monthWage.autoOvertimeSalary;
                            self.WageDetailsModel.data.monthWage.autoOvertimeSalaryStatus = @"0";
                        }else{
                            self.WageDetailsModel.data.monthWage.overtimeSalary = [NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue];
                            self.WageDetailsModel.data.monthWage.autoOvertimeSalaryStatus = @"1";
                        }
                    }else if (self.ClassType == 3){
//                        NSArray *strArr = [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:strArr];
//                        mutableArr[self.row] = [NSString stringWithFormat:@"公积金-%.2f",self.MoneyTF.text.floatValue];
                        self.WageDetailsModel.data.monthWage.reserve = [NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue];
                    }else if (self.ClassType == 4){
//                        NSArray *strArr = [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:strArr];
//                        mutableArr[self.row] = [NSString stringWithFormat:@"社保-%.2f",self.MoneyTF.text.floatValue];
                        self.WageDetailsModel.data.monthWage.socialInsurance = [NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue];
                    }else if (self.ClassType == 5){
//                        NSArray *strArr = [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:strArr];
//                        mutableArr[self.row] = [NSString stringWithFormat:@"个人所得税-%.2f",self.MoneyTF.text.floatValue];
                        if (self.TopViewSwitch.on) {
                            self.WageDetailsModel.data.monthWage.taxStatus = @"0";
//                            self.WageDetailsModel.data.monthWage.personalTax = [NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue];
                        }else{
                            self.WageDetailsModel.data.monthWage.taxStatus = @"1";
                            self.WageDetailsModel.data.monthWage.personalTax = [NSString stringWithFormat:@"%.2f",self.MoneyTF.text.floatValue];
                        }
                    }
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    if (self.block) {
                        self.block();
                    }
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"保存失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}

@end
