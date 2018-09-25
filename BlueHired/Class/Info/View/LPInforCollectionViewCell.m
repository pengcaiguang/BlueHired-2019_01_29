//
//  LPInforCollectionViewCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInforCollectionViewCell.h"
#import "LPInfoListModel.h"
#import "LPInfoCell.h"
#import "LPInfoDetailVC.h"

static NSString *LPInfoCellID = @"LPInfoCell";

@interface LPInforCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, assign) NSNumber *labelListModelId;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPInfoListModel *model;

@property(nonatomic,strong) NSMutableArray <LPInfoListDataModel *>*listArray;

@property(nonatomic,strong) NSMutableArray <LPInfoListDataModel *>*selectArray;


@end

@implementation LPInforCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.page = 1;
    self.listArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
-(void)setType:(NSInteger)type{
    _type = type;
    [self requestQueryInfolist];
}
-(void)setSelectStatus:(BOOL)selectStatus{
    _selectStatus = selectStatus;
    [self.tableview reloadData];
}
-(void)setSelectAll:(BOOL)selectAll{
    _selectAll = selectAll;
    if (selectAll) {
        self.selectArray = [self.listArray mutableCopy];
    }else{
        [self.selectArray removeAllObjects];
    }
    [self.tableview reloadData];
}
-(void)deleteInfo{
    if (self.selectArray.count == 0) {
        [[UIWindow visibleViewController].view showLoadingMeg:@"请选择需要删除的消息" time:MESSAGE_SHOW_TIME];
    }else{
        [self requestDelInfos];
    }
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
    }else{
        [self.contentView showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInfoCellID];
    cell.model = self.listArray[indexPath.row];
    cell.selectStatus = self.selectStatus;
    cell.selectAll = self.selectAll;
    if (self.selectStatus) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.selectBlock = ^(LPInfoListDataModel * _Nonnull model) {
        if ([self.selectArray containsObject:model]) {
            [self.selectArray removeObject:model];
        }else{
            [self.selectArray addObject:model];
        }
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPInfoDetailVC *vc = [[LPInfoDetailVC alloc]init];
    vc.model = self.listArray[indexPath.row];
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LPInfoCell *cell = (LPInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.statusImgView.image = [UIImage imageNamed:@"info_read"];
    });
}
#pragma mark - request
-(void)requestQueryInfolist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"type":@(self.type)
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
-(void)requestDelInfos{
    NSMutableArray *array = [NSMutableArray array];
    for (LPInfoListDataModel *model in self.selectArray) {
        [array addObject:model.id];
    }
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *dic = @{
                          @"infoId":string
                          };
    [NetApiManager requestDelInfosWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [self.selectArray removeAllObjects];
            self.page = 1;
            [self requestQueryInfolist];
            [[UIWindow visibleViewController].view showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPInfoCellID bundle:nil] forCellReuseIdentifier:LPInfoCellID];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
