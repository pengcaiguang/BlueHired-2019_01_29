//
//  LPRecreationVC.m
//  BlueHired
//
//  Created by iMac on 2019/11/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRecreationVC.h"
#import "LPRecreationInformationCell.h"
#import "LPRecreationVideoCell.h"
#import "LPRecreationModel.h"
#import "AppDelegate.h"
#import "LPVideoListVC.h"
#import "LPEssayListVC.h"
#import "LSPlayerView.h"
#import "LPEssayDetailVC.h"
#import "LPGameListVC.h"
#import "LPBoolAdwepVC.h"


static NSString *LPRecreationInformationCellID = @"LPRecreationInformationCell";
static NSString *LPRecreationVideoCellID = @"LPRecreationVideoCell";

@interface LPRecreationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *HeadView;
@property (nonatomic, strong) UIButton *ListGame;
@property (nonatomic, strong) UIButton *ListBook;
@property (nonatomic, strong) UIButton *HeadGame;
@property (nonatomic, strong) UIButton *HeadBook;

@property (nonatomic, strong) LPRecreationModel *model;

@property (nonatomic, strong) LSPlayerView *PlayerView;

@end

@implementation LPRecreationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"看看";
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(0));
    }];
    [self requestGetMechanismVideo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];
        
    [self requestGetShandeConsole];
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

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - Touch
- (void)TouchMoreViode:(UIButton *)sender{
    LPVideoListVC *vc = [[LPVideoListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)TouchMoreInformation:(UIButton *)sender{
     LPEssayListVC *vc = [[LPEssayListVC alloc] init];
     vc.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:vc animated:YES];
}

- (void)TouchHeadBtn:(UIButton *)sender{
    if (sender == self.ListGame || sender == self.HeadGame) {
        if ([LoginUtils validationLogin:self]) {
            LPGameListVC *vc = [[LPGameListVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (sender == self.ListBook || sender == self.HeadBook){
//        if ([LoginUtils validationLogin:self]) {
            LPBoolAdwepVC *vc = [[LPBoolAdwepVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return LENGTH_SIZE(40);
    }
    return LENGTH_SIZE(45);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(40))];
        View.backgroundColor = [UIColor whiteColor];
//        View.backgroundColor = [UIColor redColor];
        UILabel *Label = [[UILabel alloc] init];
        [View addSubview:Label];
        [Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(13));
            make.centerY.equalTo(View);
        }];
        Label.text = @"企业视频";
        Label.font = [UIFont boldSystemFontOfSize:FontSize(17)];
        Label.textColor = [UIColor colorWithHexString:@"#333333"];
        
        UIButton *Btn = [[UIButton alloc] init];
        [View addSubview:Btn];
        [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(LENGTH_SIZE(-13));
            make.centerY.equalTo(View);
        }];
        Btn.titleLabel.font = FONT_SIZE(14);
        [Btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [Btn setTitle:@"查看更多 >" forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(TouchMoreViode:) forControlEvents:UIControlEventTouchUpInside];
        return View;
    }else{
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, LENGTH_SIZE(5), SCREEN_WIDTH, LENGTH_SIZE(40))];
        View.backgroundColor = [UIColor whiteColor];
        UILabel *Label = [[UILabel alloc] init];
        [View addSubview:Label];
        [Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(13));
            make.centerY.equalTo(View);
        }];
        Label.text = @"热点新闻";
        Label.font = [UIFont boldSystemFontOfSize:FontSize(17)];
        Label.textColor = [UIColor colorWithHexString:@"#333333"];
        
        UIButton *Btn = [[UIButton alloc] init];
        [View addSubview:Btn];
        [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(LENGTH_SIZE(-13));
            make.centerY.equalTo(View);
        }];
        Btn.titleLabel.font = FONT_SIZE(14);
        [Btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [Btn setTitle:@"查看更多 >" forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(TouchMoreInformation:) forControlEvents:UIControlEventTouchUpInside];

        return View;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.model.data.videoList.count;
    }
    
    return self.model.data.essayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return LENGTH_SIZE(246);
    }
    return LENGTH_SIZE(96);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LPRecreationVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRecreationVideoCellID];
        cell.index = indexPath.row;
        cell.superTableView = tableView;
        cell.model = self.model.data.videoList[indexPath.row];
        WEAK_SELF()
        cell.playerBlock = ^(LSPlayerView * _Nonnull player) {
            weakSelf.PlayerView = player;
        };
        
        return cell;
      
    }else{
        LPRecreationInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:LPRecreationInformationCellID];
        cell.model = self.model.data.essayList[indexPath.row];
        return cell;
    }
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        LPEssayDetailVC *vc = [[LPEssayDetailVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.essaylistDataModel = self.model.data.essayList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        [_tableview registerNib:[UINib nibWithNibName:LPRecreationVideoCellID bundle:nil] forCellReuseIdentifier:LPRecreationVideoCellID];
               
        [_tableview registerNib:[UINib nibWithNibName:LPRecreationInformationCellID bundle:nil] forCellReuseIdentifier:LPRecreationInformationCellID];

        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            [self requestGetShandeConsole];
            [self requestGetMechanismVideo];
            [self.PlayerView closeClick];

        }];
        
        _tableview.tableHeaderView = self.HeadView;
//        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            if (self.SelectType == 1) {
//                [self requestQueryinviteRecord];
//            }else{
//                [self.tableview.mj_footer endRefreshing];
//            }
//        }];
    }
    return _tableview;
}

- (UIView *)HeadView{
    if (!_HeadView) {
        _HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(118))];
        _HeadView.backgroundColor = [UIColor whiteColor];
        UIButton *listGame = [[UIButton alloc] init];
        [_HeadView addSubview:listGame];
        self.ListGame = listGame;
        [listGame mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(0);
            make.width.mas_offset(LENGTH_SIZE(190));
            make.height.mas_offset(LENGTH_SIZE(118));
        }];
        [listGame setBackgroundImage:[UIImage imageNamed:@"game"] forState:UIControlStateNormal];
        [listGame addTarget:self action:@selector(TouchHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *listBook = [[UIButton alloc] init];
        [_HeadView addSubview:listBook];
        self.ListBook = listBook;
        [listBook mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_offset(0);
            make.width.mas_offset(LENGTH_SIZE(190));
            make.height.mas_offset(LENGTH_SIZE(118));
        }];
        [listBook setBackgroundImage:[UIImage imageNamed:@"noval"] forState:UIControlStateNormal];
        [listBook addTarget:self action:@selector(TouchHeadBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *HeadBook = [UIButton buttonWithType:UIButtonTypeCustom];
        [_HeadView addSubview:HeadBook];
        self.HeadBook = HeadBook;
        [HeadBook mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(118));
        }];
        [HeadBook setBackgroundImage:[UIImage imageNamed:@"novel2"] forState:UIControlStateNormal];
        [HeadBook addTarget:self action:@selector(TouchHeadBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *HeadGame = [UIButton buttonWithType:UIButtonTypeCustom];
        [_HeadView addSubview:HeadGame];
        self.HeadGame = HeadGame;
        [HeadGame mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(118));
        }];
        UIImage *Image = [UIImage imageNamed:@"game2"];
    
        [HeadGame setBackgroundImage:Image forState:UIControlStateNormal];
        [HeadGame addTarget:self action:@selector(TouchHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
//        HeadGame.imageView.contentMode = UIViewContentModeScaleToFill;
    }

    return _HeadView;
}


#pragma mark - request

-(void)requestGetMechanismVideo{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"size":@(3)
                          };
    [NetApiManager requestGetMechanismVideo:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPRecreationModel mj_objectWithKeyValues:responseObject];
                [self.tableview reloadData];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestGetShandeConsole{
    NSDictionary *dic = @{
                          @"type":@(2)
                          };
    [NetApiManager requestGetShandeConsole:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.HeadBook.hidden = YES;
                self.HeadGame.hidden = YES;
                self.ListBook.hidden = YES;
                self.ListGame.hidden = YES;
                
                if ([responseObject[@"data"] integerValue] == 0) {
                    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
                }else if ([responseObject[@"data"] integerValue] == 1){
                    self.HeadBook.hidden = NO;
                    self.tableview.tableHeaderView = self.HeadView;
                }else if ([responseObject[@"data"] integerValue] == 2){
                    self.HeadGame.hidden = NO;
                    self.tableview.tableHeaderView = self.HeadView;
                }else if ([responseObject[@"data"] integerValue] == 3){
                    self.ListGame.hidden = NO;
                    self.ListBook.hidden = NO;
                    self.tableview.tableHeaderView = self.HeadView;
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
