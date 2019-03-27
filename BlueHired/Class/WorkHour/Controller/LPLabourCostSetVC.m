//
//  LPLabourCostSetVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLabourCostSetVC.h"
#import "LPConsumeTypeCell.h"
#import "LPLabourCostModel.h"
#import "LPLabourCostEditVC.h"
#import "LPProListModel.h"

static NSString *LPConsumeTypeCellID = @"LPConsumeTypeCell";

@interface LPLabourCostSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *Save;

@property(nonatomic,strong) NSMutableArray <LPProListDataModel *>*listArray;
@property (nonatomic, strong) LPProListModel *Promodel;
@property(nonatomic,assign) NSInteger page;

@property (nonatomic, strong) LPLabourCostModel *model;

@end

@implementation LPLabourCostSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.Type == 1) {
        self.navigationItem.title = @"工价设置";
        [self.Save setTitle:@"添加工价" forState:UIControlStateNormal];
        [self requestQueryGetPriceName];
    }else if (self.Type == 2){
        self.navigationItem.title = @"产品列表";
        [self.Save setTitle:@"添加产品信息" forState:UIControlStateNormal];
        self.page = 1;
        [self requestQueryGetProList];
    }
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-65);
        } else {
            // Fallback on earlier versions
             make.bottom.mas_equalTo(-65);
        }
    }];
    self.tableview.backgroundColor =[UIColor whiteColor];
}

- (IBAction)TouchSave:(id)sender {
    LPLabourCostEditVC *vc = [[LPLabourCostEditVC alloc] init];
    vc.listArray = self.listArray;
    vc.Type = self.Type;
    [self.navigationController pushViewController:vc animated:YES];
    vc.Block = ^(void){
        if (self.Type == 1) {
            [self requestQueryGetPriceName];
        }else{
            if (self.listArray.count == 0) {
                [self addNodataViewHidden:NO];
            }else{
                [self addNodataViewHidden:YES];
            }
            [self.tableview reloadData];
        }
    };
}


#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.Type == 2) {
      return  self.listArray.count;
    }
    return self.model.data.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPConsumeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:LPConsumeTypeCellID];
    if(cell == nil){
        cell = [[LPConsumeTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPConsumeTypeCellID];
    }
    if (self.Type == 2) {
        LPProListDataModel *m = self.listArray[indexPath.row];
        cell.NameLable.text = m.productName;
        cell.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元/件",m.productPrice.floatValue];
        cell.DetailsLabel.text = @"";
    }else{
        LPLabourCostDataModel *m = self.model.data[indexPath.row];
        cell.NameLable.text = m.priceName;
        cell.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元/小时",m.priceMoney.floatValue];
        cell.DetailsLabel.text = @"";
    }

    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPLabourCostEditVC *vc = [[LPLabourCostEditVC alloc] init];
    if (self.Type == 1) {
        vc.model = self.model.data[indexPath.row];
    }else{
        vc.Promodel = self.listArray[indexPath.row];

    }
    vc.Type = self.Type;
    vc.listArray = self.listArray;
    [self.navigationController pushViewController:vc animated:YES];
    vc.Block = ^(void){
//        [self requestQueryGetPriceName];
        if (self.Type == 1) {
            [self requestQueryGetPriceName];
        }else{
            if (self.listArray.count == 0) {
                [self addNodataViewHidden:NO];
            }else{
                [self addNodataViewHidden:YES];
            }
            [self.tableview reloadData];
        }
    };
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 10;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPConsumeTypeCellID bundle:nil] forCellReuseIdentifier:LPConsumeTypeCellID];
        
        _tableview.showsVerticalScrollIndicator = NO;
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        if (self.Type == 2) {
            _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
                self.page = 1;
                [self requestQueryGetProList];
            }];
            _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self requestQueryGetProList];
            }];
        }

    }
    return _tableview;
}

- (void)setPromodel:(LPProListModel *)Promodel{
    _Promodel = Promodel;
    if ([self.Promodel.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.Promodel.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.Promodel.data];
            [self.tableview reloadData];
            if (self.Promodel.data.count <20) {
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


- (void)setModel:(LPLabourCostModel *)model{
    _model = model;
    [self.tableview reloadData];
    if (model.data.count == 0) {
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
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-65);
            } else {
                // Fallback on earlier versions
                make.bottom.mas_equalTo(-65);
            }
            
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - request
-(void)requestQueryGetPriceName{
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetPriceName:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPLabourCostModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetProList{
    WEAK_SELF();
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"status":@(1)
                          };
    [NetApiManager requestQueryGetProList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.Promodel = [LPProListModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
