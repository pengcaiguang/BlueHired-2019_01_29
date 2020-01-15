//
//  LPInforCollectionViewCell.m
//  BlueHired
//
//  Created by peng on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInforCollectionViewCell.h"
#import "LPInfoListModel.h"
#import "LPInfoCell.h"
#import "LPInfoDetailVC.h"
#import "LPMoodDetailVC.h"

static NSString *LPInfoCellID = @"LPInfoCell";

@interface LPInforCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, assign) NSNumber *labelListModelId;

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
//        make.edges.equalTo(self.contentView);
        make.top.left.right.bottom.mas_offset(0);
    }];
 
}
-(void)setType:(NSInteger)type{
    _type = type;
    self.page = 1;
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
        if (self.model.data.list.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.list];
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
        [self.contentView showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [noDataView image:nil text:@"抱歉！没有新的消息！"];
        [self.contentView addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(49);
            make.bottom.mas_equalTo(-47);
        }];
        noDataView.hidden = hidden;
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
//    cell.selectAll = self.selectAll;
    if (self.selectStatus) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    if ([self.selectArray containsObject:cell.model]) {
        cell.selectButton.selected = YES;

     }else{
         cell.selectButton.selected = NO;

     }
    
    cell.selectBlock = ^(LPInfoListDataModel * _Nonnull model) {
        if ([self.selectArray containsObject:model]) {
            [self.selectArray removeObject:model];
        }else{
            [self.selectArray addObject:model];
        }
        
        if (self.selectArray.count == self.listArray.count)
        {
            self.allButton.selected = YES;
//            self.selectAll = YES;
        }
        else
        {
            self.allButton.selected = NO;
//            self.selectAll = NO;
        }
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.selectStatus) {
        
        LPInfoListDataModel *modelData = self.listArray[indexPath.row];
        if (modelData.moodId != nil) {
            LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            LPMoodListDataModel *moodListDataModel = [[LPMoodListDataModel alloc] init];
            moodListDataModel.id = modelData.moodId;
            vc.moodListDataModel = moodListDataModel;
            vc.InfoId = [NSString stringWithFormat:@"%@",modelData.id];
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LPInfoCell *cell = (LPInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
                LPInfoListDataModel *m = self.listArray[indexPath.row];
                m.status =@(1);
                
                cell.statusImgView.image = [UIImage imageNamed:@"info_read"];
            });
            return;
        }
        LPInfoDetailVC *vc = [[LPInfoDetailVC alloc]init];
        vc.model = modelData;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LPInfoCell *cell = (LPInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
            LPInfoListDataModel *m = self.listArray[indexPath.row];
            m.status =@(1);

            cell.statusImgView.image = [UIImage imageNamed:@"info_read"];
        });
    }

}
#pragma mark - request
-(void)requestQueryInfolist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"type":@(self.type),
                          @"versionType":@"2.2"
                          };
    [NetApiManager requestQueryInfolistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
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
           
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
//                    self.page = 1;
//                    [self requestQueryInfolist];
                    [self.listArray removeObjectsInArray:self.selectArray];
                    [self.tableview reloadData];
                    [self.selectArray removeAllObjects];
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除失败" time:MESSAGE_SHOW_TIME];
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
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPInfoCellID bundle:nil] forCellReuseIdentifier:LPInfoCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            if (!self.selectStatus) {
                self.page = 1;
                [self requestQueryInfolist];
            }else{
                [self.tableview.mj_header endRefreshing];
            }

        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (!self.selectStatus) {
                [self requestQueryInfolist];
            }else{
                [self.tableview.mj_footer endRefreshing];
            }
        }];
    }
    return _tableview;
}

@end
