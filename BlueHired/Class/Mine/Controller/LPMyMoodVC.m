//
//  LPMyMoodVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMyMoodVC.h"
#import "LPCircleListCell.h"
#import "LPMoodDetailVC.h"
#import "LPMoodListModel.h"
#import "LPCircleInfoListVC.h"

static NSString *LPCircleListCellID = @"LPCircleListCell";

@interface LPMyMoodVC ()<UITableViewDelegate,UITableViewDataSource,SDTimeLineCellDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPMoodListModel *moodListModel;
@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;
@end

@implementation LPMyMoodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的动态";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"消息" style:UIBarButtonItemStyleDone target:self action:@selector(touchMessageButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#666666"]];
     [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateSelected];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.page = 1;
    [self requestMoodList];
}


-(void)touchMessageButton{
    LPCircleInfoListVC *vc = [[LPCircleInfoListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moodListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMoodListDataModel *model = self.moodListArray[indexPath.row];
    CGFloat DetailsHeight = [LPTools calculateRowHeight:model.moodDetails
                                               fontSize:FontSize(15)
                                                  Width:SCREEN_WIDTH - LENGTH_SIZE(71)];
//    [self calculateCommentHeight:model];
    CGFloat CommentHeight = 0;
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
    
    cell.LikeBt.hidden = YES;
    cell.CommentBt.hidden = YES;
    
    cell.CommentView.hidden = YES;
    cell.operationButton.hidden = YES;
    
    
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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        LPCircleListCell *cell = (LPCircleListCell*)[self.tableview cellForRowAtIndexPath:indexPath];
//        cell.viewLabel.text = [NSString stringWithFormat:@"%ld",[cell.viewLabel.text integerValue] + 1];
//        self.moodListArray[indexPath.row].view = @([cell.viewLabel.text integerValue]);
//    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
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
        noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [noDataView image:nil text:@"这里空空如也,赶紧说点什么吧！"];

        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
 
}

#pragma mark - request
-(void)requestMoodList{
    NSInteger type = 1;
 
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
        //        _tableview.estimatedRowHeight = 100;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPCircleListCellID bundle:nil] forCellReuseIdentifier:LPCircleListCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestMoodList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMoodList];
        }];
    }
    return _tableview;
}


#pragma mark  计算高度


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
 

@end
