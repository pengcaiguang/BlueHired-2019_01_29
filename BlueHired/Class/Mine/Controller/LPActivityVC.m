//
//  LPActivityVC.m
//  BlueHired
//
//  Created by iMac on 2019/1/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPActivityVC.h"
#import "LPActivityModel.h"
#import "LPActivityCell.h"
#import "LPActivityDatelisVC.h"

static NSString *LPActivityCellID = @"LPActivityCell";

@interface LPActivityVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPActivityModel *Model;
@property(nonatomic,strong) NSMutableArray <LPActivityDataModel *>*ListArray;

@end

@implementation LPActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动中心";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.bottom.mas_equalTo(0);
        
    }];
    
    self.page = 1;
    [self requestActivityList];

}

#pragma mark - TableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 140.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:LPActivityCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.ListArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPActivityDatelisVC *vc = [[LPActivityDatelisVC alloc] init];
    vc.Model = self.ListArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = YES;
        //        _tableview.tableFooterView = [[UIView alloc]init];
        //        _tableview.rowHeight = UITableViewAutomaticDimension;
        //        _tableview.estimatedRowHeight = 0.0;
        //        _tableview.estimatedRowHeight = 100;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellEditingStyleNone;
        _tableview.estimatedSectionHeaderHeight = 0;
        [_tableview registerNib:[UINib nibWithNibName:LPActivityCellID bundle:nil] forCellReuseIdentifier:LPActivityCellID];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestActivityList];
        }];
    }
    return _tableview;
}

-(void)setModel:(LPActivityModel *)Model{
    _Model = Model;
    if ([Model.code integerValue] == 0) {
        if (self.page == 1) {
            self.ListArray = [NSMutableArray array];
        }
        if (Model.data.count > 0) {
            self.page += 1;
            [self.ListArray addObjectsFromArray:Model.data];
            [self.tableview reloadData];
            if(Model.data.count<20){
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (Model.data.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
     }else{
        [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(98);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}

#pragma mark - request
-(void)requestActivityList{
    NSDictionary *dic = @{@"page":@(self.page)};
    [NetApiManager requestQueryActivityList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Model = [LPActivityModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
