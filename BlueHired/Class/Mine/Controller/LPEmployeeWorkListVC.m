//
//  LPEmployeeWorkListVC.m
//  BlueHired
//
//  Created by iMac on 2019/8/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPEmployeeWorkListVC.h"
#import "LPMechanismcommentMechanismlistModel.h"
#import "LPSelectCityVC.h"
#import "LPSearchBar.h"
#import "LPEmployeeWorkListCell.h"
#import "LPInformationSearchVC.h"

static NSString *LPEmployeeWorkListCellID = @"LPEmployeeWorkListCell";

@interface LPEmployeeWorkListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,LPSelectCityVCDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UILabel *cityLabel;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) NSString *mechanismAddress;
@property(nonatomic,strong) LPMechanismcommentMechanismlistModel *model;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentMechanismlistDataModel *>*listArray;

@end

@implementation LPEmployeeWorkListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"在招企业列表";
    self.mechanismAddress = @"china";
    [self setTitleView];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
    self.page = 1;
    [self requestGetWorkMechanismList];
}


-(void)setTitleView{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(LENGTH_SIZE(44));
    }];
    bgView.backgroundColor = [UIColor baseColor];
    
    UIView *leftBarButtonView = [[UIView alloc]init];
    [bgView addSubview:leftBarButtonView];
    [leftBarButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LENGTH_SIZE(44));
        make.left.mas_equalTo(LENGTH_SIZE(11));
        make.top.mas_equalTo(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSelectCityButton)];
    leftBarButtonView.userInteractionEnabled = YES;
    [leftBarButtonView addGestureRecognizer:tap];
    
    
    UIImageView *pimageView = [[UIImageView alloc]init];
    [leftBarButtonView addSubview:pimageView];
    [pimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(leftBarButtonView);
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(18), LENGTH_SIZE(18)));
    }];
    pimageView.image = [UIImage imageNamed:@"location"];
    
    self.cityLabel = [[UILabel alloc]init];
    [leftBarButtonView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pimageView.mas_right).offset(LENGTH_SIZE(4));
        make.centerY.mas_equalTo(leftBarButtonView);
        make.right.equalTo(leftBarButtonView.mas_right).offset(0);
    }];
    self.cityLabel.text = @"全国";
    self.cityLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    self.cityLabel.textColor = [UIColor whiteColor];
    
 
    LPSearchBar *searchBar = [self addSearchBar];
    UIView *wrapView = [[UIView alloc]init];
    [bgView addSubview:wrapView];
    [wrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBarButtonView.mas_right).offset(LENGTH_SIZE(13));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.centerY.equalTo(bgView);
        make.height.mas_equalTo(LENGTH_SIZE(30));
    }];
    wrapView.layer.cornerRadius = LENGTH_SIZE(14);
    wrapView.layer.masksToBounds = YES;
    
    [wrapView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
}

#pragma mark - search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    LPInformationSearchVC *vc = [[LPInformationSearchVC alloc]init];
    vc.Empmodel = self.Empmodel;
    vc.mechanismAddress = self.mechanismAddress;
    vc.Type = 6;
    [self.navigationController pushViewController:vc animated:YES];

    return NO;
}

#pragma mark - LPSelectCityVCDelegate
-(void)selectCity:(LPCityModel *)model{
    if ([model.c_name isEqualToString:@"全国"]) {
        self.mechanismAddress = @"china";
    }else{
        self.mechanismAddress = model.c_name;
    }
    if (model.c_name.length>3) {
        self.cityLabel.text = [NSString stringWithFormat:@"%@…",[model.c_name substringToIndex:3]];
    }else{
        self.cityLabel.text = model.c_name;
    }
    self.page = 1;
    [self requestGetWorkMechanismList];
}


- (LPSearchBar *)addSearchBar{
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]init];
    
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入企业名称";
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
        searchField.layer.cornerRadius = LENGTH_SIZE(15);
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:FontSize(13)];
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - LENGTH_SIZE(30)) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}

-(void)touchSelectCityButton{
    LPSelectCityVC *vc = [[LPSelectCityVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(66);
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPEmployeeWorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEmployeeWorkListCellID];
    cell.Empmodel = self.Empmodel;
    cell.model = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setModel:(LPMechanismcommentMechanismlistModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data];
            [self.tableview reloadData];
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.listArray.count == 0) {
            self.tableview.mj_footer.alpha = 0;
            [self addNodataViewHidden:NO];
        }else{
            self.tableview.mj_footer.alpha = 1;
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
        LPNoDataView *noDataView = [[LPNoDataView alloc]init];
        [self.view addSubview:noDataView];
        [noDataView image:nil text:@"没有相关数据~"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(LENGTH_SIZE(49));
            make.bottom.mas_equalTo(LENGTH_SIZE(0));
        }];
        noDataView.hidden = hidden;
    }
}

-(void)requestGetWorkMechanismList{
    NSDictionary *dic = @{@"mechanismAddress":self.mechanismAddress,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"userId":self.Empmodel.userId
                          };
    
    [NetApiManager requestGetWorkMechanismList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPMechanismcommentMechanismlistModel mj_objectWithKeyValues:responseObject];
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
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPEmployeeWorkListCellID bundle:nil] forCellReuseIdentifier:LPEmployeeWorkListCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetWorkMechanismList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetWorkMechanismList];
        }];
    }
    return _tableview;
}


@end
