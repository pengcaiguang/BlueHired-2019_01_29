//
//  LPAffiliationMenageVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPAffiliationMenageVC.h"
#import "LPSearchBar.h"
#import "LPAffiliationModel.h"
#import "LPAffiliationMenageCell.h"
#import "LPAffiliationCollectionViewCell.h"

static NSString *LPTLendAuditCellID = @"LPAffiliationMenageCell";
static NSString *LPInformationCollectionViewCellID = @"";


@interface LPAffiliationMenageVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) LPSearchBar *searchButton;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic,strong) UIView *labelListView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@property (nonatomic,copy) NSString *workStatus;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *reType;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger labelTag;


 @property (nonatomic,strong) LPAffiliationModel *model;
@property(nonatomic,strong) NSMutableArray <LPAffiliationDataModel *>*listArray;

@property(nonatomic,strong) NSArray *textArray;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger IndexType;

@end

@implementation LPAffiliationMenageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (kUserDefaultsValue(USERDATA).integerValue == 4 ||
        kUserDefaultsValue(USERDATA).integerValue >= 8) {
        self.navigationItem.title = @"归属员工管理";
         self.textArray = @[@"全部",@"在职",@"待业"];
        self.type = 4;
    }else if (kUserDefaultsValue(USERDATA).integerValue == 3){
        self.navigationItem.title = @"归属员工管理";
        self.textArray = @[@"全部",@"在职",@"待业"];
        self.type = 3;
    }else if (kUserDefaultsValue(USERDATA).integerValue == 1 ||
              kUserDefaultsValue(USERDATA).integerValue == 2){
        self.navigationItem.title = @"劳务工管理";
        self.textArray = @[@"全部",@"在职",@"待业",@"返费设置"];
        self.type = 1;
    }else if (kUserDefaultsValue(USERDATA).integerValue == 6){
        self.navigationItem.title = @"劳务工管理";
        self.textArray = @[@"全部",@"在职",@"待业",@"返费提醒"];
        self.type = 2;
    }

    self.labelArray = [NSMutableArray array];

    [self setViewUI];
    self.workStatus = @"";
    self.key = @"";
    self.reType = @"";
    self.page = 1;

    
    
    [self.view addSubview:self.labelListView];
    [self.labelListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(48);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.labelListView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.labelListView addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat w = 0;
    for (int i = 0; i <self.textArray.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = self.textArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:label];
        label.textColor = [UIColor grayColor];
        CGSize size = CGSizeMake(100, MAXFLOAT);//设置高度宽度的最大限度
        CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        
        CGFloat lw = rect.size.width + 30;
        w += lw;
        label.frame = CGRectMake(w - lw, 0, lw, 50);
        label.frame = CGRectMake(SCREEN_WIDTH/self.textArray.count*i, 0, SCREEN_WIDTH/self.textArray.count, 50);

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
    self.labelArray[0].textColor = [UIColor baseColor];
    
//    [self.collectionView reloadData];
//    [self requestQuerylabourlist];
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [self.view addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizerRight];
 
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizerLeft];
 
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.page = 1;
    [self requestQuerylabourlist];
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");

        
        if (self.labelTag+1 == self.textArray.count) {
            return;
        }
        self.labelTag  +=1;
        [self selectButtonAtIndex:self.labelTag];
        [self scrollToItenIndex:self.labelTag];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.labelTag == 0) {
            return;
        }
        self.labelTag  -=1;
        [self selectButtonAtIndex:self.labelTag];
        [self scrollToItenIndex:self.labelTag];
     }
}



-(void)setViewUI{
    UIView *baseview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    baseview.backgroundColor =[UIColor baseColor];
    
    LPSearchBar *searchBar = [self addSearchBar];
    self.searchButton = searchBar;
    UIView *wrapView = [[UIView alloc]init];
    wrapView.frame = CGRectMake(16, 10, SCREEN_WIDTH-16-70-14, 28);
    wrapView.layer.cornerRadius = 14;
    wrapView.layer.masksToBounds = YES;
    
    //    wrapView.clipsToBounds = YES;
    //    wrapView.backgroundColor = [UIColor whiteColor];
    [baseview addSubview:wrapView];
    [wrapView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
    UIButton *searchBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 58, 28)];
    searchBt.backgroundColor = [UIColor whiteColor];
    searchBt.layer.cornerRadius = 14;
    searchBt.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [searchBt setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(touchsearch:) forControlEvents:UIControlEventTouchUpInside];
    [baseview addSubview:searchBt];
    
    [self.view addSubview:baseview];
    
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.key = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     self.page = 1;
    [DSBaActivityView showActiviTy];
    [self requestQuerylabourlist];
}

-(void)touchsearch:(UIButton *)button{
    self.key = [self.searchButton.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.page = 1;
    [DSBaActivityView showActiviTy];
    [self requestQuerylabourlist];
}


- (LPSearchBar *)addSearchBar{
    self.definesPresentationContext = YES;
    LPSearchBar *searchBar = [[LPSearchBar alloc]init];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入姓名或联系方式";
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


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPAffiliationMenageCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTLendAuditCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPAffiliationMenageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPTLendAuditCellID];
    }
    
    cell.model = self.listArray[indexPath.row];
    //    WEAK_SELF()
    //    cell.Block = ^(void) {
    //        [weakSelf requestQueryWorkOrderList];
    //    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)touchLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    self.labelTag = index;
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}

-(void)selectButtonAtIndex:(NSInteger)index{
    CGFloat x = CGRectGetMinX(self.labelArray[index].frame);
    CGFloat w = CGRectGetWidth(self.labelArray[index].frame);
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor grayColor];
    }
    self.labelArray[index].textColor = [UIColor baseColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(x, 48, w, 2);
    }];
}

-(void)scrollToItenIndex:(NSInteger)index{
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
//    LPRecruitReqiuerCollectionViewCell *cell = (LPRecruitReqiuerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    self.Type = index;
//    cell.type = index;
//
    //    [self.collectionView reloadData];
    if (index == self.IndexType) {
        return;
    }
    
    if (index == 0) {
        self.workStatus = @"";
    }else if (index == 1){
        self.workStatus = @"1";
    }else if (index == 2){
        self.workStatus = @"0";
    }
    self.reType = @"";

    if (index == 3) {
        self.reType = @"1";
        self.workStatus = @"";
    }
    
    self.page = 1;
    [self requestQuerylabourlist];
    self.IndexType = index;
}




#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.textArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPAffiliationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPInformationCollectionViewCellID forIndexPath:indexPath];
//    cell.tableview = self.tableview;
    cell.page = 1;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    [self selectButtonAtIndex:page];
//    [self scrollToItenIndex:page];
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([DeviceUtils deviceType] == IPhone_X) {
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-88-48-50);
    }else{
        return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-64-48-50);
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

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPTLendAuditCellID bundle:nil] forCellReuseIdentifier:LPTLendAuditCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
                        self.page = 1;
//            self.workStatus = @"";
//            self.key = @"";
            [self requestQuerylabourlist];
        }];
                _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self requestQuerylabourlist];
                }];
    }
    return _tableview;
}

-(UIView *)labelListView{
    if (!_labelListView) {
        _labelListView = [[UIView alloc]init];
    }
    return _labelListView;
}

- (void)setModel:(LPAffiliationModel *)model
{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (self.model.data.count) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
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
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(98);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}

#pragma mark - request
-(void)requestQuerylabourlist{
    
    NSDictionary *dic = @{@"key":self.key,
                          @"reType":self.reType,
                          @"workStatus":self.workStatus,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"type":[NSString stringWithFormat:@"%ld",(long)self.type]};
    
    WEAK_SELF()
    [NetApiManager requestQuerylabourlist:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [DSBaActivityView hideActiviTy];
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            weakSelf.model = [LPAffiliationModel mj_objectWithKeyValues:responseObject];
            [weakSelf.tableview reloadData];

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryassistantlabourlist{
    NSDictionary *dic = @{@"key":self.key,
                          @"reMoney":self.reType,
                          @"workStatus":self.workStatus,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"type":[NSString stringWithFormat:@"%ld",(long)self.type]};
    
    WEAK_SELF()
    [NetApiManager requestQueryassistantlabourlist:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            weakSelf.model = [LPAffiliationModel mj_objectWithKeyValues:responseObject];
            [weakSelf.tableview reloadData];

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
