//
//  LPCircleVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleVC.h"
#import "LPSearchBar.h"
#import "LPCircleCollectionViewCell.h"
#import "LPLoginVC.h"

static NSString *LPCircleCollectionViewCellID = @"LPCircleCollectionViewCell";

@interface LPCircleVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation LPCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];

    [self setNavigationButton];
    [self setupTitleView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addSendButton];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setNavigationButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo_Information" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(touchMessageButton)];
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
        make.bottom.mas_equalTo(-0);
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
        
    }
}
-(void)addSendButton{
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-89);
    }];
    [button setImage:[UIImage imageNamed:@"sendDynamic_img"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:@"#FB5454"];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 25;
    [button addTarget:self action:@selector(touchSendButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)touchSendButton{
    if ([LoginUtils validationLogin:self]) {
        
    }
}
-(void)validationLogin{
    
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
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self selectButtonAtIndex:page];
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPCircleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPCircleCollectionViewCellID forIndexPath:indexPath];
//    cell.labelListDataModel = self.labelListModel.data[indexPath.row];
    cell.contentView.backgroundColor = randomColor;
    cell.index = indexPath.row;
    return cell;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([DeviceUtils deviceType] == IPhone_X) {
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88-49);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
