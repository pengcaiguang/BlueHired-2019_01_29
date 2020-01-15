//
//  LPWorkInfoVC.m
//  BlueHired
//
//  Created by iMac on 2020/1/7.
//  Copyright © 2020 lanpin. All rights reserved.
//

#import "LPWorkInfoVC.h"
#import "LPInfoListModel.h"
#import "LPWorkInfoCell.h"
#import "LPInfoDetailVC.h"
#import "LPMoodDetailVC.h"
#import "LPMoodListModel.h"

static NSString *LPWorkInfoCellID = @"LPWorkInfoCell";

@interface LPWorkInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) LPInfoListModel *model;
@property (nonatomic,strong) NSMutableArray <LPInfoListDataModel *>*listArray;

@end

@implementation LPWorkInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"招工通知";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(0));
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    self.page = 1;
    [self requestQueryGetInfolist];
    
}

-(void)touchDeleteButton{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"是否确定清空消息记录？"];
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            [self requestQueryUpdateInfoMood];
        }
    }];
    [alert show];
}

#pragma mark - TableViewDelegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(288);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkInfoCellID];
    cell.model = self.listArray[indexPath.row];
 
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LPInfoListDataModel *modelData = self.listArray[indexPath.row];
    modelData.status = @(1);
    [tableView reloadData];
    
    if (modelData.moodId != nil) {
        LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        LPMoodListDataModel *moodListDataModel = [[LPMoodListDataModel alloc] init];
        moodListDataModel.id = modelData.moodId;
        vc.moodListDataModel = moodListDataModel;
        vc.InfoId = [NSString stringWithFormat:@"%@",modelData.id];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    LPInfoDetailVC *vc = [[LPInfoDetailVC alloc]init];
    vc.model = modelData;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - request
-(void)requestQueryGetInfolist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"type":@"3"
                          };
    [NetApiManager requestQueryGetInfolist:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPInfoListModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//一键清空圈子通知或者招工通知
-(void)requestQueryUpdateInfoMood{
       
    NSDictionary *dic = @{@"type":@"1"};
   
    [NetApiManager requestQueryUpdateInfoMood:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    self.page = 1;
                    [self requestQueryGetInfolist];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"消息清空失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
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
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkInfoCellID bundle:nil] forCellReuseIdentifier:LPWorkInfoCellID];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
 
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryGetInfolist];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetInfolist];
        }];
    }
    return _tableview;
}


-(void)setModel:(LPInfoListModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
         
 
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.list.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.list];
            [self.tableview reloadData];
            if (self.model.data.list.count < 20) {
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
            self.tableview.mj_footer.alpha = 0;
            [self addNodataViewHidden:NO];
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            self.tableview.mj_footer.alpha = 1;
            [self addNodataViewHidden:YES];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(touchDeleteButton)];
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#333333"]];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateSelected];
            
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
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.tableview.lx_height)];
        [noDataView image:nil text:@"抱歉！没有新的消息！"];
        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
}
 

@end
