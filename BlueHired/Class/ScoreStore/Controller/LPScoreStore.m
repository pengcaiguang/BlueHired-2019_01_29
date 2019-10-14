//
//  LPScoreStore.m
//  BlueHired
//
//  Created by iMac on 2019/9/17.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStore.h"
#import "LPScoreStoreCell.h"
#import "LPScoreStoreHeadReusableView.h"
#import "LPScoreStoredetailsVC.h"
#import "LPShippingAddressVC.h"
#import "LPMyOrderVC.h"
#import "LPProductListModel.h"

static NSString *LPScoreStoreCellID = @"LPScoreStoreCell";
static NSString *LPScoreStoreHeadReusableViewID = @"LPScoreStoreHeadReusableView";

@interface LPScoreStore ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) LPProductListModel *model;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray <LPProductListDataModel *>*listArray;

@end

@implementation LPScoreStore

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"积分商城";
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地址管理" style:UIBarButtonItemStylePlain target:self action:@selector(TouchesRightBar)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#333333"]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(13),NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(13),NSFontAttributeName, nil] forState:UIControlStateSelected];

    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
    }];
    
    self.page = 1;
    [self requestGetProductList];
}

#pragma mark --Touches
-(void)TouchesRightBar{
    if ([LoginUtils validationLogin:self]) {
        LPShippingAddressVC *vc = [[LPShippingAddressVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

 

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LPScoreStoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPScoreStoreCellID forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LPScoreStoredetailsVC *vc = [[LPScoreStoredetailsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.ListModel = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        LPScoreStoreHeadReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:LPScoreStoreHeadReusableViewID forIndexPath:indexPath];
        headerView.model = self.model;
        return headerView;
    }
    return nil;
}



#pragma mark -- lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(floor(LENGTH_SIZE(172)) ,floor(LENGTH_SIZE(230)));
        layout.sectionInset = UIEdgeInsetsMake(LENGTH_SIZE(10), LENGTH_SIZE(10),LENGTH_SIZE(10), LENGTH_SIZE(10));
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, LENGTH_SIZE(261));

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = NO;

        [_collectionView registerNib:[UINib nibWithNibName:LPScoreStoreCellID bundle:nil] forCellWithReuseIdentifier:LPScoreStoreCellID];
        [_collectionView registerNib:[UINib nibWithNibName:LPScoreStoreHeadReusableViewID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LPScoreStoreHeadReusableViewID];
 
        
        _collectionView.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetProductList];
        }];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetProductList];
        }];
    }
    return _collectionView;
}



- (void)setModel:(LPProductListModel *)model
{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.list.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.list];
            [self.collectionView reloadData];
            if (self.model.data.list.count<20) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                self.collectionView.mj_footer.hidden = self.listArray.count<20?YES:NO;
            }
        }else{
            if (self.page == 1) {
                [self.collectionView reloadData];
            }else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
    for (UIView *view in self.collectionView.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, LENGTH_SIZE(261), SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - LENGTH_SIZE(261))];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.collectionView addSubview:noDataView];
//        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//            //            make.edges.equalTo(self.view);
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(261);
//            make.bottom.mas_equalTo(0);
//        }];
        noDataView.hidden = hidden;
    }
}


#pragma mark - request
-(void)requestGetProductList{
    NSDictionary *dic = @{@"page":@(self.page)};
    [NetApiManager requestGetProductList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPProductListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
