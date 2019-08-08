//
//  LPRegisterEntryVC.m
//  BlueHired
//
//  Created by iMac on 2019/8/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRegisterEntryVC.h"
#import "LPInviteWorkListModel.h"
#import "LPRegisterEntryCell.h"
#import "LPRegisterDetailVC.h"
static NSString *LPRegisterEntryCellID = @"LPRegisterEntryCell";

@interface LPRegisterEntryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPInviteWorkListModel *model;
@property(nonatomic,strong) NSMutableArray <LPInviteWorkListDataModel *>*listArray;

@end

@implementation LPRegisterEntryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请入职人员";
    [self setupUI];
    self.page = 1;
    [self requestGetInviteWorkList];
}



-(void)setupUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_offset(0);
        make.height.mas_equalTo(LENGTH_SIZE(75));
    }];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *MonthLabel = [[UILabel alloc] init];
 
    [headView addSubview:MonthLabel];
    [MonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.centerY.equalTo(headView);
    }];
    MonthLabel.textColor = [UIColor baseColor];
    MonthLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    MonthLabel.numberOfLines = 0;
    MonthLabel.text = @"说明：A邀请B入职，B入职满15天后才会开始计算A的邀请入职奖励；若B未成功入职，B邀请的人员不会与A建立间接关系。";
    
  
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(-49));
        } else {
            make.bottom.mas_equalTo(LENGTH_SIZE(-49));
        }
        make.top.equalTo(headView.mas_bottom).offset(LENGTH_SIZE(10));
        
    }];
    
    UIButton *RegBtn = [[UIButton alloc] init];
    [self.view addSubview:RegBtn];
    [RegBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(0));
        } else {
            make.bottom.mas_equalTo(LENGTH_SIZE(0));
        }
        make.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(49));
    }];
    [RegBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegBtn.backgroundColor = [UIColor baseColor];
    RegBtn.titleLabel.font = FONT_SIZE(17);
    [RegBtn setTitle:@"查看奖励" forState:UIControlStateNormal];
    [RegBtn addTarget:self action:@selector(touchRegBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)touchRegBtn:(UIButton *)sender{
    LPRegisterDetailVC *vc = [[LPRegisterDetailVC alloc]init];
    vc.Type = 1;
    [self.navigationController pushViewController:vc animated:YES];

}



#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return LENGTH_SIZE(93);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPRegisterEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRegisterEntryCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





-(void)setModel:(LPInviteWorkListModel *)model{
    _model = model;
 
    
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            if (self.model.data.count<20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableview reloadData];
        
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
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.tableview.frame))];
        [self.tableview addSubview:noDataView];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        
        noDataView.hidden = hidden;
    }
}





#pragma mark - request

-(void)requestGetInviteWorkList{
    NSDictionary *dic = @{@"page":@(self.page)};
    
 
    [NetApiManager requestGetInviteWorkList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPInviteWorkListModel mj_objectWithKeyValues:responseObject];
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
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        [_tableview registerNib:[UINib nibWithNibName:LPRegisterEntryCellID bundle:nil] forCellReuseIdentifier:LPRegisterEntryCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetInviteWorkList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetInviteWorkList];
        }];
    }
    return _tableview;
}



@end
