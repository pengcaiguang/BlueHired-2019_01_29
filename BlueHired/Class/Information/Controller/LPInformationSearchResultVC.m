//
//  LPInformationSearchResultVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationSearchResultVC.h"
#import "LPEssaylistModel.h"
#import "LPInformationSingleCell.h"
#import "LPInformationMoreCell.h"
#import "LPEssayDetailVC.h"
#import "LPVideoListModel.h"
#import "LPInfoMationVideoCell.h"
#import "LPVideoVC.h"


static NSString *LPInformationSingleCellID = @"LPInformationSingleCell";
static NSString *LPInformationMoreCellID = @"LPInformationMoreCell";
static NSString *LPInformationVideoCollectionViewCellID = @"LPInfoMationVideoCell";

@interface LPInformationSearchResultVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPVideoListModel *VideoListModel;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPEssaylistModel *model;
@property(nonatomic,strong) NSMutableArray <LPEssaylistDataModel *>*listArray;
@property(nonatomic,strong) NSMutableArray <LPVideoListDataModel *>*VideolistArray;
@property (nonatomic, assign) BOOL isReloadData;

@end

@implementation LPInformationSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"搜索结果";
    self.page = 1;
    self.listArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.videocollectionView];
    [self.videocollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (self.Type == 1) {
        [self requestEssaylist];
        self.tableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }else{
        [self requestQueryGetVideoList];
        self.tableview.hidden = YES;
        self.videocollectionView.hidden = NO;
     }

}
-(void)setModel:(LPEssaylistModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.listArray.count == 0) {
            [self addNodataView];
        }
        [self.tableview reloadData];
        
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}


-(void)setVideoListModel:(LPVideoListModel *)VideoListModel{
    _VideoListModel = VideoListModel;
    
    if ([self.VideoListModel.code integerValue] == 0) {
        self.isReloadData = NO;
        if (self.page == 1) {
            self.VideolistArray = [NSMutableArray array];
        }
        if (self.VideoListModel.data.count > 0) {
            self.page += 1;
            [self.VideolistArray addObjectsFromArray:self.VideoListModel.data];
            [self.videocollectionView reloadData];
            if (self.VideoListModel.data.count<20) {
                [self.videocollectionView.mj_footer endRefreshingWithNoMoreData];
                self.isReloadData = YES;
            }
        }else{
            if (self.page == 1) {
                [self.videocollectionView reloadData];
            }else{
                [self.videocollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            self.isReloadData = YES;

        }
        //
        if (self.VideolistArray.count == 0) {
            [self addNodataView];
        }else{
            
         }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}


-(void)addNodataView{
    LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:noDataView];
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = @[];
    if (self.listArray.count > indexPath.row) {
        array = [self.listArray[indexPath.row].essayUrl componentsSeparatedByString:@";"];
    }
    if (array.count ==0) {
        return nil;
    }else if (array.count == 1) {
        LPInformationSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationSingleCellID];
        if(cell == nil){
            cell = [[LPInformationSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationSingleCellID];
        }
        cell.model = self.listArray[indexPath.row];
        return cell;
    }else{
        LPInformationMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationMoreCellID];
        if(cell == nil){
            cell = [[LPInformationMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationMoreCellID];
        }
        cell.model = self.listArray[indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
    vc.essaylistDataModel = self.listArray[indexPath.row];
    vc.Supertableview = self.tableview;
    vc.essaylistDataModel = self.listArray[indexPath.row];
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        LPEssaylistDataModel *model = self.listArray[indexPath.row];
        model.view = @(model.view.integerValue +1);
        
        NSString *viewStr = @"";
        if (model.view.integerValue>10000) {
            viewStr = [NSString stringWithFormat:@"%.1fw", model.view.integerValue/10000.0] ;
        }else{
            viewStr = model.view ? [model.view stringValue] : @"0";
        }

        if ([cell isKindOfClass:[LPInformationSingleCell class]]) {
            LPInformationSingleCell *c = (LPInformationSingleCell *)cell;
            c.viewLabel.text = viewStr;
        }else if ([cell isKindOfClass:[LPInformationMoreCell class]]) {
            LPInformationMoreCell *c = (LPInformationMoreCell *)cell;
            c.viewLabel.text = viewStr;
        }
    });
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.VideolistArray.count;
 }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LPInfoMationVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInformationVideoCollectionViewCellID forIndexPath:indexPath];
    cell.model = self.VideolistArray[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.videocollectionView) {
        LPVideoVC *vc = [[LPVideoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.listArray = self.VideolistArray;
        vc.VideoRow = indexPath.row;
        vc.KeySuperVC = self;
        vc.page = self.page;
        vc.Type = 2;
        vc.key = self.string;
        vc.isReloadData = self.isReloadData;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
         if ([DeviceUtils deviceType] == IPhone_X) {
            return CGSizeMake((SCREEN_WIDTH-21)/2 ,(SCREEN_WIDTH-21)/2*230/172);
        }else{
            return CGSizeMake((SCREEN_WIDTH-21)/2 ,(SCREEN_WIDTH-21)/2*230/172);
        }
   }

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
         return UIEdgeInsetsMake(8, 8, 8, 8);
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
         return 5;
  
}

//cell的最小列间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
         return 5;
 
}

#pragma mark - request
-(void)requestEssaylist{
    NSDictionary *dic = @{
                          @"key":self.string,
                          @"page":@(self.page)
                          };
    [NetApiManager requestEssaylistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.model = [LPEssaylistModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetVideoList{
    
    //计算ids
    NSString *ids =@"";
    if (self.listArray.count<=40) {
        for (LPVideoListDataModel *m in self.VideolistArray) {
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }else{
        for (int i = self.VideolistArray.count-40 ; i<self.VideolistArray.count ; i++) {
            LPVideoListDataModel *m = self.VideolistArray[i];
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }
    NSLog(@"ids = %@",ids);
    
    NSDictionary *dic = @{@"videoName":self.string,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"ids":ids
                          };
    [NetApiManager requestQueryGetVideoList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [self.videocollectionView.mj_header endRefreshing];
            [self.videocollectionView.mj_footer endRefreshing];
            self.VideoListModel = [LPVideoListModel mj_objectWithKeyValues:responseObject];
            
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPInformationSingleCellID bundle:nil] forCellReuseIdentifier:LPInformationSingleCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];
        
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestEssaylist];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestEssaylist];
        }];
    }
    return _tableview;
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
        _videocollectionView.pagingEnabled = YES;
        [_videocollectionView registerNib:[UINib nibWithNibName:LPInformationVideoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:LPInformationVideoCollectionViewCellID];
//        _videocollectionView.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            self.page = 1;
//            [self requestQueryGetVideoList];
//        }];
        _videocollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestQueryGetVideoList];
        }];
    }
    return _videocollectionView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
