//
//  LPFullTimeDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPFullTimeDetailVC.h"
#import "LPWorkHourDetailPieChartCell.h"
#import "LPAddRecordCell.h"
#import "LPSelectWorkhourModel.h"
#import "LPSubsidyDeductionVC.h"
#import "LPSalaryStatisticsCell.h"

static NSString *LPWorkHourDetailPieChartCellID = @"LPWorkHourDetailPieChartCell";
static NSString *LPAddRecordCellID = @"LPAddRecordCell";
static NSString *LPSalaryStatisticsCellID = @"LPSalaryStatisticsCell";

@interface LPFullTimeDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) NSMutableArray <UIButton *>*bottomButtonArray;
@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,assign) NSInteger month;

@property(nonatomic,strong) LPSelectWorkhourModel *model;

@property(nonatomic,strong) NSArray *subsidiesArray;
@property(nonatomic,strong) NSMutableArray *subsidiesValueArray;
@property(nonatomic,strong) NSDictionary *subsidiesDic;

@property(nonatomic,strong) NSArray *deductionsArray;
@property(nonatomic,strong) NSMutableArray *deductionsValueArray;
@property(nonatomic,strong) NSDictionary *deductionsDic;

@property(nonatomic,strong) NSString *subsidyTotal;
@property(nonatomic,strong) NSString *deductionTotal;
@property(nonatomic,strong) NSString *addTotal;
@property(nonatomic,strong) NSString *basicSalary;

@end

@implementation LPFullTimeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工时详情";
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:currentDate].integerValue;
    
    self.subsidiesArray = @[];
    self.deductionsArray = @[];
    self.subsidiesValueArray = [[NSMutableArray alloc] init];
    self.deductionsValueArray = [[NSMutableArray alloc] init];
    
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
    
//    UIButton *deleteButton = [[UIButton alloc]init];
//    [bgView addSubview:deleteButton];
//    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-14);
//        make.centerY.equalTo(bgView);
//        make.size.mas_equalTo(CGSizeMake(15, 19));
//    }];
//    [deleteButton setImage:[UIImage imageNamed:@"delete_white"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-48);
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
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    
}
-(void)chooseMonth{
//    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWithResponse:^(NSString *str) {
//        NSLog(@"str = %@", str);
//        [self.timeButton setTitle:str forState:UIControlStateNormal];
//        self.currentDateString = self.timeButton.titleLabel.text;
//        [self requestSelectWorkhour];
//    }];
    
//    [datePickerView show];
//    self.monthView.hidden = !self.monthView.isHidden;
//    self.monthBackView.hidden = !self.monthBackView.isHidden;
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
    [self requestSelectWorkhour];
    
}
-(void)touchBottomButton:(UIButton *)button{
    NSLog(@"预估工资");
    if ([self.basicSalary floatValue] == 0.0 ) {
        [self.view showLoadingMeg:@"请输入企业底薪" time:MESSAGE_SHOW_TIME];
        return;
    }
    [self requestAddWorkrecord];
}
#pragma mark - setter
-(void)setModel:(LPSelectWorkhourModel *)model{
    _model = model;
    
    
//    self.deductionsArray =[model.data.workRecord.normlDeductLabel componentsSeparatedByString:@","];
//    self.subsidiesArray =[model.data.workRecord.normlSubsidyLabel componentsSeparatedByString:@","];
    
    NSMutableArray *Dearray = [[NSMutableArray alloc] init];
    NSMutableArray *DearrayValue = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicDea = [[NSMutableDictionary alloc] init];

    for (NSString *string in [model.data.workRecord.normlDeductLabel componentsSeparatedByString:@","])
    {
        NSArray *arr = [string componentsSeparatedByString:@"-"];
        if (arr.count >=2) {
            [Dearray addObject:arr[0]];
            [DearrayValue addObject:arr[1]];
            [dicDea setObject:arr[1] forKey:arr[0]];
        }
    }
    self.deductionsArray = [Dearray mutableCopy];
    self.deductionsValueArray = [DearrayValue mutableCopy];
    self.deductionsDic = [dicDea mutableCopy];

    NSMutableArray *Subarray = [[NSMutableArray alloc] init];
    NSMutableArray *SubarrayValue = [[NSMutableArray alloc] init];
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];

    for (NSString *string in [model.data.workRecord.normlSubsidyLabel componentsSeparatedByString:@","])
    {
        NSArray *arr = [string componentsSeparatedByString:@"-"];
        if (arr.count >=2) {
            [Subarray addObject:arr[0]];
            [SubarrayValue addObject:arr[1]];
            [subDic setObject:arr[1] forKey:arr[0]];

        }
    }
    self.subsidiesArray = [Subarray mutableCopy];
    self.subsidiesValueArray = [SubarrayValue mutableCopy];
    self.subsidiesDic = [subDic mutableCopy];

//    self.deductionsDic = [model.data.workRecord.normlDeductLabel mj_JSONObject];
//    self.subsidiesDic = [str mj_JSONObject];
//    self.deductionsArray = [self.deductionsDic allKeys];
//    self.subsidiesArray = [self.subsidiesDic allKeys];

    self.deductionTotal = [NSString stringWithFormat:@"%.2f",model.data.workRecord.normlDeductMoney.floatValue];
    self.subsidyTotal = [NSString stringWithFormat:@"%.2f",model.data.workRecord.normlSubsidyMoney.floatValue];
    self.addTotal = [NSString stringWithFormat:@"%.2f",model.data.workRecord.addWorkSalary.floatValue];
    self.basicSalary = [NSString stringWithFormat:@"%.2f",model.data.workRecord.basicSalary.floatValue];
    [self.bottomButtonArray[1] setTitle:[NSString stringWithFormat:@"%.2f",model.data.workRecord.totalMoney.floatValue] forState:UIControlStateNormal];

    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        LPWorkHourDetailPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailPieChartCellID];
        cell.index = indexPath.row;
        NSLog(@"index = %ld",(long)indexPath.row);
        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 3 || indexPath.row == 4){
        LPAddRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:LPAddRecordCellID];
        if (indexPath.row == 3) {
            cell.imgView.image = [UIImage imageNamed:@"add_subsidies_record"];
            cell.addTextLabel.text = @"添加补贴记录";
            [cell.addButton setTitle:@"添加补贴记录" forState:UIControlStateNormal];
            
            NSArray *array = self.subsidiesArray;
            cell.textArray = array;
            cell.valueArray = self.subsidiesValueArray;
            WEAK_SELF()
            cell.block = ^{
                LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
                vc.type = 1;
                vc.selectArray = weakSelf.subsidiesArray;
//                vc.block = ^(NSArray *array) {
//                    weakSelf.subsidiesArray = array;
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                };
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
        }else{
            cell.imgView.image = [UIImage imageNamed:@"add_deductions_record"];
            cell.addTextLabel.text = @"添加扣款记录";
            [cell.addButton setTitle:@"添加扣款记录" forState:UIControlStateNormal];
            
            NSArray *array = self.deductionsArray;

            cell.valueArray = self.deductionsValueArray;
            cell.textArray = array;
            WEAK_SELF()
            cell.block = ^{
                LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
                vc.type = 2;
                vc.selectArray = weakSelf.deductionsArray;
//                vc.block = ^(NSArray *array) {
//                    weakSelf.deductionsArray = array;
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                };
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
        }

        return cell;
    }else{
        LPSalaryStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSalaryStatisticsCellID];
        cell.subsidyLabel.text = [NSString stringWithFormat:@"补贴总计：%@",self.subsidyTotal ? self.subsidyTotal : @""];
        cell.deductionLabel.text = [NSString stringWithFormat:@"扣款总计：%@",self.deductionTotal ? self.deductionTotal : @""];
        cell.overtimeLabel.text = [NSString stringWithFormat:@"加班总计：%@",self.addTotal ? self.addTotal : @""];
        if ([self.basicSalary floatValue] == 0.0) {
            cell.basicSalaryTextField.text = @"";
        }
        else
        {
            cell.basicSalaryTextField.text = self.basicSalary;
        }
        WEAK_SELF();
        
//        __weak LPSalaryStatisticsCell *weakCell = cell;
        cell.block = ^(NSString *string) {
            weakSelf.basicSalary = string;
//            CGFloat addTotal = [weakSelf calculation];
//            weakCell.overtimeLabel.text = [NSString stringWithFormat:@"加班总计：%.2f",addTotal];
        };
        return cell;
    }
}
-(void)calculation{
    CGFloat h = [self.basicSalary floatValue]/21.75/8.0;
//    self.addTypeTypeArray = @[@"普通加班",@"周末加班",@"节假日加班"];
    CGFloat normalAdd = 0;
    CGFloat weekendAdd = 0;
    CGFloat holidayAdd = 0;
    for (LPSelectWorkhourDataAddHourListModel *model in self.model.data.addHourList) {
        if ([model.addType integerValue] == 0) {
            normalAdd = [model.totalAddHour floatValue] * h * 1.5;
        }
        if ([model.addType integerValue] == 1) {
            weekendAdd = [model.totalAddHour floatValue] * h * 2.0;
        }
        if ([model.addType integerValue] == 2) {
            holidayAdd = [model.totalAddHour floatValue] * h * 3.0;
        }
    }
    CGFloat total = normalAdd + weekendAdd + holidayAdd;
    self.addTotal = [NSString stringWithFormat:@"%.2f",total];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)refresh:(CGFloat)dedTotal add:(CGFloat)subTotal{
    self.deductionTotal = [NSString stringWithFormat:@"%.2f",dedTotal];
    self.subsidyTotal = [NSString stringWithFormat:@"%.2f",subTotal];
    CGFloat total = self.basicSalary.floatValue + self.addTotal.floatValue + subTotal - dedTotal;
    [self.bottomButtonArray[1] setTitle:[NSString stringWithFormat:@"%.2f",total] forState:UIControlStateNormal];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - request
-(void)requestSelectWorkhour{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"month":self.currentDateString
                          };
    [NetApiManager requestSelectWorkhourWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPSelectWorkhourModel mj_objectWithKeyValues:responseObject];
                [self calculation];
                [self refresh:[self.model.data.workRecord.normlDeductMoney floatValue] add:[self.model.data.workRecord.normlSubsidyMoney floatValue]];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestAddWorkrecord{

    [self calculation];
    
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
    [dic setObject:self.addTotal forKey:@"addWorkSalary"];
    [dic setObject:self.basicSalary forKey:@"basicSalary"];
    [dic setObject:self.currentDateString forKey:@"time"];
    [dic setObject:@(0) forKey:@"type"];

    if (![dedstring isEqualToString:@""]) {
        [dic setObject:dedstring forKey:@"normlDeductLabel"];
        [dic setObject:@(dedMoney) forKey:@"normlDeductMoney"];
    }

    if (![substring isEqualToString:@""]) {
        [dic setObject:substring forKey:@"normlSubsidyLabel"];
        [dic setObject:@(subMoney) forKey:@"normlSubsidyMoney"];
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
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self refresh:dedMoney add:subMoney];
                    [self.view showLoadingMeg:@"保存成功" time:MESSAGE_SHOW_TIME];
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

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourDetailPieChartCellID bundle:nil] forCellReuseIdentifier:LPWorkHourDetailPieChartCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPAddRecordCellID bundle:nil] forCellReuseIdentifier:LPAddRecordCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPSalaryStatisticsCellID bundle:nil] forCellReuseIdentifier:LPSalaryStatisticsCellID];
        
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
