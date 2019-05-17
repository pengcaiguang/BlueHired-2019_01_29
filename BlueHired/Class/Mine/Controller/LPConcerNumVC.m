//
//  LPConcerNumVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPConcerNumVC.h"
#import "LPConcernModel.h"
#import "LPConcerNumCell.h"
#import "LPPraiseListModel.h"
#import "LPReportVC.h"

static NSString *LPConcerNumCellID = @"LPConcerNumCell";

@interface LPConcerNumVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPConcernModel *model;;
@property(nonatomic,strong) NSMutableArray <LPConcernDataModel *>*ListArray;

@end

@implementation LPConcerNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.Type == 1) {
        self.navigationItem.title = @"你有0位粉丝";
    }else{
        self.navigationItem.title = @"关注0人";
    }
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    self.page =1;
    [self requestQueryUserConcernList];
 }


#pragma mark - TableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 62.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPConcerNumCell *cell = [tableView dequeueReusableCellWithIdentifier:LPConcerNumCellID];
    cell.Type = self.Type;
    cell.model = self.ListArray[indexPath.row];
    WEAK_SELF()
    cell.Block = ^(void){
        [weakSelf.tableview reloadData];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LPConcernDataModel *m = self.ListArray[indexPath.row];
    
    LPMoodListDataModel *Moodmodel = [[LPMoodListDataModel alloc] init];
    if (self.Type == 1) {
        Moodmodel.userId = @(m.userId.integerValue);
    }else if (self.Type == 2){
        Moodmodel.userId = @(m.concernUserId.integerValue);
    }
    Moodmodel.userName = m.userName;
    Moodmodel.identity = m.identity;
    
    
    LPReportVC *vc = [[LPReportVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.MoodModel = Moodmodel;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
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
        _tableview.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellEditingStyleNone;
        _tableview.estimatedSectionHeaderHeight = 0;
        [_tableview registerNib:[UINib nibWithNibName:LPConcerNumCellID bundle:nil] forCellReuseIdentifier:LPConcerNumCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryUserConcernList];
        }];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryUserConcernList];
        }];
    }
    return _tableview;
}


- (void)setModel:(LPConcernModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.ListArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.page += 1;
            [self.ListArray addObjectsFromArray:model.data];
            if (self.Type == 1) {
                self.navigationItem.title = [NSString stringWithFormat:@"你有%ld位粉丝",(long)model.data[0].totalNum.integerValue];
            }else if (self.Type == 2){
                self.navigationItem.title = [NSString stringWithFormat:@"关注%ld人",(long)model.data[0].totalNum.integerValue];
            }
            [self.tableview reloadData];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
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


-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    LPNoDataView *noDataView ;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            noDataView = (LPNoDataView *)view;
            has = YES;
        }
    }
    if (!has) {
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.tableview addSubview:noDataView];
        if (self.Type == 1) {
            [noDataView image:nil text:@"还没有粉丝呢！"];
        }else if (self.Type == 2){
            [noDataView image:nil text:@"你还没有关注任何人，赶快去关注感兴趣的小伙伴吧！"];

        }
        noDataView.hidden = hidden;
    }
    
}


#pragma mark - request
-(void)requestQueryUserConcernList{
    
    NSDictionary *dic = @{@"page":@(self.page),
                          @"type":@(self.Type)
                          };
    [NetApiManager requestQueryUserConcernList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPConcernModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
