//
//  LPCollectionView.m
//  BlueHired
//
//  Created by iMac on 2019/11/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPCollectionView.h"
#import "LPEssayCollectionModel.h"
#import "LPWorkCollectionModel.h"
#import "LPMain2Cell.h"
#import "LPVideoCollectionModel.h"
#import "LPCollectionEssayCell.h"
#import "LPRecreationVideoCell.h"
#import "LPEssayDetailVC.h"
#import "LPWorkDetailVC.h"

static NSString *LPCollectionEssayCellID = @"LPCollectionEssayCell";
static NSString *LPCollectionWorkCellID = @"LPMain2Cell";
static NSString *LPCollectionVideoCellID = @"LPRecreationVideoCell";

@interface LPCollectionView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPWorkCollectionModel *workCollectionModel;
@property(nonatomic,strong) LPEssayCollectionModel *essayCollectionModel;
@property(nonatomic,strong) LPVideoCollectionModel *VideoCollectionModel;

@property(nonatomic,strong) NSMutableArray <LPWorkCollectionDataModel *>*wordListArray;
@property(nonatomic,strong) NSMutableArray <LPEssayCollectionDataModel *>*essayListArray;
@property(nonatomic,strong) NSMutableArray <LPRecreationVideoListModel *>*VideoListArray;

@property(nonatomic,strong) NSMutableArray *selectArray;

@end

@implementation LPCollectionView

 - (instancetype)initWithFrame:(CGRect)frame
 {
     self = [super initWithFrame:frame];
     if (self) {
         self.wordListArray = [NSMutableArray array];
         self.essayListArray = [NSMutableArray array];
         self.selectArray = [NSMutableArray array];
         
         [self addSubview:self.tableview];
         [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self);
         }];
     }
     return self;
 }


-(void)GetList{
    self.page = 1;
    if (self.index == 0) {
        [self requestGetEssayCollection];
    }else if (self.index == 1){
        [self requestGetWorkCollection];
//        [self requestGetVideoCollection];
    }else if (self.index == 2){
        [self requestGetVideoCollection];
     }
}

-(void)setSelectStatus:(BOOL)selectStatus{
    _selectStatus = selectStatus;
    if (!selectStatus) {
        [self.selectArray removeAllObjects];
    }
    [self.tableview reloadData];
}

- (void)setAllButton:(UIButton *)AllButton{
    _AllButton = AllButton;
    [self.selectArray removeAllObjects];

    if (self.AllButton.selected && self.selectStatus && self.index == 0) {
        self.selectArray = [self.essayListArray mutableCopy];
    }
    
    if (self.AllButton.selected && self.selectStatus && self.index == 1) {
        self.selectArray = [self.wordListArray mutableCopy];
    }
    
    if (self.AllButton.selected && self.selectStatus && self.index == 2) {
        self.selectArray = [self.VideoListArray mutableCopy];
    }
    [self.tableview reloadData];
}

-(void)setSelectAll:(BOOL)selectAll{
    _selectAll = selectAll;
    if (selectAll) {
         [self.selectArray removeAllObjects];
        if (self.index == 0) {
            self.selectArray = [self.essayListArray mutableCopy];
        }else if (self.index == 1){
            self.selectArray = [self.wordListArray mutableCopy];
        }else if (self.index == 2){
            self.selectArray = [self.VideoListArray mutableCopy];
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
            if (essayCollectionModel.data.count < 20 ) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
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
        [self showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
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
            if (workCollectionModel.data.count < 20 ) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
         }else{
            if (self.page == 1) {
 
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
        [self showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
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
            if (VideoCollectionModel.data.count < 20 ) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
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
        [self showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}

#pragma mark - TableViewDelegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        return LENGTH_SIZE(96);
    }else if (self.index == 1){
         
        return LENGTH_SIZE(86) ;
    }
    return LENGTH_SIZE(246);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.index == 0) {
        return self.essayListArray.count;
    }else if (self.index == 1){
        return self.wordListArray.count;
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
        LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionWorkCellID];
        cell.Cmodel = self.wordListArray[indexPath.row];
        cell.selectStatus = self.selectStatus;
//        cell.selectAll = self.selectAll;
        if (self.selectStatus) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }

        if ([self.selectArray containsObject:cell.Cmodel]) {
            cell.selectButton.selected = YES;
        }else{
            cell.selectButton.selected = NO;
        }

        cell.selectBlock = ^(LPWorkCollectionDataModel * _Nonnull model) {
            if ([self.selectArray containsObject:model]) {
                [self.selectArray removeObject:model];
            }else{
                [self.selectArray addObject:model];
            }

            if (self.selectArray.count == self.wordListArray.count) {
                self.AllButton.selected = YES;
            }else{
                self.AllButton.selected = NO;
            }
        };
        return cell;
        
    }else{
        LPRecreationVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCollectionVideoCellID];
        cell.model = self.VideoListArray[indexPath.row];
        cell.selectStatus = self.selectStatus;
        cell.index = indexPath.row;
        cell.superTableView = tableView;

        WEAK_SELF()
        cell.playerBlock = ^(LSPlayerView * _Nonnull player) {
            weakSelf.PlayerView = player;
        };
        
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
        
        cell.selectBlock = ^(LPRecreationVideoListModel * _Nonnull model) {
            if ([self.selectArray containsObject:model]) {
                [self.selectArray removeObject:model];
            }else{
                [self.selectArray addObject:model];
            }
            
            if (self.selectArray.count == self.VideoListArray.count) {
                self.AllButton.selected = YES;
            }else{
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
    WEAK_SELF()
    if (self.index == 0) {
        LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        NSDictionary *dic = [self.essayListArray[indexPath.row] mj_JSONObject];
        vc.essaylistDataModel = [LPRecreationEssayListModel mj_objectWithKeyValues:dic];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        
        vc.CollectionBlock = ^(void){
            [weakSelf.essayListArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableview reloadData];
        };
     }else if (self.index == 1){
        LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        NSDictionary *dic = [self.wordListArray[indexPath.row] mj_JSONObject];
        vc.workListModel = [LPWorklistDataWorkListModel mj_objectWithKeyValues:dic];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        vc.CollectionBlock = ^(void){
            [weakSelf.wordListArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableview reloadData];
        };
     }else if (self.index == 2){
         
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
        for (LPWorkCollectionDataModel *model in self.selectArray) {
            [array addObject:model.collectId];
        }
    }else if (self.index == 2){
        for (LPRecreationVideoListModel *model in self.selectArray) {
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
                    if (self.index == 0) {
                        [self.essayListArray removeObjectsInArray:self.selectArray];
                        if (self.essayListArray.count == 0) {
                            self.tableview.mj_footer.alpha = 0;
                            [self addNodataViewHidden:NO];
                        }else{
                            self.tableview.mj_footer.alpha = 1;
                            [self addNodataViewHidden:YES];
                        }
                    }else if (self.index == 1){
                        
                        [self.wordListArray removeObjectsInArray:self.selectArray];
                        if (self.wordListArray.count == 0) {
                            self.tableview.mj_footer.alpha = 0;
                            [self addNodataViewHidden:NO];
                        }else{
                            self.tableview.mj_footer.alpha = 1;
                            [self addNodataViewHidden:YES];
                        }
                    }else if (self.index == 2){
                        [self.VideoListArray removeObjectsInArray:self.selectArray];
                        if (self.VideoListArray.count == 0) {
                            self.tableview.mj_footer.alpha = 0;
                            [self addNodataViewHidden:NO];
                        }else{
                            self.tableview.mj_footer.alpha = 1;
                            [self addNodataViewHidden:YES];
                        }
                    }
                    
                    
                    [self.selectArray removeAllObjects];
                    [self.tableview reloadData];
                    
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
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];

        [_tableview registerNib:[UINib nibWithNibName:LPCollectionEssayCellID bundle:nil] forCellReuseIdentifier:LPCollectionEssayCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPCollectionWorkCellID bundle:nil] forCellReuseIdentifier:LPCollectionWorkCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPCollectionVideoCellID bundle:nil] forCellReuseIdentifier:LPCollectionVideoCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            if (self.index == 0) {
                [self requestGetEssayCollection];
            }else if (self.index == 1){
                [self requestGetWorkCollection];
//                [self requestGetVideoCollection];
            }else if (self.index == 2){
                [self.PlayerView closeClick];
                [self requestGetVideoCollection];
            }
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.index == 0) {
                [self requestGetEssayCollection];
            }else if (self.index == 1){
                [self requestGetWorkCollection];
            }else if (self.index == 2){
                [self requestGetVideoCollection];
            }
        }];
    }
    return _tableview;
}


@end
