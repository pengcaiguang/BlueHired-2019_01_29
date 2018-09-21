//
//  LPInfoVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/20.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInfoVC.h"
#import "LPInforCollectionViewCell.h"

static NSString *LPInforCollectionViewCellID = @"LPInforCollectionViewCell";

@interface LPInfoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) UIView *labelListView;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@property(nonatomic,strong) NSArray *titleArray;

@property(nonatomic,assign) NSInteger selectType;
@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,assign) BOOL selectAll;

@end

@implementation LPInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息中心";
    
    self.titleArray = @[@"系统通知",@"其他消息"];
    self.labelArray = [NSMutableArray array];

    [self setNavigationButton];
    [self setTitleView];
    [self setBottomView];
    
    [self.view addSubview:self.labelListView];
    [self.labelListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelListView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
-(void)setNavigationButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
}
-(void)touchManagerButton{
    if (self.isSelect) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
        self.isSelect = NO;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
        self.isSelect = YES;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-49);
        }];
    }
    [self.collectionView reloadData];
}

-(void)setTitleView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.labelListView addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat w = 0;
    for (int i = 0; i <self.titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = self.titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:label];
        label.textColor = [UIColor grayColor];
        CGSize size = CGSizeMake(100, MAXFLOAT);//设置高度宽度的最大限度
        CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        
        CGFloat lw = rect.size.width + 30;
        w += lw;
        label.frame = CGRectMake(w - lw, 0, lw, 50);
        
        label.frame = CGRectMake(SCREEN_WIDTH/self.titleArray.count*i, 0, SCREEN_WIDTH/self.titleArray.count, 50);

        label.tag = i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabel:)];
        [label addGestureRecognizer:tap];
        [self.labelArray addObject:label];
    }
    scrollView.contentSize = CGSizeMake(w, 50);
    
    self.lineView = [[UIView alloc]init];
    CGFloat s = CGRectGetWidth(self.labelArray[0].frame);
    self.lineView.frame = CGRectMake(0, 48, s, 2);
    self.lineView.backgroundColor = [UIColor baseColor];
    [scrollView addSubview:self.lineView];
    self.labelArray[0].textColor = [UIColor blackColor];
}
-(void)setBottomView{
    UIButton *selectButton = [[UIButton alloc]init];
    [self.view addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-13);
        make.width.mas_equalTo(70);
    }];
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [selectButton addTarget:self action:@selector(touchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    [self.view addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
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
    self.selectAll = button.isSelected;
}
-(void)touchDeleteButton:(UIButton *)button{
    
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
        self.lineView.frame = CGRectMake(x, 48, w, 2);
    }];
    
    self.selectType = index+1;
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
    return self.titleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPInforCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInforCollectionViewCellID forIndexPath:indexPath];
    cell.type = self.selectType;
    cell.selectStatus = self.isSelect;
    cell.selectAll = self.selectAll;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([DeviceUtils deviceType] == IPhone_X) {
        if (self.isSelect) {
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88-50-49);
        }else{
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88-50);
        }
    }else{
        if (self.isSelect) {
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-64-50-49);
        }else{
            return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-64-50);
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
        [_collectionView registerNib:[UINib nibWithNibName:LPInforCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPInforCollectionViewCellID];
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
