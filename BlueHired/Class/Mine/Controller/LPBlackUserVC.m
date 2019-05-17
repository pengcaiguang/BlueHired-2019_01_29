//
//  LPBlackUserVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/19.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBlackUserVC.h"
#import "LPUserBlackModel.h"
#import "LPUserBlackCell.h"

static NSString *LPTLendAuditCellID = @"LPUserBlackCell";

@interface LPBlackUserVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property (nonatomic, strong)LPUserBlackModel *model;
@property(nonatomic,strong) NSMutableArray <LPUserBlackDataModel *>*listArray;

@end

@implementation LPBlackUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"黑名单";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self requestQueryDefriendPullBlackUserList];
 }

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPUserBlackCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTLendAuditCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPUserBlackCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPTLendAuditCellID];
    }
    
    cell.model = self.listArray[indexPath.row];
    WEAK_SELF()
    cell.Block = ^(LPUserBlackDataModel *Delete) {
        [weakSelf.listArray removeObject:Delete];
        [weakSelf.tableview reloadData];
        if (weakSelf.listArray.count == 0) {
            [weakSelf addNodataViewHidden:NO];
        }else{
            [weakSelf addNodataViewHidden:YES];
        }
     };
    return cell;
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPTLendAuditCellID bundle:nil] forCellReuseIdentifier:LPTLendAuditCellID];
//        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            [self requestQueryUserRegistration];
//        }];
        //        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //            [self requestGetOnWork];
        //        }];
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableview;
}

- (void)setModel:(LPUserBlackModel *)model{
    _model = model;
    self.listArray = [[NSMutableArray alloc] init];
    [self.listArray addObjectsFromArray:model.data];
    [self.tableview reloadData];

    if (self.listArray.count == 0) {
        [self addNodataViewHidden:NO];
    }else{
        [self addNodataViewHidden:YES];
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
            make.top.mas_equalTo(49);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}

-(void)requestQueryDefriendPullBlackUserList{
    WEAK_SELF()
    [NetApiManager requestQueryDefriendPullBlackUserList:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0 ) {
                weakSelf.model = [LPUserBlackModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
