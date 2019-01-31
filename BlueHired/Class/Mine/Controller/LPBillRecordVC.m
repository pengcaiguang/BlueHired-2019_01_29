//
//  LPBillRecordVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBillRecordVC.h"
#import "LPBillrecordModel.h"
#import "LPBillRecordCell.h"
#import "LPBillRecordStateVC.h"

@interface LPBillRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPBillrecordModel *model;
@property(nonatomic,strong) NSMutableArray <LPBillrecordDataModel *>*listArray;

@end

@implementation LPBillRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人账单";
    self.page = 1;

    
    [self tableviewinit];
    [self requestQueryBillrecord];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 60;
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
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-48);
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - request
-(void)requestQueryBillrecord{
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]
                          };
    [NetApiManager requestQueryBillrecordWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.model = [LPBillrecordModel mj_objectWithKeyValues:responseObject];
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
