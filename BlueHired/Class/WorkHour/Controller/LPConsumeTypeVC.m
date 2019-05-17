//
//  LPConsumeTypeVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPConsumeTypeVC.h"
#import "LPConsumeTypeCell.h"
#import "LPConsumeDetailsVC.h"
#import "LPOverTimeAccountModel.h"

static NSString *LPConsumeTypeCellID = @"LPConsumeTypeCell";

@interface LPConsumeTypeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)LPOverTimeAccountModel *OverModel;
@property (nonatomic,assign) NSInteger page;
@property(nonatomic,strong) NSMutableArray <LPOverTimeAccountDataaccountListModel *>*listArray;

@end

@implementation LPConsumeTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消费明细";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-74);
        } else {
            make.bottom.mas_equalTo(-74);
        }
    }];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self requestQueryGetOvertimeAccount];
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPConsumeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:LPConsumeTypeCellID];
    if(cell == nil){
        cell = [[LPConsumeTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPConsumeTypeCellID];
    }
 
    cell.model = self.listArray[indexPath.row];
    return cell;
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPConsumeDetailsVC *vc = [[LPConsumeDetailsVC alloc] init];
    vc.model = self.listArray[indexPath.row];
    vc.currentDateString = self.currentDateString;
    vc.WorkHourType = self.WorkHourType;
    WEAK_SELF()
    vc.block = ^(NSInteger index){
        weakSelf.page = 1;
        [weakSelf requestQueryGetOvertimeAccount];
    };
    [self.navigationController   pushViewController:vc animated:YES];
}

- (IBAction)ConsumeTouch:(id)sender {
    LPConsumeDetailsVC *vc = [[LPConsumeDetailsVC alloc] init];
    vc.currentDateString = self.currentDateString;
    WEAK_SELF()
    vc.WorkHourType = self.WorkHourType;
    vc.block = ^(NSInteger index){
        weakSelf.page = 1;
        [weakSelf requestQueryGetOvertimeAccount];
    };
    [self.navigationController   pushViewController:vc animated:YES];
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
        [_tableview registerNib:[UINib nibWithNibName:LPConsumeTypeCellID bundle:nil] forCellReuseIdentifier:LPConsumeTypeCellID];
 
        _tableview.showsVerticalScrollIndicator = NO;
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryGetOvertimeAccount];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetOvertimeAccount];
        }];
    }
    return _tableview;
}

- (void)setOverModel:(LPOverTimeAccountModel *)OverModel{
    _OverModel = OverModel;
    if ([self.OverModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.OverModel.data.accountList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.OverModel.data.accountList];
            [self.tableview reloadData];
            if (self.OverModel.data.accountList.count) {
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
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-74);
            } else {
                make.bottom.mas_equalTo(-74);
            }
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - request
-(void)requestQueryGetOvertimeAccount{
    WEAK_SELF()
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"time":self.currentDateString,
                          @"status":@(3),
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page]
                          };
    [NetApiManager requestQueryGetOvertimeAccount:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.OverModel = [LPOverTimeAccountModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
