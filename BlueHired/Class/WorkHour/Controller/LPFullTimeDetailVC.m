//
//  LPFullTimeDetailVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPFullTimeDetailVC.h"
#import "LPWorkHourDetailPieChartCell.h"
#import "LPAddRecordCell.h"
#import "LPSelectWorkhourModel.h"
#import "LPSubsidyDeductionVC.h"

static NSString *LPWorkHourDetailPieChartCellID = @"LPWorkHourDetailPieChartCell";


static NSString *LPAddRecordCellID = @"LPAddRecordCell";

@interface LPFullTimeDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *bottomButtonArray;
@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,assign) NSInteger month;

@property(nonatomic,strong) LPSelectWorkhourModel *model;

@property(nonatomic,strong) NSArray *subsidiesArray;

@property(nonatomic,strong) NSArray *deductionsArray;
@end

@implementation LPFullTimeDetailVC

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
    
    self.subsidiesArray = @[@"全勤绩效：",@"车费补贴："];
    self.deductionsArray = @[@"社保扣款：",@"请假扣款："];
    
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
        make.bottom.mas_equalTo(-48);
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
        }else{
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        }
//        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(0);
    }];
    
    
}
-(void)chooseMonth{
    self.monthView.hidden = !self.monthView.isHidden;
    self.monthBackView.hidden = !self.monthBackView.isHidden;
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
#pragma mark - setter
-(void)setModel:(LPSelectWorkhourModel *)model{
    _model = model;
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        LPWorkHourDetailPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailPieChartCellID];
        cell.index = indexPath.row;
        cell.model = self.model;
        return cell;
    }else{
        LPAddRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:LPAddRecordCellID];
        if (indexPath.row == 3) {
            NSArray *array = self.subsidiesArray;
            cell.textArray = array;
            WEAK_SELF()
            cell.block = ^{
                LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
                vc.type = 1;
                vc.block = ^(NSString *string) {
                    NSMutableArray *muarray = [NSMutableArray arrayWithArray:array];
                    [muarray addObject:string];
                    weakSelf.subsidiesArray = [muarray copy];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
            
        }else{
            NSArray *array = self.deductionsArray;
            cell.textArray = array;
            WEAK_SELF()
            cell.block = ^{
                LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
                vc.type = 2;
                vc.block = ^(NSString *string) {
                    NSMutableArray *muarray = [NSMutableArray arrayWithArray:array];
                    [muarray addObject:string];
                    weakSelf.deductionsArray = [muarray copy];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
        
        cell.index = indexPath.row;

//        cell.block = ^{
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - request
-(void)requestSelectWorkhour{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"day":self.currentDateString
                          };
    [NetApiManager requestSelectWorkhourWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPSelectWorkhourModel mj_objectWithKeyValues:responseObject];
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
