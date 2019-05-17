//
//  LPWorkdaySetVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkdaySetVC.h"
#import "LPWorkHourYsetModel.h"

@interface LPWorkdaySetVC ()
@property (weak, nonatomic) IBOutlet UIButton *SaveBT;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;
@property (weak, nonatomic) IBOutlet UIButton *setdate;
@property (weak, nonatomic) IBOutlet UIView *setdateView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIView *WeekView;
@property (nonatomic,strong) LPWorkHourYsetModel *model;



@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIDatePicker *datePicker;
@end

@implementation LPWorkdaySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SaveBT.layer.cornerRadius = 4;
    self.cancelBT.layer.cornerRadius = 4;
    self.cancelBT.layer.borderWidth = 1;
    self.cancelBT.layer.borderColor= [UIColor baseColor].CGColor;

    self.navigationItem.title = @"正常工作日设置";
    
    [self requestQueryGetHoursWorkYset];
    
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
    _datePicker.minimumDate = [DataTimeTool dateFromString:@"2010-01-01" DateFormat:@"yyyy-MM-dd"];
    _datePicker.maximumDate = [NSDate date];
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //    _datePicker.locale = [NSLocale systemLocale];
//    _datePicker.date = [NSDate date];
    if (self.setdate.currentTitle.length==0) {
        _datePicker.date = [NSDate date];
    }else{
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //NSString转NSDate
        NSDate *date=[formatter dateFromString:self.setdate.currentTitle];
        _datePicker.date = date;
    }
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

- (IBAction)selectWeekTouch:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSArray *OverTimeArr = [self.model.data.overtimeMul componentsSeparatedByString:@"#"];
    NSArray *weekendArr = [self.model.data.weekendMul componentsSeparatedByString:@"#"];
    UILabel *MulLabel = [self.WeekView viewWithTag:2000+sender.tag];
    UILabel *MoneyLabel = [self.WeekView viewWithTag:1000+sender.tag];
    
    if (sender.selected) {
        MulLabel.text = [NSString stringWithFormat:@"%@倍工资",OverTimeArr[1]];
        MoneyLabel.text = [NSString stringWithFormat:@"%@元/小时",OverTimeArr[0]];
    }else{
        MulLabel.text = [NSString stringWithFormat:@"%@倍工资",weekendArr[1]];
        MoneyLabel.text = [NSString stringWithFormat:@"%@元/小时",weekendArr[0]];
    }
    
}

- (IBAction)SaveTouch:(UIButton *)sender {
    if (self.setdate.currentTitle.length == 0) {
        [self.view showLoadingMeg:@"请选择工作日生效时间" time:2.0];
        return;
    }
    NSMutableArray *WeekArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<7; i++) {
        UIButton *bt = [self.WeekView viewWithTag:i+1000];
        if (bt.selected) {
            [WeekArr addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    
    if (WeekArr.count==0) {
        [self.view showLoadingMeg:@"请选择您的正常工作日" time:2.0];
        return;
    }
    
    NSArray *dateArr = [self.model.data.workDayTime componentsSeparatedByString:@"#"];

    if ([[WeekArr componentsJoinedByString:@"-"] isEqualToString:self.model.data.workDay] &&
        [self.setdate.currentTitle isEqualToString:dateArr[0]]) {
        
        [self.navigationController   popViewControllerAnimated:YES];
        return;
    }
    
    
     NSString *str1 = [NSString stringWithFormat:@"修改正常工作日，将根据您的设置数据，去修改您的加班工资倍数，是否继续修改？"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    //设置：在3~length-3个单位长度内的内容显示成橙色
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:NSMakeRange(10, str.length-str2.length -2)];
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            [self requestQuerySetHoursWorkYset:[WeekArr componentsJoinedByString:@"-"]];
        }
    }];
    [alert show];
    
}
- (IBAction)cancelTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setModel:(LPWorkHourYsetModel *)model{
    _model = model;
    if (model.data) {
        NSArray *OverTimeArr = [model.data.overtimeMul componentsSeparatedByString:@"#"];
        NSArray *weekendArr = [model.data.weekendMul componentsSeparatedByString:@"#"];

        for (NSInteger i = 0 ; i <7; i++) {
            UILabel *MulLabel = [self.WeekView viewWithTag:3000+i];
            UILabel *MoneyLabel = [self.WeekView viewWithTag:2000+i];
            MulLabel.text = [NSString stringWithFormat:@"%@倍工资",weekendArr[1]];
            MoneyLabel.text = [NSString stringWithFormat:@"%@元/小时",weekendArr[0]];
        }
        
        NSArray *WeekArr = [model.data.workDay componentsSeparatedByString:@"-"];
        for (NSString *Week in WeekArr) {
            UIButton *bt = [self.WeekView viewWithTag:1000+Week.integerValue-1];
            bt.selected = YES;
            
            UILabel *MulLabel = [self.WeekView viewWithTag:3000+Week.integerValue-1];
            UILabel *MoneyLabel = [self.WeekView viewWithTag:2000+Week.integerValue-1];
            MulLabel.text = [NSString stringWithFormat:@"%@倍工资",OverTimeArr[1]];
            MoneyLabel.text = [NSString stringWithFormat:@"%@元/小时",OverTimeArr[0]];
        }
        
        NSArray *dateArr = [model.data.workDayTime componentsSeparatedByString:@"#"];
        if ([dateArr[0] isEqualToString:@"2000-01-01"]) {
            [self.setdate setTitle:[DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }else{
            [self.setdate setTitle:dateArr[0] forState:UIControlStateNormal];
        }

    }
}


#pragma mark - request
-(void)requestQueryGetHoursWorkYset{
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"status":@(2),
                          };
    [NetApiManager requestQueryGetHoursWorkYset:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPWorkHourYsetModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQuerySetHoursWorkYset:(NSString *)WeekArrStr{
    
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"id":self.model.data.id?self.model.data.id:@"",
                          @"workDayTime":self.setdate.currentTitle,
                          @"workDay":WeekArrStr,
                          @"status":@(2)
                          };
    [NetApiManager requestQuerySetHoursWorkYset:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1){
                    [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
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

@end
