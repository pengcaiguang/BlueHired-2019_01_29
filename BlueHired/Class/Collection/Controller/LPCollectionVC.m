//
//  LPCollectionVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionVC.h"
#import "LPCollectionCollectionViewCell.h"

static NSString *LPCollectionCollectionViewCellID = @"LPCollectionCollectionViewCell";

@interface LPCollectionVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property (nonatomic,strong) UIView *lineView;

@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,assign) BOOL selectAll;
@property(nonatomic,assign) NSInteger selectType;
@property(nonatomic,strong) UIButton *AllButton;

@end

@implementation LPCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setNavigationButton];
    [self setupTitleView];
    [self setBottomView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
//        //为push操作
//        NSLog(@"为push操作");
//    } else if ([viewControllers indexOfObject:self] == viewControllers.count-1) {
//        //为pop操作
//        NSLog(@"为pop操作");
//
//    }
    
//
//    if (self.navigationController.topViewController == self) {
//        NSLog(@"push进来的");
//
//    }else{
//        NSLog(@"pop进来");
//    }
//
    
    LPCollectionCollectionViewCell *cell = (LPCollectionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.index =self.selectType;
}

-(void)setNavigationButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
}
-(void)setupTitleView{
    UIView *navigationView = [[UIView alloc]init];
    navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 49);
    navigationView.center = CGPointMake(navigationView.superview.center.x, navigationView.superview.frame.size.height/2);
    self.navigationItem.titleView = navigationView;
    
    self.buttonArray = [NSMutableArray array];
//    NSArray *titleArray = @[@"资讯",@"招聘",@"视频"];
    NSArray *titleArray = @[@"资讯",@"视频"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [navigationView addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
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
    self.lineView.backgroundColor = [UIColor baseColor];
}
-(void)setBottomView{
    UIButton *selectButton = [[UIButton alloc]init];
    [self.view addSubview:selectButton];
    self.AllButton = selectButton;
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        //        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.width.mas_equalTo(SCREEN_WIDTH - 180);
        make.height.mas_equalTo(49);
    }];
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectButton addTarget:self action:@selector(touchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
//    selectButton.backgroundColor = [UIColor blueColor];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    [self.view addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(180);
    }];
    deleteButton.backgroundColor = [UIColor colorWithHexString:@"#FF5353"];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteButton addTarget:self action:@selector(touchDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)touchSelectButton:(UIButton *)button{
    button.selected = !button.isSelected;
    LPCollectionCollectionViewCell *cell = (LPCollectionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.selectAll = button.isSelected;
//    self.selectAll = button.isSelected;
}
-(void)touchDeleteButton:(UIButton *)button{
    LPCollectionCollectionViewCell *cell = (LPCollectionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell deleteInfo];
}
-(void)touchManagerButton{

    
    if (self.isSelect) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
        self.isSelect = NO;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
        self.isSelect = YES;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(-49);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49);
            } else {
                make.bottom.mas_equalTo(-49);
            }
        }];
    }

    [self.collectionView reloadData];
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
    if (self.isSelect) {
            [self cancelSelect];
    }

//    self.selectType = index;
}
-(void)cancelSelect{
    self.isSelect = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
//    [self.collectionView reloadData];
    LPCollectionCollectionViewCell *cell = (LPCollectionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.selectStatus =self.isSelect;
    
}
-(void)scrollToItenIndex:(NSInteger)index{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
//    LPCollectionCollectionViewCell *cell = (LPCollectionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.index =index;
    self.selectType =index;
    [self.collectionView reloadData];

}
#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self selectButtonAtIndex:page];
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPCollectionCollectionViewCellID forIndexPath:indexPath];
    //    cell.labelListDataModel = self.labelListModel.data[indexPath.row];
    cell.contentView.backgroundColor = randomColor;
    cell.selectStatus = self.isSelect;
//    cell.selectAll = self.selectAll;
    cell.AllButton = self.AllButton;
    cell.index = self.selectType;

    return cell;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([DeviceUtils deviceType] == IPhone_X) {
        if (self.isSelect) {
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88-49);
        }else{
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88);
        }
    }else{
        if (self.isSelect) {
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-64-49);
        }else{
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-64);
        }
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
        [_collectionView registerNib:[UINib nibWithNibName:LPCollectionCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPCollectionCollectionViewCellID];
        //        [_collectionView registerNib:[UINib nibWithNibName:JWMarketSellCollectionViewCellId bundle:nil] forCellWithReuseIdentifier:JWMarketSellCollectionViewCellId];
        
    }
    return _collectionView;
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
