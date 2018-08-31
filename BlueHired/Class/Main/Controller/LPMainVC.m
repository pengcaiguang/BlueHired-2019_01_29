//
//  LPMainVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMainVC.h"
#import "LPSearchBar.h"
#import "LPMainCell.h"
#import "LPWorklistModel.h"
#import "SDCycleScrollView.h"
#import "LPSortAlertView.h"
#import "LPScreenAlertView.h"

static NSString *LPMainCellID = @"LPMainCell";

@interface LPMainVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,LPSortAlertViewDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong) UIButton *sortButton;
@property(nonatomic,strong) UIButton *screenButton;

@property(nonatomic,strong) LPSortAlertView *sortAlertView;
@property(nonatomic,strong) LPScreenAlertView *screenAlertView;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPWorklistModel *model;
@property(nonatomic,strong) NSMutableArray <LPWorklistDataWorkListModel *>*listArray;

@property(nonatomic,assign) NSInteger orderType;
@end

@implementation LPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];

    
    self.page = 1;
    self.listArray = [NSMutableArray array];
    
    [self setLeftButton];
    [self setSearchView];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self request];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setLeftButton{
    UIView *leftBarButtonView = [[UIView alloc]init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButtonView];
    [leftBarButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSelectCityButton)];
    leftBarButtonView.userInteractionEnabled = YES;
    [leftBarButtonView addGestureRecognizer:tap];
    
    
    UIImageView *pimageView = [[UIImageView alloc]init];
    [leftBarButtonView addSubview:pimageView];
    [pimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(leftBarButtonView);
        make.size.mas_equalTo(CGSizeMake(11, 12));
    }];
    pimageView.image = [UIImage imageNamed:@"positioning"];
    
    UILabel *cityLabel = [[UILabel alloc]init];
    [leftBarButtonView addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pimageView.mas_right).offset(3);
        make.centerY.mas_equalTo(leftBarButtonView);
    }];
    cityLabel.text = @"全国";
    cityLabel.font = [UIFont systemFontOfSize:15];
    cityLabel.textColor = [UIColor whiteColor];
    
    UIImageView *dimageView = [[UIImageView alloc]init];
    [leftBarButtonView addSubview:dimageView];
    [dimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityLabel.mas_right).offset(3);
        make.centerY.equalTo(leftBarButtonView);
        make.size.mas_equalTo(CGSizeMake(11, 6));
        make.right.equalTo(leftBarButtonView.mas_right).offset(0);
    }];
    dimageView.image = [UIImage imageNamed:@"downArrow"];
}

-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 - 2 * 15, 44)];
    UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
    [wrapView addSubview:searchBar];
    self.navigationItem.titleView = wrapView;
}
- (LPSearchBar *)addSearchBarWithFrame:(CGRect)frame {
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]initWithFrame:frame];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入企业名称或关键字";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14;
        searchField.layer.masksToBounds = YES;
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 28.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}
-(void)setModel:(LPWorklistModel *)model{
    _model = model;
//    [self addNodataView];
    if ([self.model.code integerValue] == 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (LPWorklistDataSlideshowListModel *model in self.model.data.slideshowList) {
            [array addObject:model.mechanismUrl];
        }
        self.cycleScrollView.imageURLStringsGroup = array;
//        [self updataHeaderView];
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.workList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.workList];
            [self.tableview reloadData];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}
-(void)addNodataView{
    LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, SCREEN_HEIGHT-240-49-64)];
    [self.tableview addSubview:noDataView];
}
-(void)updataHeaderView{
    if (self.model.data.slideshowList.count <= 0) {
        return;
    }
    CGSize size = [UIImage getImageSizeWithURL:self.model.data.slideshowList[0].mechanismUrl];
    CGFloat s = SCREEN_WIDTH/size.width;
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height*s + 40);
    self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height*s);
}

-(void)touchSelectCityButton{
    NSLog(@"touchSelectCityButton");
    
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMainCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
    if(cell == nil){
        cell = [[LPMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
    }
    cell.model = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark - target
-(void)touchSortButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.sortAlertView.hidden = !button.isSelected;
}

#pragma mark - LPSortAlertViewDelegate
-(void)touchTableView:(NSInteger)index{
    self.orderType = index;
    self.page = 1;
    [self request];
}

-(void)touchScreenButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.screenAlertView.hidden = !button.isSelected;
}
#pragma mark - request
-(void)request{
    NSDictionary *dic = @{
                          @"orderType":self.orderType ? @(self.orderType) : @"",
                          @"page":@(self.page)
                          };
    [NetApiManager requestWorklistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        self.model = [LPWorklistModel mj_objectWithKeyValues:responseObject];
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
        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor baseColor];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
        [_tableHeaderView addSubview:self.cycleScrollView];
        [_tableHeaderView addSubview:self.sortButton];
        [_tableHeaderView addSubview:self.screenButton];
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, 239.5, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = [UIColor baseColor];
        [_tableHeaderView addSubview:lineView];
    }
    return _tableHeaderView;
}
-(UIButton *)sortButton{
    if (!_sortButton) {
        _sortButton = [[UIButton alloc]init];
        _sortButton.frame = CGRectMake(13, 210, 70, 20);
        [_sortButton setTitle:@"综合排序" forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"sort_normal"] forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"sort_selected"] forState:UIControlStateSelected];
        [_sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sortButton setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _sortButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_sortButton.imageView.frame.size.width - _sortButton.frame.size.width + _sortButton.titleLabel.intrinsicContentSize.width, 0, 0);
        _sortButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_sortButton.titleLabel.frame.size.width - _sortButton.frame.size.width + _sortButton.imageView.frame.size.width);
        [_sortButton addTarget:self action:@selector(touchSortButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}
-(UIButton *)screenButton{
    if (!_screenButton) {
        _screenButton = [[UIButton alloc]init];
        _screenButton.frame = CGRectMake(SCREEN_WIDTH-45-13, 210, 45, 20);
        [_screenButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_screenButton setImage:[UIImage imageNamed:@"screen_normal"] forState:UIControlStateNormal];
        _screenButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _screenButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_screenButton.imageView.frame.size.width - _screenButton.frame.size.width + _screenButton.titleLabel.intrinsicContentSize.width, 0, 0);
        _screenButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_screenButton.titleLabel.frame.size.width - _screenButton.frame.size.width + _screenButton.imageView.frame.size.width);
        [_screenButton addTarget:self action:@selector(touchScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenButton;
}
-(LPSortAlertView *)sortAlertView{
    if (!_sortAlertView) {
        _sortAlertView = [[LPSortAlertView alloc]init];
        _sortAlertView.touchButton = self.sortButton;
        _sortAlertView.delegate = self;
    }
    return _sortAlertView;
}
-(LPScreenAlertView *)screenAlertView{
    if (!_screenAlertView) {
        _screenAlertView = [[LPScreenAlertView alloc]init];
        _screenAlertView.touchButton = self.screenButton;
    }
    return _screenAlertView;
}

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    }
    return _cycleScrollView;
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
