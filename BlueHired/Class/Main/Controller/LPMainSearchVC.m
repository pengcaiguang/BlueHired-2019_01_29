//
//  LPMainSearchVC.m
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMainSearchVC.h"
#import "LPSearchBar.h"
#import "LPMainSearchResultVC.h"
#import "LPWorklistModel.h"
#import "LPWorkDetailVC.h"
#import "LPMain2Cell.h"

static NSString *MainSearchHistory = @"MainSearchHistory";
static NSString *LPMainCellID = @"LPMain2Cell";

@interface LPMainSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Resulttableview;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) LPWorklistModel *model;
@property(nonatomic,strong) NSMutableArray <LPWorklistDataWorkListModel *>*listArray;

@property(nonatomic,copy) NSArray *textArray;
@property(nonatomic,copy) NSString *searchWord;

@property(nonatomic,strong)LPSearchBar *SearchBar;

@end

@implementation LPMainSearchVC

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
    self.Resulttableview.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.textArray = (NSArray *)kUserDefaultsValue(MainSearchHistory);
    [self.tableview reloadData];
}

-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 - 0 * 15 - 44 -5 , 44)];
    self.SearchBar = searchBar;
    [searchBar becomeFirstResponder];
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
//    searchBar.backgroundColor = [UIColor blueColor];
    
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

#pragma mark - UITextFieldDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.Resulttableview.hidden == NO) {
        self.Resulttableview.hidden = YES;
        self.textArray = (NSArray *)kUserDefaultsValue(MainSearchHistory);
        [self.tableview reloadData];
    }
    return YES;
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
        [self.view showLoadingMeg:@"请输入企业名称或关键字" time:MESSAGE_SHOW_TIME];
    }
}

-(void)saveWords{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.textArray];
    if (![array containsObject:self.searchWord]) {
        [array insertObject:self.searchWord atIndex:0];
        kUserDefaultsSave([array copy], MainSearchHistory);
    }
}

-(void)search:(NSString *)string{
//    LPMainSearchResultVC *vc = [[LPMainSearchResultVC alloc]init];
//    vc.string = string;
//    [self.navigationController pushViewController:vc animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.Resulttableview.hidden = NO;
    self.page = 1;
    [self request];
}

-(void)clearHistory{
    kUserDefaultsRemove(MainSearchHistory);
    self.textArray = nil;
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableview) {
        if (self.textArray.count>5) {
            return 5;
        }
        return self.textArray.count;
    }else{
        return self.listArray.count;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F1F0"];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.Resulttableview) {
        
        LPWorklistDataWorkListModel *m = self.listArray[indexPath.row];
        if (m.key.length == 0) {
            return LENGTH_SIZE(120) ;
        }
        return LENGTH_SIZE(140) ;
    }
    return 44.0;
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
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setImage:[UIImage imageNamed:@"delete_search"] forState:UIControlStateNormal];
        [button setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }else{
        return nil;
    }

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
        LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
        if(cell == nil){
            cell = [[LPMain2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
        }
        cell.model = self.listArray[indexPath.row];
        return cell;
    }

  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableview) {
        self.searchWord = self.textArray[indexPath.row];
        self.SearchBar.text = self.textArray[indexPath.row];
        [self search:self.textArray[indexPath.row]];
    }else{
        LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
        vc.workListModel = self.listArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 30;
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
        _Resulttableview.estimatedRowHeight = 0;
        
        _Resulttableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Resulttableview.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
        _Resulttableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_Resulttableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        _Resulttableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self request];
        }];
        _Resulttableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self request];
        }];
    }
    return _Resulttableview;
}



-(void)setModel:(LPWorklistModel *)model{
    _model = model;
    //    [self addNodataView];
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.workList.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data.workList];
            [self.Resulttableview reloadData];
        }else{
            if (self.page == 1) {
                [self.Resulttableview reloadData];
            }else{
                [self.Resulttableview.mj_footer endRefreshingWithNoMoreData];
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
    for (UIView *view in self.Resulttableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-30-kNavBarHeight-kBottomBarHeight)];
        [noDataView image:nil text:@"搜索尚无结果\n更多企业正在洽谈中,敬请期待!"];
        [self.Resulttableview addSubview:noDataView];
 
        noDataView.hidden = hidden;
    }
    
    
//    LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [noDataView image:nil text:@"搜索尚无结果\n更多企业正在洽谈中,敬请期待!"];
//    [self.Resulttableview addSubview:noDataView];
//    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.Resulttableview);
//    }];
}


#pragma mark - request
-(void)request{
    NSDictionary *dic = @{
                          @"type":@(0),
                          @"mechanismName":self.searchWord,
                          @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china",
                          @"page":@(self.page)
                          };
    [NetApiManager requestWorklistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.Resulttableview.mj_header endRefreshing];
        [self.Resulttableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                 self.model = [LPWorklistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//计算标签高度
-(CGFloat)calculateKeyHeight:(NSString *) Key{
    if (Key.length == 0) {
        return 0;
    }
    Key = [Key stringByReplacingOccurrencesOfString:@"丨" withString:@"|"];

    NSArray * tagArr = [Key componentsSeparatedByString:@"|"];
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<tagArr.count; i++) {
        CGSize tagTextSize = [tagArr[i] sizeWithFont:[UIFont systemFontOfSize:FontSize(12)] maxSize:CGSizeMake(SCREEN_WIDTH-LENGTH_SIZE(116), LENGTH_SIZE(17))];
        if (tagBtnX+tagTextSize.width+14 > SCREEN_WIDTH-LENGTH_SIZE(116)) {
            tagBtnX = 0;
            tagBtnY += LENGTH_SIZE(17)+8;
        }
        tagBtnX = tagBtnX + tagTextSize.width + LENGTH_SIZE(4);
    }
    return tagBtnY + LENGTH_SIZE(17);
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
