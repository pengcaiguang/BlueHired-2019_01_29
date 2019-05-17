//
//  LPLeaveDetailsVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLeaveDetailsVC.h"
#import "LPConsumeDetailsVC.h"
#import "LPLeaveDetailsModel.h"
#import "LPLeaveDetailsCell.h"

static NSString *LPLeaveDetailsCellID = @"LPLeaveDetailsCell";

@interface LPLeaveDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel *TitleLabel;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong)LPLeaveDetailsModel *Model;
@property(nonatomic,strong) NSMutableArray <LPLeaveDetailsDataModel *>*listArray;
@end

@implementation LPLeaveDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.tableview.backgroundColor =[UIColor whiteColor];
    self.page = 1;
    [self requestQueryGetOvertimeGetDetails];
    [self setupTitleView];
}


-(void)setupTitleView{
    UIView *navigationView = [[UIView alloc]init];
    navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 49);
    navigationView.center = CGPointMake(navigationView.superview.center.x, navigationView.superview.frame.size.height/2);
    self.navigationItem.titleView = navigationView;
    
    self.TitleLabel = [[UILabel alloc] init];
    [navigationView addSubview:self.TitleLabel];
    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(navigationView);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(SCREEN_WIDTH==320?154:200);
    }];
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.TitleLabel.text = [self.TitleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
    
    self.TitleLabel.textAlignment = NSTextAlignmentCenter;
    self.TitleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH==320?12:16];

    
    UIButton *leftButton = [[UIButton alloc] init];
    [navigationView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.TitleLabel.mas_left).offset(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(49);
    }];
    [leftButton setImage:[UIImage imageNamed:@"WorkHourDateLeftBT_icon"] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftButton addTarget:self action:@selector(TouchLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *RightButton = [[UIButton alloc] init];
    [navigationView addSubview:RightButton];
    [RightButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.TitleLabel.mas_right).offset(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(49);
    }];
    [RightButton setImage:[UIImage imageNamed:@"WorkHourDateRightBT_icon"] forState:UIControlStateNormal];
    RightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [RightButton addTarget:self action:@selector(TouchRightButton) forControlEvents:UIControlEventTouchUpInside];

}



-(void)TouchLeftButton{
    NSArray *dateArr = [self.KQDateString componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *date = [dateFormatter dateFromString:dateArr[0]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setMonth:1];
    [comps2 setDay:-1];
    NSDate *endDate = [calender dateByAddingComponents:comps2 toDate:StartDate options:0];
    NSString *KQ = [NSString stringWithFormat:@"%@#%@",[dateFormatter stringFromDate:StartDate],[dateFormatter stringFromDate:endDate]];
    self.KQDateString = KQ;
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
    self.page = 1;
    [self requestQueryGetOvertimeGetDetails];
}

-(void)TouchRightButton{
    NSArray *dateArr = [self.KQDateString componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *date = [dateFormatter dateFromString:dateArr[0]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setMonth:1];
    [comps2 setDay:-1];
    NSDate *endDate = [calender dateByAddingComponents:comps2 toDate:StartDate options:0];
    NSString *KQ = [NSString stringWithFormat:@"%@#%@",[dateFormatter stringFromDate:StartDate],[dateFormatter stringFromDate:endDate]];
    self.KQDateString = KQ;
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
    self.page = 1;
    [self requestQueryGetOvertimeGetDetails];
}



#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPLeaveDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPLeaveDetailsCellID];
    if(cell == nil){
        cell = [[LPLeaveDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPLeaveDetailsCellID];
    }
    cell.WorkHourType = self.WorkHourType;
    cell.Type = self.Type;
    cell.Model = self.listArray[indexPath.row];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 10;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPLeaveDetailsCellID bundle:nil] forCellReuseIdentifier:LPLeaveDetailsCellID];
        
        _tableview.showsVerticalScrollIndicator = NO;
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryGetOvertimeGetDetails];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetOvertimeGetDetails];
        }];
    }
    return _tableview;
}

- (void)setModel:(LPLeaveDetailsModel *)Model{
    _Model = Model;
    if ([self.Model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.Model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.Model.data];
            [self.tableview reloadData];
            if (self.Model.data.count) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.listArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
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
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - request
-(void)requestQueryGetOvertimeGetDetails{
    WEAK_SELF()
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"timeRange":[self.KQDateString stringByReplacingOccurrencesOfString:@"." withString:@"-"],
                          @"status":@(self.Type),
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page]
                          };
    [NetApiManager requestQueryGetOvertimeGetDetails:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Model = [LPLeaveDetailsModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
