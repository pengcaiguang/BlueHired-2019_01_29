//
//  LPScoreStoreBillVC.m
//  BlueHired
//
//  Created by iMac on 2019/9/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStoreBillVC.h"
#import "LPScoreStoreBillCell.h"
#import "LPScoreStoreBillModel.h"
#import "LPScoreStoreBillDetailsVC.h"

static NSString *LPScoreStoreBillCellID = @"LPScoreStoreBillCell";


@interface LPScoreStoreBillVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic,strong) LPScoreStoreBillModel *model;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray <LPScoreStoreBillDataModel *>*listArray;

@end

@implementation LPScoreStoreBillVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(0));
        make.left.right.bottom.mas_offset(0);
    }];
    
    self.navigationItem.title = @"积分账单";
    self.page = 1;
    [self requestGetProductScoreList];
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(60);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LENGTH_SIZE(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPScoreStoreBillCell *cell = [tableView dequeueReusableCellWithIdentifier:LPScoreStoreBillCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete)
     {
         GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否删除该账单，一经删除，无法恢复！" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#808080"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                if (buttonIndex) {
                    [self requestDelUserBill:self.listArray[indexPath.row]];
                }
            }];
            [alert show];
         
     }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPScoreStoreBillDetailsVC *vc = [[LPScoreStoreBillDetailsVC alloc] init];
    vc.Billmodel = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_tableview registerNib:[UINib nibWithNibName:LPScoreStoreBillCellID bundle:nil] forCellReuseIdentifier:LPScoreStoreBillCellID];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetProductScoreList];
        }];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetProductScoreList];
        }];
    }
    return _tableview;
}



- (void)setModel:(LPScoreStoreBillModel *)model
{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (self.model.data.count<20) {
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
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableview.lx_height)];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
       
        noDataView.hidden = hidden;
    }
}


#pragma mark - request
-(void)requestGetProductScoreList{
    NSDictionary *dic = @{@"page":@(self.page)};
    [NetApiManager requestGetProductScoreList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPScoreStoreBillModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestDelUserBill:(LPScoreStoreBillDataModel *) m{
    NSDictionary *dic = @{
                            };
    
    NSString *urlStr = [NSString stringWithFormat:@"billrecord/del_user_bill?id=%@&type=3",m.id];
    
     [NetApiManager requestDelUserBill:dic URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if([responseObject[@"data"] integerValue] == 1){
                    [self.listArray removeObject:m];
                    if (self.listArray.count == 0) {
                        [self addNodataViewHidden:NO];
                    }else{
                        [self addNodataViewHidden:YES];
                    }
                    [self.tableview reloadData];
                    [self.view showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [self.view showLoadingMeg:@"删除失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
