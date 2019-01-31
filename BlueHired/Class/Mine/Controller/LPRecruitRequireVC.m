//
//  LPRecruitRequireVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRecruitRequireVC.h"
#import "LPRecruitReqiuerCollectionViewCell.h"
#import "LPRecruitRequirePvwVC.h"
static NSString *LPInformationCollectionViewCellID = @"LPRecruitReqiuerCollectionViewCell";

@interface LPRecruitRequireVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView *labelListView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *senderBt;

@property (nonatomic,assign) NSInteger Type;


@end

@implementation LPRecruitRequireVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"招聘要求";
    self.labelArray = [NSMutableArray array];

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
        make.bottom.mas_equalTo(-50);
    }];
    
 
    
    
    NSArray *array = @[@"入职要求",@"薪资福利",@"住宿餐饮",@"工作时间",@"面试材料",@"其他说明"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.labelListView addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat w = 0;
    for (int i = 0; i <array.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:label];
        label.textColor = [UIColor grayColor];
        CGSize size = CGSizeMake(100, MAXFLOAT);//设置高度宽度的最大限度
        CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        
        CGFloat lw = rect.size.width + 30;
        w += lw;
        label.frame = CGRectMake(w - lw, 0, lw, 50);
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
    
    [self.collectionView reloadData];
    
    
    UIButton *bt = [[UIButton alloc] init];
    bt.layer.cornerRadius = 10;
    bt.backgroundColor = [UIColor baseColor];
    [bt addTarget:self action:@selector(touchSenderbt:) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:@"预览" forState:UIControlStateNormal];
    [bt setTintColor:[UIColor whiteColor]];
    [self.view addSubview:bt];
    self.senderBt = bt;
    [self.senderBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    
}

-(void)touchSenderbt:(UIButton *)sender
{
    LPRecruitRequirePvwVC *vc = [[LPRecruitRequirePvwVC alloc] init];
//        vc.dataList = _TypeArr;
        vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
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
}



-(void)scrollToItenIndex:(NSInteger)index{


    LPRecruitReqiuerCollectionViewCell *cell = (LPRecruitReqiuerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    self.Type = index;
     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPRecruitReqiuerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInformationCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.content = [LPTools isNullToString:_model.workDemand];
    }else if (indexPath.row == 1){
        cell.content = [LPTools isNullToString:_model.workSalary];
    }else if (indexPath.row == 2){
        cell.content = [LPTools isNullToString:_model.eatSleep];
    }else if (indexPath.row == 3){
        cell.content = [LPTools isNullToString:_model.workTime];
    }else if (indexPath.row == 4){
        cell.content = [LPTools isNullToString:_model.workKnow];
    }else if (indexPath.row == 5){
        cell.content = [LPTools isNullToString:_model.remarks];
    }
    
    
    WEAK_SELF()
    cell.BlockSuper = ^(NSString *textView,NSInteger row) {
        if (row == 0) {
            weakSelf.model.workDemand = textView;
        }else if (row == 1){
            weakSelf.model.workSalary = textView;

        }else if (row == 2){
            weakSelf.model.eatSleep = textView;

        }else if (row == 3){
            weakSelf.model.workTime = textView;

        }else if (row == 4){
            weakSelf.model.workKnow = textView;

        }else if (row == 5){
            weakSelf.model.remarks = textView;

        }
    };
    
//    cell.model = self.model;
    cell.type = self.Type;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self selectButtonAtIndex:page];
    [self scrollToItenIndex:page];
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([DeviceUtils deviceType] == IPhone_X) {
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88-50-50);
    }else{
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-64-50-50);
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
        [_collectionView registerNib:[UINib nibWithNibName:LPInformationCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPInformationCollectionViewCellID];
        //        [_collectionView registerNib:[UINib nibWithNibName:JWMarketSellCollectionViewCellId bundle:nil] forCellWithReuseIdentifier:JWMarketSellCollectionViewCellId];
        
    }
    return _collectionView;
}

@end
