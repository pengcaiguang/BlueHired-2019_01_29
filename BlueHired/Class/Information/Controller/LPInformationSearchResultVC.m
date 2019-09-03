//
//  LPInformationSearchResultVC.m
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationSearchResultVC.h"
#import "LPEssaylistModel.h"
#import "LPInformationSingleCell.h"
#import "LPInformationMoreCell.h"
#import "LPEssayDetailVC.h"
#import "LPVideoListModel.h"
#import "LPInfoMationVideoCell.h"
#import "LPVideoVC.h"
#import "LPMoodListModel.h"
#import "LPCircleListCell.h"
#import "LPMoodDetailVC.h"


static NSString *LPCircleListCellID = @"LPCircleListCell";
static NSString *LPInformationSingleCellID = @"LPInformationSingleCell";
static NSString *LPInformationMoreCellID = @"LPInformationMoreCell";
static NSString *LPInformationVideoCollectionViewCellID = @"LPInfoMationVideoCell";

@interface LPInformationSearchResultVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SDTimeLineCellDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPVideoListModel *VideoListModel;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPEssaylistModel *model;
@property(nonatomic,strong) NSMutableArray <LPEssaylistDataModel *>*listArray;
@property(nonatomic,strong) NSMutableArray <LPVideoListDataModel *>*VideolistArray;
@property (nonatomic, assign) BOOL isReloadData;

@property(nonatomic,strong) LPMoodListModel *moodListModel;
@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;

@end

@implementation LPInformationSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"搜索结果";
    self.page = 1;
    self.listArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.videocollectionView];
    [self.videocollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.Type == 1) {
        [self requestEssaylist];
        self.tableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }else if (self.Type == 2){
        [self requestQueryGetVideoList];
        self.tableview.hidden = YES;
        self.videocollectionView.hidden = NO;
    }else if (self.Type == 3){
        [self requestMoodList];
        self.tableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }

}

-(void)setModel:(LPEssaylistModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.listArray.count == 0) {
            [self addNodataView];
        }
        [self.tableview reloadData];
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}


-(void)setVideoListModel:(LPVideoListModel *)VideoListModel{
    _VideoListModel = VideoListModel;
    
    if ([self.VideoListModel.code integerValue] == 0) {
        self.isReloadData = NO;
        if (self.page == 1) {
            self.VideolistArray = [NSMutableArray array];
        }
        if (self.VideoListModel.data.count > 0) {
            self.page += 1;
            [self.VideolistArray addObjectsFromArray:self.VideoListModel.data];
            [self.videocollectionView reloadData];
            if (self.VideoListModel.data.count<20) {
                [self.videocollectionView.mj_footer endRefreshingWithNoMoreData];
                self.isReloadData = YES;
            }
        }else{
            if (self.page == 1) {
                [self.videocollectionView reloadData];
            }else{
                [self.videocollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            self.isReloadData = YES;

        }
        //
        if (self.VideolistArray.count == 0) {
            [self addNodataView];
        }else{
            
         }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}



-(void)setMoodListModel:(LPMoodListModel *)moodListModel{
    _moodListModel = moodListModel;
    if ([moodListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.moodListArray = [NSMutableArray array];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
            //                [self.tableview scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //            });
        }
        if (moodListModel.data.count > 0) {
            self.page += 1;
            [self.moodListArray addObjectsFromArray:moodListModel.data];
            [self.tableview reloadData];
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
                
                
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.moodListArray.count == 0) {
            [self addNodataView];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}



-(void)addNodataView{
    LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:noDataView];
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.Type== 3) {
        return self.moodListArray.count;
    }
    return self.listArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.Type == 3) {
        LPMoodListDataModel *model = self.moodListArray[indexPath.row];
        CGFloat DetailsHeight = [LPTools calculateRowHeight:model.moodDetails fontSize:15 Width:SCREEN_WIDTH - 71];
//        [self calculateCommentHeight:model];
        CGFloat CommentHeight = 0;
        if (DetailsHeight>90) {
            if ([[LPTools isNullToString:model.address] isEqualToString:@""] || [model.address isEqualToString:@"保密"]) {
                //        89 + (DetailsHeight>=80?80:DetailsHeight+5)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
                return   89 + (model.isOpening?DetailsHeight+43:128)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
            }else{
                return   107 + (model.isOpening?DetailsHeight+43:128)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
            }
        }else{
            if ([[LPTools isNullToString:model.address] isEqualToString:@""] || [model.address isEqualToString:@"保密"]) {
                //        89 + (DetailsHeight>=80?80:DetailsHeight+5)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
                return   89 + DetailsHeight + 5 + [self calculateImageHeight:model.moodUrl]  +CommentHeight;
            }else{
                return   107 + DetailsHeight + 5 + [self calculateImageHeight:model.moodUrl]  +CommentHeight;
            }
        }
    }else if (self.Type == 1){
        NSArray *array = @[];
        if (self.listArray.count > indexPath.row) {
            array = [self.listArray[indexPath.row].essayUrl componentsSeparatedByString:@";"];
        }
        if (array.count ==0) {
            return 40.0;
        }else if (array.count == 1|| array.count == 2){
            return 110.0;
        }else{
            return 150.0;
        }
    }
    
    return 40.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.Type== 1) {
        NSArray *array = @[];
        if (self.listArray.count > indexPath.row) {
            array = [self.listArray[indexPath.row].essayUrl componentsSeparatedByString:@";"];
        }
        if (array.count ==0) {
            return nil;
        }else if (array.count == 1|| array.count == 2) {
            LPInformationSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationSingleCellID];
            if(cell == nil){
                cell = [[LPInformationSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationSingleCellID];
            }
            cell.model = self.listArray[indexPath.row];
            return cell;
        }else{
            LPInformationMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationMoreCellID];
            if(cell == nil){
                cell = [[LPInformationMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationMoreCellID];
            }
            cell.model = self.listArray[indexPath.row];
            return cell;
        }
    }else{
        LPCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCircleListCellID];
        if(cell == nil){
            cell = [[LPCircleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPCircleListCellID];
        }
        cell.model = self.moodListArray[indexPath.row];
        cell.indexPath = indexPath;
        cell.SuperTableView = tableView;
        cell.moodListArray = self.moodListArray;
        cell.ClaaViewType = 1;
        
        cell.CommentView.hidden = YES;
        cell.TriangleView.hidden = YES;
        cell.operationButton.hidden = YES;
        
        cell.delegate =self;
        WEAK_SELF()
        cell.Block = ^(void){
            weakSelf.page = 1;
            [weakSelf requestMoodList];
        };
        
        cell.PraiseBlock = ^(void){
            [weakSelf.tableview reloadData];
        };
        if (!cell.moreButtonClickedBlock) {
            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                weakSelf.moodListArray[indexPath.row].isOpening = !weakSelf.moodListArray[indexPath.row].isOpening;
                //            [weakSelf.tableview reloadSections:indexPath withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableview reloadData];
                
            }];
        }
        cell.VideoBlock =  ^(NSString *VideoUrl,UIImageView *view){
            //播放网络url视频 先下载 再播放
            WJMoviePlayerView *playerView = [[WJMoviePlayerView alloc] init];
            playerView.movieURL = [NSURL URLWithString:VideoUrl];
            playerView.coverView = view;
            [playerView show];
        };
        
        
        return cell;
    }
}
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell  with:(NSIndexPath *)indexPath
{
    LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
 
    vc.hidesBottomBarWhenPushed = YES;
    vc.moodListDataModel = self.moodListArray[indexPath.row];
    vc.moodListArray = self.moodListArray;
    vc.SuperTableView = self.tableview;
    
    [self.navigationController pushViewController:vc animated:YES];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        LPCircleListCell *cell = (LPCircleListCell*)[self.tableview cellForRowAtIndexPath:indexPath];
//        cell.viewLabel.text = [NSString stringWithFormat:@"%ld",[cell.viewLabel.text integerValue] + 1];
//        self.moodListArray[indexPath.row].view = @([cell.viewLabel.text integerValue]);
//    });
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.Type == 1) {
        LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
        vc.essaylistDataModel = self.listArray[indexPath.row];
        vc.Supertableview = self.tableview;
        vc.essaylistDataModel = self.listArray[indexPath.row];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            LPEssaylistDataModel *model = self.listArray[indexPath.row];
            model.view = @(model.view.integerValue +1);
            
            NSString *viewStr = @"";
            if (model.view.integerValue>10000) {
                viewStr = [NSString stringWithFormat:@"%.1fw", model.view.integerValue/10000.0] ;
            }else{
                viewStr = model.view ? [model.view stringValue] : @"0";
            }
            
            if ([cell isKindOfClass:[LPInformationSingleCell class]]) {
                LPInformationSingleCell *c = (LPInformationSingleCell *)cell;
                c.viewLabel.text = viewStr;
            }else if ([cell isKindOfClass:[LPInformationMoreCell class]]) {
                LPInformationMoreCell *c = (LPInformationMoreCell *)cell;
                c.viewLabel.text = viewStr;
            }
        });
    }
    
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.VideolistArray.count;
 }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LPInfoMationVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInformationVideoCollectionViewCellID forIndexPath:indexPath];
    cell.model = self.VideolistArray[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.videocollectionView) {
//        LPVideoVC *vc = [[LPVideoVC alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.listArray = self.VideolistArray;
//        vc.VideoRow = indexPath.row;
//        vc.KeySuperVC = self;
//        vc.page = self.page;
//        vc.Type = 2;
//        vc.key = self.string;
//        vc.isReloadData = self.isReloadData;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
         if ([DeviceUtils deviceType] == IPhone_X) {
            return CGSizeMake((SCREEN_WIDTH-21)/2 ,(SCREEN_WIDTH-21)/2*230/172);
        }else{
            return CGSizeMake((SCREEN_WIDTH-21)/2 ,(SCREEN_WIDTH-21)/2*230/172);
        }
   }

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
         return UIEdgeInsetsMake(8, 8, 8, 8);
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
         return 5;
  
}

//cell的最小列间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
         return 5;
 
}

#pragma mark - request
-(void)requestEssaylist{
    NSDictionary *dic = @{
                          @"key":self.string,
                          @"page":@(self.page)
                          };
    [NetApiManager requestEssaylistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPEssaylistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetVideoList{
    
    //计算ids
    NSString *ids =@"";
    if (self.listArray.count<=40) {
        for (LPVideoListDataModel *m in self.VideolistArray) {
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }else{
        for (int i = self.VideolistArray.count-40 ; i<self.VideolistArray.count ; i++) {
            LPVideoListDataModel *m = self.VideolistArray[i];
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }
    NSLog(@"ids = %@",ids);
    
    NSDictionary *dic = @{@"videoName":self.string,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"ids":ids
                          };
    [NetApiManager requestQueryGetVideoList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.videocollectionView.mj_header endRefreshing];
        [self.videocollectionView.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.VideoListModel = [LPVideoListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}





-(void)requestMoodList{
    NSInteger type = 0;
    NSDictionary *dic = @{@"page":@(self.page),
                          @"type":@(type),
                          @"moodDetails":self.string,
                          @"versionType":@"2.4"
                          };
    [NetApiManager requestMoodListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [DSBaActivityView hideActiviTy];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.moodListModel = [LPMoodListModel mj_objectWithKeyValues:responseObject];
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
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        if (self.Type == 3) {
            _tableview.estimatedRowHeight = 0;
        }else if (self.Type == 1){
            _tableview.estimatedRowHeight = 100;
        }
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPInformationSingleCellID bundle:nil] forCellReuseIdentifier:LPInformationSingleCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPCircleListCellID bundle:nil] forCellReuseIdentifier:LPCircleListCellID];

        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            if (self.Type== 1) {
                self.page = 1;
                [self requestEssaylist];
            }else if (self.Type == 3){
                self.page = 1;
                [self requestMoodList];
            }

        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.Type == 1) {
                [self requestEssaylist];
            }else if (self.Type == 3){
                [self requestMoodList];
            }
        }];
    }
    return _tableview;
}




- (UICollectionView *)videocollectionView{
    if (!_videocollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //         layout.minimumInteritemSpacing = 3;// 垂直方向的间距
        //        layout.minimumLineSpacing = 3; // 水平方向的间距
        _videocollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _videocollectionView.backgroundColor = [UIColor whiteColor];
        _videocollectionView.showsHorizontalScrollIndicator = NO;
        _videocollectionView.dataSource = self;
        _videocollectionView.delegate = self;
        _videocollectionView.pagingEnabled = NO;
        [_videocollectionView registerNib:[UINib nibWithNibName:LPInformationVideoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPInformationVideoCollectionViewCellID];
//        _videocollectionView.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            self.page = 1;
//            [self requestQueryGetVideoList];
//        }];
        _videocollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetVideoList];
        }];
    }
    return _videocollectionView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 

//计算图片高度
- (CGFloat)calculateImageHeight:(NSString *)string
{
    if (kStringIsEmpty(string)) {
        return 0;
    }
    CGFloat imgw = (SCREEN_WIDTH-70 - 10)/3;
    NSArray *imageArray = [string componentsSeparatedByString:@";"];
    if (imageArray.count ==1)
    {
        return 250;
    }
    else
    {
        return ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
    }
}

//计算点赞和评论高度
- (CGFloat)calculateCommentHeight:(LPMoodListDataModel *)model
{
    CGFloat Praiseheighe = 0.0;
    if (model.praiseList.count) {
        NSString *PraiseStr = @"♡ ";
        if (model.praiseList.count>10) {
            for (int i = 0 ;i <10 ;i++ ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,model.praiseList[i].userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
            PraiseStr = [NSString stringWithFormat:@"%@等%lu人觉得很赞",PraiseStr,model.praiseList.count];
        }else{
            for (LPMoodPraiseListDataModel *Pmodel in model.praiseList ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,Pmodel.userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
        }
        Praiseheighe = [LPTools calculateRowHeight:PraiseStr fontSize:13 Width:SCREEN_WIDTH-70-14];
        //        Praiseheighe = Praiseheighe >48 ?48:Praiseheighe;
        Praiseheighe = Praiseheighe + 14;
    }else{
        Praiseheighe = 0.0;
    }
    
    CGFloat commentheighe = 0.0;
    if (model.commentModelList.count) {
        
        for (int i =0; i < model.commentModelList.count; i++) {
            LPMoodCommentListDataModel   *CModel = model.commentModelList[i];
            NSString *CommentStr;
            if (CModel.toUserName) {        //回复
                CommentStr = [NSString stringWithFormat:@"%@ 回复 %@:%@",CModel.toUserName,CModel.userName,CModel.commentDetails];
            }else{      //评论
                CommentStr = [NSString stringWithFormat:@"%@:%@",CModel.userName,CModel.commentDetails];
            }
            commentheighe += [LPTools calculateRowHeight:CommentStr fontSize:13 Width:SCREEN_WIDTH-70-14]+7;
        }
        if (model.commentModelList.count >=5) {
            commentheighe += 23;
        }
        commentheighe += 7;
    }else{
        commentheighe = 0.0;
    }
    
    if (commentheighe || Praiseheighe) {
        return floor(commentheighe + Praiseheighe +16);
        
    }
    
    
    return floor(commentheighe + Praiseheighe);
}

@end
