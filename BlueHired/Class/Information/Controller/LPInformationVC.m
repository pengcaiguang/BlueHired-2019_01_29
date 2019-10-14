//
//  LPInformationVC.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationVC.h"
#import "LPSearchBar.h"
#import "LPLabelListModel.h"
#import "LPInformationCollectionViewCell.h"
#import "LPInformationSearchVC.h"
#import "LPInfoVC.h"
#import "UIBarButtonItem+Badge.h"
#import "LPSortAlertView.h"
#import "LPVideoListModel.h"
#import "LPInfoMationVideoCell.h"
#import "LPVideoVC.h"
#import "LPVideoTypeModel.h"
#import "JXCategoryView.h"
#import "LPInformationView.h"
#import "UISegmentedControl+LPCommon.h"


static NSString *LPInformationCollectionViewCellID = @"LPInformationCollectionViewCell";
static NSString *LPInformationVideoCollectionViewCellID = @"LPInfoMationVideoCell";

@interface LPInformationVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,LPSortAlertViewDelegate>
@property(nonatomic,strong) LPLabelListModel *labelListModel;
@property(nonatomic,strong) LPVideoListModel *VideoListModel;
@property(nonatomic,strong) LPVideoTypeModel *VideoTypeModel;
@property(nonatomic,strong) NSMutableArray <LPVideoListDataModel *>*listArray;

@property(nonatomic,strong) UIView *labelListView;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;
@property(nonatomic,strong) UIButton *VideoLabel;
@property(nonatomic,strong) LPSortAlertView *sortAlertView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger GetVideoUserID;

@property (nonatomic,assign) UIScrollView *LabelscrollView;
@property (nonatomic, assign) BOOL isReloadData;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) LPSearchBar *search;

@property (nonatomic, strong) UIScrollView *ViewscrollView;
@property (nonatomic, strong) NSMutableArray <LPInformationView *>*ViewArray;

@property (nonatomic,strong) UISegmentedControl *Segmented;

@end

@implementation LPInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.labelArray = [NSMutableArray array];
 

//    self.extendedLayoutIncludesOpaqueBars = YES;
//    if (@available(iOS 11.0, *)) {
//        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    [self setNavigationButton];
    [self setLeftButton];
    [self setSearchView];
    
    [self.view addSubview:self.labelListView];
    [self.labelListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.labelListView.mas_bottom).offset(0);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-0);
//    }];

    self.ViewscrollView = [[UIScrollView alloc] init];
    self.ViewscrollView.frame = CGRectMake(0, LENGTH_SIZE(40), Screen_Width,  SCREEN_HEIGHT-kNavBarHeight-LENGTH_SIZE(40)-49-kBottomBarHeight);
   
    self.ViewscrollView.delegate = self;
    self.ViewscrollView.pagingEnabled = YES;
    self.ViewscrollView.showsHorizontalScrollIndicator = FALSE;
     [self.view addSubview:self.ViewscrollView];
    
    [self.view addSubview:self.videocollectionView];
    [self.videocollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
    }];
 
    
//    self.videocollectionView.hidden = YES;
 }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];
    
    
    
    if (self.VideoTypeModel.data.count <= 0) {
        [self requestQueryGetVideoTypeList];
    }
    
    if (self.labelArray.count <= 0) {
        //判断缓存
        NSDate *date = [LPUserDefaults getObjectByFileName:@"INFOLABELLISTCACHEDATE"];
        id CacheList = [LPUserDefaults getObjectByFileName:@"INFOLABELLISTCACHE"];
        if ([LPTools compareOneDay:date withAnotherDay:[NSDate date]]<=15 && CacheList) {
            self.labelListModel = [LPLabelListModel mj_objectWithKeyValues:CacheList];
        }else{
            [self requestLabellist];
        }
    }
    
//    if (AlreadyLogin) {
//        [self requestQueryInfounreadNum];
//    }

    //视频列表获取规则
    NSLog(@"%ld",(long)kUserDefaultsValue(LOGINID).integerValue);
    if (self.IsBackVideo == NO &&
        (self.GetVideoUserID != kUserDefaultsValue(LOGINID).integerValue ||
        self.listArray.count<=0)) {
            //查看是否有缓存数据
//            VIDEOLISTCACHEDATE
         NSDate *date = [LPUserDefaults getObjectByFileName:@"VIDEOLISTCACHEDATE"];
        NSMutableArray *CacheList = [LPUserDefaults getObjectByFileName:@"VIDEOLISTCACHE"];
            
            if ([LPTools compareOneDay:date withAnotherDay:[NSDate date]]<=15 && CacheList.count) {
                [self.listArray removeAllObjects];
                self.listArray = [LPVideoListDataModel mj_objectArrayWithKeyValuesArray:CacheList];
                [self.videocollectionView reloadData];
            }else{
                self.page = 1;
//                [self.listArray removeAllObjects];
                [self requestQueryGetVideoList];
            }
            

    }else{
        self.IsBackVideo = NO;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setNavigationButton{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"serch" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
//    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"serch"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,100,24, 24);
    [button addTarget:self action:@selector(touchMessageButton) forControlEvents:UIControlEventTouchDown];
//
//    // 添加角标
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navLeftButton;
//    self.navigationItem.rightBarButtonItem.badgeValue = @"";
//    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];

}

-(void)setLeftButton{
    UIView *leftBarButtonView = [[UIView alloc]init];
    //    leftBarButtonView.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButtonView];
    [leftBarButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height);
    }];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSortButton)];
//    leftBarButtonView.userInteractionEnabled = YES;
//    [leftBarButtonView addGestureRecognizer:tap];
    
//    UIImageView *pimageView = [[UIImageView alloc]init];
//    [leftBarButtonView addSubview:pimageView];
//    [pimageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(-15);
//        make.size.mas_equalTo(CGSizeMake(11, 12));
//    }];
//    pimageView.image = [UIImage imageNamed:@"positioning"];
    
//    self.VideoLabel = [[UIButton alloc]init];
//    [leftBarButtonView addSubview:self.VideoLabel];
//    [self.VideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(-5);
//    }];
//    [self.VideoLabel setTitle:@"视频" forState:UIControlStateNormal];
//    self.VideoLabel.titleLabel.font = [UIFont systemFontOfSize:17];
//    [self.VideoLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.VideoLabel addTarget:self action:@selector(touchSortButton:) forControlEvents:UIControlEventTouchUpInside];
//    self.VideoLabel.selected = NO;
//    UIImageView *dimageView = [[UIImageView alloc]init];
//    [leftBarButtonView addSubview:dimageView];
//    [dimageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.VideoLabel.mas_right).offset(3);
//        make.centerY.equalTo(self.VideoLabel);
//        make.size.mas_equalTo(CGSizeMake(11, 6));
//        make.right.equalTo(leftBarButtonView.mas_right).offset(0);
//    }];
//    dimageView.image = [UIImage imageNamed:@"downArrow"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo_Information" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
}

-(void)touchMessageButton{
//    self.VideoLabel.selected = NO;
//    self.sortAlertView.hidden =YES;
//    if ([LoginUtils validationLogin:self]) {
//         LPInfoVC *vc = [[LPInfoVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    [self searchBarShouldBeginEditing:nil];
    
}
-(void)setSearchView{
//    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 , 44)];
//    self.search = searchBar;
//    UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
//    [wrapView addSubview:searchBar];
//    self.navigationItem.titleView = wrapView;
    
    UISegmentedControl *Segmented = [[UISegmentedControl alloc] initWithItems:@[@"视频",@"资讯"]];
    self.Segmented = Segmented;
    Segmented.frame = CGRectMake(0, 0, 160, 28);
    Segmented.tintColor = [UIColor whiteColor];
    Segmented.selectedSegmentIndex = 0;
    [Segmented addTarget:self action:@selector(Segmentedselected:) forControlEvents:UIControlEventValueChanged];

    self.navigationItem.titleView = Segmented;
    [Segmented ensureiOS12Style];
 
}

-(void)Segmentedselected:(UISegmentedControl *) sender{
    if (sender.selectedSegmentIndex == 0) {
//        [self.VideoLabel setTitle:@"视频" forState:UIControlStateNormal];
//        self.search.placeholder = @"搜索感兴趣的短视频";
        self.videocollectionView.hidden = NO;
    }else{
//        [self.VideoLabel setTitle:@"资讯" forState:UIControlStateNormal];
//        self.search.placeholder = @"搜索关键字";
        self.videocollectionView.hidden =  YES;
    }
}

- (LPSearchBar *)addSearchBarWithFrame:(CGRect)frame {
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]initWithFrame:frame];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索感兴趣的短视频";
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
#pragma mark - target
-(void)touchSortButton:(UIButton *)button{
 
    self.sortAlertView.titleArray  = @[@"视频",@"资讯"];
    button.selected = !button.isSelected;
    self.sortAlertView.hidden =  !button.isSelected;

}
#pragma mark - LPSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{
    NSLog(@"index = %ld",(long)index);
    if (index == 0) {
        [self.VideoLabel setTitle:@"视频" forState:UIControlStateNormal];
        self.search.placeholder = @"搜索感兴趣的短视频";
        self.videocollectionView.hidden = NO;
    }else{
         [self.VideoLabel setTitle:@"资讯" forState:UIControlStateNormal];
        self.search.placeholder = @"搜索关键字";
        self.videocollectionView.hidden =  YES;
    }
 }

-(void)setLabelListModel:(LPLabelListModel *)labelListModel{
    _labelListModel = labelListModel;
    if ([labelListModel.code integerValue] == 0) {
        if (labelListModel.data.count <= 0) {
            return;
        }
        
        for (UIView *view in [self.ViewscrollView subviews]) {
            [view removeFromSuperview];
        }
        for (UIView *view in [self.labelListView subviews]) {
            [view removeFromSuperview];
        }
        
        NSMutableArray *LabelArray = [[NSMutableArray alloc] init];
        self.ViewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i <labelListModel.data.count; i++) {
            [LabelArray addObject:labelListModel.data[i].labelName];
            LPInformationView *view = [[LPInformationView alloc] init];
//            view.labelListDataModel = labelListModel.data[i];
            view.frame = CGRectMake(i*self.ViewscrollView.bounds.size.width, 0, self.ViewscrollView.bounds.size.width, self.ViewscrollView.bounds.size.height);
            [self.ViewArray addObject:view];
            [self.ViewscrollView addSubview:view];
        }
        if (self.ViewArray.count) {
            self.ViewArray[0].labelListDataModel = labelListModel.data[0];
        }
 
        self.ViewscrollView.contentSize = CGSizeMake(Screen_Width*labelListModel.data.count, self.ViewscrollView.frame.size.height);

        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(40))];
        [self.labelListView addSubview:scrollView];
        self.LabelscrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
//        NSArray *t = @[@"首页",@"军事",@"生活生活",@"社会回",@"招聘",@"信息新",@"圈子",@"我的我的",@"我",@"搜索"];

        CGFloat w = 0;
        for (int i = 0; i <labelListModel.data.count; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.text = labelListModel.data[i].labelName;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:FontSize(14)];
            [scrollView addSubview:label];
            label.textColor = [UIColor grayColor];
            CGSize size = CGSizeMake(LENGTH_SIZE(100), MAXFLOAT);//设置高度宽度的最大限度
            CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];

            CGFloat lw = rect.size.width + LENGTH_SIZE(30);
            w += lw;
            label.frame = CGRectMake(w - lw, 0, lw, LENGTH_SIZE(40));
            label.tag = i;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabel:)];
            [label addGestureRecognizer:tap];
            [self.labelArray addObject:label];
        }
        scrollView.contentSize = CGSizeMake(w, LENGTH_SIZE(40));

        self.lineView = [[UIView alloc]init];
        CGFloat s = CGRectGetWidth(self.labelArray[0].frame);
        self.lineView.frame = CGRectMake(0, LENGTH_SIZE(38), s, LENGTH_SIZE(2));
        self.lineView.backgroundColor = [UIColor baseColor];
        [scrollView addSubview:self.lineView];
        self.labelArray[0].textColor = [UIColor blackColor];

        [self.collectionView reloadData];
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)touchLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}
-(void)selectButtonAtIndex:(NSInteger)index{
    CGFloat x = CGRectGetMinX(self.labelArray[index].frame);
    CGFloat w = CGRectGetWidth(self.labelArray[index].frame);
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor grayColor];
    }
    self.labelArray[index].textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(x, LENGTH_SIZE(38), w, LENGTH_SIZE(2));
    }];
 
    if (x+w>SCREEN_WIDTH) {
        [self.LabelscrollView setContentOffset:CGPointMake(x+w - SCREEN_WIDTH,0) animated:YES];
    }else{
        [self.LabelscrollView setContentOffset:CGPointMake(0,0) animated:YES];

    }
    
}
-(void)scrollToItenIndex:(NSInteger)index{
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.ViewArray[index].labelListDataModel = self.labelListModel.data[index];
    [self.ViewscrollView setContentOffset:CGPointMake(Screen_Width*index,0 ) animated:YES];
    self.ViewscrollView.bouncesZoom = NO;
}
#pragma mark - search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.VideoLabel.selected = NO;
    self.sortAlertView.hidden =YES;
    LPInformationSearchVC *vc = [[LPInformationSearchVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    NSLog(@"%ld",(long)self.Segmented.selectedSegmentIndex);
    if (self.Segmented.selectedSegmentIndex == 1) {
        vc.Type = 1;
    }else{
        vc.Type = 2;
    }
     [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.ViewscrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (scrollView == self.ViewscrollView) {
            self.ViewArray[page].labelListDataModel = self.labelListModel.data[page];
            [self selectButtonAtIndex:page];
        }
    }else{
       
    }

}

#pragma mark - request
-(void)requestLabellist{
    NSDictionary *dic = @{
                          @"type":@(1)
                          };
    [NetApiManager requestLabellistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.labelListModel = [LPLabelListModel mj_objectWithKeyValues:responseObject];
                [LPUserDefaults saveObject:responseObject byFileName:@"INFOLABELLISTCACHE"];
                [LPUserDefaults saveObject:[NSDate date] byFileName:@"INFOLABELLISTCACHEDATE"];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.videocollectionView) {
        return self.listArray.count;
    }
    return self.labelListModel.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.videocollectionView) {
        LPInfoMationVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInformationVideoCollectionViewCellID forIndexPath:indexPath];
        cell.model = self.listArray[indexPath.row];
        return cell;
    }
    LPInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInformationCollectionViewCellID forIndexPath:indexPath];
    cell.labelListDataModel = self.labelListModel.data[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.videocollectionView) {
        LPVideoVC *vc = [[LPVideoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.listArray = self.listArray;
        vc.VideoRow = indexPath.row;
        vc.superVC = self;
        vc.page = self.page;
        vc.Type = 1;
        vc.isReloadData = self.isReloadData;
        vc.TypeModel = self.VideoTypeModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.videocollectionView) {
        if ([DeviceUtils deviceType] == IPhone_X) {
            return CGSizeMake((SCREEN_WIDTH-19)/2 ,(SCREEN_WIDTH-19)/2*230/172);
        }else{
            return CGSizeMake((SCREEN_WIDTH-19)/2 ,(SCREEN_WIDTH-19)/2*230/172);
        }
    }
    
    if ([DeviceUtils deviceType] == IPhone_X) {
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-kNavBarHeight-40-49);
    }else{
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-kNavBarHeight-40-49);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.videocollectionView) {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.videocollectionView) {
        return 3;
    }
    return 0;
}

//cell的最小列间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.videocollectionView) {
        return 3;
    }
    return 0;
}


#pragma mark - lazy
-(UIView *)labelListView{
    if (!_labelListView) {
        _labelListView = [[UIView alloc]init];
    }
    return _labelListView;
}

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
        [_collectionView registerNib:[UINib nibWithNibName:LPInformationCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPInformationCollectionViewCellID];
//        [_collectionView registerNib:[UINib nibWithNibName:JWMarketSellCollectionViewCellId bundle:nil] forCellWithReuseIdentifier:JWMarketSellCollectionViewCellId];
        
    }
    return _collectionView;
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
        _videocollectionView.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
//            [self.listArray removeAllObjects];
//            [self.videocollectionView reloadData];
            [self requestQueryGetVideoList];
        }];
        _videocollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetVideoList];
        }];
    }
    return _videocollectionView;
}

-(LPSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPSortAlertView alloc]init];
        _sortAlertView.touchButton = self.VideoLabel;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}



-(void)setVideoListModel:(LPVideoListModel *)VideoListModel{
    _VideoListModel = VideoListModel;
    
    if ([self.VideoListModel.code integerValue] == 0) {
 
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
            [LPUserDefaults removeValueWithKey:@"VIDEOLISTCACHE"];
        }
        if (self.listArray.count == 0) {
            self.GetVideoUserID = kUserDefaultsValue(LOGINID).integerValue;
            NSLog(@"%ld",(long)self.GetVideoUserID);
            self.listArray = [NSMutableArray array];
            self.isReloadData = NO;

        }
        if (self.VideoListModel.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.VideoListModel.data];
            
            NSArray *CacheArray =[LPVideoListDataModel mj_keyValuesArrayWithObjectArray:self.listArray] ;
            
            [LPUserDefaults saveObject:CacheArray byFileName:@"VIDEOLISTCACHE"];
            [LPUserDefaults saveObject:[NSDate date] byFileName:@"VIDEOLISTCACHEDATE"];

            [self.videocollectionView reloadData];
            if (self.VideoListModel.data.count<20) {
                [self.videocollectionView.mj_footer endRefreshingWithNoMoreData];
                self.isReloadData = YES;
            }
        }else{
            self.isReloadData = YES;
            if (self.page == 1) {
                [self.videocollectionView reloadData];
            }else{
                [self.videocollectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
//
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
    for (UIView *view in self.videocollectionView.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.videocollectionView addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(49);
            make.bottom.mas_equalTo(-47);
        }];
        noDataView.hidden = hidden;
    }
}

-(void)requestQueryInfounreadNum{
    NSDictionary *dic = @{
                          };
    [NetApiManager requestQueryUnreadNumWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSInteger num = [responseObject[@"data"] integerValue];
                if (num == 0) {
                    self.navigationItem.rightBarButtonItem.badgeValue = @"";
                }
                else if (num>9)
                {
                    self.navigationItem.rightBarButtonItem.badgeValue = @"9+";
                }
                else
                {
                    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)num];
                }
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

-(void)requestQueryGetVideoList{
    
    //计算ids
    
    NSString *ids =@"";
    if (self.listArray.count<=40) {
        for (LPVideoListDataModel *m in self.listArray) {
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }else{
        for (int i = self.listArray.count-40 ; i<self.listArray.count ; i++) {
            LPVideoListDataModel *m = self.listArray[i];
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }
    NSLog(@"ids = %@",ids);
    
    if (self.page == 1) {
        ids =@"";
    }else{
        if (self.listArray.count) {
            if (self.listArray.count/20>0) {
                self.page = self.listArray.count/20+1;
            }else{
                self.page = 2;
            }
        }
    }
    
 
    
     NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"ids":ids };
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
//获取视频分类
- (void)requestQueryGetVideoTypeList{
     NSDictionary *dic = @{@"type":@"4"};
    [NetApiManager requestQueryGetVideoType:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.VideoTypeModel = [LPVideoTypeModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
         }else{
//            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)saveVideoID{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *string = [dateFormatter stringFromDate:[NSDate date]];
    
        if (kUserDefaultsValue(@"ERRORINFORMATION")) {
            NSString *errorString = kUserDefaultsValue(@"ERRORINFORMATION");
            NSString *str = [LPTools dateTimeDifferenceWithStartTime:errorString endTime:string];
            if ([str integerValue] < 1) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请勿频繁操作" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
                }];
                [alert show];
                return;
            }
        }
        kUserDefaultsSave(string, @"ERRORINFORMATION");
}

@end
