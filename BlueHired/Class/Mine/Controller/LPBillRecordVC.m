//
//  LPBillRecordVC.m
//  BlueHired
//
//  Created by peng on 2018/9/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBillRecordVC.h"
#import "LPBillrecordModel.h"
#import "LPBillRecordCell.h"
#import "LPBillRecordStateVC.h"
#import "LPMainSortAlertView.h"

@interface LPBillRecordVC ()<UITableViewDelegate,UITableViewDataSource,LPMainSortAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPBillrecordModel *model;
@property(nonatomic,strong) NSMutableArray <LPBillrecordDataModel *>*listArray;
@property(nonatomic,strong) NSString *Status;
@property(nonatomic,strong) LPMainSortAlertView *sortAlertView;
@property(nonatomic,strong) NSArray *StatusArr;

@end

@implementation LPBillRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人账单";
    self.StatusArr = @[@"全部账单",@"邀请奖励",@"平台奖励",@"账户提现",@"借支到账",@"工资到账",@"返费到账",@"其他"];
    self.Status = @"0";
    self.page = 1;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [self tableviewinit];
    [self requestQueryBillrecord];
}
#pragma mark - Touch
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sortAlertView close];
}

- (IBAction)TouchSelectType:(UIButton *)sender {
    self.sortAlertView.titleArray  = self.StatusArr;
    sender.selected = !sender.isSelected;
    self.sortAlertView.touchButton = sender;
    self.sortAlertView.selectTitle = sender.tag;
    self.sortAlertView.hidden = !sender.isSelected;
}

#pragma mark - LPMainSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{
    [self.selectBtn setTitle:self.StatusArr[index] forState:UIControlStateNormal];
    self.selectBtn.tag = index;
    self.Status = [NSString stringWithFormat:@"%ld",(long)index];
    self.page = 1;
    [self requestQueryBillrecord];
}

#pragma mark - LPMainSortAlertView
-(LPMainSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPMainSortAlertView alloc]init];
        _sortAlertView.touchButton = self.selectBtn;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return LENGTH_SIZE(70);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPBillRecordCell *cell = [LPBillRecordCell loadCell];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPBillRecordStateVC *vc = [[LPBillRecordStateVC alloc] init];
    vc.model = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    if (self.model.data[indexPath.row].status.integerValue == 1){
//         return NO;
//    }
//    return YES;
//}

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


- (void)setModel:(LPBillrecordModel *)model{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (self.model.data.count <20) {
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
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
        
        noDataView.hidden = hidden;
    }
}
#pragma mark - request
-(void)requestQueryBillrecord{
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"versionType":@"2.4",
                          @"status":self.Status
                          };
    [NetApiManager requestQueryBillrecordWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPBillrecordModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
         }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestDelUserBill:(LPBillrecordDataModel *) m{
    NSDictionary *dic = @{
    };
    NSString *urlStr = [NSString stringWithFormat:@"billrecord/del_user_bill?id=%@&type=%@",m.id,m.billType];

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



#pragma mark lazy
- (void)tableviewinit{
//        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 52;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerClass:[LPBillRecordCell class] forCellReuseIdentifier:@"LPBillRecordCell"];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryBillrecord];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryBillrecord];
        }];
        
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(10))];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    _tableview.tableHeaderView = headView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
