//
//  LPCircleCollectionViewCell.m
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleCollectionViewCell.h"
#import "LPMoodTypeModel.h"
#import "LPMoodListModel.h"
#import "LPCircleListCell.h"
#import "LPMoodDetailVC.h"
#import "LPCircleInfoListVC.h"

static NSString *LPCircleListCellID = @"LPCircleListCell";

@interface LPCircleCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,SDTimeLineCellDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,strong) UIView *tableHeader2View;
@property(nonatomic,strong) UIButton *expandbutton;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPMoodTypeModel *moodTypeModel;
@property(nonatomic,strong) LPMoodTypeDataModel *selectMoodTypeDataModel;

@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@property(nonatomic,strong) LPMoodListModel *moodListModel;
@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;

@property(nonatomic,strong) UIButton *messageBT;
@property (nonatomic,assign) NSInteger GetMoodUserID;

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
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
    }];
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


-(void)setMoodTypeModel:(LPMoodTypeModel *)moodTypeModel{
    if (_moodTypeModel) {
        if ([_moodTypeModel.mj_keyValues isEqual:moodTypeModel.mj_keyValues]) {
            return;
        }
    }
    _moodTypeModel = moodTypeModel;
    
    if (moodTypeModel.data.count > 0 ) {
        self.tableview.tableHeaderView = self.tableHeaderView;
        self.tableHeaderView.clipsToBounds = YES;
        for(UIView *view in [self.tableHeaderView subviews])
        {
            [view removeFromSuperview];
        }
        if (moodTypeModel.data.count > 4) {
            [self.tableHeaderView addSubview:self.expandbutton];
            [self.expandbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(30);
            }];
        }
        
        CGFloat space = (SCREEN_WIDTH-37*4)/8;
        for (int i = 0; i<moodTypeModel.data.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(i%4 * 37 + (space*(2*(i%4)+1)), floor(i/4)*80 + 20, 37, 37);
            [imgView sd_setImageWithURL:[NSURL URLWithString:moodTypeModel.data[i].labelUrl]];
            [self.tableHeaderView addSubview:imgView];
            [self.tableHeaderView insertSubview:imgView atIndex:0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMoodType:)];
            imgView.tag = i;
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, CGRectGetMaxY(imgView.frame)+5, SCREEN_WIDTH/4, 15);
            label.text = moodTypeModel.data[i].labelName;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            [self.tableHeaderView addSubview:label];
            [self.tableHeaderView insertSubview:label atIndex:0];
            [self.labelArray addObject:label];
        }
        self.labelArray[0].textColor = [UIColor baseColor];
        self.selectMoodTypeDataModel = moodTypeModel.data[0];

    }
}

-(void)setMoodListModel:(LPMoodListModel *)moodListModel{
    _moodListModel = moodListModel;
    if ([moodListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.moodListArray = [NSMutableArray array];
            self.GetMoodUserID = kUserDefaultsValue(LOGINID).integerValue;
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
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];

        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
    
    if (self.index == 0) {
         if (_expandbutton.selected) {
//             noDataView.frame = CGRectMake(0, ( 64+120 + floor((self.moodTypeModel.data.count-1)/4)*80),
//                                           SCREEN_WIDTH, SCREEN_HEIGHT- ( 120 + floor((self.moodTypeModel.data.count-1)/4)*80) -64);
        }else{
//            noDataView.frame = CGRectMake(0, 64+120, SCREEN_WIDTH, SCREEN_HEIGHT - 120 -64);
            noDataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64);
        }
        
         [noDataView image:nil text:@"赶紧来抢占一楼吧!"];
    }else if (self.index == 1){
        [noDataView image:nil text:@"您还没有关注任何内容,赶紧去关注吧！"];
        noDataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);

    }else if (self.index == 2){
        [noDataView image:nil text:@"这里空空如也,赶紧说点什么吧!"];
        noDataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);

    }
    
    if (!AlreadyLogin && self.index >0) {
        [noDataView image:nil text:@"您还未登录,登录后可查看!"];
        noDataView.isShowLoginBt = NO;
    }else{
        noDataView.isShowLoginBt = YES;
    }
    
}

-(void)touchMoodType:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor blackColor];
    }
    if (self.labelArray.count) {
        self.labelArray[index].textColor = [UIColor baseColor];
        self.selectMoodTypeDataModel = self.moodTypeModel.data[index];
    }
    [DSBaActivityView showActiviTy];
    self.page = 1;
    [self requestMoodList];
}

-(void)touchMoodTypeDeleteBack{
    [self.tableview reloadData];
}

-(void)touchMoodTypeSenderBack:(NSInteger )tap{
    NSInteger index = tap;
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor blackColor];
    }
    
    if (self.labelArray.count) {
        self.labelArray[index].textColor = [UIColor baseColor];
        self.selectMoodTypeDataModel = self.moodTypeModel.data[index];
    }

    
    self.moodListArray = [NSMutableArray array];
    [self.tableview reloadData];
    [self.tableview layoutIfNeeded];

    
    self.index = 0;
    self.page = 1;
    [self requestMoodList];
}

-(void)touchExpandButton:(UIButton *)button{
    button.selected = !button.isSelected;
    if (button.selected) {
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120 + floor((self.moodTypeModel.data.count-1)/4)*80);
    }else{
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    }
    
    if (self.moodListArray.count == 0) {
        self.tableview.mj_footer.alpha = 0;
        [self addNodataViewHidden:NO];
    }else{
        self.tableview.mj_footer.alpha = 1;
        [self addNodataViewHidden:YES];
    }
    
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.CircleMessage>0) {
        return 47;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = self.tableHeader2View;
    [self.messageBT setTitle:[NSString stringWithFormat:@"  您有%ld条新消息！ ",(long)_CircleMessage] forState:UIControlStateNormal];

    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moodListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMoodListDataModel *model = self.moodListArray[indexPath.row];
    CGFloat DetailsHeight = [LPTools calculateRowHeight:model.moodDetails fontSize:15 Width:SCREEN_WIDTH - 71];
 
    CGFloat CommentHeight = [self calculateCommentHeight:model];
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
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            LPCircleListCell *cell = (LPCircleListCell*)[self.tableview cellForRowAtIndexPath:indexPath];
//            cell.viewLabel.text = [NSString stringWithFormat:@"%ld",[cell.viewLabel.text integerValue] + 1];
//            self.moodListArray[indexPath.row].view = @([cell.viewLabel.text integerValue]);
//        });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
//    vc.Type = 1;
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.moodListDataModel = self.moodListArray[indexPath.row];
//    vc.moodListArray = self.moodListArray;
//    vc.SuperTableView = self.tableview;
//    
//    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        LPCircleListCell *cell = (LPCircleListCell*)[tableView cellForRowAtIndexPath:indexPath];
//        cell.viewLabel.text = [NSString stringWithFormat:@"%ld",[cell.viewLabel.text integerValue] + 1];
//        self.moodListArray[indexPath.row].view = @([cell.viewLabel.text integerValue]);
//    });
}
#pragma mark - request
-(void)requestMoodType{
    [NetApiManager requestMoodTypeWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [LPUserDefaults saveObject:responseObject byFileName:[NSString stringWithFormat:@"CIRCLETYPELISTCACHE"]];
                [LPUserDefaults saveObject:[NSDate date] byFileName:[NSString stringWithFormat: @"CIRCLETYPELISTCACHEDATE"]];
                self.moodTypeModel = [LPMoodTypeModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestMoodList{
    NSInteger type = 0;
//    switch (self.index) {
//        case 0:
//            type = 0;
//            break;
//        case 1:
//            type = 2;
//            self.selectMoodTypeDataModel = nil;
//            break;
//
//        case 2:
//            type = 1;
//            self.selectMoodTypeDataModel = nil;
//            break;
//
//        default:
//            break;
//    }
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
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPCircleListCellID bundle:nil] forCellReuseIdentifier:LPCircleListCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestMoodList];
            if (AlreadyLogin) {
                [self requestQueryInfounreadNum];
            }
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMoodList];
        }];
    }
    return _tableview;
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView){
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 47);
    }
    return _tableHeaderView;
}

-(UIView *)tableHeader2View{
    if (!_tableHeader2View) {
        _tableHeader2View = [[UIView alloc] init];
        _tableHeader2View.frame = CGRectMake(0, 0, SCREEN_WIDTH, 47);
        _tableHeader2View.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc] init];
        self.messageBT = button;
        [_tableHeader2View addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self.tableHeader2View);
            make.height.mas_offset(30);
        }];
        button.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.65];
        button.layer.cornerRadius = 15;
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

-(UIButton *)expandbutton{
    if (!_expandbutton) {
        _expandbutton = [[UIButton alloc]init];
        [_expandbutton setTitle:@"点击展开" forState:UIControlStateNormal];
        [_expandbutton setTitle:@"点击收起" forState:UIControlStateSelected];
        [_expandbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_expandbutton setImage:[UIImage imageNamed:@"expand_img"] forState:UIControlStateNormal];
        [_expandbutton setImage:[UIImage imageNamed:@"shrinkage_img"] forState:UIControlStateSelected];
        _expandbutton.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _expandbutton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_expandbutton addTarget:self action:@selector(touchExpandButton:) forControlEvents:UIControlEventTouchUpInside];
        _expandbutton.titleEdgeInsets = UIEdgeInsetsMake(0, -_expandbutton.imageView.frame.size.width - _expandbutton.titleLabel.intrinsicContentSize.width + 10, 0, 0);
        _expandbutton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_expandbutton.titleLabel.intrinsicContentSize.width -_expandbutton.imageView.frame.size.width-30);
    }
    return _expandbutton;
    
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
