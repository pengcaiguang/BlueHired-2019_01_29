//
//  LPEntryVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPEntryVC.h"
#import "LPSearchBar.h"
#import "LPEntryCell.h"
#import "LPEntryScreenView.h"
#import "LPentryModel.h"
#import "LPLPEntrySetDateVC.h"

static NSString *LPTLendAuditCellID = @"LPEntryCell";

@interface LPEntryVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,LPLandScreenAlertViewDelegate>
@property(nonatomic,strong) UIButton *sortButton;
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPEntryScreenView *screenAlertView;
@property (weak, nonatomic) IBOutlet UIButton *righttimeButton;
@property (nonatomic,strong) LPSearchBar *searchButton;

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,strong) LPentryModel *model;
@property(nonatomic,strong) NSMutableArray <LPentryDataModel *>*listArray;
@property(nonatomic,assign) NSInteger page;

@end

@implementation LPEntryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"入职员工管理";
    self.status = @"-1";
    self.key = @"";
    [self setViewUI];
    self.page = 1;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(88);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self requestQueryWorkOrderList];
 }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.page = 1;
//    [self requestQueryWorkOrderList];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.screenAlertView.hidden) {
        self.screenAlertView.hidden = YES;
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
    
    [self.righttimeButton addTarget:self action:@selector(touchslices:) forControlEvents:UIControlEventTouchUpInside];

 }

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.key = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DSBaActivityView showActiviTy];
    self.page = 1;
    [self requestQueryWorkOrderList];
}

-(void)touchsearch:(UIButton *)button{
    self.key = [self.searchButton.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DSBaActivityView showActiviTy];
    self.page = 1;
    [self requestQueryWorkOrderList];
}

-(void)touchslices:(UIButton *)button{
    
    self.screenAlertView.SuperView = self;
    button.selected = !button.isSelected;
    self.screenAlertView.hidden = !button.isSelected;
}


- (LPSearchBar *)addSearchBar{
    self.definesPresentationContext = YES;
    LPSearchBar *searchBar = [[LPSearchBar alloc]init];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入姓名或者联系方式";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    UITextField *searchField;
    
    if (@available(iOS 13.0, *)) {
        searchField = searchBar.searchTextField;
    }else{
        searchField = [searchBar valueForKey:@"searchField"];
    }
    
    
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
    LPEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTLendAuditCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPEntryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPTLendAuditCellID];
    }
    
    cell.model = self.listArray[indexPath.row];
    WEAK_SELF()
    cell.Block = ^(void) {
//        weakSelf.page = 1;
//        [weakSelf requestQueryWorkOrderList];
        [weakSelf.tableview reloadData];
    };
    
    cell.BlockTL = ^(LPentryDataModel *M){
        //        weakSelf.page = 1;
        //        [weakSelf requestQueryWorkOrderList];
        [weakSelf.listArray removeObject:M];
        [weakSelf.tableview reloadData];
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
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
            self.status = @"-1";
            self.key = @"";
            [self requestQueryWorkOrderList];
        }];
                _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self requestQueryWorkOrderList];
                }];
    }
    return _tableview;
}
-(LPEntryScreenView *)screenAlertView{
    if (!_screenAlertView) {
        _screenAlertView = [[LPEntryScreenView alloc]init];
        _screenAlertView.touchButton = self.righttimeButton;
        _screenAlertView.delegate = self;
    }
    return _screenAlertView;
}

#pragma mark - LPScreenAlertViewDelegate
-(void)touchTableView:(NSInteger) Row
{
    NSLog(@"touchtableView = %ld",(long)Row);
    if (Row == 0) {
        self.status = @"-1";
        [_righttimeButton setTitle:@"全部" forState:UIControlStateNormal];
    }else if (Row == 1){
        self.status = @"2";
        [_righttimeButton setTitle:@"面试未处理" forState:UIControlStateNormal];

    }else if (Row == 2){
        self.status = @"1";
        [_righttimeButton setTitle:@"面试已处理" forState:UIControlStateNormal];

    }else if (Row == 3){
        self.status = @"3";
        [_righttimeButton setTitle:@"一人多号" forState:UIControlStateNormal];
    }
    self.page = 1;
    [self requestQueryWorkOrderList];
    
}

- (void)setModel:(LPentryModel *)model
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
            if (self.model.data.count<20) {
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
            make.top.mas_equalTo(89);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}

#pragma mark - request
-(void)requestQueryWorkOrderList{
    NSDictionary *dic = @{@"key":self.key,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"status":self.status,
                          @"mechanismId":self.Mechanismodel.id
                          };
    
    WEAK_SELF()
    [NetApiManager requestQueryWorkOrderList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [DSBaActivityView hideActiviTy];
        if (isSuccess) {

            if ([responseObject[@"code"] integerValue] == 0) {
                weakSelf.model = [LPentryModel mj_objectWithKeyValues:responseObject];
                [weakSelf.tableview reloadData];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
