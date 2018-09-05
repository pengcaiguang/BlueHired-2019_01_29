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

static NSString *LPInformationSingleCellID = @"LPInformationSingleCell";
static NSString *LPInformationMoreCellID = @"LPInformationMoreCell";

@interface LPInformationSearchResultVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPEssaylistModel *model;
@property(nonatomic,strong) NSMutableArray <LPEssaylistDataModel *>*listArray;
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
    [self requestEssaylist];

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
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[LPInformationSingleCell class]]) {
            LPInformationSingleCell *c = (LPInformationSingleCell *)cell;
            c.viewLabel.text = [NSString stringWithFormat:@"%ld",[c.viewLabel.text integerValue] + 1];
        }else if ([cell isKindOfClass:[LPInformationMoreCell class]]) {
            LPInformationMoreCell *c = (LPInformationMoreCell *)cell;
            c.viewLabel.text = [NSString stringWithFormat:@"%ld",[c.viewLabel.text integerValue] + 1];
        }
    });
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
            [self.view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
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
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestEssaylist];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestEssaylist];
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
