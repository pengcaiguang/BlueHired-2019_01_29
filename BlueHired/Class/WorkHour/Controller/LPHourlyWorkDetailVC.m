//
//  LPHourlyWorkDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPHourlyWorkDetailVC.h"
#import "LPSubsidyDeductionVC.h"
#import "LPAddRecordCell.h"
#import "LPSalaryHourlyStatisticsCell.h"
#import "LPSelectWorkhourHourlyModel.h"

static NSString *LPAddRecordCellID = @"LPAddRecordCell";
static NSString *LPSalaryHourlyStatisticsCellID = @"LPSalaryHourlyStatisticsCell";

@interface LPHourlyWorkDetailVC ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIView *tableHeaderView;
@property (weak, nonatomic) FSCalendar *calendar;
@property(nonatomic,strong) NSMutableArray <UIButton *>*bottomButtonArray;

@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;
@property(nonatomic,strong) UIButton *daySalaryButton;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,assign) NSInteger month;

@property(nonatomic,strong) LPSelectWorkhourHourlyModel *model;

@property(nonatomic,strong) NSArray *subsidiesArray;
@property(nonatomic,strong) NSDictionary *subsidiesDic;

@property(nonatomic,strong) NSArray *deductionsArray;
@property(nonatomic,strong) NSDictionary *deductionsDic;

@property(nonatomic,strong) NSString *subsidyTotal;
@property(nonatomic,strong) NSString *deductionTotal;

@end

@implementation LPHourlyWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工时详情";
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:currentDate].integerValue;
    
    
    [self setupUI];
    [self requestSelectWorkhour];
    

}

-(void)setupUI{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    bgView.backgroundColor = [UIColor baseColor];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    [bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(19, 20));
    }];
    imgView.image = [UIImage imageNamed:@"calendar"];
    
    self.timeButton = [[UIButton alloc]init];
    [bgView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *leftImgView = [[UIImageView alloc]init];
    [bgView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 12));
        make.centerY.equalTo(self.timeButton);
        make.right.equalTo(self.timeButton.mas_left).offset(-10);
    }];
    leftImgView.image = [UIImage imageNamed:@"left_arrow"];
    
    UIImageView *rightImgView = [[UIImageView alloc]init];
    [bgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 12));
        make.centerY.equalTo(self.timeButton);
        make.left.equalTo(self.timeButton.mas_right).offset(10);
    }];
    rightImgView.image = [UIImage imageNamed:@"right_arrow"];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-48);
        } else {
            make.bottom.mas_equalTo(-48);
        }
        make.top.mas_equalTo(48);
    }];
    self.bottomButtonArray = [NSMutableArray array];
    NSArray *titleArray = @[@"预估工资",@"0.00元"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [self.view addSubview:button];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = i;
        if (i == 0) {
            button.backgroundColor = [UIColor baseColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        }
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}
-(void)chooseMonth{
//    self.monthView.hidden = !self.monthView.isHidden;
//    self.monthBackView.hidden = !self.monthBackView.isHidden;
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWithResponse:^(NSString *str) {
        NSLog(@"str = %@", str);
        [self.timeButton setTitle:str forState:UIControlStateNormal];
        self.currentDateString = self.timeButton.titleLabel.text;
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSDate *birthdayDate = [dateFormatter dateFromString:self.currentDateString];
        [self.calendar selectDate:birthdayDate];
        
        [self requestSelectWorkhour];
    }];
    [datePickerView show];
}
-(void)monthViewHidden{
    self.monthView.hidden = YES;
    self.monthBackView.hidden = YES;

}

-(void)touchMonthButton:(UIButton *)button{
    NSString *year = [self.currentDateString substringToIndex:4];
    self.currentDateString = [NSString stringWithFormat:@"%@-%02ld",year,button.tag+1];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    for (UIButton *button in self.monthButtonArray) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    button.selected = YES;
    button.backgroundColor = [UIColor baseColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self monthViewHidden];
    });
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *birthdayDate = [dateFormatter dateFromString:self.currentDateString];
    [self.calendar selectDate:birthdayDate];
    
    [self requestSelectWorkhour];
}
-(void)touchBottomButton:(UIButton *)button{
    NSLog(@"预估工资");
    [self requestAddWorkrecord];
}
#pragma mark - setter
-(void)setModel:(LPSelectWorkhourHourlyModel *)model{
    _model = model;
    
    
//    self.deductionsDic = [[model.data.workRecord.reDeductLabel stringByReplacingOccurrencesOfString:@"-" withString:@":"] mj_JSONObject];
//    self.subsidiesDic = [[model.data.workRecord.reSubsidyLabel stringByReplacingOccurrencesOfString:@"-" withString:@":"] mj_JSONObject];
//    self.deductionsArray = [self.deductionsDic allKeys];
//    self.subsidiesArray = [self.subsidiesDic allKeys];
    
    NSMutableArray *Dearray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicDea = [[NSMutableDictionary alloc] init];
    
    for (NSString *string in [model.data.workRecord.reDeductLabel componentsSeparatedByString:@","])
    {
        NSArray *arr = [string componentsSeparatedByString:@"-"];
        if (arr.count >=2) {
            [Dearray addObject:arr[0]];
            [dicDea setObject:arr[1] forKey:arr[0]];
        }
    }
    self.deductionsArray = [Dearray mutableCopy];
    self.deductionsDic = [dicDea mutableCopy];
    
    NSMutableArray *Subarray = [[NSMutableArray alloc] init];
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
    
    for (NSString *string in [model.data.workRecord.reSubsidyLabel componentsSeparatedByString:@","])
    {
        NSArray *arr = [string componentsSeparatedByString:@"-"];
        if (arr.count >=2) {
            [Subarray addObject:arr[0]];
            [subDic setObject:arr[1] forKey:arr[0]];
            
        }
    }
    self.subsidiesArray = [Subarray mutableCopy];
    self.subsidiesDic = [subDic mutableCopy];
    
    
    
    self.deductionTotal = [NSString stringWithFormat:@"%.2f",model.data.workRecord.reDeductMoney.floatValue];
    self.subsidyTotal = [NSString stringWithFormat:@"%.2f",model.data.workRecord.reSubsidyMoney.floatValue];
//    self.addTotal = [NSString stringWithFormat:@"%.2f",model.data.workRecord.addWorkSalary.floatValue];
//    self.basicSalary = [NSString stringWithFormat:@"%.2f",model.data.workRecord.basicSalary.floatValue];
    [self.bottomButtonArray[1] setTitle:[NSString stringWithFormat:@"%.2f",model.data.workRecord.totalMoney.floatValue] forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormatterdd = [[NSDateFormatter alloc] init];
    dateFormatterdd.dateFormat = @"dd";
    NSString *string = [dateFormatterdd stringFromDate:self.calendar.selectedDate];
 
    if (self.model.data.workHourList.count) {
        for (LPSelectWorkhourHourlyDataListModel *model in self.model.data.workHourList) {
            if ([model.time isEqualToString:string]) {
                if (model.dayMoney.floatValue == 0.0) {
                    [self.daySalaryButton setTitle:@"您当日未记录工时" forState:UIControlStateNormal];
                }
                else
                {
                    [self.daySalaryButton setTitle:[NSString stringWithFormat:@"您当日的工资为：%.2f元",model.dayMoney.floatValue] forState:UIControlStateNormal];
                }
                
                break;
            }
        }
    }else{
        [self.daySalaryButton setTitle:@"您当日未记录工时" forState:UIControlStateNormal];
    }
    
    
    [self.tableview reloadData];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPAddRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:LPAddRecordCellID];
    if (indexPath.row == 0) {
        cell.imgView.image = [UIImage imageNamed:@"add_subsidies_record"];
        cell.addTextLabel.text = @"添加补贴记录";
        [cell.addButton setTitle:@"添加补贴记录" forState:UIControlStateNormal];
        
        NSArray *array = self.subsidiesArray;
        cell.textArray = array;
        WEAK_SELF()
        cell.block = ^{
            LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
            vc.type = 1;
            vc.selectArray = weakSelf.subsidiesArray;
//            vc.block = ^(NSArray *array) {
//                weakSelf.subsidiesArray = array;
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [self.subsidiesDic mutableCopy];
        for (int i =0; i<[dic allKeys].count; i++) {
            if (![self.subsidiesArray containsObject:[dic allKeys][i]]) {
                [dic removeObjectForKey:[dic allKeys][i]];
            }
        }
        self.subsidiesDic = [dic copy];
        
        cell.dic = self.subsidiesDic;
        cell.dicBlock = ^(NSDictionary *dic) {
            weakSelf.subsidiesDic = dic;
            
            //                NSInteger total = 0;
            //                NSArray *array = [dic allValues];
            //                for (NSString *str in array) {
            //                    total += [str integerValue];
            //                }
            //                weakSelf.subsidyTotal = [NSString stringWithFormat:@"%ld",total];
            //                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return cell;
    }else if(indexPath.row == 1){
        cell.imgView.image = [UIImage imageNamed:@"add_deductions_record"];
        cell.addTextLabel.text = @"添加扣款记录";
        [cell.addButton setTitle:@"添加扣款记录" forState:UIControlStateNormal];
        
        NSArray *array = self.deductionsArray;
        cell.textArray = array;
        WEAK_SELF()
        cell.block = ^{
            LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
            vc.type = 2;
            vc.selectArray = weakSelf.deductionsArray;
//            vc.block = ^(NSArray *array) {
//                weakSelf.deductionsArray = array;
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [self.deductionsDic mutableCopy];
        for (int i =0; i<[dic allKeys].count; i++) {
            if (![self.deductionsArray containsObject:[dic allKeys][i]]) {
                [dic removeObjectForKey:[dic allKeys][i]];
            }
        }
        self.deductionsDic = [dic copy];
        
        cell.dic = self.deductionsDic;
        cell.dicBlock = ^(NSDictionary *dic) {
            weakSelf.deductionsDic = dic;
            
            //                NSInteger total = 0;
            //                NSArray *array = [dic allValues];
            //                for (NSString *str in array) {
            //                    total += [str integerValue];
            //                }
            //                weakSelf.deductionTotal = [NSString stringWithFormat:@"%ld",total];
            //                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return cell;
    }else{
        LPSalaryHourlyStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSalaryHourlyStatisticsCellID];
        cell.subsidyLabel.text = [NSString stringWithFormat:@"补贴总计：%@",self.subsidyTotal ? self.subsidyTotal : @""];
        cell.deductionLabel.text = [NSString stringWithFormat:@"扣款总计：%@",self.deductionTotal ? self.deductionTotal : @""];

        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd";
    NSString *string = [dateFormatter stringFromDate:date];
    NSLog(@"did select %@",string);
    if (self.model.data.workHourList.count==0) {
       [self.daySalaryButton setTitle:@"您当日未记录工时" forState:UIControlStateNormal];
        return;
    }
    for (LPSelectWorkhourHourlyDataListModel *model in self.model.data.workHourList) {
        if ([model.time isEqualToString:string]) {
            if (model.dayMoney.floatValue == 0.0) {
                [self.daySalaryButton setTitle:@"您当日未记录工时" forState:UIControlStateNormal];
            }
            else
            {
                [self.daySalaryButton setTitle:[NSString stringWithFormat:@"您当日的工资为：%.2f元",model.dayMoney.floatValue] forState:UIControlStateNormal];
            }
            break;
        }
        else
        {
            [self.daySalaryButton setTitle:@"您当日未记录工时" forState:UIControlStateNormal];
        }
    }
}
-(void)refresh:(CGFloat)dedTotal add:(CGFloat)subTotal{
    self.deductionTotal = [NSString stringWithFormat:@"%.2f",dedTotal];
    self.subsidyTotal = [NSString stringWithFormat:@"%.2f",subTotal];
    CGFloat total = self.model.data.workRecord.totalMoney.floatValue + subTotal - dedTotal;
    [self.bottomButtonArray[1] setTitle:[NSString stringWithFormat:@"%.2f",total] forState:UIControlStateNormal];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - request
-(void)requestSelectWorkhour{
    NSDictionary *dic = @{
                          @"type":@(1),
                          @"month":self.currentDateString
                          };
    [NetApiManager requestSelectWorkhourWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPSelectWorkhourHourlyModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestAddWorkrecord{
    
//    [self calculation];
    
//    NSString *dedstring = [self.deductionsDic mj_JSONString];
//    NSArray *dedArray = [self.deductionsDic allValues];
//    CGFloat dedMoney = 0;
//    for (NSString *str in dedArray) {
//        dedMoney += [str floatValue];
//    }
//
//    NSString *substring = [self.subsidiesDic mj_JSONString];
//    NSArray *subArray = [self.subsidiesDic allValues];
//    CGFloat subMoney = 0;
//    for (NSString *str in subArray) {
//        subMoney += [str floatValue];
//    }
    
    
    CGFloat dedMoney = 0;
    CGFloat subMoney = 0;
    NSString *dedstring =@"";
    for (int i =0 ; i < self.deductionsArray.count ; i++) {
        NSString *key = self.deductionsArray[i];
        if([[self.deductionsDic objectForKey:key] isEqual:[NSNull null]] ||
           ![self.deductionsDic objectForKey:key]||
           [[self.deductionsDic objectForKey:key] isEqualToString:@""]){
            [self.view showLoadingMeg:[NSString stringWithFormat:@"请先输入“%@”的金额",key] time:MESSAGE_SHOW_TIME];
            return;
        }
        
        CGFloat mony  = [[self.deductionsDic objectForKey:key] floatValue];
        NSString *str = [NSString stringWithFormat:@"%@-%.2f,",key,mony];
        dedstring = [dedstring stringByAppendingString:str];
        dedMoney += mony;
    }
    
    NSString *substring =@"";
    for (int i =0 ; i < self.subsidiesArray.count ; i++) {
        NSString *key = self.subsidiesArray[i];
        if([[self.subsidiesDic objectForKey:key] isEqual:[NSNull null]] ||
           ![self.subsidiesDic objectForKey:key] ||
           [[self.subsidiesDic objectForKey:key] isEqualToString:@""]){
            [self.view showLoadingMeg:[NSString stringWithFormat:@"请先输入“%@”的金额",key] time:MESSAGE_SHOW_TIME];
            return;
        }
        CGFloat mony  = [[self.subsidiesDic objectForKey:key] floatValue];
        NSString *str = [NSString stringWithFormat:@"%@-%.2f,",key,mony];
        substring = [substring stringByAppendingString:str];
        subMoney += mony;
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.currentDateString forKey:@"time"];
    [dic setObject:@(1) forKey:@"type"];
    
    if (dedstring) {
        [dic setObject:dedstring forKey:@"reDeductLabel"];
        [dic setObject:@(dedMoney) forKey:@"reDeductMoney"];
    }
    
    if (substring) {
        [dic setObject:substring forKey:@"reSubsidyLabel"];
        [dic setObject:@(subMoney) forKey:@"reSubsidyMoney"];
    }
    
    //    NSDictionary *dic = @{
    //                          @"addWorkSalary":@(add),
    //                          @"basicSalary":self.basicSalary,
    //                          @"deductLabel":dedstring ? dedstring : @"",
    //                          @"deductMoney":@(dedMoney),
    //                          @"subsidyLabel":substring ? substring : @"",
    //                          @"subsidyMoney":@(subMoney)
    //                          };
    [NetApiManager requestAddWorkrecordWithParam:[dic copy] withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                [self requestSelectWorkhour];
                [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPAddRecordCellID bundle:nil] forCellReuseIdentifier:LPAddRecordCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPSalaryHourlyStatisticsCellID bundle:nil] forCellReuseIdentifier:LPSalaryHourlyStatisticsCellID];
    }
    return _tableview;
}
-(UIView *)monthView{
    if (!_monthView) {
        _monthView = [[UIView alloc]init];
        [self.view addSubview:_monthView];
        [_monthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(48);
            make.bottom.mas_equalTo(0);
        }];
        _monthView.backgroundColor = [UIColor blackColor];
        _monthView.alpha = 0.5;
        _monthView.userInteractionEnabled = YES;
        _monthView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(monthViewHidden)];
        [_monthView addGestureRecognizer:tap];
        
        
        self.monthBackView = [[UIView alloc]init];
        [self.view addSubview:self.monthBackView];
        [self.monthBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(48);
            make.height.mas_equalTo(150);
        }];
        self.monthBackView.hidden = YES;
        self.monthBackView.backgroundColor = [UIColor whiteColor];
        
        self.monthButtonArray = [NSMutableArray array];
        
        for (int i = 0; i < 12; i++) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, floor(i/4)*51, SCREEN_WIDTH/4, 51);
            view.backgroundColor = [UIColor whiteColor];
            [self.monthBackView addSubview:view];
            
            UIButton *button = [[UIButton alloc]init];
            [view addSubview:button];
            button.frame = CGRectMake((SCREEN_WIDTH/4-41)/2, 5, 41, 41);
            button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20.5;
            button.tag = i;
            [self.monthButtonArray addObject:button];
            [button addTarget:self action:@selector(touchMonthButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.monthButtonArray[self.month-1].selected = YES;
        self.monthButtonArray[self.month-1].backgroundColor = [UIColor baseColor];
        
    }
    return _monthView;
    
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 288)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 253)];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.scrollDirection = FSCalendarScrollDirectionVertical;
        calendar.backgroundColor = [UIColor whiteColor];
        calendar.scrollEnabled = NO;
        calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        calendar.appearance.selectionColor = [UIColor baseColor];
        calendar.appearance.weekdayTextColor = [UIColor baseColor];
        calendar.appearance.headerTitleColor = [UIColor baseColor];
        calendar.appearance.todayColor = [UIColor baseColor];
        calendar.today = nil;
        [calendar selectDate:[NSDate date]];
        calendar.appearance.headerDateFormat = @"yyyy年MM月";
        calendar.headerHeight = 5.0;
        calendar.calendarHeaderView.hidden = YES;
        calendar.placeholderType = FSCalendarPlaceholderTypeNone;
//        [calendar registerClass:[LPCalendarCell class] forCellReuseIdentifier:@"cell"];
        [_tableHeaderView addSubview:calendar];
        
        UIButton *daySalaryButton = [[UIButton alloc]init];
        [_tableHeaderView addSubview:daySalaryButton];
        [daySalaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(calendar);
            make.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(30);
        }];
        daySalaryButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [daySalaryButton setTitle:@"点击日期可查看当日工资哦！" forState:UIControlStateNormal];
        [daySalaryButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        self.daySalaryButton = daySalaryButton;
        self.calendar = calendar;
    }
    return _tableHeaderView;
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
