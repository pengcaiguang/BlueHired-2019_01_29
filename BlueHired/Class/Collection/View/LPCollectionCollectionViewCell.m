//
//  LPCollectionCollectionViewCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionCollectionViewCell.h"
#import "LPEssayCollectionModel.h"
#import "LPWorkCollectionModel.h"
#import "LPCollectionEssayCell.h"
#import "LPCollectionWorkCell.h"
#import "LPWorkDetailVC.h"
#import "LPEssayDetailVC.h"

static NSString *LPCollectionEssayCellID = @"LPCollectionEssayCell";
static NSString *LPCollectionWorkCellID = @"LPCollectionWorkCell";

@interface LPCollectionCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPWorkCollectionModel *workCollectionModel;
@property(nonatomic,strong) LPEssayCollectionModel *essayCollectionModel;

@property(nonatomic,strong) NSMutableArray <LPWorkCollectionDataModel *>*wordListArray;
@property(nonatomic,strong) NSMutableArray <LPEssayCollectionDataModel *>*essayListArray;

@property(nonatomic,strong) NSMutableArray *selectArray;

@end
@implementation LPCollectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.page = 1;
    self.wordListArray = [NSMutableArray array];
    self.essayListArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
#pragma mark - setdata
-(void)setIndex:(NSInteger)index{
    _index = index;
    self.page = 1;
    if (index == 0) {
        [self requestGetEssayCollection];
    }else{
        [self requestGetWorkCollection];
    }
}
-(void)setSelectStatus:(BOOL)selectStatus{
    _selectStatus = selectStatus;
    [self.tableview reloadData];
}
-(void)setSelectAll:(BOOL)selectAll{
    _selectAll = selectAll;
    if (selectAll) {
        if (self.index == 0) {
            self.selectArray = [self.essayListArray mutableCopy];
        }else{
            self.selectArray = [self.wordListArray mutableCopy];
        }
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
-(void)setEssayCollectionModel:(LPEssayCollectionModel *)essayCollectionModel{
    _essayCollectionModel = essayCollectionModel;
    if ([essayCollectionModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.essayListArray = [NSMutableArray array];
        }
        if (essayCollectionModel.data.count > 0) {
            self.page += 1;
            [self.essayListArray addObjectsFromArray:essayCollectionModel.data];
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
-(void)setWorkCollectionModel:(LPWorkCollectionModel *)workCollectionModel{
    _workCollectionModel = workCollectionModel;
    if ([workCollectionModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.wordListArray = [NSMutableArray array];
        }
        if (workCollectionModel.data.count > 0) {
            self.page += 1;
            [self.wordListArray addObjectsFromArray:workCollectionModel.data];
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
    if (self.index == 0) {
        return self.essayListArray.count;
    }else{
        return self.wordListArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        LPCollectionEssayCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionEssayCellID];
        cell.model = self.essayListArray[indexPath.row];
        cell.selectStatus = self.selectStatus;
        cell.selectAll = self.selectAll;
        if (self.selectStatus) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        cell.selectBlock = ^(LPEssayCollectionDataModel * _Nonnull model) {
            if ([self.selectArray containsObject:model]) {
                [self.selectArray removeObject:model];
            }else{
                [self.selectArray addObject:model];
            }
        };
        return cell;
    }else{
        LPCollectionWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionWorkCellID];
        cell.model = self.wordListArray[indexPath.row];
        cell.selectStatus = self.selectStatus;
        cell.selectAll = self.selectAll;
        if (self.selectStatus) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        cell.selectBlock = ^(LPWorkCollectionDataModel * _Nonnull model) {
            if ([self.selectArray containsObject:model]) {
                [self.selectArray removeObject:model];
            }else{
                [self.selectArray addObject:model];
            }
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.index == 0) {
        LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        NSDictionary *dic = [self.essayListArray[indexPath.row] mj_JSONObject];
        vc.essaylistDataModel = [LPEssaylistDataModel mj_objectWithKeyValues:dic];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LPCollectionEssayCell *cell = (LPCollectionEssayCell*)[tableView cellForRowAtIndexPath:indexPath];
            cell.viewLabel.text = [NSString stringWithFormat:@"%ld",[cell.viewLabel.text integerValue] + 1];
        });
    }else{
        LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        NSDictionary *dic = [self.wordListArray[indexPath.row] mj_JSONObject];
        vc.workListModel = [LPWorklistDataWorkListModel mj_objectWithKeyValues:dic];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - request
-(void)requestGetWorkCollection{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          };
    [NetApiManager requestGetWorkCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.workCollectionModel = [LPWorkCollectionModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestGetEssayCollection{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          };
    [NetApiManager requestGetEssayCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.essayCollectionModel = [LPEssayCollectionModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestDelInfos{
    NSMutableArray *array = [NSMutableArray array];
    if (self.index == 0) {
        for (LPEssayCollectionDataModel *model in self.selectArray) {
            [array addObject:model.collectId];
        }
    }else{
        for (LPWorkCollectionDataModel *model in self.selectArray) {
            [array addObject:model.collectId];
        }
    }
    
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *dic = @{
                          @"ids":string
                          };
    [NetApiManager requestDeleteCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [self.selectArray removeAllObjects];
            self.page = 1;
            if (self.index == 0) {
                [self requestGetEssayCollection];
            }else{
                [self requestGetWorkCollection];
            }
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
        [_tableview registerNib:[UINib nibWithNibName:LPCollectionEssayCellID bundle:nil] forCellReuseIdentifier:LPCollectionEssayCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPCollectionWorkCellID bundle:nil] forCellReuseIdentifier:LPCollectionWorkCellID];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            if (self.index == 0) {
                [self requestGetEssayCollection];
            }else{
                [self requestGetWorkCollection];
            }
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.index == 0) {
                [self requestGetEssayCollection];
            }else{
                [self requestGetWorkCollection];
            }
        }];
    }
    return _tableview;
}
@end
