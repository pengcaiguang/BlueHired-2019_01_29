//
//  LPAwardInvitationVC.m
//  BlueHired
//
//  Created by iMac on 2019/8/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAwardInvitationVC.h"
#import "LPAwardInvitationCell.h"
#import "LPPrizeMoney.h"

static NSString *LPAwardInvitationCellID = @"LPAwardInvitationCell";

@interface LPAwardInvitationVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) LPPrizeMoney *Prizemodel;
@property(nonatomic,strong) NSMutableArray <LPPrizeDataMoney *>*listArray;
@property(nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation LPAwardInvitationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请奖励领取";
    [self setupUI];
    self.page = 1;
    [self requestQueryPrizeMoneyList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
    
}

-(void)setupUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"process"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_offset(LENGTH_SIZE(66));
    }];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(imageView.mas_top).offset(0);
        make.top.mas_equalTo(0);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(86);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPAwardInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:LPAwardInvitationCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setPrizemodel:(LPPrizeMoney *)Prizemodel{
    _Prizemodel = Prizemodel;
    if ([Prizemodel.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (Prizemodel.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:Prizemodel.data];
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
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]init];
        [self.view addSubview:noDataView];
        [noDataView image:nil text:@"没有相关数据~"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(LENGTH_SIZE(-66));
            } else {
                make.bottom.mas_equalTo(LENGTH_SIZE(-66));
            }
        }];
        noDataView.hidden = hidden;
    }
}


#pragma mark - request
-(void)requestQueryPrizeMoneyList{
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"type":@"2"
                          };
    [NetApiManager requestQueryPrizeMoneyList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Prizemodel = [LPPrizeMoney mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPAwardInvitationCellID bundle:nil] forCellReuseIdentifier:LPAwardInvitationCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestQueryPrizeMoneyList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryPrizeMoneyList];
        }];
      
        
    }
    return _tableview;
}


@end
