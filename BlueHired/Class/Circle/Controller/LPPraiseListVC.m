//
//  LPPraiseListVC.m
//  BlueHired
//
//  Created by iMac on 2018/12/21.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPPraiseListVC.h"
#import "LPPraiseListModel.h"
#import "LPPraiseListCell.h"
#import "LPReportVC.h"

static NSString *LPLPPraiseListCellID = @"LPPraiseListCell";

@interface LPPraiseListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPPraiseListModel *PraiseListModel;
@property(nonatomic,strong) NSMutableArray <LPPraiseDataModel *>*PraiseListArray;

@end

@implementation LPPraiseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"0人觉得很赞";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);

    }];
    self.page = 1;
    [self requestPraiseList];
 }
#pragma mark - TableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.PraiseListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 51.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     LPPraiseListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPLPPraiseListCellID];
    cell.model = self.PraiseListArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger ControllerCount = 0 ;
    for (UIViewController *v in self.navigationController.viewControllers) {
        if ([v  isKindOfClass:[LPReportVC class]]) {
            ControllerCount +=1;
        }
    }
    if (ControllerCount >= 3) {
        [LPTools AlertMessageView:@"当前页面跳转过深，请回退！"];
        return;
    }
    
    LPPraiseDataModel *m = self.PraiseListArray[indexPath.row];
    LPMoodListDataModel *Moodmodel = [[LPMoodListDataModel alloc] init];
    Moodmodel.userId = @(m.id.integerValue);
    Moodmodel.userName = m.userName;
    Moodmodel.identity = m.identity;
    LPReportVC *vc = [[LPReportVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.MoodModel = Moodmodel;
    vc.SupermoodListArray = self.SupermoodListArray;
    vc.SuperTableView = self.SuperTableView;
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
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellEditingStyleNone;
        _tableview.estimatedSectionHeaderHeight = 0;
        [_tableview registerNib:[UINib nibWithNibName:LPLPPraiseListCellID bundle:nil] forCellReuseIdentifier:LPLPPraiseListCellID];

        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestPraiseList];
        }];
    }
    return _tableview;
}
-(void)setPraiseListModel:(LPPraiseListModel *)PraiseListModel{
    _PraiseListModel = PraiseListModel;
    if ([PraiseListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.PraiseListArray = [NSMutableArray array];
        }
        if (PraiseListModel.data.list.count > 0) {
            self.page += 1;
            [self.PraiseListArray addObjectsFromArray:PraiseListModel.data.list];
            [self.tableview reloadData];
         }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        self.navigationItem.title = [NSString stringWithFormat:@"%ld人觉得很赞",(long)PraiseListModel.data.num.integerValue];
     }else{
        [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
    }
}

#pragma mark - request
-(void)requestPraiseList{
    
    NSDictionary *dic = @{@"id": self.Moodmodel.id,
                        @"page":@(self.page)
                          };
    [NetApiManager requestQueryPraiseList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.PraiseListModel = [LPPraiseListModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
     }];
}


@end
