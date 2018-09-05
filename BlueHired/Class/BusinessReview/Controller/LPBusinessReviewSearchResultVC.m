//
//  LPBusinessReviewSearchResultVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/5.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPBusinessReviewSearchResultVC.h"
#import "LPMechanismcommentMechanismlistModel.h"
#import "LPBusinessReviewCell.h"
#import "LPBusinessReviewDetailVC.h"

static NSString *LPBusinessReviewCellID = @"LPBusinessReviewCell";

@interface LPBusinessReviewSearchResultVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPMechanismcommentMechanismlistModel *model;
@property(nonatomic,strong) NSMutableArray <LPMechanismcommentMechanismlistDataModel *>*listArray;

@end

@implementation LPBusinessReviewSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"企业搜索";
    self.page = 1;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(49);
//        make.bottom.mas_equalTo(0);
    }];
    [self requestMechanismcommentMechanismlist];
}

#pragma mark - setter
-(void)setModel:(LPMechanismcommentMechanismlistModel *)model{
    _model = model;
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
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(49);
//            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - request
-(void)requestMechanismcommentMechanismlist{
    NSDictionary *dic = @{
                          @"page":@(self.page),
                          @"mechanismAddress":@"china",
                          @"mechanismName":self.string
                          };
    [NetApiManager requestMechanismcommentMechanismlistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.model = [LPMechanismcommentMechanismlistModel mj_objectWithKeyValues:responseObject];
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPBusinessReviewCellID bundle:nil] forCellReuseIdentifier:LPBusinessReviewCellID];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
