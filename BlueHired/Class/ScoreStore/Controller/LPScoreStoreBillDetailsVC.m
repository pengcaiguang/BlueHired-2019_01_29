//
//  LPScoreStoreBillDetailsVC.m
//  BlueHired
//
//  Created by iMac on 2019/10/9.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStoreBillDetailsVC.h"
#import "LPStoreBillDetailsCell.h"
#import "LPStotrBillDetailsModel.h"

static NSString *LPStoreBillDetailsCellID = @"LPStoreBillDetailsCell";

@interface LPScoreStoreBillDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic,strong) LPStotrBillDetailsModel *model;
@end

@implementation LPScoreStoreBillDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单明细";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(10));
        make.left.right.bottom.mas_offset(0);
    }];
     [self requestQueryGetOrderDetails];
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.orderItemList.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return LENGTH_SIZE(120);
//}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPStoreBillDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPStoreBillDetailsCellID];
    cell.model = self.model.data.orderItemList[indexPath.row];
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
        _tableview.estimatedRowHeight = LENGTH_SIZE(120);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPStoreBillDetailsCellID bundle:nil] forCellReuseIdentifier:LPStoreBillDetailsCellID];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
//        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            self.page = 1;
//            [self requestGetProductScoreList];
//        }];
//
//        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self requestGetProductScoreList];
//        }];
    }
    return _tableview;
}

 #pragma mark - request
 -(void)requestQueryGetOrderDetails{
     NSDictionary *dic = @{@"orderId":self.Billmodel.orderId};
     [NetApiManager requestQueryGetOrderDetails:dic withHandle:^(BOOL isSuccess, id responseObject) {
         NSLog(@"%@",responseObject);
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         
         if (isSuccess) {
             if ([responseObject[@"code"] integerValue] == 0) {
                 self.model = [LPStotrBillDetailsModel mj_objectWithKeyValues:responseObject];
                 if (self.model == nil) {
                     [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"该条记录可能已经被删除" time:MESSAGE_SHOW_TIME];
                     [self.navigationController popViewControllerAnimated:YES];
                 }else{
                     [self.tableview reloadData];
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
