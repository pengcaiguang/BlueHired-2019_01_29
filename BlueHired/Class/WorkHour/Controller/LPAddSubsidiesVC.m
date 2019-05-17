//
//  LPAddSubsidiesVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/11.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAddSubsidiesVC.h"
#import "LPSubsidyDeductionVC.h"
#import "LPSubsidyModel.h"


@interface LPAddSubsidiesVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *View1;
@property (weak, nonatomic) IBOutlet UIView *View2;

@property (weak, nonatomic) IBOutlet UIButton *selectSubsidyBt;
@property (weak, nonatomic) IBOutlet UIButton *selectSubsidyBt2;

@property (weak, nonatomic) IBOutlet UITextField *TextField1;
@property (weak, nonatomic) IBOutlet UITextField *TextField2;

@property (weak, nonatomic) IBOutlet UITextField *TextField3;
@property (weak, nonatomic) IBOutlet UILabel *View2Label1;
@property (weak, nonatomic) IBOutlet UILabel *View2Label2;

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel2;

@property (weak, nonatomic) IBOutlet UILabel *View1Label1;
@property (weak, nonatomic) IBOutlet UILabel *View1Label2;

@property (nonatomic,strong) LPSubsidyModel *model;

@end

@implementation LPAddSubsidiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TextField1.delegate = self;
    self.TextField2.delegate = self;
    self.TextField3.delegate = self;
    self.TitleLabel1.text = @"";
    self.TitleLabel2.text = @"";
 
    if (self.row) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(butClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
    }
    if (self.ClassType == 0) {
        self.navigationItem.title = @"添加补贴记录";
        self.View1Label2.text = @"选择补贴类型";
        if (self.row) {
            NSArray *strArr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
            NSArray *typeArr = [strArr[self.row.integerValue] componentsSeparatedByString:@"-"];
            NSString *TypeName = typeArr[0];
            NSString *TypeMoney = typeArr[1];
            
            if ([TypeName isEqualToString:@"早班补贴"]||
                [TypeName isEqualToString:@"中班补贴"]||
                [TypeName isEqualToString:@"晚班补贴"]||
                [TypeName isEqualToString:@"白班补贴"]||
                [TypeName isEqualToString:@"夜班补贴"]) {
                self.View2.hidden = NO;
                self.View1.hidden = YES;
                self.View2Label1.text = [NSString stringWithFormat:@"%@金额(元/天)",TypeName];
                self.View2Label2.text = [NSString stringWithFormat:@"本月%@天数(天)",TypeName];
                [self.selectSubsidyBt setTitle:TypeName forState:UIControlStateNormal];
                [self requestQueryGetSubsidy];
                self.TitleLabel2.text = [NSString stringWithFormat:@"提示:请输入该企业%@金额以及本月%@天数",TypeName,TypeName];
                
            }else{
                self.View2.hidden = YES;
                self.View1.hidden = NO;
                [self.selectSubsidyBt2 setTitle:TypeName forState:UIControlStateNormal];
                self.TextField3.text = TypeMoney;
                self.TitleLabel1.text = [NSString stringWithFormat:@"提示:请输入该企业%@金额",TypeName];
                self.View1Label1.text = [NSString stringWithFormat:@"%@金额(元/月)",TypeName];
                
            }
            
        }else{
            self.View2.hidden = YES;
            self.View1.hidden = NO;
        }
    }else{
        self.navigationItem.title = @"添加扣款记录";
        self.View2.hidden = YES;
        self.View1.hidden = NO;
        self.View1Label2.text = @"选择扣款类型";
        self.View1Label1.text = @"金额(元/月)";
        self.TitleLabel1.text = @"";
        if (self.row) {
            NSArray *strArr = [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
            NSArray *typeArr = [strArr[self.row.integerValue] componentsSeparatedByString:@"-"];
            NSString *TypeName = typeArr[0];
            NSString *TypeMoney = typeArr[1];
            [self.selectSubsidyBt2 setTitle:TypeName forState:UIControlStateNormal];
            self.TextField3.text = TypeMoney;
        }
    }
    
    
    
   
    

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
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7 ? YES : NO;
}

- (IBAction)TouchSelectType:(id)sender {
    WEAK_SELF()
    LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
    vc.type = self.ClassType==0? 1:2;
    if (self.View2.hidden == NO) {              //班次补贴
        vc.TypeName = self.selectSubsidyBt.currentTitle;
    }else{
        vc.TypeName = self.selectSubsidyBt2.currentTitle;
    }
    vc.TypeArray = [ self.ClassType==0?self.WageDetailsModel.data.monthWage.subsidy:self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
//    vc.selectArray = weakSelf.deductionsArray;
    vc.block = ^(NSString *str) {
        
            if (self.ClassType == 0) {
                if ([str isEqualToString:@"早班补贴"]||
                    [str isEqualToString:@"中班补贴"]||
                    [str isEqualToString:@"晚班补贴"]||
                    [str isEqualToString:@"白班补贴"]||
                    [str isEqualToString:@"夜班补贴"]) {
                    weakSelf.View2.hidden = NO;
                    weakSelf.View1.hidden = YES;
                    [weakSelf.selectSubsidyBt setTitle:str forState:UIControlStateNormal];
                    weakSelf.View2Label1.text = [NSString stringWithFormat:@"%@金额(元/天)",str];
                    weakSelf.View2Label2.text = [NSString stringWithFormat:@"本月%@天数(天)",str];
                    if (weakSelf.row) {
                        [self requestQueryGetSubsidy];
                    }
                    self.TitleLabel2.text = [NSString stringWithFormat:@"提示:请输入该企业%@金额以及本月%@天数",str,str];
                }else{
                    weakSelf.View2.hidden = YES;
                    weakSelf.View1.hidden = NO;
                    [weakSelf.selectSubsidyBt2 setTitle:str forState:UIControlStateNormal];
                    self.TitleLabel1.text = [NSString stringWithFormat:@"提示:请输入该企业%@金额",str];
                    self.View1Label1.text = [NSString stringWithFormat:@"%@金额(元/月)",str];
                }
            }else{
                weakSelf.View2.hidden = YES;
                weakSelf.View1.hidden = NO;
                [weakSelf.selectSubsidyBt2 setTitle:str forState:UIControlStateNormal];
                self.TitleLabel1.text = [NSString stringWithFormat:@"提示：请输入%@金额",str];
            }

        
     };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)butClick{        //删除
//    [self requestQueryDeleteAccount];
    if (self.ClassType == 0) {
        NSArray *strArr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
        [self requestQueryDeteleOvertimeAddMonthWage:strArr[self.row.integerValue]];
    }else{
        NSArray *strArr = [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
        [self requestQueryDeteleOvertimeAddMonthWage:strArr[self.row.integerValue]];

    }
}

- (IBAction)SaveTouch:(id)sender {
    if (self.ClassType == 0) {
        if (self.View2.hidden == NO) {              //班次补贴
            if (self.selectSubsidyBt.currentTitle.length==0) {
                [self.view showLoadingMeg:@"请选择补贴类型" time:2.0];
                return;
            }
//            if (self.TextField1.text.floatValue==0.0) {
//                [self.view showLoadingMeg:@"请输入补贴金额" time:2.0];
//                return;
//            }
//            if (self.TextField2.text.floatValue==0.0) {
//                [self.view showLoadingMeg:@"请输入本月天数" time:2.0];
//                return;
//            }
            
            NSString *MoneyStr =[NSString stringWithFormat:@"%.2f",self.TextField1.text.floatValue*self.TextField2.text.floatValue];
            
            NSString *modelStr = [NSString stringWithFormat:@"%@-%@",self.selectSubsidyBt.currentTitle,MoneyStr];
            [self requestQueryGetOvertimeAddMonthWage:modelStr];
            
        }else{
            if (self.selectSubsidyBt2.currentTitle.length==0) {
                [self.view showLoadingMeg:@"请选择补贴类型" time:2.0];
                return;
            }
//            if (self.TextField3.text.floatValue==0.0) {
//                [self.view showLoadingMeg:@"请输入补贴金额" time:2.0];
//                return;
//            }
            
            NSString *modelStr = [NSString stringWithFormat:@"%@-%.2f",self.selectSubsidyBt2.currentTitle,self.TextField3.text.floatValue];
            [self requestQueryGetOvertimeAddMonthWage:modelStr];
            
        }
    }else{
        if (self.selectSubsidyBt2.currentTitle.length==0) {
            [self.view showLoadingMeg:@"请选择扣款类型" time:2.0];
            return;
        }
//        if (self.TextField3.text.floatValue==0.0) {
//            [self.view showLoadingMeg:@"请输入金额" time:2.0];
//            return;
//        }
        
        NSString *modelStr = [NSString stringWithFormat:@"%@-%.2f",self.selectSubsidyBt2.currentTitle,self.TextField3.text.floatValue];
        [self requestQueryGetOvertimeAddMonthWage:modelStr];
    }
    
    

    
}
- (void)setModel:(LPSubsidyModel *)model{
    _model = model;
    if (model.data) {
        self.TextField1.text = reviseString(model.data.subsidyMoney);
        self.TextField2.text = reviseString(model.data.subsidyDays);
    }
}



#pragma mark - request
-(void)requestQueryDeteleOvertimeAddMonthWage:(NSString *)str{
    WEAK_SELF()
    NSDictionary *dic;
    if (self.ClassType == 0) {
            dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                    @"type":@(self.WorkHourType),
                    @"time":self.KQDateString,
                    @"subsidy":str,
                    @"delStatus":@(1)
                    };
    }else{
        dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                @"type":@(self.WorkHourType),
                @"time":self.KQDateString,
                @"deductContent":str,
                @"delStatus":@(1)
                };
    }
    
    
    
    [NetApiManager requestQueryGetOvertimeAddMonthWage:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0){
                    [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
                    if (self.ClassType == 0) {
                        if (self.row) {
                            NSArray *strArr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
                            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:strArr];
                            [mutableArr removeObjectAtIndex:self.row.integerValue];
                            self.WageDetailsModel.data.monthWage.subsidy = [mutableArr componentsJoinedByString:@","];
                        }
                    }else{
                        if (self.row) {
                            NSArray *strArr = [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
                            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:strArr];
                            [mutableArr removeObjectAtIndex:self.row.integerValue];
                            self.WageDetailsModel.data.monthWage.deductContent = [mutableArr componentsJoinedByString:@","];
                        }
                    }
                    
                    
                    if (self.block) {
                        self.block();
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


#pragma mark - request
-(void)requestQueryGetOvertimeAddMonthWage:(NSString *)str{
    WEAK_SELF()
    NSDictionary *dic;
    if (self.ClassType == 0) {
        if (self.View2.hidden == NO) {              //班次补贴
            
            NSString *subsidyType = @"";
            if ([self.selectSubsidyBt.currentTitle isEqualToString:@"早班补贴"]) {
                subsidyType = @"1";
            }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"中班补贴"]){
                subsidyType = @"2";
            }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"晚班补贴"]){
                subsidyType = @"3";
            }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"白班补贴"]){
                subsidyType = @"4";
            }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"夜班补贴"]){
                subsidyType = @"5";
            }
            
            NSArray *strArr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
            NSString *perValue = @"";
            if (self.row) {
                perValue = strArr[self.row.integerValue];
            }
            
            dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                    @"type":@(self.WorkHourType),
                    @"time":self.KQDateString,
                    @"subsidy":str,
                    @"subsidyType":subsidyType,
                    @"subsidyMoney":[NSString stringWithFormat:@"%.2f",self.TextField1.text.floatValue],
                    @"subsidyDays":[NSString stringWithFormat:@"%ld",self.TextField2.text.integerValue],
                    @"perValue":perValue
                    };
        }else{
            NSArray *strArr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
            NSString *perValue = @"";
            if (self.row) {
                perValue = strArr[self.row.integerValue];
            }
            
            dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                    @"type":@(self.WorkHourType),
                    @"time":self.KQDateString,
                    @"subsidy":str,
                    @"perValue":perValue
                    };
        }
    }else{
        NSArray *strArr = [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
        NSString *perValue = @"";
        if (self.row) {
            perValue = strArr[self.row.integerValue];
        }
        dic = @{@"id":self.WageDetailsModel.data.monthWage.id?self.WageDetailsModel.data.monthWage.id:@"",
                @"type":@(self.WorkHourType),
                @"time":self.KQDateString,
                @"deductContent":str,
                @"perValue":perValue
                };
    }
    
    
    
    [NetApiManager requestQueryGetOvertimeAddMonthWage:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0){
                    [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
                    
                    if (!self.WageDetailsModel.data.monthWage.id) {
                        self.WageDetailsModel.data.monthWage.id = responseObject[@"data"];
                    }
                    
                    if (self.ClassType == 0) {
                        if (self.row) {
                            NSArray *strArr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
                            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:strArr];
                            mutableArr[self.row.integerValue] = str;
                            self.WageDetailsModel.data.monthWage.subsidy = [mutableArr componentsJoinedByString:@","];
                        }else{
                            if (self.WageDetailsModel.data.monthWage.subsidy.length == 0 ) {
                                self.WageDetailsModel.data.monthWage.subsidy = str;
                            }else {
                                NSString *modelStr = [NSString stringWithFormat:@"%@,%@", self.WageDetailsModel.data.monthWage.subsidy,str];
                                self.WageDetailsModel.data.monthWage.subsidy = modelStr;
                            }
                        }
                    }else{
                        if (self.row) {
                            NSArray *strArr = [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
                            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:strArr];
                            mutableArr[self.row.integerValue] = str;
                            self.WageDetailsModel.data.monthWage.deductContent = [mutableArr componentsJoinedByString:@","];
                        }else{
                            if (self.WageDetailsModel.data.monthWage.deductContent.length == 0 ) {
                                self.WageDetailsModel.data.monthWage.deductContent = str;
                
                            }else {
                                NSString *modelStr = [NSString stringWithFormat:@"%@,%@", self.WageDetailsModel.data.monthWage.deductContent,str];
                                self.WageDetailsModel.data.monthWage.deductContent = modelStr;
                            }
                        }
                    }
                    
                    
                    if (self.block) {
                        self.block();
                    }
                    //                self.WageDetailsModel = self.WageDetailsModel;
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

#pragma mark - request
-(void)requestQueryGetSubsidy{
         NSString *subsidyType = @"";
        if ([self.selectSubsidyBt.currentTitle isEqualToString:@"早班补贴"]) {
            subsidyType = @"1";
        }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"中班补贴"]){
            subsidyType = @"2";
        }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"晚班补贴"]){
            subsidyType = @"3";
        }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"白班补贴"]){
            subsidyType = @"4";
        }else if ([self.selectSubsidyBt.currentTitle isEqualToString:@"夜班补贴"]){
            subsidyType = @"5";
        }
    
    NSDictionary *dic = @{
                        @"id":reviseString( self.WageDetailsModel.data.monthWage.id),
                        @"type":subsidyType
                        };
    
    [NetApiManager requestQueryGetSubsidy:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPSubsidyModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
