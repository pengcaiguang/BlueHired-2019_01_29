//
//  LPShippingAddressVC.m
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPShippingAddressVC.h"
#import "LPShippingAddressCell.h"
#import "LPShiooingAddressEditVC.h"

static NSString *LPShippingAddressCellID = @"LPShippingAddressCell";

@interface LPShippingAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LPOrderAddressModel *model;
@property (nonatomic,assign) NSInteger page;

@end

@implementation LPShippingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收货地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加新地址" style:UIBarButtonItemStylePlain target:self action:@selector(TouchesRightBar)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#333333"]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(13),NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(13),NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(0));
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    self.page = 1;
    [self requestGetOrderAddressList];
}

#pragma mark --Touches
-(void)TouchesRightBar{
    LPShiooingAddressEditVC *vc = [[LPShiooingAddressEditVC alloc] init];
    vc.SuperVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:LPShippingAddressCellID];
    cell.model = self.listArray[indexPath.row];
    if (cell.model.id == self.SelectModel.id) {
        cell.LayoutConstraint_Selecticon_width.constant = LENGTH_SIZE(33);
    }else{
        cell.LayoutConstraint_Selecticon_width.constant = LENGTH_SIZE(0);
    }
    WEAK_SELF()
    cell.Block = ^(void) {
        LPShiooingAddressEditVC *vc = [[LPShiooingAddressEditVC alloc] init];
        vc.Type = self.Type;
        vc.SuperVC = weakSelf;
        vc.ListModel = self.listArray[indexPath.row];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.Type == 1) {
        LPOrderAddressModel *m = [[LPOrderAddressModel alloc] init];
        m.data = [[NSMutableArray alloc] initWithObjects:self.listArray[indexPath.row], nil];
        [self.SupreVC setAddressModel: m];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        LPShiooingAddressEditVC *vc = [[LPShiooingAddressEditVC alloc] init];
        vc.SuperVC = self;
        vc.ListModel = self.listArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 70;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPShippingAddressCellID bundle:nil] forCellReuseIdentifier:LPShippingAddressCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetOrderAddressList];
        }];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetOrderAddressList];
        }];
    }
    return _tableview;
}


- (void)setModel:(LPOrderAddressModel *)model
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
-(void)requestGetOrderAddressList{
    NSDictionary *dic = @{@"page":@(self.page)};
    [NetApiManager requestGetOrderAddressList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPOrderAddressModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
