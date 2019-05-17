//
//  LPCollectionCollectionViewCell.m
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionCollectionViewCell.h"
#import "LPEssayCollectionModel.h"
#import "LPWorkCollectionModel.h"
#import "LPCollectionEssayCell.h"
#import "LPCollectionWorkCell.h"
#import "LPWorkDetailVC.h"
#import "LPEssayDetailVC.h"
#import "LPVideoCollectionModel.h"
#import "LPCollectionVideoCell.h"
#import "LPVideoVC.h"

static NSString *LPCollectionEssayCellID = @"LPCollectionEssayCell";
static NSString *LPCollectionWorkCellID = @"LPCollectionWorkCell";
static NSString *LPCollectionVideoCellID = @"LPCollectionVideoCell";

@interface LPCollectionCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPWorkCollectionModel *workCollectionModel;
@property(nonatomic,strong) LPEssayCollectionModel *essayCollectionModel;
@property(nonatomic,strong) LPVideoCollectionModel *VideoCollectionModel;

@property(nonatomic,strong) NSMutableArray <LPWorkCollectionDataModel *>*wordListArray;
@property(nonatomic,strong) NSMutableArray <LPEssayCollectionDataModel *>*essayListArray;
@property(nonatomic,strong) NSMutableArray <LPVideoCollectionDataModel *>*VideoListArray;

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
//        make.edges.equalTo(self.contentView);
        make.top.left.right.bottom.mas_offset(0);
    }];
}
#pragma mark - setdata
-(void)setIndex:(NSInteger)index{
    _index = index;
    self.page = 1;
    if (index == 0) {
        [self requestGetEssayCollection];
    }else if (index == 1){
//        [self requestGetWorkCollection];
        [self requestGetVideoCollection];
    }else if (index == 2){
        [self requestGetVideoCollection];
     }
    
}
-(void)setSelectStatus:(BOOL)selectStatus{
    _selectStatus = selectStatus;

//    [self.tableview reloadData];
}
-(void)setSelectAll:(BOOL)selectAll{
    _selectAll = selectAll;
    if (selectAll) {
         [self.selectArray removeAllObjects];
        if (self.index == 0) {
            self.selectArray = [self.essayListArray mutableCopy];
        }else if (self.index == 1){
//            self.selectArray = [self.wordListArray mutableCopy];
            self.selectArray = [self.VideoListArray mutableCopy];

        }else if (self.index == 2){
            self.selectArray = [self.VideoListArray mutableCopy];
        }
    }else{
        [self.selectArray removeAllObjects];
    }
    [self.tableview reloadData];
}

-(void)TableViewReload{
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
        }else{
            if (self.page == 1) {
//                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [self.selectArray removeAllObjects];
        if (self.AllButton.selected && self.selectStatus) {
            self.selectArray = [self.essayListArray mutableCopy];
        }
        
        [self.tableview reloadData];
        if (self.essayListArray.count == 0) {
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
-(void)setWorkCollectionModel:(LPWorkCollectionModel *)workCollectionModel{
    _workCollectionModel = workCollectionModel;
    if ([workCollectionModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.wordListArray = [NSMutableArray array];
        }
        if (workCollectionModel.data.count > 0) {
            self.page += 1;
            [self.wordListArray addObjectsFromArray:workCollectionModel.data];
//            [self.tableview reloadData];
        }else{
            if (self.page == 1) {
//                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.selectArray removeAllObjects];
        if (self.AllButton.selected && self.selectStatus) {
            self.selectArray = [self.wordListArray mutableCopy];
        }
        [self.tableview reloadData];
        
        if (self.wordListArray.count == 0) {
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



-(void)setVideoCollectionModel:(LPVideoCollectionModel *)VideoCollectionModel{
    _VideoCollectionModel = VideoCollectionModel;
    if ([VideoCollectionModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.VideoListArray = [NSMutableArray array];
        }
        if (VideoCollectionModel.data.count > 0) {
            self.page += 1;
            [self.VideoListArray addObjectsFromArray:VideoCollectionModel.data];
            //            [self.tableview reloadData];
        }else{
            if (self.page == 1) {
                //                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.selectArray removeAllObjects];
        if (self.AllButton.selected && self.selectStatus) {
            self.selectArray = [self.VideoListArray mutableCopy];
        }
        [self.tableview reloadData];
        
        if (self.VideoListArray.count == 0) {
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
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
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
    if (self.index == 0) {
        return self.essayListArray.count;
    }else if (self.index == 1){
//        return self.wordListArray.count;
        return self.VideoListArray.count;
    }else{
        return self.VideoListArray.count;
     }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        LPCollectionEssayCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionEssayCellID];
        cell.model = self.essayListArray[indexPath.row];
        cell.selectStatus = self.selectStatus;
//        cell.selectAll = self.selectAll;
        
        if ([self.selectArray containsObject:cell.model]) {
            cell.selectButton.selected = YES;
         }else{
             cell.selectButton.selected = NO;
         }
        
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
            
            if (self.selectArray.count == self.essayListArray.count) {
                self.AllButton.selected = YES;
            }
            else
            {
                self.AllButton.selected = NO;
            }
        };
        return cell;
    }else if (self.index == 1){
//        LPCollectionWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionWorkCellID];
//        cell.model = self.wordListArray[indexPath.row];
//        cell.selectStatus = self.selectStatus;
////        cell.selectAll = self.selectAll;
//        if (self.selectStatus) {
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }else{
//            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        }
//
//        if ([self.selectArray containsObject:cell.model]) {
//            cell.selectButton.selected = YES;
//        }else{
//            cell.selectButton.selected = NO;
//        }
//
//        cell.selectBlock = ^(LPWorkCollectionDataModel * _Nonnull model) {
//            if ([self.selectArray containsObject:model]) {
//                [self.selectArray removeObject:model];
//            }else{
//                [self.selectArray addObject:model];
//            }
//
//            if (self.selectArray.count == self.wordListArray.count) {
//                self.AllButton.selected = YES;
//            }
//            else
//            {
//                self.AllButton.selected = NO;
//            }
//        };
//        return cell;
        
        
        
        
        LPCollectionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionVideoCellID];
        cell.model = self.VideoListArray[indexPath.row];
        cell.selectStatus = self.selectStatus;
        //        cell.selectAll = self.selectAll;
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
        
        cell.selectBlock = ^(LPVideoCollectionDataModel * _Nonnull model) {
            if ([self.selectArray containsObject:model]) {
                [self.selectArray removeObject:model];
            }else{
                [self.selectArray addObject:model];
            }
            
            if (self.selectArray.count == self.wordListArray.count) {
                self.AllButton.selected = YES;
            }
            else
            {
                self.AllButton.selected = NO;
            }
        };
        return cell;
        
        
    }else{
        LPCollectionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionVideoCellID];
        cell.model = self.VideoListArray[indexPath.row];
        cell.selectStatus = self.selectStatus;
        //        cell.selectAll = self.selectAll;
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
        
        cell.selectBlock = ^(LPVideoCollectionDataModel * _Nonnull model) {
            if ([self.selectArray containsObject:model]) {
                [self.selectArray removeObject:model];
            }else{
                [self.selectArray addObject:model];
            }
            
            if (self.selectArray.count == self.wordListArray.count) {
                self.AllButton.selected = YES;
            }
            else
            {
                self.AllButton.selected = NO;
            }
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectStatus) {
        return;
    }
    
    if (self.index == 0) {
        LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        NSDictionary *dic = [self.essayListArray[indexPath.row] mj_JSONObject];
        vc.essaylistDataModel = [LPEssaylistDataModel mj_objectWithKeyValues:dic];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LPCollectionEssayCell *cell = (LPCollectionEssayCell*)[tableView cellForRowAtIndexPath:indexPath];
            LPEssayCollectionDataModel *model = self.essayListArray[indexPath.row];
            model.view = @(model.view.integerValue +1);
            if (model.view.integerValue>10000) {
                cell.viewLabel.text = [NSString stringWithFormat:@"%.1fw", model.view.integerValue/10000.0] ;
            }else{
                cell.viewLabel.text = model.view ? [model.view stringValue] : @"0";
            }
 
        });
    }else if (self.index == 1){
//        LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        NSDictionary *dic = [self.wordListArray[indexPath.row] mj_JSONObject];
//        vc.workListModel = [LPWorklistDataWorkListModel mj_objectWithKeyValues:dic];
//        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        NSDictionary *dic = [self.VideoListArray[indexPath.row] mj_JSONObject];
        
        LPVideoListDataModel *Model= [LPVideoListDataModel mj_objectWithKeyValues:dic];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:Model];
        LPVideoVC *vc = [[LPVideoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.listArray = arr;
        vc.VideoRow = indexPath.row;
        //        vc.page = self.page;
        vc.Type = 3;
        vc.isReloadData = YES;
        vc.VideoRow  =0 ;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }else if (self.index == 2){
        NSDictionary *dic = [self.VideoListArray[indexPath.row] mj_JSONObject];

        LPVideoListDataModel *Model= [LPVideoListDataModel mj_objectWithKeyValues:dic];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:Model];
        LPVideoVC *vc = [[LPVideoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
         vc.listArray = arr;
        vc.VideoRow = indexPath.row;
         //        vc.page = self.page;
        vc.Type = 3;
        vc.isReloadData = YES;
        vc.VideoRow  =0 ;
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
            if ([responseObject[@"code"] integerValue] == 0) {
                 self.workCollectionModel = [LPWorkCollectionModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
            if ([responseObject[@"code"] integerValue] == 0) {
                self.essayCollectionModel = [LPEssayCollectionModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
//获取视频收藏列表
-(void)requestGetVideoCollection{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          };
    [NetApiManager requestQueryGetVideoCollection:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.VideoCollectionModel = [LPVideoCollectionModel mj_objectWithKeyValues:responseObject];
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
    if (self.index == 0) {
        for (LPEssayCollectionDataModel *model in self.selectArray) {
            [array addObject:model.collectId];
        }
    }else if (self.index == 1){
//        for (LPWorkCollectionDataModel *model in self.selectArray) {
//            [array addObject:model.collectId];
//        }
        for (LPVideoCollectionDataModel *model in self.selectArray) {
            [array addObject:model.collectId];
        }
    }else if (self.index == 2){
        for (LPVideoCollectionDataModel *model in self.selectArray) {
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
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.selectArray removeAllObjects];
                    self.page = 1;
                    if (self.index == 0) {
                        [self requestGetEssayCollection];
                    }else if (self.index == 1){
                        //                [self requestGetWorkCollection];
                        [self requestGetVideoCollection];
                    }else if (self.index == 2){
                        [self requestGetVideoCollection];
                    }
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [[UIWindow visibleViewController].view showLoadingMeg:@"删除失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
        [_tableview registerNib:[UINib nibWithNibName:LPCollectionEssayCellID bundle:nil] forCellReuseIdentifier:LPCollectionEssayCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPCollectionWorkCellID bundle:nil] forCellReuseIdentifier:LPCollectionWorkCellID];
                [_tableview registerNib:[UINib nibWithNibName:LPCollectionVideoCellID bundle:nil] forCellReuseIdentifier:LPCollectionVideoCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            if (self.index == 0) {
                [self requestGetEssayCollection];
            }else if (self.index == 1){
//                [self requestGetWorkCollection];
                [self requestGetVideoCollection];
            }else if (self.index == 2){
                [self requestGetVideoCollection];
            }
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.index == 0) {
                [self requestGetEssayCollection];
            }else if (self.index == 1){
//                [self requestGetWorkCollection];
                [self requestGetVideoCollection];
            }else if (self.index == 2){
                [self requestGetVideoCollection];
            }
        }];
    }
    return _tableview;
}
@end
