//
//  LPBusinessReviewVC.m
//  BlueHired
//
//  Created by peng on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPBusinessReviewVC.h"
#import "LPMechanismcommentMechanismlistModel.h"
#import "LPBusinessReviewCell.h"
#import "LPSelectCityVC.h"
#import "LPSearchBar.h"
#import "LPBusinessReviewSearchVC.h"
#import "LPBusinessReviewDetailVC.h"
#import "LPInformationSearchVC.h"

static NSString *LPBusinessReviewCellID = @"LPBusinessReviewCell";

@interface LPBusinessReviewVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,LPSelectCityVCDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) UILabel *cityLabel;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) NSString *mechanismAddress;

@property(nonatomic,strong) LPMechanismcommentMechanismlistModel *model;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentMechanismlistDataModel *>*listArray;

@end

@implementation LPBusinessReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"企业点评";
    
    self.page = 1;
    [self setTitleView];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(LENGTH_SIZE(44));
        make.bottom.mas_equalTo(0);
    }];
    [self requestMechanismcommentMechanismlist];
}

-(void)setTitleView{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(LENGTH_SIZE(44));
    }];
    bgView.backgroundColor = [UIColor baseColor];
    
    UIView *leftBarButtonView = [[UIView alloc]init];
    [bgView addSubview:leftBarButtonView];
    [leftBarButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LENGTH_SIZE(44));
        make.left.mas_equalTo(LENGTH_SIZE(13));
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
    self.cityLabel.font = [UIFont systemFontOfSize:FontSize(16)];
    self.cityLabel.textColor = [UIColor whiteColor];
    
//    UIImageView *dimageView = [[UIImageView alloc]init];
//    [leftBarButtonView addSubview:dimageView];
//    [dimageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.cityLabel.mas_right).offset(3);
//        make.centerY.equalTo(leftBarButtonView);
//        make.size.mas_equalTo(CGSizeMake(11, 6));
//        make.right.equalTo(leftBarButtonView.mas_right).offset(0);
//    }];
//    dimageView.image = [UIImage imageNamed:@"downArrow"];
    
    UIView *wrapView = [[UIView alloc]init];
    [bgView addSubview:wrapView];
    [wrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBarButtonView.mas_right).offset(LENGTH_SIZE(13));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.top.mas_equalTo(LENGTH_SIZE(7));
        make.height.mas_equalTo(LENGTH_SIZE(30));
    }];
    wrapView.backgroundColor = [UIColor whiteColor];
    wrapView.layer.cornerRadius = LENGTH_SIZE(15);
    wrapView.clipsToBounds = YES;
    [bgView layoutIfNeeded];
    wrapView.layer.masksToBounds = YES;
    LPSearchBar *searchBar = [self addSearchBar];
//    searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH - 78, 30);
    [wrapView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);

    }];
    
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
        searchField.font = [UIFont systemFontOfSize:FontSize(14)];
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 30.0) / 2.0;
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

#pragma mark - search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    LPInformationSearchVC *vc = [[LPInformationSearchVC alloc]init];
    vc.Type = 4;
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
//    self.cityLabel.text = model.c_name;
    self.page = 1;
    [self requestMechanismcommentMechanismlist];
}
#pragma mark - setter
-(void)setModel:(LPMechanismcommentMechanismlistModel *)model{
     _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            
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
-(void)requestMechanismcommentMechanismlist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"mechanismAddress":self.mechanismAddress ? self.mechanismAddress : @"china"
                          };
    [NetApiManager requestMechanismcommentMechanismlistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
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
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPBusinessReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:LPBusinessReviewCellID];
    cell.model = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPBusinessReviewDetailVC *vc = [[LPBusinessReviewDetailVC alloc]init];
    vc.mechanismlistDataModel = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_tableview registerNib:[UINib nibWithNibName:LPBusinessReviewCellID bundle:nil] forCellReuseIdentifier:LPBusinessReviewCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestMechanismcommentMechanismlist];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMechanismcommentMechanismlist];
        }];
    }
    return _tableview;
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
