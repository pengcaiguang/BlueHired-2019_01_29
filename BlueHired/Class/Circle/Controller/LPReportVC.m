//
//  LPReportVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/8.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPReportVC.h"
#import "LPReportContentVC.h"
#import "LPCircleListCell.h"
#import "LPMoodListModel.h"
#import "LPUsermaterialMoodModel.h"
#import "LPMoodDetailVC.h"
#import "LPCircleVC.h"
#import "XWScanImage.h"

@interface LPReportVC ()<UITableViewDelegate,UITableViewDataSource,SDTimeLineCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *PersonBT;
@property (weak, nonatomic) IBOutlet UIButton *CircleBT;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *gradingiamge;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *ConcemNum;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIButton *userConcernButton;
@property (weak, nonatomic) IBOutlet UIButton *ReportBt;

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Circletableview;

@property (nonatomic,assign) NSInteger Selecttype;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPMoodListModel *moodListModel;
@property(nonatomic,strong) LPUsermaterialMoodModel *userModel;

@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;

@end

static NSString *LPCircleListCellID = @"LPCircleListCell";
@implementation LPReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    self.moodListArray = [NSMutableArray array];
    self.userImage.layer.cornerRadius = 36;
    self.userConcernButton.layer.cornerRadius = 13.5;

    self.PersonBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.PersonBT setTitleEdgeInsets:UIEdgeInsetsMake(self.PersonBT.imageView.frame.size.height +10,-self.PersonBT.imageView.frame.size.width, 0.0,0.0)];
    [self.PersonBT setImageEdgeInsets:UIEdgeInsetsMake(-self.PersonBT.imageView.frame.size.height, 0.0,0.0, -self.PersonBT.titleLabel.bounds.size.width)];
 
    self.CircleBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.CircleBT setTitleEdgeInsets:UIEdgeInsetsMake(self.CircleBT.imageView.frame.size.height +10,-self.CircleBT.imageView.frame.size.width, 0.0,0.0)];
    [self.CircleBT setImageEdgeInsets:UIEdgeInsetsMake(-self.CircleBT.imageView.frame.size.height, 0.0,0.0, -self.CircleBT.titleLabel.bounds.size.width)];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(211);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
        
    }];
    
    [self.view addSubview:self.Circletableview];
    self.Circletableview.hidden = YES;
    [self.Circletableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(211);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
     }];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [self.userImage addGestureRecognizer:tapGestureRecognizer1];
     [self.userImage setUserInteractionEnabled:YES];
    [self requestUserMaterialSelect];
    [self requestMoodList];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([_MoodModel.userId integerValue] ==[kUserDefaultsValue(LOGINID) integerValue]){
        self.ReportBt.hidden = YES;
        self.userConcernButton.hidden = YES;
    }else{
        self.ReportBt.hidden = NO;
        self.userConcernButton.hidden = NO;
    }
    
    [self.Circletableview reloadData];
    
    if (self.isSenderBack == 3) {
        [self requestMoodList];
    }
}


-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

- (IBAction)touchCircleRoPerson:(UIButton *)sender{
    self.PersonBT.selected = NO;
    self.CircleBT.selected = NO;
    sender.selected = YES;
    if (self.PersonBT.selected) {
        self.Selecttype = 0;
        self.tableview.hidden = NO;
        self.Circletableview.hidden = YES;
        [self addNodataViewHidden:YES];
        [self.tableview reloadData];
    }else{
        self.Selecttype = 1;
        self.tableview.hidden = YES;
        self.Circletableview.hidden = NO;
        if (self.moodListArray.count == 0) {
            [self requestMoodList];
        }else{
            [self addNodataViewHidden:YES];
        }
 
     }
}

- (IBAction)touchUpInside:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]){
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否屏蔽“%@”用户？",_MoodModel.userName] textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                NSLog(@"点击屏蔽用户");
                [self requestQueryDefriendPullBlack];
            }
        }];
        [alert show];
    }
    

    
}


- (IBAction)touchconcern:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]){
        [self requestSetUserConcern];
    }
}



#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _Circletableview) {
        return self.moodListArray.count;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _Circletableview) {
        LPMoodListDataModel *model = self.moodListArray[indexPath.row];
        float DetailsHeight = [self calculateRowHeight:model.moodDetails fontSize:15 Width:SCREEN_WIDTH - 71];
//        [self calculateCommentHeight:model];
        CGFloat CommentHeight = 0;
//        return   107 + (DetailsHeight>=80?80:DetailsHeight+5)+[self calculateImageHeight:model.moodUrl]+CommentHeight;
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
    }else{
        return 44.0;
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    if (tableView == _Circletableview) {
        LPCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCircleListCellID];
        if(cell == nil){
            cell = [[LPCircleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPCircleListCellID];
        }
        cell.model = self.moodListArray[indexPath.row];
        cell.ContentType = 1;
        cell.ClaaViewType = 2;
        cell.moodListArray = self.SupermoodListArray;
        cell.SuperTableView = self.SuperTableView;
        cell.indexPath = indexPath;

 
        cell.CommentView.hidden = YES;
        cell.TriangleView.hidden = YES;
        cell.operationButton.hidden = YES;
        
        cell.ReportBt.hidden = YES;
//        cell.operationButton.hidden = YES;

        cell.delegate =self;
        WEAK_SELF()
        cell.PraiseBlock = ^(void){
            [weakSelf.Circletableview reloadData];
        };
        if (!cell.moreButtonClickedBlock) {
            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                weakSelf.moodListArray[indexPath.row].isOpening = !weakSelf.moodListArray[indexPath.row].isOpening;
                //            [weakSelf.tableview reloadSections:indexPath withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.Circletableview reloadData];
                
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
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    if (indexPath.row == 0) {
        NSString *strSex = @"";
        if ([self.userModel.data.user_sex integerValue] == 0) {
            strSex = @"未知";
        }else if ([self.userModel.data.user_sex integerValue] == 1){
            strSex = @"男";
        }else if ([self.userModel.data.user_sex integerValue] == 2 ){
            strSex = @"女";
        }
        cell.textLabel.text = [NSString stringWithFormat:@"性别:%@",strSex];
    }else if (indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"生日:%@",[LPTools isNullToString:self.userModel.data.birthday]];
    }else if (indexPath.row == 2){
        
        NSString *strMarry = @"";
        if ([self.userModel.data.marry_status integerValue] == 0) {
            strMarry = @"保密";
        }else if ([self.userModel.data.marry_status integerValue] == 1){
            strMarry = @"未婚";
        }else if ([self.userModel.data.marry_status integerValue] == 2){
            strMarry = @"已婚";
        }else if ([self.userModel.data.marry_status integerValue] == 3){
            strMarry = @"单身";
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"情感状态:%@",strMarry];
    }else if (indexPath.row == 3){
        cell.textLabel.text = [NSString stringWithFormat:@"曾任职工作:%@",[LPTools isNullToString:self.userModel.data.work_type]];
    }else if (indexPath.row == 4){
        cell.textLabel.text = [NSString stringWithFormat:@"工作年限:%@年",[LPTools isNullToString:self.userModel.data.work_years]];
    }else if (indexPath.row == 5){
        cell.textLabel.text = [NSString stringWithFormat:@"在职企业:%@",[LPTools isNullToString:self.userModel.data.mechanismName]];
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
    [cell.contentView addSubview:view];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _Circletableview) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
       
        vc.hidesBottomBarWhenPushed = YES;
        vc.moodListDataModel = self.moodListArray[indexPath.row];
        vc.moodListArray = self.SupermoodListArray;
        vc.SuperTableView = self.SuperTableView;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell  with:(NSIndexPath *)indexPath
{
    LPMoodDetailVC *vc = [[LPMoodDetailVC alloc]init];
 
    vc.hidesBottomBarWhenPushed = YES;
    vc.moodListDataModel = self.moodListArray[indexPath.row];
    vc.moodListArray = self.SupermoodListArray;
    vc.SuperTableView = self.SuperTableView;
    
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        LPCircleListCell *cell = (LPCircleListCell*)[self.tableview cellForRowAtIndexPath:indexPath];
//        cell.viewLabel.text = [NSString stringWithFormat:@"%ld",[cell.viewLabel.text integerValue] + 1];
//        self.moodListArray[indexPath.row].view = @([cell.viewLabel.text integerValue]);
//    });
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = YES;
        //        _tableview.tableFooterView = [[UIView alloc]init];
        //        _tableview.rowHeight = UITableViewAutomaticDimension;
        //        _tableview.estimatedRowHeight = 0.0;
//        _tableview.estimatedRowHeight = 100;
        _Circletableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellEditingStyleNone;
        _tableview.estimatedSectionHeaderHeight = 0;
 
    }
    return _tableview;
}
-(UITableView *)Circletableview
{
    if (!_Circletableview) {
        _Circletableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Circletableview.delegate = self;
        _Circletableview.dataSource = self;
        _Circletableview.scrollEnabled = YES;
        //        _tableview.tableFooterView = [[UIView alloc]init];
        //        _tableview.rowHeight = UITableViewAutomaticDimension;
        //        _tableview.estimatedRowHeight = 0.0;
//        _Circletableview.estimatedRowHeight = 100;
        _Circletableview.estimatedRowHeight = 0;
        _Circletableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _Circletableview.separatorColor = [UIColor redColor];
        _Circletableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //        _tableview.tableHeaderView = self.tableHeaderView;
         _Circletableview.estimatedSectionHeaderHeight = 0;
        [_Circletableview registerNib:[UINib nibWithNibName:LPCircleListCellID bundle:nil] forCellReuseIdentifier:LPCircleListCellID];
         _Circletableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestMoodList];
        }];
        _Circletableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMoodList];
        }];
    }
    return _Circletableview;
}

-(void)setMoodListModel:(LPMoodListModel *)moodListModel{
    _moodListModel = moodListModel;
    if ([moodListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.moodListArray = [NSMutableArray array];
        }
        if (moodListModel.data.count > 0) {
            self.page += 1;
            [self.moodListArray addObjectsFromArray:moodListModel.data];
            [self.Circletableview reloadData];
        }else{
            if (self.page == 1) {
                [self.Circletableview reloadData];
            }else{
                [self.Circletableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.moodListArray.count == 0 && self.CircleBT.selected == YES) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(221);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}
 
- (void)setUserModel:(LPUsermaterialMoodModel *)UserModel{
    _userModel = UserModel;
    self.userName.text = [LPTools isNullToString:UserModel.data.user_name];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:UserModel.data.user_url] placeholderImage:[UIImage imageNamed:@"mine_headimg_placeholder"]];
    self.ConcemNum.text = [NSString stringWithFormat:@"粉丝:%@",[LPTools isNullToString:UserModel.data.concernNum]];
    self.money.text = [NSString stringWithFormat:@"%@",[LPTools isNullToString:UserModel.data.grading]];
    if (UserModel.data.isConcern.integerValue == 1) {
        [self.userConcernButton setTitle:@" 已关注" forState:UIControlStateNormal];
    }else{
        [self.userConcernButton setTitle:@" 未关注" forState:UIControlStateNormal];
    }
    
    self.gradingiamge.image = [UIImage imageNamed:UserModel.data.grading];

//    if (UserModel.data.score.integerValue >=0 && UserModel.data.score.integerValue <3000) {
//        self.gradingiamge.image = [UIImage imageNamed:@"见习职工"];
//        
//    }else if (UserModel.data.score.integerValue >= 3000 && UserModel.data.score.integerValue < 6000){
//        self.gradingiamge.image = [UIImage imageNamed:@"初级职工"];
//        
//    }else if (UserModel.data.score.integerValue >= 6000 && UserModel.data.score.integerValue < 12000){
//        self.gradingiamge.image = [UIImage imageNamed:@"中级职工"];
//        
//    }else if (UserModel.data.score.integerValue >= 12000 && UserModel.data.score.integerValue < 18000){
//        self.gradingiamge.image = [UIImage imageNamed:@"高级职工"];
//        
//    }else if (UserModel.data.score.integerValue >= 18000 && UserModel.data.score.integerValue < 24000){
//        self.gradingiamge.image = [UIImage imageNamed:@"部门精英"];
//        
//    }else if (UserModel.data.score.integerValue >= 24000 && UserModel.data.score.integerValue < 30000){
//        self.gradingiamge.image = [UIImage imageNamed:@"部门经理"];
//        
//    }else if (UserModel.data.score.integerValue >= 30000 && UserModel.data.score.integerValue < 36000){
//        self.gradingiamge.image = [UIImage imageNamed:@"区域经理"];
//        
//    }else if (UserModel.data.score.integerValue >= 36000 && UserModel.data.score.integerValue < 45000){
//        self.gradingiamge.image = [UIImage imageNamed:@"总经理"];
//        
//    }else{
//        self.gradingiamge.image = [UIImage imageNamed:@"董事长"];
//        
//    }
    
}

 


#pragma mark - request
-(void)requestMoodList{
 
    NSDictionary *dic = @{@"userId": self.MoodModel.userId,
                          @"type":@"1",
                          @"page":@(self.page)
                           };
    [NetApiManager requestMoodListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Circletableview.mj_header endRefreshing];
        [self.Circletableview.mj_footer endRefreshing];
        
        self.moodListModel = [LPMoodListModel mj_objectWithKeyValues:responseObject];
    }];
}


-(void)requestUserMaterialSelect{
    NSDictionary *dic = @{
                          @"id":[NSString stringWithFormat:@"%@", _MoodModel.userId]
                          };
    [NetApiManager requestQueryUserMaterialSelect:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.userModel = [LPUsermaterialMoodModel mj_objectWithKeyValues:responseObject];
            [self.tableview reloadData];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
       
    }];
}



-(void)requestSetUserConcern{
    NSDictionary *dic = @{
                          @"concernUserId":self.MoodModel.userId,
                          };
    [NetApiManager requestSetUserConcernWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"data"])) {
                 if ([responseObject[@"data"] integerValue]  == 0) {
                     [self.userConcernButton setTitle:@" 已关注" forState:UIControlStateNormal];

                }else if ([responseObject[@"data"] integerValue] == 1) {
                    [self.userConcernButton setTitle:@" 未关注" forState:UIControlStateNormal];

                }
 
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryDefriendPullBlack{
    NSDictionary *dic = @{@"identity":[LPTools isNullToString:self.MoodModel.identity],
                          @"type":@"1"
                          };
    [NetApiManager requestQueryDefriendPullBlack:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
//                LPCircleVC *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//                vc.isSenderBack = 2;
//                [self.navigationController popToViewController:vc animated:YES];
                [self.navigationController   popViewControllerAnimated:YES];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat) W
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paraStyle01};
    /*计算高度要先指定宽度*/
    CGRect rect = [string boundingRectWithSize:CGSizeMake(W, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return ceil(rect.size.height);
    
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
 
        Praiseheighe = [self calculateRowHeight:PraiseStr fontSize:13 Width:SCREEN_WIDTH-70-14];
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
            commentheighe += [self calculateRowHeight:CommentStr fontSize:13 Width:SCREEN_WIDTH-70-14]+7;
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
