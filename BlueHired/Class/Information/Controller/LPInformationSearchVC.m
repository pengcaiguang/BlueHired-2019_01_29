//
//  LPInformationSearchVC.m
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationSearchVC.h"
#import "LPSearchBar.h"
#import "LPInformationSearchResultVC.h"
#import "LPEssaylistModel.h"
#import "LPInformationSingleCell.h"
#import "LPInformationMoreCell.h"
#import "LPEssayDetailVC.h"
#import "LPVideoListModel.h"
#import "LPInfoMationVideoCell.h"
#import "LPVideoVC.h"
#import "LPMoodListModel.h"
#import "LPCircleListCell.h"
#import "LPMoodDetailVC.h"
#import "LPMechanismcommentMechanismlistModel.h"
#import "LPBusinessReviewCell.h"
#import "LPBusinessReviewDetailVC.h"
#import "LPEmployeeManageCell.h"
#import "LPEmployeeWorkListCell.h"
#import "LPLPEmployeeModel.h"


static NSString *InformationSearchHistory = @"InformationSearchHistory";
static NSString *VideoSearchHistory = @"VideoSearchHistory";
static NSString *CircleSearchHistory = @"CircleSearchHistory";
static NSString *BusinessReviewSearchHistory = @"BusinessReviewSearchHistory";
static NSString *LPEmployeeManageHistory = @"LPEmployeeManageHistory";
static NSString *LPEmployeeWorkListHistory = @"LPEmployeeWorkListHistory";


static NSString *LPCircleListCellID = @"LPCircleListCell";
static NSString *LPInformationSingleCellID = @"LPInformationSingleCell";
static NSString *LPInformationMoreCellID = @"LPInformationMoreCell";
static NSString *LPInformationVideoCollectionViewCellID = @"LPInfoMationVideoCell";
static NSString *LPBusinessReviewCellID = @"LPBusinessReviewCell";
static NSString *LPEmployeeWorkListCellID = @"LPEmployeeWorkListCell";
static NSString *LPEmployeeManageCellID = @"LPEmployeeManageCell";


@interface LPInformationSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SDTimeLineCellDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Resulttableview;

@property(nonatomic,copy) NSArray *textArray;
@property(nonatomic,copy) NSString *searchWord;

@property(nonatomic,strong) LPVideoListModel *VideoListModel;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPEssaylistModel *model;
@property(nonatomic,strong) NSMutableArray <LPEssaylistDataModel *>*listArray;
@property(nonatomic,strong) NSMutableArray <LPVideoListDataModel *>*VideolistArray;
@property (nonatomic, assign) BOOL isReloadData;

@property(nonatomic,strong) LPMoodListModel *moodListModel;
@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;

@property(nonatomic,strong) LPMechanismcommentMechanismlistModel *Businessmodel;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentMechanismlistDataModel *>*BusinesslistArray;

//5
@property(nonatomic,strong) LPLPEmployeeModel *Employeemodel;
@property(nonatomic,strong) NSMutableArray <LPLPEmployeeDataModel *>*EmployeelistArray;
@property(nonatomic,strong) LPLPEmployeeDataModel *selectEmployeemodel;
@property(nonatomic,strong) CustomIOSAlertView *CustomAlert;
@property(nonatomic,strong) UITextField *AlertTF;

//6
@property(nonatomic,strong) LPMechanismcommentMechanismlistModel *Mechanismmodel;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentMechanismlistDataModel *>*MechanismlistArray;

@property(nonatomic,strong)LPSearchBar *SearchBar;


@end

@implementation LPInformationSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSearchView];
    [self setSearchButton];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.Resulttableview];
    [self.Resulttableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.videocollectionView];
    [self.videocollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    self.Resulttableview.hidden = YES;
    self.videocollectionView.hidden = YES;

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.Type == 1) {
        self.textArray = (NSArray *)kUserDefaultsValue(InformationSearchHistory);
    }else if (self.Type == 2){
        self.textArray = (NSArray *)kUserDefaultsValue(VideoSearchHistory);
    }else if (self.Type == 3){
        self.textArray = (NSArray *)kUserDefaultsValue(CircleSearchHistory);
    }else if (self.Type == 4){
        self.textArray = (NSArray *)kUserDefaultsValue(BusinessReviewSearchHistory);
    }else if (self.Type == 5){
        self.textArray = (NSArray *)kUserDefaultsValue(LPEmployeeManageHistory);
    }else if (self.Type == 6){
        self.textArray = (NSArray *)kUserDefaultsValue(LPEmployeeWorkListHistory);
    }
    [self.tableview reloadData];
}

-(void)setSearchView{
//    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 - 0 * 15 - 44 - 5, 44)];
    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 52  - 47 - 20*2- 5*2, 44)];
    [searchBar becomeFirstResponder];
    self.SearchBar = searchBar;

    UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
    [wrapView addSubview:searchBar];
    self.navigationItem.titleView = wrapView;
}
- (LPSearchBar *)addSearchBarWithFrame:(CGRect)frame {
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]initWithFrame:frame];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入搜索关键字";
    if (self.Type == 2) {
        searchBar.placeholder = @"请输入视频关键字";
    }else if (self.Type == 4){
        searchBar.placeholder = @"请输入企业名称或关键字";
    }
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor colorWithHexString:@"#F2F1F0"]];
        searchField.layer.cornerRadius = 15;
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 30.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}
-(void)setSearchButton{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 47, 28);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 14;
//    [button setBackgroundImage:[UIImage imageNamed:@"search_btn_bgView"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchSearchButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    button.backgroundColor = [UIColor redColor];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self touchSearchButton];
}

#pragma mark - UITextFieldDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.Resulttableview.hidden == NO ||
        self.videocollectionView.hidden == NO) {
        self.Resulttableview.hidden = YES;
        self.videocollectionView.hidden = YES;
        self.tableview.hidden = NO;
        
        if (self.Type == 1) {
            self.textArray = (NSArray *)kUserDefaultsValue(InformationSearchHistory);
        }else if (self.Type == 2){
            self.textArray = (NSArray *)kUserDefaultsValue(VideoSearchHistory);
        }else if (self.Type == 3){
            self.textArray = (NSArray *)kUserDefaultsValue(CircleSearchHistory);
        }else if (self.Type == 4){
            self.textArray = (NSArray *)kUserDefaultsValue(BusinessReviewSearchHistory);
        }else if (self.Type == 5){
            self.textArray = (NSArray *)kUserDefaultsValue(LPEmployeeManageHistory);
        }else if (self.Type == 6){
            self.textArray = (NSArray *)kUserDefaultsValue(LPEmployeeWorkListHistory);
        }
        [self.tableview reloadData];
    }
    return YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"-%@",searchBar.text);
    self.searchWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(void)touchSearchButton{
    if (self.searchWord.length > 0) {
        [self saveWords];
        [self search:self.searchWord];
    }
    else
    {
        [self.view showLoadingMeg:@"请输入搜索关键字" time:MESSAGE_SHOW_TIME];
    }
}

-(void)saveWords{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.textArray];
    if (![array containsObject:self.searchWord]) {
        [array insertObject:self.searchWord atIndex:0];
        if (self.Type == 1) {
            kUserDefaultsSave([array copy], InformationSearchHistory);
        }else if (self.Type == 2){
            kUserDefaultsSave([array copy], VideoSearchHistory);
        }else if (self.Type == 3){
            kUserDefaultsSave([array copy], CircleSearchHistory);
        }else if (self.Type == 4){
            kUserDefaultsSave([array copy], BusinessReviewSearchHistory);
        }else if (self.Type == 5){
            kUserDefaultsSave([array copy], LPEmployeeManageHistory);
        }else if (self.Type == 6){
            kUserDefaultsSave([array copy], LPEmployeeWorkListHistory);
        }
     }
}

-(void)search:(NSString *)string{
//    LPInformationSearchResultVC *vc = [[LPInformationSearchResultVC alloc]init];
//    vc.Type = self.Type;
//    vc.string = string;
//    [self.navigationController pushViewController:vc animated:YES];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.tableview.hidden = YES;
    if (self.Type == 1) {
        self.page = 1;
        [self requestEssaylist];
        self.Resulttableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }else if (self.Type == 2){
        self.page = 1;
        [self.VideolistArray removeAllObjects];
        [self requestQueryGetVideoList];
        self.Resulttableview.hidden = YES;
        self.videocollectionView.hidden = NO;
    }else if (self.Type == 3){
        self.page = 1;
        [self requestMoodList];
        self.Resulttableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }else if (self.Type == 4){
        self.page = 1;
        [self requestMechanismcommentMechanismlist];
        self.Resulttableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }else if (self.Type == 5){
        self.page = 1;
        [self requestGetEmployeeList];
        self.Resulttableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }else if (self.Type == 6){
        self.page = 1;
        [self requestGetWorkMechanismList];
        self.Resulttableview.hidden = NO;
        self.videocollectionView.hidden = YES;
    }
    
}

-(void)clearHistory{
    if (self.Type == 1) {
        kUserDefaultsRemove(InformationSearchHistory);
    }else if (self.Type == 2){
        kUserDefaultsRemove(VideoSearchHistory);
    }else if (self.Type == 3){
        kUserDefaultsRemove(CircleSearchHistory);
    }else if (self.Type == 4){
        kUserDefaultsRemove(BusinessReviewSearchHistory);
    }else if (self.Type == 5){
        kUserDefaultsRemove(LPEmployeeManageHistory);
    }else if (self.Type == 6){
        kUserDefaultsRemove(LPEmployeeWorkListHistory);
    }
     self.textArray = nil;
    [self.tableview reloadData];
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
            [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.listArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        [self.Resulttableview reloadData];
        
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
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}



-(void)setMoodListModel:(LPMoodListModel *)moodListModel{
    _moodListModel = moodListModel;
    if ([moodListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.moodListArray = [NSMutableArray array];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
            //                [self.tableview scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //            });
        }
        if (moodListModel.data.count > 0) {
            self.page += 1;
            [self.moodListArray addObjectsFromArray:moodListModel.data];
            [self.Resulttableview reloadData];
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.moodListArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}


-(void)setBusinessmodel:(LPMechanismcommentMechanismlistModel *)Businessmodel{
    _Businessmodel = Businessmodel;
    if ([self.Businessmodel.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.BusinesslistArray = [NSMutableArray array];
        }
        if (self.Businessmodel.data.count > 0) {
            self.page += 1;
            [self.BusinesslistArray addObjectsFromArray:self.Businessmodel.data];
            [self.Resulttableview reloadData];
            
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.BusinesslistArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}


-(void)setEmployeemodel:(LPLPEmployeeModel *)Employeemodel{
    _Employeemodel = Employeemodel;
    if ([self.Employeemodel.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.EmployeelistArray = [NSMutableArray array];
        }
        if (self.Employeemodel.data.count > 0) {
            self.page += 1;
            [self.EmployeelistArray addObjectsFromArray:self.Employeemodel.data];
            [self.Resulttableview reloadData];
            
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.EmployeelistArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

- (void)setMechanismmodel:(LPMechanismcommentMechanismlistModel *)Mechanismmodel{
    _Mechanismmodel = Mechanismmodel;
    if ([self.Mechanismmodel.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.MechanismlistArray = [NSMutableArray array];
        }
        if (self.Mechanismmodel.data.count > 0) {
            self.page += 1;
            [self.MechanismlistArray addObjectsFromArray:self.Mechanismmodel.data];
            [self.Resulttableview reloadData];
            
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.MechanismlistArray.count == 0) {
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
    if (self.Type == 1 || self.Type == 3|| self.Type == 4|| self.Type == 5|| self.Type == 6) {
        for (UIView *view in self.Resulttableview.subviews) {
            if ([view isKindOfClass:[LPNoDataView class]]) {
                view.hidden = hidden;
                has = YES;
            }
        }
    }else if (self.Type == 2){
        for (UIView *view in self.videocollectionView.subviews) {
            if ([view isKindOfClass:[LPNoDataView class]]) {
                view.hidden = hidden;
                has = YES;
            }
        }
    }

    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-30-kNavBarHeight-kBottomBarHeight)];
        if (self.Type == 1 || self.Type == 3|| self.Type == 4|| self.Type == 5|| self.Type == 6) {
            [self.Resulttableview addSubview:noDataView];
        }else if (self.Type == 2){
            [self.videocollectionView addSubview:noDataView];
        }
        
        noDataView.hidden = hidden;
    }
    
    
    //    LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    [noDataView image:nil text:@"搜索尚无结果\n更多企业正在洽谈中,敬请期待!"];
    //    [self.Resulttableview addSubview:noDataView];
    //    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.Resulttableview);
    //    }];
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        if (self.textArray.count>5) {
            return 5;
        }
        return self.textArray.count;
    }else if (tableView == self.Resulttableview){
        if (self.Type == 3) {
            return self.moodListArray.count;
        }else if (self.Type == 1){
            return self.listArray.count;
        }else if (self.Type == 4){
            return self.BusinesslistArray.count;
        }else if (self.Type == 5){
            return self.EmployeelistArray.count;
        }else if (self.Type == 6){
            return self.MechanismlistArray.count;
        }
    }
    return 0;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F1F0"];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(view);
    }];
    if (tableView == self.tableview) {
        label.text = @"历史搜索";
    }else{
        label.text = @"搜索结果";
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        return 30;
    }
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        
        if (self.textArray.count <= 0) {
            UIView *view = [[UIView alloc]init];
            return view;
        }
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]init];
        [view addSubview:button];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(view);
            make.width.mas_equalTo(120);
        }];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setImage:[UIImage imageNamed:@"delete_search"] forState:UIControlStateNormal];
        [button setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }else{
        return nil;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.Resulttableview) {
        if (self.Type == 3) {
            LPMoodListDataModel *model = self.moodListArray[indexPath.row];
            CGFloat DetailsHeight = [LPTools calculateRowHeight:model.moodDetails fontSize:15 Width:SCREEN_WIDTH - 71];
            //        [self calculateCommentHeight:model];
            CGFloat CommentHeight = 0;
            if (DetailsHeight>90) {
                if ([[LPTools isNullToString:model.address] isEqualToString:@""] || [model.address isEqualToString:@"保密"]) {
                    //        89 + (DetailsHeight>=80?80:DetailsHeight+5)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
                    return   89 + (model.isOpening?DetailsHeight+43:128)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
                }else{
                    return   107 + (model.isOpening?DetailsHeight+43:128)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
                }
            }else{
                if ([[LPTools isNullToString:model.address] isEqualToString:@""] || [model.address isEqualToString:@"保密"]) {
                    //        89 + (DetailsHeight>=80?80:DetailsHeight+5)+[self calculateImageHeight:model.moodUrl]  +CommentHeight;
                    return   89 + DetailsHeight + 5 + [self calculateImageHeight:model.moodUrl]  +CommentHeight;
                }else{
                    return   107 + DetailsHeight + 5 + [self calculateImageHeight:model.moodUrl]  +CommentHeight;
                }
            }
        }else if (self.Type == 1){
            NSArray *array = @[];
            if (self.listArray.count > indexPath.row) {
                array = [self.listArray[indexPath.row].essayUrl componentsSeparatedByString:@";"];
            }
            if (array.count ==0) {
                return 40.0;
            }else if (array.count == 1|| array.count == 2){
                return 110.0;
            }else{
                return 150.0;
            }
        }else if (self.Type == 4){
            return 77.0;
        }else if (self.Type == 5){
            return LENGTH_SIZE(144);
        }else if (self.Type == 6){
            return LENGTH_SIZE(66);
        }
    }
    return 40.0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        static NSString *rid=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
            UIView *LineV = [[UIView alloc] init];
            [cell.contentView addSubview:LineV];
            [LineV mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.mas_offset(12);
                make.right.bottom.mas_offset(0);
                make.height.mas_offset(1);
            }];
            LineV.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.text = self.textArray[indexPath.row];
        return cell;
    }else{
        
        if (self.Type== 1) {
            NSArray *array = @[];
            if (self.listArray.count > indexPath.row) {
                array = [self.listArray[indexPath.row].essayUrl componentsSeparatedByString:@";"];
            }
            if (array.count ==0) {
                return nil;
            }else if (array.count == 1|| array.count == 2) {
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
        }else if (self.Type == 4){
            LPBusinessReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:LPBusinessReviewCellID];
            cell.model = self.BusinesslistArray[indexPath.row];
            return cell;
        }else if (self.Type == 5){
            LPEmployeeManageCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEmployeeManageCellID];
            cell.model = self.EmployeelistArray[indexPath.row];
            WEAK_SELF()
            cell.remarkBlock = ^{
                weakSelf.selectEmployeemodel = weakSelf.EmployeelistArray[indexPath.row];
                [weakSelf initRemarkAlertView];
            };
            return cell;
        }else if (self.Type == 6){
            LPEmployeeWorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEmployeeWorkListCellID];
            cell.Empmodel = self.Empmodel;
            cell.model = self.MechanismlistArray[indexPath.row];
            return cell;
        } else{
            LPCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCircleListCellID];
            if(cell == nil){
                cell = [[LPCircleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPCircleListCellID];
            }
            cell.model = self.moodListArray[indexPath.row];
            cell.indexPath = indexPath;
            cell.SuperTableView = tableView;
            cell.moodListArray = self.moodListArray;
            cell.ClaaViewType = 1;
            
            cell.CommentView.hidden = YES;
            cell.TriangleView.hidden = YES;
            cell.operationButton.hidden = YES;
            
            cell.delegate =self;
            WEAK_SELF()
            cell.Block = ^(void){
                weakSelf.page = 1;
                [weakSelf requestMoodList];
            };
            
            cell.PraiseBlock = ^(void){
                [weakSelf.Resulttableview reloadData];
            };
            if (!cell.moreButtonClickedBlock) {
                [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                    weakSelf.moodListArray[indexPath.row].isOpening = !weakSelf.moodListArray[indexPath.row].isOpening;
                    //            [weakSelf.tableview reloadSections:indexPath withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf.Resulttableview reloadData];
                    
                }];
            }
            cell.VideoBlock =  ^(NSString *VideoUrl,UIImageView *view){
                //播放网络url视频 先下载 再播放
                WJMoviePlayerView *playerView = [[WJMoviePlayerView alloc] init];
                playerView.movieURL = [NSURL URLWithString:VideoUrl];
                playerView.coverView = view;
                [playerView show];
            };
            
            
            return cell;
        }
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableview) {
        self.searchWord = self.textArray[indexPath.row];
        self.SearchBar.text = self.textArray[indexPath.row];
        [self search:self.textArray[indexPath.row]];
        
    }else if (tableView == self.Resulttableview){
        if (self.Type == 1) {
            LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
            vc.essaylistDataModel = self.listArray[indexPath.row];
            vc.Supertableview = self.Resulttableview;
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
        }else if (self.Type == 4){
            LPBusinessReviewDetailVC *vc = [[LPBusinessReviewDetailVC alloc]init];
            vc.mechanismlistDataModel = self.BusinesslistArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark -- UICollectionViewDataSource

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    //返回段头段尾视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        //添加头视图的内容
        headerView.backgroundColor = [UIColor colorWithHexString:@"#F2F1F0"];
        
        UILabel *label = [[UILabel alloc]init];
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(headerView);
        }];
        label.text = @"搜索结果";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        
        reusableView = headerView;
        return reusableView;
    }
    //如果底部视图
    if (kind ==UICollectionElementKindSectionFooter)
    {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"forIndexPath:indexPath];
//        footerview.backgroundColor = [UIColor purpleColor];
//        reusableView = footerview;
        
    }
    return reusableView;
}

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
        vc.key = self.searchWord;
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
    return CGSizeMake(SCREEN_WIDTH, 30);
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
                          @"key":self.searchWord,
                          @"page":@(self.page)
                          };
    [NetApiManager requestEssaylistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPEssaylistModel mj_objectWithKeyValues:responseObject];
            }else{
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
    if (self.VideolistArray.count<=40) {
        for (LPVideoListDataModel *m in self.VideolistArray) {
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }else{
        for (NSInteger i = self.VideolistArray.count-40 ; i<self.VideolistArray.count ; i++) {
            LPVideoListDataModel *m = self.VideolistArray[i];
            ids = [NSString stringWithFormat:@"%@%@v,",ids,m.id];
        }
    }
    NSLog(@"ids = %@",ids);
    
    NSDictionary *dic = @{@"videoName":self.searchWord,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"ids":ids
                          };
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

-(void)requestMoodList{
    NSInteger type = 0;
    NSDictionary *dic = @{@"page":@(self.page),
                          @"type":@(type),
                          @"moodDetails":self.searchWord,
                          @"versionType":@"2.4"
                          };
    [NetApiManager requestMoodListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        [DSBaActivityView hideActiviTy];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.moodListModel = [LPMoodListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}
-(void)requestMechanismcommentMechanismlist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"mechanismAddress":@"china",
                          @"mechanismName":self.searchWord
                          };
    [NetApiManager requestMechanismcommentMechanismlistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Businessmodel = [LPMechanismcommentMechanismlistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestGetEmployeeList{
    NSDictionary *dic = @{
                          @"key":self.searchWord,
                          @"page":[NSString stringWithFormat:@"%ld",self.page]
                          };
    
    [NetApiManager requestGetEmployeeList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Employeemodel = [LPLPEmployeeModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestGetWorkMechanismList{
    NSDictionary *dic = @{@"mechanismName":self.searchWord,
                          @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"userId":self.Empmodel.userId
                          };
    
    [NetApiManager requestGetWorkMechanismList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Mechanismmodel = [LPMechanismcommentMechanismlistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
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
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableview;
}

- (UITableView *)Resulttableview{
    if (!_Resulttableview) {
        _Resulttableview = [[UITableView alloc]init];
        _Resulttableview.delegate = self;
        _Resulttableview.dataSource = self;
        _Resulttableview.tableFooterView = [[UIView alloc]init];
        _Resulttableview.rowHeight = UITableViewAutomaticDimension;
        if (self.Type == 3) {
            _Resulttableview.estimatedRowHeight = 0;
        }else if (self.Type == 1){
            _Resulttableview.estimatedRowHeight = 100;
        }
        if (self.Type == 5 ||self.Type == 6) {
            _Resulttableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        }else{
            _Resulttableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }

        _Resulttableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_Resulttableview registerNib:[UINib nibWithNibName:LPInformationSingleCellID bundle:nil] forCellReuseIdentifier:LPInformationSingleCellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LPCircleListCellID bundle:nil] forCellReuseIdentifier:LPCircleListCellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LPBusinessReviewCellID bundle:nil] forCellReuseIdentifier:LPBusinessReviewCellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LPEmployeeWorkListCellID bundle:nil] forCellReuseIdentifier:LPEmployeeWorkListCellID];
        [_Resulttableview registerNib:[UINib nibWithNibName:LPEmployeeManageCellID bundle:nil] forCellReuseIdentifier:LPEmployeeManageCellID];
        
        _Resulttableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            if (self.Type== 1) {
                self.page = 1;
                [self requestEssaylist];
            }else if (self.Type == 3){
                self.page = 1;
                [self requestMoodList];
            }else if (self.Type == 5){
                self.page = 1;
                [self requestGetEmployeeList];
            }else if (self.Type == 6){
                self.page = 1;
                [self requestGetWorkMechanismList];
            }
            
        }];
        _Resulttableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.Type == 1) {
                [self requestEssaylist];
            }else if (self.Type == 3){
                [self requestMoodList];
            }else if (self.Type == 5){
                [self requestGetEmployeeList];
            }else if (self.Type == 6){
                [self requestGetWorkMechanismList];
            }
        }];
    }
    return _Resulttableview;
}




- (UICollectionView *)videocollectionView{
    if (!_videocollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
//        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 30.0f);  //设置headerView大小
        layout.sectionHeadersPinToVisibleBounds = YES;//头视图悬浮
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
        [_videocollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置

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


//计算图片高度
- (CGFloat)calculateImageHeight:(NSString *)string
{
    if (kStringIsEmpty(string)) {
        return 0;
    }
    CGFloat imgw = (SCREEN_WIDTH-70 - 10)/3;
    NSArray *imageArray = [string componentsSeparatedByString:@";"];
    if (imageArray.count ==1)
    {
        return 250;
    }
    else
    {
        return ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
    }
}

//计算点赞和评论高度
- (CGFloat)calculateCommentHeight:(LPMoodListDataModel *)model
{
    CGFloat Praiseheighe = 0.0;
    if (model.praiseList.count) {
        NSString *PraiseStr = @"♡ ";
        if (model.praiseList.count>10) {
            for (int i = 0 ;i <10 ;i++ ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,model.praiseList[i].userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
            PraiseStr = [NSString stringWithFormat:@"%@等%lu人觉得很赞",PraiseStr,model.praiseList.count];
        }else{
            for (LPMoodPraiseListDataModel *Pmodel in model.praiseList ) {
                PraiseStr = [NSString stringWithFormat:@"%@%@、",PraiseStr,Pmodel.userName];
            }
            PraiseStr = [PraiseStr substringToIndex:PraiseStr.length -1];
        }
        Praiseheighe = [LPTools calculateRowHeight:PraiseStr fontSize:13 Width:SCREEN_WIDTH-70-14];
        //        Praiseheighe = Praiseheighe >48 ?48:Praiseheighe;
        Praiseheighe = Praiseheighe + 14;
    }else{
        Praiseheighe = 0.0;
    }
    
    CGFloat commentheighe = 0.0;
    if (model.commentModelList.count) {
        
        for (int i =0; i < model.commentModelList.count; i++) {
            LPMoodCommentListDataModel   *CModel = model.commentModelList[i];
            NSString *CommentStr;
            if (CModel.toUserName) {        //回复
                CommentStr = [NSString stringWithFormat:@"%@ 回复 %@:%@",CModel.toUserName,CModel.userName,CModel.commentDetails];
            }else{      //评论
                CommentStr = [NSString stringWithFormat:@"%@:%@",CModel.userName,CModel.commentDetails];
            }
            commentheighe += [LPTools calculateRowHeight:CommentStr fontSize:13 Width:SCREEN_WIDTH-70-14]+7;
        }
        if (model.commentModelList.count >=5) {
            commentheighe += 23;
        }
        commentheighe += 7;
    }else{
        commentheighe = 0.0;
    }
    
    if (commentheighe || Praiseheighe) {
        return floor(commentheighe + Praiseheighe +16);
        
    }
    
    
    return floor(commentheighe + Praiseheighe);
}



- (void)initRemarkAlertView{
    CustomIOSAlertView *alertview = [[CustomIOSAlertView alloc] init];
    self.CustomAlert = alertview;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  LENGTH_SIZE(300), LENGTH_SIZE(177))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] init];
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(22));
        make.left.right.mas_offset(0);
    }];
    title.textColor = [UIColor colorWithHexString:@"#333333"];
    title.font = [UIFont boldSystemFontOfSize:18];
    title.text = @"编辑备注";
    title.textAlignment = NSTextAlignmentCenter;
    
    UITextField *TF = [[UITextField alloc] init];
    self.AlertTF = TF;
    [view addSubview:TF];
    [TF mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(65));
        make.left.mas_offset(LENGTH_SIZE(20));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.height.mas_offset(LENGTH_SIZE(36));
    }];
    TF.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    TF.layer.borderWidth = 1;
    TF.layer.cornerRadius = 6;
    TF.placeholder = @"请输入备注";
    TF.text = self.selectEmployeemodel.remark;
    [TF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *button = [[UIButton alloc] init];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(TF.mas_bottom).offset(LENGTH_SIZE(15));
        make.left.mas_offset(LENGTH_SIZE(20));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.height.mas_offset(LENGTH_SIZE(40));
    }];
    button.layer.cornerRadius = 6;
    button.backgroundColor = [UIColor baseColor];
    [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [button setTitle:@"保  存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Touchremark:) forControlEvents:UIControlEventTouchUpInside];
    
    alertview.containerView = view;
    alertview.buttonTitles=@[];
    [alertview setUseMotionEffects:true];
    [alertview setCloseOnTouchUpOutside:true];
    [alertview show];
}

-(void)Touchremark:(UIButton *)sender{
    [self.CustomAlert close];
    [self requestUpdateEmpRemark];
    //    [self requestUpdateRelationReg:self.selectmodel.id.stringValue remark:self.AlertTF.text];
}



-(void)requestUpdateEmpRemark{
    NSDictionary *dic = @{
                          @"id":self.selectEmployeemodel.id,
                          @"type":self.selectEmployeemodel.type,
                          @"remark":self.AlertTF.text
                          };
    
    [NetApiManager requestUpdateEmpRemark:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"编辑备注成功" time:MESSAGE_SHOW_TIME];
                    self.selectEmployeemodel.remark = self.AlertTF.text;
                    [self.Resulttableview reloadData];
                }else{
                    [self.view showLoadingMeg:@"编辑备注失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


#pragma mark textFieldChanged
-(void)textFieldChanged:(UITextField *)textField{
    //
    
    /**
     *  最大输入长度,中英文字符都按一个字符计算
     */
    int kMaxLength = 10;
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                // 截取子串
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            // 截取子串
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
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
