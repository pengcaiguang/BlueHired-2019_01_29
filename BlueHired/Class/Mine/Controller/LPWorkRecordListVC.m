//
//  LPWorkRecordListVC.m
//  BlueHired
//
//  Created by iMac on 2019/10/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkRecordListVC.h"
#import "LPWorkRecordModel.h"
#import "LPWorkRecordCell.h"

static NSString *LPWorkRecordListCellID = @"LPWorkRecordCell";

@interface LPWorkRecordListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPWorkRecordModel *model;
@property(nonatomic,strong) NSMutableArray <LPWorkRecordDataModel *>*listArray;

@end

@implementation LPWorkRecordListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"入职记录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(10));
        make.bottom.mas_equalTo(0);
    }];
    
    self.page = 1;
    [self requestGetWorkRecordList];
    
}

#pragma mark - TableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(66);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorkRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkRecordListCellID];
    cell.model = self.listArray[indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

 
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 64;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkRecordListCellID bundle:nil] forCellReuseIdentifier:LPWorkRecordListCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetWorkRecordList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetWorkRecordList];
        }];
    }
    return _tableview;
}



- (void)setModel:(LPWorkRecordModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data];
            [self.tableview reloadData];
            if (model.data.count<20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.mj_footer.hidden = self.listArray.count<20?YES:NO;
            }
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.listArray.count == 0) {
            self.tableview.mj_footer.alpha = 0;
            [self addNodataViewHidden:NO];
        }else{
            self.tableview.mj_footer.alpha = 1;
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
        LPNoDataView *noDataView = [[LPNoDataView alloc]init];
        [self.view addSubview:noDataView];
        [noDataView image:nil text:@"没有相关数据~"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(LENGTH_SIZE(0));
            make.bottom.mas_equalTo(LENGTH_SIZE(0));
        }];
        noDataView.hidden = hidden;
    }
}



-(void)requestGetWorkRecordList{
    NSDictionary *dic = @{
                            @"userId":self.Emodel.userId,
                            @"page":[NSString stringWithFormat:@"%ld",self.page]
                          };
    
    [NetApiManager requestGetWorkRecordList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPWorkRecordModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
