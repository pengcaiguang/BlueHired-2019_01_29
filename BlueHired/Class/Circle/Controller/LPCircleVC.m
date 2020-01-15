//
//  LPCircleVC.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleVC.h"
#import "LPSearchBar.h"
#import "LPCircleCollectionViewCell.h"
#import "LPLoginVC.h"
#import "LPAddMoodeVC.h"
#import "LPInfoVC.h"
#import "UIBarButtonItem+Badge.h"
#import "LPInformationSearchVC.h"

 
static NSString *LPCircleCollectionViewCellID = @"LPCircleCollectionViewCell";

@interface LPCircleVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) NSInteger TypeIndex;
@property (nonatomic,assign) NSInteger isTopbar;

@end

@implementation LPCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http:www.baidu.com"]];

    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];

    [self setNavigationButton];
    [self setSearchView];
//    [self setupTitleView];
//    self.navigationItem.title = @"圈子";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
    }];
    [self.collectionView reloadData];
    self.TypeIndex = 0;
    _isTopbar = YES;
    [self addSendButton];
    
    [self selectButtonAtIndex:0];
    [self scrollToItenIndex:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSenderBack == 1 && !_isTopbar ) {
//        if (self.TypeIndex != 0) {
            [self selectButtonAtIndex:0];
            [self scrollToItenIndex:0];
//        }
        self.isSenderBack   = 0;
    }else if (self.isSenderBack == 3){
        LPCircleCollectionViewCell *cell = (LPCircleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.TypeIndex inSection:0]];
         [cell touchMoodTypeDeleteBack];
        self.isSenderBack   = 0;
    }else if (self.isSenderBack == 4){
        self.isSenderBack   = 0;
        self.TypeIndex = 0;
        [self selectButtonAtIndex:0];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self.collectionView layoutIfNeeded];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LPCircleCollectionViewCell *cell = (LPCircleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell touchMoodTypeSenderBack:0];
        });
    }
    if (AlreadyLogin) {
        [self requestQueryInfounreadNum];
    }else{
        LPCircleCollectionViewCell *cell = (LPCircleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setCircleMessage:0];
    }
    _isTopbar = NO;
//    [self.collectionView reloadData];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)setSearchView{
 
    
    LPSearchBar *searchBar = [self addSearchBar];
    searchBar.frame = CGRectMake(0, 0,  SCREEN_WIDTH - 80  , 32);

    UIView *wrapView = [[UIView alloc]init];
    wrapView.frame = CGRectMake(0, 0,  SCREEN_WIDTH - 80  , 32);
    wrapView.layer.cornerRadius = 16;
    wrapView.layer.masksToBounds = YES;
    //    wrapView.clipsToBounds = YES;
    wrapView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = wrapView;
//    self.navigationItem.titleView.backgroundColor = [UIColor redColor];
    
    [wrapView addSubview:searchBar];
//    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//
//    }];
}

- (LPSearchBar *)addSearchBar{
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]init];
    
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入关键字";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    UITextField *searchField;
    
    if (@available(iOS 13.0, *)) {
        searchField = searchBar.searchTextField;
    }else{
        searchField = [searchBar valueForKey:@"searchField"];
    }
   
    
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
#pragma mark - search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    LPInformationSearchVC *vc = [[LPInformationSearchVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Type = 3;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}


-(void)setNavigationButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo_Information" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0,100,button.currentImage.size.width, button.currentImage.size.height);
//    [button addTarget:self action:@selector(touchMessageButton) forControlEvents:UIControlEventTouchDown];
//
//    // 添加角标
//    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = navLeftButton;
//    self.navigationItem.rightBarButtonItem.badgeValue = @"";
//    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];


    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(touchMessageButton)];
}
-(void)setupTitleView{
    UIView *navigationView = [[UIView alloc]init];
    navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 49);
    navigationView.center = CGPointMake(navigationView.superview.center.x, navigationView.superview.frame.size.height/2);
    self.navigationItem.titleView = navigationView;
    
    self.buttonArray = [NSMutableArray array];
    NSArray *titleArray = @[@"分类",@"关注",@"我的"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [navigationView addSubview:button];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(touchTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
    }
    self.buttonArray[0].selected = YES;
    [self.buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [self.buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
    }];
    
    self.lineView = [[UIView alloc]init];
    [navigationView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(self.buttonArray[0].mas_width);
        make.centerX.equalTo(self.buttonArray[0]);
    }];
    self.lineView.backgroundColor = [UIColor whiteColor];
}
-(void)touchMessageButton{
    if ([LoginUtils validationLogin:self]) {
        LPInfoVC *vc = [[LPInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)addSendButton{
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(70), LENGTH_SIZE(72)));
        make.right.mas_equalTo(LENGTH_SIZE(-2));
        make.bottom.mas_equalTo(LENGTH_SIZE(-2));
    }];
    [button setImage:[UIImage imageNamed:@"sendDynamic_img"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchSendButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)touchSendButton{
    if ([LoginUtils validationLogin:self]) {
        LPAddMoodeVC *vc = [[LPAddMoodeVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)touchTitleButton:(UIButton *)button{
    NSInteger index = [self.buttonArray indexOfObject:button];
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}
-(void)selectButtonAtIndex:(NSInteger)index{
    for (UIButton *btn in self.buttonArray) {
        btn.selected = NO;
    }
    self.buttonArray[index].selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(self.buttonArray[index].mas_width);
            make.centerX.equalTo(self.buttonArray[index]);
        }];
        [self.lineView.superview layoutIfNeeded];
    }];
    
}
-(void)scrollToItenIndex:(NSInteger)index{
    self.TypeIndex = index;
     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LPCircleCollectionViewCell *cell = (LPCircleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.TypeIndex inSection:0]];
        [cell setIndex:self.TypeIndex];
    });
 }

#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.TypeIndex =page;
    [self selectButtonAtIndex:page];
    [self scrollToItenIndex:page];
 }
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPCircleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPCircleCollectionViewCellID forIndexPath:indexPath];
   
//    cell.labelListDataModel = self.labelListModel.data[indexPath.row];
    cell.contentView.backgroundColor = randomColor;
//    cell.index = indexPath.row;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_iPhoneX) {
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88-83.0);
    }else{
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-64-49);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        // layout.minimumInteritemSpacing = 10;// 垂直方向的间距
        layout.minimumLineSpacing = 0; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:LPCircleCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPCircleCollectionViewCellID];
        //        [_collectionView registerNib:[UINib nibWithNibName:JWMarketSellCollectionViewCellId bundle:nil] forCellWithReuseIdentifier:JWMarketSellCollectionViewCellId];
        
    }
    return _collectionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    // Dispose of any resources that can be recreated.
}

-(void)requestQueryInfounreadNum{
    NSDictionary *dic = @{@"type":@(6)
                          };
    [NetApiManager requestQueryUnreadNumWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSInteger num = [responseObject[@"data"] integerValue];
                LPCircleCollectionViewCell *cell = (LPCircleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell setCircleMessage:num];
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

 


@end
