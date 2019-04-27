//
//  LPMainVC.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//



#import "LPMainVC.h"
#import "LPSearchBar.h"
#import "LPMainCell.h"
#import "LPWorklistModel.h"
#import "LPMechanismlistModel.h"
#import "SDCycleScrollView.h"
#import "LPSortAlertView.h"
#import "LPScreenAlertView.h"
#import "LPMainSearchVC.h"
#import "LPWorkDetailVC.h"
#import "LPSelectCityVC.h"
#import "LPHongBaoVC.h"
#import "LPMain2Cell.h"
#import "DHGuidePageHUD.h"

#define OPERATIONFORKEY @"operationGuidePage"

static NSString *LPMainCellID = @"LPMain2Cell";

@interface LPMainVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,LPSortAlertViewDelegate,LPSelectCityVCDelegate,LPScreenAlertViewDelegate,UITabBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,strong) UILabel *cityLabel;
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong) UIButton *sortButton;
@property(nonatomic,strong) UIButton *screenButton;

@property(nonatomic,strong) LPSortAlertView *sortAlertView;
@property(nonatomic,strong) LPScreenAlertView *screenAlertView;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPWorklistModel *model;
@property(nonatomic,strong) NSMutableArray <LPWorklistDataWorkListModel *>*listArray;

@property(nonatomic,strong) LPMechanismlistModel *mechanismlistModel;

@property(nonatomic,strong) NSString *orderType;
@property(nonatomic,strong) NSString *mechanismAddress;


@property(nonatomic,strong) UIScrollView *RecommendScrollView;
@property(nonatomic,strong) UIImageView *RecommendBackImage;
@property (strong, nonatomic) NSTimer * myTimer;//定时器管控轮播

@property(nonatomic,strong) UIView *ButtonView;//定时器管控轮播
@property(nonatomic,strong) NSMutableArray <UIButton *>*ButtonArr;//定时器管控轮播

@end

@implementation LPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];

    [self setLeftButton];
    [self setSearchView];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    self.page = 1;
//    self.listArray = [NSMutableArray array];
//    [self request];
//    [self requestMechanismlist];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeScrollContentOffSetY) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:OPERATIONFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:OPERATIONFORKEY];
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否进行招工报名引导？" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSArray *imageNameArray = @[@"报名操作指导_01",@"报名操作指导_02",@"报名操作指导_03",@"报名操作指导_04",@"报名操作指导_05"];
                //        if (IS_iPhoneX) {
                //            imageNameArray = @[@"报名操作指导X_01",@"报名操作指导X_02",@"报名操作指导X_03",@"报名操作指导X_04",@"报名操作指导X_05",@"报名操作指导X_06"];
                //        }
                // 创建并添加引导页
                DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:[UIApplication sharedApplication].keyWindow.frame imageNameArray:imageNameArray buttonIsHidden:YES isShowBt:YES isTouchNext:YES ];
                guidePage.slideInto = YES;
                [[UIApplication sharedApplication].keyWindow addSubview:guidePage];
            }
        }];
        [alert show];
    }
    
    [self requestQueryDownload];
    [self requestMechanismlist];
    
 
    //查看缓存
    NSDate *date = [LPUserDefaults getObjectByFileName:[NSString stringWithFormat: @"WORKLISTCACHEDATE"]];
    id CacheList = [LPUserDefaults getObjectByFileName:[NSString stringWithFormat: @"WORKLISTCACHE"]];
    NSString *ISLoginstr = [LPUserDefaults getObjectByFileName:[NSString stringWithFormat: @"CIRCLELISTCACHEISLogin"]];
    if ([LPTools compareOneDay:date withAnotherDay:[NSDate date]]<=15 && CacheList ) {
        self.page = 1;
        self.model = [LPWorklistModel mj_objectWithKeyValues:CacheList];
        if (ISLoginstr.integerValue == 1) {
            self.page = 1;
            [self request];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [LPUserDefaults saveObject:@"0" byFileName:[NSString stringWithFormat:@"CIRCLELISTCACHEISLogin"]];
            });
        }
    }else{
        self.page = 1;
        [self request];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview reloadData];
 }

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.screenAlertView.hidden) {
        self.screenAlertView.hidden = YES;
    }
    [_myTimer invalidate];
    _myTimer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setLeftButton{
    UIView *leftBarButtonView = [[UIView alloc]init];
//    leftBarButtonView.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButtonView];
    [leftBarButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSelectCityButton)];
    leftBarButtonView.userInteractionEnabled = YES;
    [leftBarButtonView addGestureRecognizer:tap];
    
    UIImageView *pimageView = [[UIImageView alloc]init];
    [leftBarButtonView addSubview:pimageView];
    [pimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(11, 12));
    }];
    pimageView.image = [UIImage imageNamed:@"positioning"];
    
    self.cityLabel = [[UILabel alloc]init];
    [leftBarButtonView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pimageView.mas_right).offset(3);
        make.centerY.mas_equalTo(pimageView);
    }];
    self.cityLabel.text = @"全国";
    self.cityLabel.font = [UIFont systemFontOfSize:15];
    self.cityLabel.textColor = [UIColor whiteColor];
    
    UIImageView *dimageView = [[UIImageView alloc]init];
    [leftBarButtonView addSubview:dimageView];
    [dimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityLabel.mas_right).offset(3);
        make.centerY.equalTo(pimageView);
        make.size.mas_equalTo(CGSizeMake(11, 6));
        make.right.equalTo(leftBarButtonView.mas_right).offset(0);
    }];
    dimageView.image = [UIImage imageNamed:@"downArrow"];
}

-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBar];
    UIView *wrapView = [[UIView alloc]init];
    wrapView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 99, 32);
    wrapView.layer.cornerRadius = 16;
    wrapView.layer.masksToBounds = YES;
//    wrapView.clipsToBounds = YES;
    wrapView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = wrapView;

    [wrapView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
}
- (LPSearchBar *)addSearchBar{
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]init];
    
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入企业名称或关键字";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14;
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 28.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}
#pragma mark - setter
-(void)setMechanismlistModel:(LPMechanismlistModel *)mechanismlistModel{
    _mechanismlistModel = mechanismlistModel;
    self.screenAlertView.mechanismlistModel = mechanismlistModel;
}
-(void)setModel:(LPWorklistModel *)model{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (LPWorklistDataWorkListModel *model in self.model.data.slideshowList) {
            [array addObject:model.mechanismUrl];
        }
        self.cycleScrollView.imageURLStringsGroup = array;
//        [self updataHeaderView];
//        if (array.count>5) {
//            self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
//        }
        
        [self.RecommendScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
        for (int i =0 ;i <self.model.data.workBarsList.count;i++) {
            LPWorklistDataWorkBarsListModel *m = self.model.data.workBarsList[i];
            UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(0, i*27 , SCREEN_WIDTH-69, 27)];
            [self.RecommendScrollView addSubview:label];
            label.text = [NSString stringWithFormat:@"恭喜用户%@报名%@,入职成功!",m.userName,m.mechanismName];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
        }
        self.RecommendScrollView.contentSize = CGSizeMake(0, self.model.data.workBarsList.count*27);
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.workList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.workList];
            [self.tableview reloadData];

        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }

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
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 266, SCREEN_WIDTH, SCREEN_HEIGHT-266-49-kNavBarHeight-kBottomBarHeight)];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
}

-(void)updataHeaderView{
    if (self.model.data.slideshowList.count <= 0) {
        return;
    }
    CGSize size = [UIImage getImageSizeWithURL:self.model.data.slideshowList[0].mechanismUrl];
    CGFloat s = SCREEN_WIDTH/size.width;
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height*s + 40);
    self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height*s);
}

-(void)touchSelectCityButton{
    NSLog(@"touchSelectCityButton");
    LPSelectCityVC *vc = [[LPSelectCityVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
 
}

#pragma mark - LPSelectCityVCDelegate
-(void)selectCity:(LPCityModel *)model{
    if ([model.c_name isEqualToString:@"全国"]) {
        self.mechanismAddress = @"china";
    }else{
        self.mechanismAddress = model.c_name;
    }
    self.cityLabel.text = model.c_name;
    self.page = 1;
    [self request];
}



#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
    if(cell == nil){
        cell = [[LPMain2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
    }
    cell.model = self.listArray[indexPath.row];
//    WEAK_SELF()
//    cell.block = ^(void) {
//        weakSelf.page = 1;
//        [weakSelf request];
//    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.workListModel = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

    
//    LPHongBaoVC *vc = [[LPHongBaoVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController   pushViewController:vc animated:YES];
}

#pragma mark - search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    LPMainSearchVC *vc = [[LPMainSearchVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
 
    return NO;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
    LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.workListModel = self.model.data.slideshowList[index];
    [self.navigationController pushViewController:vc animated:YES];
 
}

#pragma mark - target
-(void)touchSortButton:(UIButton *)button{
//    if (kUserDefaultsValue(USERDATA).integerValue == 1 ||
//        kUserDefaultsValue(USERDATA).integerValue == 2 ||
//        kUserDefaultsValue(USERDATA).integerValue == 6 ) {
//        self.sortAlertView.titleArray = @[@"综合工资最高",@"报名人数最多",@"企业评分最高",@"工价最高",@"可借支",@"平台合作价",@"管理费"];
//    }else{
        self.sortAlertView.titleArray  = @[@"综合工资最高",@"报名人数最多",@"企业评分最高",@"工价最高",@"可借支"];
//    }
    button.selected = !button.isSelected;
    self.sortAlertView.hidden = !button.isSelected;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.RecommendScrollView) {
        if (scrollView.contentOffset.y==scrollView.contentSize.height){
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }

}


#pragma mark - LPSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{
    self.orderType = [NSString stringWithFormat:@"%ld",(long)index];
    self.page = 1;
    [self request];
}

-(void)touchScreenButton:(UIButton *)button{

    self.screenAlertView.SuperView = self;
    button.selected = !button.isSelected;
    self.screenAlertView.hidden = !button.isSelected;

}
#pragma mark - LPScreenAlertViewDelegate
-(void)selectMechanismTypeId:(NSString *)typeId workType:(NSString *)workType{
    self.mechanismTypeId = typeId;
    self.workType = workType;
    self.page = 1;
    [self request];
}

#pragma mark - request
-(void)request{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"page":@(self.page),
                          @"orderType":self.orderType ? self.orderType : @"",
                          @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                          @"mechanismTypeId":self.mechanismTypeId ? self.mechanismTypeId : @"",
                          @"workType":self.workType ? self.workType : @""
                          };
    [NetApiManager requestWorklistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if (self.page == 1&&!self.orderType&&!self.mechanismAddress&&!self.mechanismTypeId&&!self.workType) {
                 [LPUserDefaults saveObject:responseObject byFileName:[NSString stringWithFormat:@"WORKLISTCACHE"]];
                [LPUserDefaults saveObject:[NSDate date] byFileName:[NSString stringWithFormat: @"WORKLISTCACHEDATE"]];
            }
            self.model = [LPWorklistModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestMechanismlist{
    [NetApiManager requestMechanismlistWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.mechanismlistModel = [LPMechanismlistModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryDownload{
    NSDictionary *dic = @{
                          @"type":@"2"
                          };
    [NetApiManager requestQueryDownload:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"] != nil &&
                [responseObject[@"data"][@"version"] length]>1) {
                if (self.version.floatValue <  [responseObject[@"data"][@"version"] floatValue]  ) {
                    NSString *updateStr = [NSString stringWithFormat:@"发现新版本V%@\n为保证软件的正常运行\n请及时更新到最新版本",responseObject[@"data"][@"version"]];
                    [self creatAlterView:updateStr];
                }
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
        _tableview.estimatedRowHeight = 100;
        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self request];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self request];
        }];
    }
    return _tableview;
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView){
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 266);
        [_tableHeaderView addSubview:self.cycleScrollView];
        [_tableHeaderView addSubview:self.RecommendBackImage];
        [_tableHeaderView addSubview:self.RecommendScrollView];
        [_tableHeaderView addSubview:self.ButtonView];

        [_tableHeaderView addSubview:self.sortButton];
        [_tableHeaderView addSubview:self.screenButton];
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, 265.5, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = [UIColor baseColor];
        [_tableHeaderView addSubview:lineView];
    }
    return _tableHeaderView;
}
-(UIButton *)sortButton{
    if (!_sortButton) {
        _sortButton = [[UIButton alloc]init];
        _sortButton.frame = CGRectMake(13, 233, 70, 20);
        [_sortButton setTitle:@"默认排序" forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
        [_sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sortButton setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _sortButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_sortButton.imageView.frame.size.width - _sortButton.frame.size.width + _sortButton.titleLabel.intrinsicContentSize.width, 0, 0);
        _sortButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_sortButton.titleLabel.frame.size.width - _sortButton.frame.size.width + _sortButton.imageView.frame.size.width);
        [_sortButton addTarget:self action:@selector(TouchBt:) forControlEvents:UIControlEventTouchUpInside];
        _sortButton.selected = YES;
    }
    return _sortButton;
}
-(UIButton *)screenButton{
    if (!_screenButton) {
        _screenButton = [[UIButton alloc]init];
        _screenButton.frame = CGRectMake(SCREEN_WIDTH-45-13, 233, 45, 20);
        [_screenButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_screenButton setImage:[UIImage imageNamed:@"screen_normal"] forState:UIControlStateNormal];
        _screenButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _screenButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_screenButton.imageView.frame.size.width - _screenButton.frame.size.width + _screenButton.titleLabel.intrinsicContentSize.width, 0, 0);
        _screenButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_screenButton.titleLabel.frame.size.width - _screenButton.frame.size.width + _screenButton.imageView.frame.size.width);
        [_screenButton addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenButton;
}
-(LPSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPSortAlertView alloc]init];
        _sortAlertView.touchButton = self.sortButton;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}
-(LPScreenAlertView *)screenAlertView{
    if (!_screenAlertView) {
        _screenAlertView = [[LPScreenAlertView alloc]init];
    
        _screenAlertView.touchButton = self.screenButton;
        _screenAlertView.delegate = self;
    }
    return _screenAlertView;
}

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    }
    return _cycleScrollView;
    
}

-(UIScrollView *)RecommendScrollView{
    if (!_RecommendScrollView) {
        _RecommendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(48 , 156, SCREEN_WIDTH-69, 27)];
        _RecommendScrollView.delegate = self;
        _RecommendScrollView.showsVerticalScrollIndicator = NO;
        _RecommendScrollView.scrollEnabled = NO;
        _RecommendScrollView.bounces = NO;
     }
    return _RecommendScrollView;
}
-(void)changeScrollContentOffSetY{
    //启动定时器
    CGPoint point = self.RecommendScrollView.contentOffset;
    [self.RecommendScrollView setContentOffset:CGPointMake(0, point.y+CGRectGetHeight(self.RecommendScrollView.frame)) animated:YES];
}

- (UIImageView *)RecommendBackImage{
    if (!_RecommendBackImage) {
        _RecommendBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 156, SCREEN_WIDTH-26, 27)];
        _RecommendBackImage.image = [UIImage imageNamed:@"RecommendBackImage"];
    }
    return _RecommendBackImage;
}

- (UIView *)ButtonView{
    if (!_ButtonView) {
        _ButtonView = [[UIView alloc] initWithFrame:CGRectMake(13, 193, SCREEN_WIDTH-26, 27)];
        NSArray *arr = @[@"推荐好厂",@"高额返费",@"好评企业",@"可借支"];
        self.ButtonArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<arr.count; i++) {
            UIButton *Bt = [[UIButton alloc] init];
            [_ButtonView addSubview:Bt];
            [Bt setTitle:arr[i] forState:UIControlStateNormal];
            [Bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]] forState:UIControlStateNormal];
            [Bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E4F4FF"]] forState:UIControlStateSelected];
            [Bt setTitleColor:[UIColor colorWithHexString:@"#444444"] forState:UIControlStateNormal];
            [Bt setTitleColor:[UIColor colorWithHexString:@"#3CAFFF"] forState:UIControlStateSelected];
            Bt.titleLabel.font = [UIFont systemFontOfSize:13];
            Bt.layer.cornerRadius = 4;
            Bt.clipsToBounds = YES;
            [Bt addTarget:self action:@selector(TouchBt:) forControlEvents:UIControlEventTouchUpInside];
            [self.ButtonArr addObject:Bt];
        }
        
        [self.ButtonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
        [self.ButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.height.mas_equalTo(27);
        }];
    }
    return _ButtonView;
}
-(void)TouchBt:(UIButton *) sender{
    if (sender.selected == YES) {
        return;
    }
    self.sortButton.selected = NO;

    for (UIButton *bt in self.ButtonArr) {
        bt.selected = NO;
    }
    sender.selected = YES;
    if ([sender.currentTitle isEqualToString:@"默认排序"]) {
        self.orderType = @"";
    }else if ([sender.currentTitle isEqualToString:@"推荐好厂"]){
        self.orderType = @"7";
    }else if ([sender.currentTitle isEqualToString:@"高额返费"]){
        self.orderType = @"8";
    }else if ([sender.currentTitle isEqualToString:@"好评企业"]){
        self.orderType = @"2";
    }else if ([sender.currentTitle isEqualToString:@"可借支"]){
        self.orderType = @"4";
    }
    self.page = 1;
    [self request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//3. 弹框提示
-(void)creatAlterView:(NSString *)msg{
    UIAlertController *alertText = [UIAlertController alertControllerWithTitle:@"更新提醒" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //增加按钮
    [alertText addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [alertText addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1441365926?mt=8"; //更换id即可
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    [self presentViewController:alertText animated:YES completion:nil];
}

//版本
-(NSString *)version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}



@end
