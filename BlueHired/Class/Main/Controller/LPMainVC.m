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
#import "LPMainSortAlertView.h"
#import "LPScreenAlertView.h"
#import "LPMainSearchVC.h"
#import "LPWorkDetailVC.h"
#import "LPSelectCityVC.h"
#import "LPHongBaoVC.h"
#import "LPMain2Cell.h"
#import "DHGuidePageHUD.h"
#import "LPAdvertModel.h"
#import "ADAlertView.h"
#import "LPActivityModel.h"
#import "LPActivityDatelisVC.h"
#import "LPInCommentsVC.h"
#import "UIImage+GIF.h"
#import "LPHotWorkVC.h"

#define OPERATIONFORKEY @"operationGuidePage"

static NSString *LPMainCellID = @"LPMain2Cell";

@interface LPMainVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,LPMainSortAlertViewDelegate,LPSelectCityVCDelegate,LPScreenAlertViewDelegate,UITabBarDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)LPAdvertModel *AdvertModel;

@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,strong) UILabel *cityLabel;
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong) UIButton *sortButton;
@property(nonatomic,strong) UIButton *screenButton;
@property(nonatomic,strong) UIButton *screenTypeButton;
@property(nonatomic,strong) UIView *screenView;

@property(nonatomic,strong) LPMainSortAlertView *sortAlertView;
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
@property(nonatomic,assign) NSInteger oldY;
@property(nonatomic,strong) UIView *HeaderView;
@property(nonatomic,assign) BOOL IsShowHeaderView;
@property(nonatomic,assign) BOOL IsShowHeader2View;

@property(nonatomic,strong) CustomIOSAlertView *InCommentAlertView;
@property(nonatomic,strong)CustomIOSAlertView *CustomAlert;

@property(nonatomic,strong) UIButton *ReWrok;

@end

@implementation LPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    
    UIButton *ReWrok = [[UIButton alloc] init];
    [self.view addSubview:ReWrok];
    self.ReWrok = ReWrok;
    [ReWrok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(LENGTH_SIZE(4));
        make.bottom.mas_offset(LENGTH_SIZE(3));
        make.width.mas_offset(LENGTH_SIZE(94));
        make.height.mas_offset(LENGTH_SIZE(0));
    }];
    UIImage *customImg = [UIImage animatedImageNamed:@"hot_0" duration:1.0];
    [ReWrok setImage: customImg forState:UIControlStateNormal];
    [ReWrok addTarget:self action:@selector(TouchReWork:) forControlEvents:UIControlEventTouchUpInside];
    ReWrok.hidden = YES;
    
    UIButton *PhontBtn = [[UIButton alloc] init];
    [self.view addSubview:PhontBtn];
    [PhontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_offset(LENGTH_SIZE(-2));
        make.centerX.equalTo(ReWrok);
        make.bottom.equalTo(ReWrok.mas_top).offset(LENGTH_SIZE(-4));
        make.width.height.mas_offset(LENGTH_SIZE(72));
    }];
    [PhontBtn setImage:[UIImage imageNamed:@"servicePhone"] forState:UIControlStateNormal];
    [PhontBtn addTarget:self action:@selector(TouchPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self requestQueryActivityadvert:@"3"];
    
    
    
    

//    self.page = 1;
//    self.listArray = [NSMutableArray array];
//    [self request];
//    [self requestMechanismlist];

 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:OPERATIONFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OPERATIONFORKEY];
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否进行招工报名引导？"
                                                             message:nil
                                                       textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"]
                                                        buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]]
                                             buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                                         buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSArray *imageNameArray = @[@"OperationGuidance_01",
                                            @"OperationGuidance_02",
                                            @"OperationGuidance_03",
                                            @"OperationGuidance_04",
                                            @"OperationGuidance_05"];
                        if (IS_iPhoneX) {
                            imageNameArray =@[@"OperationGuidance_01_X",
                                              @"OperationGuidance_02_X",
                                              @"OperationGuidance_03_X",
                                              @"OperationGuidance_04_X",
                                              @"OperationGuidance_05_X"];
                        }
                // 创建并添加引导页
                DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:[UIApplication sharedApplication].keyWindow.frame imageNameArray:imageNameArray buttonIsHidden:YES isShowBt:YES isTouchNext:YES ];
                guidePage.slideInto = YES;
                [[UIApplication sharedApplication].keyWindow addSubview:guidePage];
            }
            
            [self requestQueryActivityadvert:@""];
            
        }];
        [alert showToWindow];
    }else{
        [self requestQueryActivityadvert:@""];
    }
    
//    [self requestQueryDownload];
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
    
    [self setLeftButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
 
    
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];
    [self setSearchView];
    [self.tableview reloadData];
    
    [self.RecommendScrollView setContentOffset:CGPointMake(0, 0)];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeScrollContentOffSetY) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    


    
    if (AlreadyLogin) {
        [self requestQueryGetWorkOrderRemarkMain];
    }
    
 }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.sortAlertView.touchButton.selected) {
        [self.sortAlertView close];
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
    NSLog(@"%f     navigationBar=%f    %f ",self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height,self.navigationController.navigationBar.frame.size.height,[[UIApplication sharedApplication] statusBarFrame].size.height);
    [leftBarButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(self.navigationController.navigationBar.frame.size.height);
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
        make.size.mas_equalTo(CGSizeMake(0, 6));
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
#pragma mark - 客服
-(void)TouchPhoneBtn:(UIButton *)sender{
//    sender.enabled = NO;
//    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.data.phone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        sender.enabled = YES;
//    });
    
    NSLog(@"咨询");
    NSString *name = self.model.data.phone;
    NSString *number = self.model.data.wxNum;
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.CustomAlert = alertView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300), LENGTH_SIZE(260))];
    view.layer.cornerRadius = LENGTH_SIZE(6);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.left.mas_offset(0);
        make.top.mas_offset(LENGTH_SIZE(24));
    }];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    titlelabel.text = @"联系客服";
    
    UILabel *titlelabel2 = [[UILabel alloc] init];
    [view addSubview:titlelabel2];
    [titlelabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.left.mas_offset(0);
        make.top.equalTo(titlelabel.mas_bottom).offset(LENGTH_SIZE(12));
    }];
    titlelabel2.textAlignment = NSTextAlignmentCenter;
    titlelabel2.font = [UIFont systemFontOfSize:FontSize(14)];
    titlelabel2.text = @"微信搜索微信号即可添加客服微信";
    titlelabel2.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    UIView *SubView = [[UIView alloc] init];
    [view addSubview:SubView];
    [SubView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titlelabel2.mas_bottom).offset(LENGTH_SIZE(19));
        make.left.mas_offset(LENGTH_SIZE(20));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.height.mas_offset(LENGTH_SIZE(75));
    }];
    SubView.layer.cornerRadius = LENGTH_SIZE(4);
    SubView.backgroundColor = [UIColor colorWithHexString:@"#F5F7FA"];
    
    
    UILabel *SubLabel1 = [[UILabel alloc] init];
    [SubView addSubview:SubLabel1];
    [SubLabel1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(13));
        make.left.mas_offset(LENGTH_SIZE(16));
        make.right.mas_offset(LENGTH_SIZE(-16));
    }];
    SubLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
    SubLabel1.font = [UIFont systemFontOfSize:FontSize(15)];
    SubLabel1.text = [NSString stringWithFormat:@"客服电话：%@ ",name];
    
    UILabel *SubLabel2 = [[UILabel alloc] init];
    [SubView addSubview:SubLabel2];
    [SubLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(SubLabel1.mas_bottom).offset(LENGTH_SIZE(12));
        make.left.mas_offset(LENGTH_SIZE(16));
    }];
    SubLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
    SubLabel2.font = [UIFont systemFontOfSize:FontSize(15)];
    SubLabel2.text = [NSString stringWithFormat:@"客服微信：%@ ",number];
    
    UIButton *CopyBt = [[UIButton alloc] init];
    [view addSubview:CopyBt];
    [CopyBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(SubView.mas_bottom).offset(LENGTH_SIZE(24));
        make.left.mas_offset(LENGTH_SIZE(20));
        make.height.mas_offset(LENGTH_SIZE(40));
    }];
    CopyBt.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
    [CopyBt setTitle:@"复制微信" forState:UIControlStateNormal];
    [CopyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CopyBt addTarget:self action:@selector(TouchCopyBt) forControlEvents:UIControlEventTouchUpInside];
    CopyBt.layer.cornerRadius = LENGTH_SIZE(6);
    CopyBt.backgroundColor = [UIColor colorWithHexString:@"#57CC37"];
    
    UIButton *dialBt = [[UIButton alloc] init];
    [view addSubview:dialBt];
    [dialBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(SubView.mas_bottom).offset(LENGTH_SIZE(24));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.left.equalTo(CopyBt.mas_right).offset(LENGTH_SIZE(16));
        make.height.mas_offset(LENGTH_SIZE(40));
        make.width.equalTo(CopyBt.mas_width);
    }];
    dialBt.titleLabel.font = [UIFont systemFontOfSize:FontSize(17)];
    [dialBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dialBt setTitle:@"拨打电话" forState:UIControlStateNormal];
    dialBt.layer.cornerRadius = LENGTH_SIZE(6);
    dialBt.backgroundColor = [UIColor baseColor];
    [dialBt addTarget:self action:@selector(TouchDialBt:) forControlEvents:UIControlEventTouchUpInside];
    
    alertView.containerView = view;
    alertView.buttonTitles=@[];
    [alertView setUseMotionEffects:true];
    [alertView setCloseOnTouchUpOutside:true];
    [alertView show];
    
}

-(void)TouchCopyBt{
    [self.CustomAlert close];
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.data.wxNum;
    [self.view showLoadingMeg:@"复制成功" time:MESSAGE_SHOW_TIME];
}

-(void)TouchDialBt:(UIButton *)sender{
    [self.CustomAlert close];
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.data.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}


#pragma mark - 热招企业
-(void)TouchReWork:(UIButton *)sender{
    LPHotWorkVC *vc = [[LPHotWorkVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 入职评价
-(void)InCommentsInitView:(NSInteger) workOrderId{
    CustomIOSAlertView *AlertView = [[CustomIOSAlertView alloc] init];
    self.InCommentAlertView = AlertView;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300), LENGTH_SIZE(326))];
    UIImageView *bgImage = [[UIImageView alloc] init];
    [view addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(view);
    }];
    bgImage.image = [UIImage imageNamed:@"In_comments_bg"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(LENGTH_SIZE(183));
        make.centerX.equalTo(view);
    }];
    titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(23)];
    titleLabel.textColor = [UIColor baseColor];
    titleLabel.text = @"恭喜您，入职成功";
    
    UILabel *ContentLabel = [[UILabel alloc] init];
    [view addSubview:ContentLabel];
    [ContentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(LENGTH_SIZE(10));
        make.centerX.equalTo(view);
    }];
    ContentLabel.font = FONT_SIZE(16);
    ContentLabel.textColor = [UIColor colorWithHexString:@"#AFB1B3"];
    ContentLabel.text = @"您可以对本次入职体验进行评价";
    
    UIButton *bt = [[UIButton alloc] init];
    [view addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(ContentLabel.mas_bottom).offset(LENGTH_SIZE(20));
        make.centerX.equalTo(view);
        make.width.mas_equalTo(LENGTH_SIZE(260));
    }];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.layer.cornerRadius = 6;
    bt.backgroundColor = [UIColor baseColor];
    bt.titleLabel.font = FONT_SIZE(16);
    [bt setTitle:@"立即评价" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(TouchInComment:) forControlEvents:UIControlEventTouchUpInside];
    bt.tag = workOrderId;
    
    AlertView.containerView = view;
    AlertView.buttonTitles = @[];
    [AlertView setUseMotionEffects:true];
    [AlertView setCloseOnTouchUpOutside:true];
    [AlertView show];
    
}


-(void)TouchInComment:(UIButton *)sender{
    NSLog(@"立即评价");
    [self.InCommentAlertView close];
    
    LPInCommentsVC *vc = [[LPInCommentsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Type = 1;
    vc.workOrderId = sender.tag;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
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
 
        
        [self.RecommendScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
        for (int i =0 ;i <self.model.data.workBarsList.count;i++) {
            LPWorklistDataWorkBarsListModel *m = self.model.data.workBarsList[i];
            UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(LENGTH_SIZE(85),
                                                                      i*floorf(LENGTH_SIZE(44)),
                                                                      SCREEN_WIDTH-LENGTH_SIZE(85),
                                                                      floorf(LENGTH_SIZE(44)))];
            [self.RecommendScrollView addSubview:label];
            label.text = [NSString stringWithFormat:@"恭喜%@入职成功%@",m.userName,m.mechanismName];
            label.textColor = [UIColor baseColor];
            label.font = [UIFont systemFontOfSize:FontSize(13)];
            label.textAlignment = NSTextAlignmentLeft;
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
            [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(0, 2)];
            [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(2+m.userName.length, 4)];
            label.attributedText = string;
 
 //            label.backgroundColor = [UIColor redColor];
        }
        self.RecommendScrollView.contentSize = CGSizeMake(0, self.model.data.workBarsList.count*floorf(LENGTH_SIZE(44)));
        
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
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0,
                                                                                 LENGTH_SIZE(296) ,
                                                                                 SCREEN_WIDTH,
                                                                                 SCREEN_HEIGHT-LENGTH_SIZE(296-49)-kNavBarHeight-kBottomBarHeight)];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
        noDataView.hidden = hidden;
    }
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
    if (model.c_name.length>3) {
        self.cityLabel.text = [NSString stringWithFormat:@"%@…",[model.c_name substringToIndex:3]];
    }else{
        self.cityLabel.text = model.c_name;
    }
    self.page = 1;
    [self request];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual: self.tableview]) {
        if (self.tableview.contentOffset.y > LENGTH_SIZE(216)) {
            if (self.IsShowHeaderView != YES) {
                _tableHeaderView.lx_height = LENGTH_SIZE(214);
                self.IsShowHeaderView = YES;
                [self.tableview reloadData];
            }
        }else{
            if (self.IsShowHeaderView != NO) {
                _tableHeaderView.lx_height = LENGTH_SIZE(296);

                self.ButtonView.lx_y = LENGTH_SIZE(254);
                self.screenView.lx_y = LENGTH_SIZE(214);
                self.ButtonView.hidden = NO;
                self.screenView.hidden = NO;
                [_tableHeaderView addSubview:self.ButtonView];
                [_tableHeaderView addSubview:self.screenView];
                self.IsShowHeaderView = NO;
                [self.tableview reloadData];
            }
        }
        
        if (self.tableview.contentOffset.y > _oldY) {
 
        }else{
 
            self.tableview.sectionHeaderHeight = LENGTH_SIZE(20);

        }
    }
 
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    _oldY = self.tableview.contentOffset.y;

}
#pragma mark - TableViewDelegate & Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.IsShowHeaderView) {
        return LENGTH_SIZE(80);
    }
    return 0;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
 
    self.ButtonView.lx_y = LENGTH_SIZE(40);
    self.screenView.lx_y = 0;

    [view addSubview:self.ButtonView];
    [view addSubview:self.screenView];

    self.HeaderView = view;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorklistDataWorkListModel *m = self.listArray[indexPath.row];
    if (m.key.length == 0) {
        return LENGTH_SIZE(120) ;
    }
    return LENGTH_SIZE(140) ;
}

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
 
}

#pragma mark - search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    LPMainSearchVC *vc = [[LPMainSearchVC alloc]init];
    vc.mechanismAddress = self.mechanismAddress;
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
        if (scrollView.contentOffset.y>=scrollView.contentSize.height){
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }

}


#pragma mark - LPMainSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{

    if (self.sortAlertView.touchButton == self.screenTypeButton) {
//        self.orderType = [NSString stringWithFormat:@"%ld",(long)index];
        if (index == 0) {
            self.mechanismTypeId = @"";
            [self.screenTypeButton setTitle:@"全部企业" forState:UIControlStateNormal];
        }else{
            self.mechanismTypeId =[NSString stringWithFormat:@"%@", self.mechanismlistModel.data.mechanismTypeList[index-1].id];
            [self.screenTypeButton setTitle:self.mechanismlistModel.data.mechanismTypeList[index-1].mechanismTypeName forState:UIControlStateNormal];
        }
        

        
        self.screenTypeButton.tag = index;
        self.page = 1;
        [self request];
    }else if (self.sortAlertView.touchButton == self.screenButton){
        if (index == 0) {
            self.workType = @"";
            [self.screenButton setTitle:@"全部工种" forState:UIControlStateNormal];
        }else if (index == 1){
            self.workType = @"1";
            [self.screenButton setTitle:@"小时工" forState:UIControlStateNormal];
        }else if (index == 2){
            self.workType = @"0";
            [self.screenButton setTitle:@"正式工" forState:UIControlStateNormal];
        }
        self.screenButton.tag = index;
        self.page = 1;
        [self request];
    }

}

-(void)touchScreenButton:(UIButton *)button{
    if (self.tableview.contentOffset.y < LENGTH_SIZE(216) ) {
        CGPoint bottomOffset = CGPointMake(0, LENGTH_SIZE(216));
        [self.tableview setContentOffset:bottomOffset animated:NO];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (button == self.screenButton) {
            self.screenTypeButton.selected = NO;
            self.sortAlertView.titleArray  = @[@"全部工种",@"小时工",@"正式工"];
            button.selected = !button.isSelected;
            self.sortAlertView.touchButton = button;
            self.sortAlertView.selectTitle = button.tag;
            self.sortAlertView.hidden = !button.isSelected;
        }else if (button == self.screenTypeButton){
            NSMutableArray *Array = [[NSMutableArray alloc] init];
            [Array addObject:@"全部企业"];
            for (int i = 0; i < self.mechanismlistModel.data.mechanismTypeList.count; i++) {
                [Array addObject:self.mechanismlistModel.data.mechanismTypeList[i].mechanismTypeName];
            }
            self.screenButton.selected = NO;

            self.sortAlertView.titleArray  = Array;
            button.selected = !button.isSelected;
            self.sortAlertView.selectTitle = button.tag;
            self.sortAlertView.touchButton = button;
            self.sortAlertView.hidden = !button.isSelected;
        }
    });
   

    
//    self.screenAlertView.SuperView = self;
//    button.selected = !button.isSelected;
//    self.screenAlertView.hidden = !button.isSelected;

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
            if ([responseObject[@"code"] integerValue] == 0) {
                if (self.page == 1&&!self.orderType&&!self.mechanismAddress&&!self.mechanismTypeId&&!self.workType) {
                    [LPUserDefaults saveObject:responseObject byFileName:[NSString stringWithFormat:@"WORKLISTCACHE"]];
                    [LPUserDefaults saveObject:[NSDate date] byFileName:[NSString stringWithFormat: @"WORKLISTCACHEDATE"]];
                }
                self.model = [LPWorklistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestMechanismlist{
    [NetApiManager requestMechanismlistWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.mechanismlistModel = [LPMechanismlistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
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
            if ([responseObject[@"code"] integerValue] == 0) {
                if (responseObject[@"data"] != nil &&
                    [responseObject[@"data"][@"version"] length]>0) {
                    if (self.version.floatValue <  [responseObject[@"data"][@"version"] floatValue]  ) {
                        NSString *updateStr = [NSString stringWithFormat:@"发现新版本V%@\n为保证软件的正常运行\n请及时更新到最新版本",responseObject[@"data"][@"version"]];
                        [self creatAlterView:updateStr];
                    }
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetWorkOrderRemarkMain{
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetWorkOrderRemarkMain:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    [self InCommentsInitView:[responseObject[@"data"] integerValue]];
                }
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
        _tableview.estimatedRowHeight = 0;
        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(296));
        [_tableHeaderView addSubview:self.cycleScrollView];
        [_tableHeaderView addSubview:self.RecommendScrollView];
        [_tableHeaderView addSubview:self.RecommendBackImage];
        [_tableHeaderView addSubview:self.ButtonView];
        [_tableHeaderView addSubview:self.screenView];
//        [_tableHeaderView addSubview:self.sortButton];
//        [_tableHeaderView addSubview:self.screenButton];
        _tableHeaderView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, LENGTH_SIZE(296.5), SCREEN_WIDTH, LENGTH_SIZE(0.5));
        lineView.backgroundColor = [UIColor clearColor];
        [_tableHeaderView addSubview:lineView];
    }
    return _tableHeaderView;
}
-(UIButton *)sortButton{
    if (!_sortButton) {
        _sortButton = [[UIButton alloc]init];
        _sortButton.frame = CGRectMake(LENGTH_SIZE(13), 0, LENGTH_SIZE(70), LENGTH_SIZE(40));
        [_sortButton setTitle:@"企业列表" forState:UIControlStateNormal];
 
        [_sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         _sortButton.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        _sortButton.enabled = NO;
    }
    return _sortButton;
}
-(UIButton *)screenButton{
    if (!_screenButton) {
        _screenButton = [[UIButton alloc]init];
        _screenButton.frame = CGRectMake(SCREEN_WIDTH-LENGTH_SIZE(75+13) , 0,LENGTH_SIZE(75), LENGTH_SIZE(40));
        [_screenButton setTitle:@"全部工种" forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [_screenButton setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_screenButton setImage:[UIImage imageNamed:@"drop_down_sel"] forState:UIControlStateSelected];
        _screenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

        _screenButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
        _screenButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_screenButton.imageView.frame.size.width - _screenButton.frame.size.width + _screenButton.titleLabel.intrinsicContentSize.width, 0,LENGTH_SIZE(20));
        _screenButton.imageEdgeInsets = UIEdgeInsetsMake(0,LENGTH_SIZE(55+8) , 0, 0);
        [_screenButton addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenButton;
}

-(UIButton *)screenTypeButton{
    if (!_screenTypeButton) {
        _screenTypeButton = [[UIButton alloc]init];
        _screenTypeButton.frame = CGRectMake(SCREEN_WIDTH-LENGTH_SIZE(75+13 + 80 + 10) , 0,LENGTH_SIZE(75),LENGTH_SIZE(40));
        [_screenTypeButton setTitle:@"全部企业" forState:UIControlStateNormal];
        [_screenTypeButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_screenTypeButton setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        [_screenTypeButton setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_screenTypeButton setImage:[UIImage imageNamed:@"drop_down_sel"] forState:UIControlStateSelected];

        _screenTypeButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
        _screenTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

        _screenTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                             -_screenTypeButton.imageView.frame.size.width - _screenTypeButton.frame.size.width + _screenTypeButton.titleLabel.intrinsicContentSize.width,
                                                             0,
                                                             LENGTH_SIZE(20));
        
        _screenTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                             LENGTH_SIZE(55+8),
                                                             0,
                                                             0);
        [_screenTypeButton addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenTypeButton;
}

- (UIView *)screenView{
     if (!_screenView) {
         _screenView = [[UIView alloc] initWithFrame:CGRectMake(0, LENGTH_SIZE(214) , SCREEN_WIDTH, LENGTH_SIZE(40))];
         _screenView.tag = 2000;
         _screenView.backgroundColor = [UIColor whiteColor];

         [_screenView addSubview:self.screenButton];
         [_screenView addSubview:self.screenTypeButton];
         [_screenView addSubview:self.sortButton];
     }
    return _screenView;
}


-(LPMainSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPMainSortAlertView alloc]init];
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
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(150)) delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleScrollView;
    
}

-(UIScrollView *)RecommendScrollView{
    if (!_RecommendScrollView) {
        _RecommendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 , LENGTH_SIZE(160), SCREEN_WIDTH, floorf(LENGTH_SIZE(44)))];
        _RecommendScrollView.delegate = self;
        _RecommendScrollView.showsVerticalScrollIndicator = NO;
        _RecommendScrollView.scrollEnabled = NO;
        _RecommendScrollView.bounces = NO;
        _RecommendScrollView.backgroundColor = [UIColor whiteColor];
        
     }
    return _RecommendScrollView;
}
-(void)changeScrollContentOffSetY{
    //启动定时器
    CGPoint point = self.RecommendScrollView.contentOffset;
 
    [self.RecommendScrollView setContentOffset:CGPointMake(0, point.y+floorf(LENGTH_SIZE(44))) animated:YES];
    
}

- (UIImageView *)RecommendBackImage{
    if (!_RecommendBackImage) {
        _RecommendBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(LENGTH_SIZE(0),LENGTH_SIZE(160) ,LENGTH_SIZE(69) ,LENGTH_SIZE(44))];
        _RecommendBackImage.image = [UIImage imageNamed:@"radio"];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(LENGTH_SIZE(68),LENGTH_SIZE(10) ,LENGTH_SIZE(1) ,LENGTH_SIZE(24))];
        [_RecommendBackImage addSubview:lineV];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        
    }
    return _RecommendBackImage;
}

- (UIView *)ButtonView{
    if (!_ButtonView) {
        _ButtonView = [[UIView alloc] initWithFrame:CGRectMake(LENGTH_SIZE(0),LENGTH_SIZE(254) ,SCREEN_WIDTH , LENGTH_SIZE(42))];
        _ButtonView.tag = 1000;
        _ButtonView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"在招企业",@"高薪企业",@"有返费",@"可借支"];
        self.ButtonArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<arr.count; i++) {
            UIButton *Bt = [[UIButton alloc] init];
            [_ButtonView addSubview:Bt];
            [Bt setTitle:arr[i] forState:UIControlStateNormal];
            [Bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]] forState:UIControlStateNormal];
            [Bt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E4F4FF"]] forState:UIControlStateSelected];
            [Bt setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [Bt setTitleColor:[UIColor colorWithHexString:@"#3CAFFF"] forState:UIControlStateSelected];
            Bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
            Bt.layer.cornerRadius =LENGTH_SIZE(4);
            Bt.clipsToBounds = YES;
            [Bt addTarget:self action:@selector(TouchBt:) forControlEvents:UIControlEventTouchUpInside];
            [self.ButtonArr addObject:Bt];
        }
        
        [self.ButtonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:LENGTH_SIZE(7) leadSpacing:LENGTH_SIZE(13) tailSpacing:LENGTH_SIZE(13)];
        [self.ButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(6));
            make.height.mas_equalTo(LENGTH_SIZE(30));
        }];
    }
    return _ButtonView;
}
-(void)TouchBt:(UIButton *) sender{
    
    if (self.tableview.contentOffset.y < LENGTH_SIZE(216)) {
        CGPoint bottomOffset = CGPointMake(0, LENGTH_SIZE(216));
        [self.tableview setContentOffset:bottomOffset animated:NO];
    }
    
    if (sender.selected == YES) {
        self.orderType = @"";
        sender.selected = NO;
        self.page = 1;
        [self request];
        return;
    }
  

    for (UIButton *bt in self.ButtonArr) {
        bt.selected = NO;
    }
    sender.selected = YES;
    if ([sender.currentTitle isEqualToString:@"默认排序"]) {
        self.orderType = @"";
    }else if ([sender.currentTitle isEqualToString:@"在招企业"]){
        self.orderType = @"10";
    }else if ([sender.currentTitle isEqualToString:@"高薪企业"]){
        self.orderType = @"8";
    }else if ([sender.currentTitle isEqualToString:@"有返费"]){
        self.orderType = @"9";
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

-(void)requestQueryActivityadvert:(NSString *) type{
    NSDictionary *dic = nil;
    if (type.integerValue == 3) {
        dic = @{@"type":type};
    }
    [NetApiManager requestQueryActivityadvert:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                LPAdvertModel *model = [LPAdvertModel mj_objectWithKeyValues:responseObject];
                if (model.data.count) {
                    if (type.integerValue == 3) {
                        self.ReWrok.hidden = NO;
                        [self.ReWrok mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_offset(LENGTH_SIZE(4));
                            make.bottom.mas_offset(LENGTH_SIZE(3));
                            make.width.mas_offset(LENGTH_SIZE(94));
                            make.height.mas_offset(LENGTH_SIZE(94));
                        }];
                    }else{
                        self.AdvertModel = model;
                        [ADAlertView  showInView:[UIWindow visibleViewController].view theDelegate:self theADInfo:model.data placeHolderImage:@"1"];
                    }
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)clickAlertViewAtIndex:(NSInteger)index{
    LPActivityDatelisVC *vc = [[LPActivityDatelisVC alloc] init];
    LPActivityDataModel *M = [[LPActivityDataModel alloc] init];
    M.id = self.AdvertModel.data[index].id;
    vc.Model = M;
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

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
