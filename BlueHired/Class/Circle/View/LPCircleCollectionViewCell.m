//
//  LPCircleCollectionViewCell.m
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleCollectionViewCell.h"
#import "LPMoodListModel.h"
#import "LPCircleListCell.h"
#import "LPMoodDetailVC.h"
#import "LPCircleInfoListVC.h"
#import "LPUserBillRecordModel.h"

static NSString *LPCircleListCellID = @"LPCircleListCell";

@interface LPCircleCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,SDTimeLineCellDelegate>
@property (nonatomic, strong)UITableView *tableview;
 
@property (nonatomic,strong) UIView *tableHeader2View;
@property (nonatomic,assign) NSInteger page;

 
@property (nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@property (nonatomic,strong) LPMoodListModel *moodListModel;
@property (nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;

@property (nonatomic,strong) UIButton *messageBT;
@property (nonatomic,assign) NSInteger GetMoodUserID;

@property (strong, nonatomic) NSTimer * myTimer;//定时器管控轮播
@property (nonatomic,strong) UIScrollView *RecommendScrollView;
@property (nonatomic,strong) LPUserBillRecordModel *BillModel;

@property (nonatomic,strong) UIView *awardView;

@end

@implementation LPCircleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.page = 1;
    self.labelArray = [NSMutableArray array];
    self.moodListArray = [NSMutableArray array];
    
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
 
    }];
    
    [self requestQueryBillUserBill];
}


-(void)touchMoodTypeSenderBack:(NSInteger )tap{
    self.index = 0;
    self.page = 1;
    [self requestMoodList];
}

-(void)touchMoodTypeDeleteBack{
    [self.tableview reloadData];
}

#pragma mark - setdata
-(void)setIndex:(NSInteger)index{
    _index = index;
 
    if (self.moodListArray.count == 0 ) {
        //查看缓存
        NSDate *date = [LPUserDefaults getObjectByFileName:[NSString stringWithFormat: @"CIRCLELISTCACHEDATE"]];
        id CacheList = [LPUserDefaults getObjectByFileName:[NSString stringWithFormat: @"CIRCLELISTCACHE"]];
         NSString *ISLoginstr = [LPUserDefaults getObjectByFileName:[NSString stringWithFormat: @"CIRCLELISTCACHEISLogin"]];
         if ([LPTools compareOneDay:date withAnotherDay:[NSDate date]]<=15 && CacheList && index == 0) {
             self.page = 1;
             self.moodListModel = [LPMoodListModel mj_objectWithKeyValues:CacheList];
             if (ISLoginstr.integerValue == 1) {
                 self.page = 1;
                 [self requestMoodList];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [LPUserDefaults saveObject:@"0" byFileName:[NSString stringWithFormat:@"CIRCLELISTCACHEISLogin"]];
                  });
             }
         }else{
             self.page = 1;
             [self requestMoodList];
         }
        
        return;
    }else{
        if (self.GetMoodUserID != kUserDefaultsValue(LOGINID).integerValue) {
            self.page = 1;
            [self requestMoodList];
        }
    }
 
}

- (void)setCircleMessage:(NSInteger)CircleMessage{
    _CircleMessage = CircleMessage;
 
    [self.tableview  reloadData];

}
 

- (void)setBillModel:(LPUserBillRecordModel *)BillModel{
    _BillModel = BillModel;
    [self.RecommendScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i =0 ;i <self.BillModel.data.count;i++) {
            LPUserBillRecordDataModel *m = self.BillModel.data[i];
        
            UILabel *Typelabel= [[UILabel alloc] initWithFrame:CGRectMake(LENGTH_SIZE(22),
                                                                  i*floorf(LENGTH_SIZE(25)),
                                                                  LENGTH_SIZE(87),
                                                                  floorf(LENGTH_SIZE(25)))];
            [self.RecommendScrollView addSubview:Typelabel];
        Typelabel.textColor = [UIColor colorWithHexString:@"#FF306A"];
        Typelabel.font = [UIFont boldSystemFontOfSize:FontSize(13)];
        Typelabel.textAlignment = NSTextAlignmentCenter;
        if (m.type.integerValue == 4) {
            Typelabel.text = @"返费奖励";
        }else if (m.type.integerValue == 5){
            Typelabel.text = @"邀请注册奖励";
        }else if (m.type.integerValue == 8){
            Typelabel.text = @"邀请入职奖励";
        }else if (m.type.integerValue == 12){
            Typelabel.text = @"分享点赞奖励";
        }
              
            UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(LENGTH_SIZE(117),
                                                                         i*floorf(LENGTH_SIZE(25)),
                                                                         SCREEN_WIDTH-LENGTH_SIZE(130),
                                                                         floorf(LENGTH_SIZE(25)))];
           [self.RecommendScrollView addSubview:label];
           label.text = [NSString stringWithFormat:@"%@获得%@元",m.userName,m.money];
           label.textColor = [UIColor whiteColor];
           label.font = [UIFont boldSystemFontOfSize:FontSize(14)];
           label.textAlignment = NSTextAlignmentLeft;
           
           NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
           [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FFC4D8"],
                                   NSFontAttributeName: FONT_SIZE(14)}
                           range:[label.text rangeOfString:@"获得"]];
        
           label.attributedText = string;

//            label.backgroundColor = [UIColor redColor];
       }
       self.RecommendScrollView.contentSize = CGSizeMake(0, self.BillModel.data.count*floorf(LENGTH_SIZE(25)));
    
    [_myTimer invalidate];
    _myTimer = nil;
    
    if (BillModel.data.count>0) {
        [self.RecommendScrollView setContentOffset:CGPointMake(0, 0)];
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeScrollContentOffSetY) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
    [self.tableview reloadData];
}

-(void)setMoodListModel:(LPMoodListModel *)moodListModel{
    _moodListModel = moodListModel;
    if ([moodListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.moodListArray = [NSMutableArray array];
            self.GetMoodUserID = kUserDefaultsValue(LOGINID).integerValue;
 
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
    LPNoDataView *noDataView ;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            noDataView = (LPNoDataView *)view;
            has = YES;
        }
    }
    if (!has) {
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableview.lx_height)];

        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
 
    [noDataView image:nil text:@"赶紧来抢占一楼吧!"];
     
     
    
}
 
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.RecommendScrollView) {
        if (scrollView.contentOffset.y>=scrollView.contentSize.height){
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }

}


#pragma mark - TableViewDelegate & Datasource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.CircleMessage>0 && self.BillModel.data.count == 0 ) {
        return LENGTH_SIZE(47);
    }
    
    if (self.CircleMessage == 0 && self.BillModel.data.count > 0 ) {
        return LENGTH_SIZE(55);
    }
    
    if (self.CircleMessage > 0 && self.BillModel.data.count > 0 ) {
           return LENGTH_SIZE(55 + 47);
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = self.tableHeader2View;
    [self.messageBT setTitle:[NSString stringWithFormat:@"  您有%ld条新消息！ ",(long)_CircleMessage] forState:UIControlStateNormal];

    if (self.CircleMessage>0 && self.BillModel.data.count == 0 ) {
        self.awardView.lx_height = 0;
    }
    
    if (self.CircleMessage == 0 && self.BillModel.data.count > 0 ) {
        self.awardView.lx_height = LENGTH_SIZE(55);
    }
    
    if (self.CircleMessage > 0 && self.BillModel.data.count > 0 ) {
           self.awardView.lx_height = LENGTH_SIZE(55);
    }
    
    
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moodListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMoodListDataModel *model = self.moodListArray[indexPath.row];
    CGFloat DetailsHeight = [LPTools calculateRowHeight:model.moodDetails
                                               fontSize:FontSize(15)
                                                  Width:SCREEN_WIDTH - LENGTH_SIZE(71)];
 
    CGFloat CommentHeight = [self calculateCommentHeight:model];
    if (DetailsHeight>LENGTH_SIZE(90)) {
        if ([[LPTools isNullToString:model.address] isEqualToString:@""] || [model.address isEqualToString:@"保密"]) {
            return   LENGTH_SIZE(89) + (model.isOpening?DetailsHeight+LENGTH_SIZE(43):LENGTH_SIZE(128))+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
        }else{
            return   LENGTH_SIZE(107) + (model.isOpening?DetailsHeight+LENGTH_SIZE(43):LENGTH_SIZE(128))+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
        }
    }else{
        if ([[LPTools isNullToString:model.address] isEqualToString:@""] || [model.address isEqualToString:@"保密"]) {
            return   LENGTH_SIZE(89) + DetailsHeight + LENGTH_SIZE(5) + [self calculateImageHeight:model.moodUrl]  + CommentHeight;
        }else{
            return   LENGTH_SIZE(107) + DetailsHeight + LENGTH_SIZE(5) + [self calculateImageHeight:model.moodUrl]  + CommentHeight;
        }
    }
    
    
 }


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCircleListCellID];
    if(cell == nil){
        cell = [[LPCircleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPCircleListCellID];
    }
    cell.model = self.moodListArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.SuperTableView = tableView;
    cell.moodListArray = self.moodListArray;
    cell.ClaaViewType = 1;

    cell.delegate =self;
    WEAK_SELF()
    cell.Block = ^(void){
        weakSelf.page = 1;
        [weakSelf requestMoodList];
    };
    
    cell.PraiseBlock = ^(void){
        [weakSelf.tableview reloadData];
    };
    
    cell.VideoBlock =  ^(NSString *VideoUrl,UIImageView *view){
        //播放网络url视频 先下载 再播放
        WJMoviePlayerView *playerView = [[WJMoviePlayerView alloc] init];
        playerView.movieURL = [NSURL URLWithString:VideoUrl];
        playerView.coverView = view;
        [playerView show];
    };
    
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            weakSelf.moodListArray[indexPath.row].isOpening = !weakSelf.moodListArray[indexPath.row].isOpening;
//            [weakSelf.tableview reloadSections:indexPath withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableview reloadData];

        }];
    }
    return cell;
}
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell  with:(NSIndexPath *)indexPath
{
         LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];

        vc.hidesBottomBarWhenPushed = YES;
        vc.moodListDataModel = self.moodListArray[indexPath.row];
        vc.moodListArray = self.moodListArray;
        vc.SuperTableView = self.tableview;
        
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}
#pragma mark - request
 

-(void)requestMoodList{
    NSInteger type = 0;
 
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"type":@(type),
                          @"versionType":@"2.4"
                          };
    [NetApiManager requestMoodListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [DSBaActivityView hideActiviTy];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (self.page == 1 && type == 0) {
                    [LPUserDefaults saveObject:responseObject byFileName:[NSString stringWithFormat:@"CIRCLELISTCACHE"]];
                    [LPUserDefaults saveObject:[NSDate date] byFileName:[NSString stringWithFormat: @"CIRCLELISTCACHEDATE"]];
                }
                self.moodListModel = [LPMoodListModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}


-(void)requestQueryInfounreadNum{
    NSDictionary *dic = @{@"type":@(6)
                          };
    [NetApiManager requestQueryUnreadNumWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSInteger num = [responseObject[@"data"] integerValue];
                self.CircleMessage=num;
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryBillUserBill{
    NSDictionary *dic = @{};
    
    [NetApiManager requestQueryBillUserBill:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.BillModel = [LPUserBillRecordModel mj_objectWithKeyValues:responseObject];
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
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
//        _tableview.estimatedRowHeight = 100;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#e0e0e0"];

        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPCircleListCellID bundle:nil] forCellReuseIdentifier:LPCircleListCellID];
//
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestMoodList];
            if (AlreadyLogin) {
                [self requestQueryInfounreadNum];
            }
            [self requestQueryBillUserBill];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMoodList];
        }];
    }
    return _tableview;
}
 

-(UIView *)tableHeader2View{
    if (!_tableHeader2View) {
        _tableHeader2View = [[UIView alloc] init];
        _tableHeader2View.frame = CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(47));
        _tableHeader2View.backgroundColor = [UIColor whiteColor];
        _tableHeader2View.clipsToBounds = YES;

        UIView *awardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(55))];
        [_tableHeader2View addSubview:awardView];
        awardView.clipsToBounds = YES;
        self.awardView = awardView;
        
        UIImageView *Image = [[UIImageView alloc] init];
        [awardView addSubview:Image];
        [Image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        Image.image = [UIImage imageNamed:@"news_bg2"];
        
        UIImageView *Image2 = [[UIImageView alloc] init];
        [awardView addSubview:Image2];
        [Image2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(15));
            make.left.mas_offset(LENGTH_SIZE(22));
            make.width.mas_offset(LENGTH_SIZE(87));
            make.height.mas_offset(LENGTH_SIZE(25));
        }];
        Image2.image = [UIImage imageNamed:@"news_bg1"];
        
        
        [awardView addSubview:self.RecommendScrollView];
        
        UIButton *button = [[UIButton alloc] init];
        self.messageBT = button;
        [_tableHeader2View addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.tableHeader2View);
            make.top.equalTo(awardView.mas_bottom).offset(LENGTH_SIZE(8.5));
            make.height.mas_offset(LENGTH_SIZE(30));
        }];
        button.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.65];
        button.layer.cornerRadius = LENGTH_SIZE(15);
        button.clipsToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(TouchMoreMessage:) forControlEvents:UIControlEventTouchUpInside];
 
        UIView *lineV = [[UIView alloc] init];
        [_tableHeader2View addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(0.5);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    return _tableHeader2View;
}
-(void)TouchMoreMessage:(UIButton *)sender{
    NSLog(@"您有1条新消息");
    LPCircleInfoListVC *vc = [[LPCircleInfoListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];

}



-(UIScrollView *)RecommendScrollView{
    if (!_RecommendScrollView) {
        _RecommendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 , LENGTH_SIZE(15), SCREEN_WIDTH, floorf(LENGTH_SIZE(25)))];
        _RecommendScrollView.delegate = self;
        _RecommendScrollView.showsVerticalScrollIndicator = NO;
        _RecommendScrollView.scrollEnabled = NO;
        _RecommendScrollView.bounces = NO;
//        _RecommendScrollView.backgroundColor = [UIColor whiteColor];
        
     }
    return _RecommendScrollView;
}

-(void)changeScrollContentOffSetY{
    //启动定时器
    CGPoint point = self.RecommendScrollView.contentOffset;
 
    [self.RecommendScrollView setContentOffset:CGPointMake(0, point.y+floorf(LENGTH_SIZE(25))) animated:YES];
    
}
 

//计算图片高度
- (CGFloat)calculateImageHeight:(NSString *)string
{
    if (kStringIsEmpty(string)) {
        return 0;
    }
    CGFloat imgw = (SCREEN_WIDTH - LENGTH_SIZE(70) - LENGTH_SIZE(10))/3;
    NSArray *imageArray = [string componentsSeparatedByString:@";"];
    if (imageArray.count ==1)
    {
        return LENGTH_SIZE(250);
    }
    else
    {
        return ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*LENGTH_SIZE(5);
    }
 }

//计算点赞和评论高度
- (CGFloat)calculateCommentHeight:(LPMoodListDataModel *)model
{
    CGFloat Praiseheighe = 0.0;
    if (model.praiseList.count) {
        NSString *PraiseStr = @"";
        if (model.praiseList.count>10) {
            for (int i = 0 ;i <10 ;i++ ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@，",PraiseStr,model.praiseList[i].userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
            PraiseStr = [NSString stringWithFormat:@"%@等%lu人觉得很赞",PraiseStr,model.praiseList.count];
        }else{
            for (LPMoodPraiseListDataModel *Pmodel in model.praiseList ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@，",PraiseStr,Pmodel.userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
        }
        Praiseheighe = [LPTools calculateRowHeight:PraiseStr fontSize:FontSize(13) Width:SCREEN_WIDTH-LENGTH_SIZE(70) - LENGTH_SIZE(37)];
//        Praiseheighe = Praiseheighe >48 ?48:Praiseheighe;
        Praiseheighe = Praiseheighe + LENGTH_SIZE(14);
    }else{
        Praiseheighe = 0.0;
    }
    
    CGFloat commentheighe = 0.0;
    if (model.commentModelList.count) {
        
        for (int i =0; i < model.commentModelList.count; i++) {
            LPMoodCommentListDataModel   *CModel = model.commentModelList[i];
            NSString *CommentStr;
            if (CModel.toUserName) {        //回复
                CommentStr = [NSString stringWithFormat:@"%@回复%@：%@",CModel.toUserName,CModel.userName,CModel.commentDetails];
            }else{      //评论
                CommentStr = [NSString stringWithFormat:@"%@：%@",CModel.userName,CModel.commentDetails];
            }
            commentheighe += [LPTools calculateRowHeight:CommentStr fontSize:FontSize(13) Width:SCREEN_WIDTH-LENGTH_SIZE(70) - LENGTH_SIZE(14)]+LENGTH_SIZE(7);
        }
        if (model.commentModelList.count >=5) {
            commentheighe += LENGTH_SIZE(23);
        }
        commentheighe += LENGTH_SIZE(7);
    }else{
        commentheighe = 0.0;
    }
    
    if (commentheighe || Praiseheighe) {
        return floor(commentheighe + Praiseheighe +LENGTH_SIZE(16));

    }
    
    
    return floor(commentheighe + Praiseheighe);
}

@end
