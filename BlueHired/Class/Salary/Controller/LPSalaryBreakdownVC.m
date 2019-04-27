//
//  LPSalaryBreakdownVC.m
//  BlueHired
//
//  Created by peng on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSalaryBreakdownVC.h"
#import "LPQuerySalarylistModel.h"
#import "LPSalaryDetailVC.h"
#import "LPSalaryBreakdownCell.h"

static NSString *LPSalaryBreakdownCellID = @"LPSalaryBreakdownCell";

@interface LPSalaryBreakdownVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;
@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,assign) NSInteger month;

@property(nonatomic,strong) LPQuerySalarylistModel *model;

@end

@implementation LPSalaryBreakdownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工资列表";
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:currentDate].integerValue;
    
    [self setupUI];
    [self requestQuerySalarylist];
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
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(48);
    }];
}
-(void)chooseMonth{
    
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWithResponse:^(NSString *str) {
         NSLog(@"str = %@", str);
        [self.timeButton setTitle:str forState:UIControlStateNormal];
        self.currentDateString = self.timeButton.titleLabel.text;
         [self requestQuerySalarylist];
     }];
    
    [datePickerView show];
//    self.monthView.hidden = !self.monthView.isHidden;
//    self.monthBackView.hidden = !self.monthBackView.isHidden;
}
-(void)monthViewHidden{
    self.monthView.hidden = YES;
    self.monthBackView.hidden = YES;
}

-(void)touchMonthButton:(UIButton *)button{
    NSString *year = [self.currentDateString substringToIndex:4];
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@-%02ld",year,button.tag+1] forState:UIControlStateNormal];
    self.currentDateString = self.timeButton.titleLabel.text;
    for (UIButton *button in self.monthButtonArray) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    button.selected = YES;
    button.backgroundColor = [UIColor baseColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self monthViewHidden];
    });
    [self requestQuerySalarylist];
}

#pragma mark - setter
-(void)setModel:(LPQuerySalarylistModel *)model{
    _model = model;
    if (model.data.count == 0) {
        [self addNodataViewHidden:NO];
    }else{
        [self addNodataViewHidden:YES];
    }
    [self.tableview reloadData];
}
-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:noDataView];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(49);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSalaryBreakdownCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSalaryBreakdownCellID];
    cell.companyNameLabel.text = self.model.data[indexPath.row].companyName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPSalaryDetailVC *vc = [[LPSalaryDetailVC alloc]init];
    vc.model = self.model.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
-(void)requestQuerySalarylist{
    NSDictionary *dic = @{
                          @"month":self.currentDateString
                          };
    [NetApiManager requestQuerySalarylistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPQuerySalarylistModel mj_objectWithKeyValues:responseObject];
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPSalaryBreakdownCellID bundle:nil] forCellReuseIdentifier:LPSalaryBreakdownCellID];

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
