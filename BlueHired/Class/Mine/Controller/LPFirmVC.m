//
//  LPFirmVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPFirmVC.h"
#import "LPSearchBar.h"
#import "LPFirmModel.h"
#import "LPFirmCell.h"


static NSString *LPTLendAuditCellID = @"LPFirmCell";

@interface LPFirmVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) LPSearchBar *searchButton;
@property (nonatomic, strong)UITableView *tableview;

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,strong) LPFirmModel *model;
@property(nonatomic,strong) NSMutableArray <LPFirmDataModel *>*listArray;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) NSArray *textArray;

@end

@implementation LPFirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业员工管理";
    [self setViewUI];
    self.status = @"";
    self.key = @"";
    _page = 1;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(48);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self requestQueryCompanyStaff];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.page = 1;
//    [self requestQueryCompanyStaff];

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
    [DSBaActivityView showActiviTy];
    self.page = 1;
    [self requestQueryCompanyStaff];
}

-(void)touchsearch:(UIButton *)button{
    self.key = [self.searchButton.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DSBaActivityView showActiviTy];
    self.page = 1;
    [self requestQueryCompanyStaff];
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
    LPFirmCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTLendAuditCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPFirmCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPTLendAuditCellID];
    }
    
    cell.model = self.listArray[indexPath.row];
    WEAK_SELF()
    cell.BlockTL = ^(LPFirmDataModel *M) {
//        [weakSelf requestQueryWorkOrderList];
        weakSelf.page = 1;
        [weakSelf requestQueryCompanyStaff];
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
            self.status = @"";
            self.key = @"";
            [self requestQueryCompanyStaff];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self requestQueryCompanyStaff];
        }];
    }
    return _tableview;
}
- (void)setModel:(LPFirmModel *)model
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
            if (self.model.data.count <20) {
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
            make.top.mas_equalTo(49);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}

#pragma mark - request
-(void)requestQueryCompanyStaff{
    NSDictionary *dic = @{@"key":self.key,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"workStatus":self.status,
                          @"mechanismId":self.Mechanismodel.id
                          };
    
    WEAK_SELF()

    [NetApiManager requestQueryCompanyStaff:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [DSBaActivityView hideActiviTy];

        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                weakSelf.model = [LPFirmModel mj_objectWithKeyValues:responseObject];
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
