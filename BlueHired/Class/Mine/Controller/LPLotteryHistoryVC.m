//
//  LPLotteryHistoryVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLotteryHistoryVC.h"
#import "LPLotteryModel.h"
#import "LPLotteryhistoryCell.h"
static NSString *LPLotteryhistoryCellID = @"LPLotteryhistoryCell";

@interface LPLotteryHistoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPLotteryModel *model;
@property(nonatomic,strong) NSMutableArray <LPLotteryDataModel *>*ListArray;
@end

@implementation LPLotteryHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"历史开奖";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.page = 1;
    [self requestQueryGetPrizeRecordList];
}
 
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPLotteryhistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:LPLotteryhistoryCellID];
    cell.model = self.ListArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [noDataView image:nil text:@"抱歉！没有相关记录!"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(40);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}


-(void)setModel:(LPLotteryModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.ListArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.ListArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.ListArray.count == 0) {
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

#pragma mark - request
-(void)requestQueryGetPrizeRecordList{
    
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"type":@(2)
                          };
    [NetApiManager requestQueryGetPrizeRecordList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.model = [LPLotteryModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPLotteryhistoryCellID bundle:nil] forCellReuseIdentifier:LPLotteryhistoryCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryGetPrizeRecordList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetPrizeRecordList];
        }];
    }
    return _tableview;
}



@end
