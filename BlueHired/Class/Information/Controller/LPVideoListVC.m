//
//  LPVideoListVC.m
//  BlueHired
//
//  Created by iMac on 2019/11/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPVideoListVC.h"
#import "LPRecreationModel.h"
#import "LPRecreationVideoCell.h"
#import "AppDelegate.h"
#import "LSPlayerView.h"

static NSString *LPRecreationVideoCellID = @"LPRecreationVideoCell";
@interface LPVideoListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong) NSMutableArray <LPRecreationVideoListModel *>*listArray;
@property(nonatomic,assign) NSInteger page;

@property (nonatomic, strong) LPRecreationModel *model;
@property (nonatomic, strong) LSPlayerView *PlayerView;


@end

@implementation LPVideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"企业视频";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(0));
    }];
    self.page = 1;
    [self requestGetMechanismVideo];
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.PlayerView closeClick];
}


// 这个方法返回支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

// 这个返回是否自动旋转
- (BOOL)shouldAutorotate{
  return kAppDelegate.allowRotation ;
}

 #pragma mark - TableViewDelegate & Datasource
  - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      return self.listArray.count;
  }

  - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      return LENGTH_SIZE(246);
  }

  - (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      LPRecreationVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRecreationVideoCellID];
      cell.index = indexPath.row;
      cell.superTableView = tableView;
      cell.model = self.listArray[indexPath.row];
      WEAK_SELF()
      cell.playerBlock = ^(LSPlayerView * _Nonnull player) {
          weakSelf.PlayerView = player;
      };
      return cell;
  }

  - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }


 #pragma mark lazy
 - (UITableView *)tableview{
     if (!_tableview) {
         _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
         _tableview.delegate = self;
         _tableview.dataSource = self;
         _tableview.tableFooterView = [[UIView alloc]init];
         _tableview.rowHeight = UITableViewAutomaticDimension;
         _tableview.estimatedRowHeight = 0;
         _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
         _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
         _tableview.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
         
         UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(20))];
         headView.backgroundColor = [UIColor whiteColor];
         UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(10))];
         lineV.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
         [headView addSubview:lineV];
             
         _tableview.tableHeaderView = headView;
         
         [_tableview registerNib:[UINib nibWithNibName:LPRecreationVideoCellID bundle:nil] forCellReuseIdentifier:LPRecreationVideoCellID];

         _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
             self.page = 1;
             [self requestGetMechanismVideo];
             [self.PlayerView closeClick];

         }];
         _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
             [self requestGetMechanismVideo];
         }];
     }
     return _tableview;
 }

 - (void)setModel:(LPRecreationModel *)model{
     _model = model;
        
        if ([self.model.code integerValue] == 0) {
  
            if (self.page == 1) {
                self.listArray = [NSMutableArray array];
            }
            if (self.model.data.videoList.count > 0) {
                self.page += 1;
                [self.listArray addObjectsFromArray:self.model.data.videoList];
                if (self.model.data.videoList.count<20) {
                    [self.tableview.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableview reloadData];
            
            if (self.listArray.count == 0) {
                [self addNodataViewHidden:NO];
            }else{
                [self addNodataViewHidden:YES];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
        }
 }


 -(void)addNodataViewHidden:(BOOL)hidden{
     BOOL has = NO;
     for (UIView *view in self.tableview.subviews) {
         if ([view isKindOfClass:[LPNoDataView class]]) {
             view.hidden = hidden;
             has = YES;
         }
     }
     if (!has) {
         LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.tableview.frame))];
         [self.tableview addSubview:noDataView];
         noDataView.hidden = hidden;
         [noDataView image:nil text:@"抱歉！没有相关记录！"];

     }
 }

 #pragma mark - request

 -(void)requestGetMechanismVideo{
     NSDictionary *dic = @{
                           @"type":@(1),
                           @"page":@(self.page)
                           };
     [NetApiManager requestGetMechanismVideo:dic withHandle:^(BOOL isSuccess, id responseObject) {
         NSLog(@"%@",responseObject);
         [self.tableview.mj_footer endRefreshing];
         [self.tableview.mj_header endRefreshing];
         if (isSuccess) {
             if ([responseObject[@"code"] integerValue] == 0) {
                 self.model = [LPRecreationModel mj_objectWithKeyValues:responseObject];
             }else{
                 [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
             }

         }else{
             [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
         }
     }];
 }


@end
