//
//  LPCircleInfoListVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/17.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPCircleInfoListVC.h"
#import "LPInfoListModel.h"
#import "LPCircleInfoCell.h"
#import "LPMoodDetailVC.h"
#import "LPMoodListModel.h"

static NSString *LPCircleInfoCellID = @"LPCircleInfoCell";

@interface LPCircleInfoListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPInfoListModel *model;
@property(nonatomic,strong) NSMutableArray <LPInfoListDataModel *>*listArray;

@end

@implementation LPCircleInfoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";

    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.page = 1;
    [self requestQueryInfolist];
    
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
}


-(void)touchDeleteButton{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"是否确定清空消息记录？"];
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            [self requestQueryDeleteInfoMood];
        }
    }];
    [alert show];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPCircleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCircleInfoCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    LPMoodListDataModel *moodListDataModel = [[LPMoodListDataModel alloc] init];
    moodListDataModel.id = self.listArray[indexPath.row].moodId;
    vc.moodListDataModel = moodListDataModel;
    vc.InfoId = [NSString stringWithFormat:@"%@",self.listArray[indexPath.row].id];
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
}

-(void)setModel:(LPInfoListModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
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
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            self.tableview.mj_footer.alpha = 1;
            [self addNodataViewHidden:YES];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(touchDeleteButton)];
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#666666"]];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateSelected];
            
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
        [noDataView image:nil text:@"抱歉！没有新的消息！"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}

#pragma mark - request
-(void)requestQueryInfolist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"type":@(6),
                          @"versionType":@"2.2"
                          };
    [NetApiManager requestQueryInfolistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.model = [LPInfoListModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryDeleteInfoMood{
    NSDictionary *dic = @{};
    [NetApiManager requestQueryDeleteInfoMood:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
//            self.model = [LPInfoListModel mj_objectWithKeyValues:responseObject];
            if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                self.page = 1;
                [self requestQueryInfolist];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPCircleInfoCellID bundle:nil] forCellReuseIdentifier:LPCircleInfoCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
                self.page = 1;
                [self requestQueryInfolist];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self requestQueryInfolist];
        }];
    }
    return _tableview;
}




@end
