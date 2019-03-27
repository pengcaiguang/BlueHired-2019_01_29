//
//  LPPieceListVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPPieceListVC.h"
#import "LPProRecirdModel.h"
#import "LPPieceEdirVC.h"
#import "LPPieceListCell.h"
static NSString *LPPieceListCellID = @"LPPieceListCell";

@interface LPPieceListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) NSMutableArray <LPProRecirdDataModel *>*listArray;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong)LPProRecirdModel *model;



@end

@implementation LPPieceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"计件列表";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-65);
    }];
    self.tableview.backgroundColor =[UIColor whiteColor];
    self.page = 1;
    [self requestQueryGetProRecordList];
}

- (IBAction)TouchSave:(id)sender {
    LPPieceEdirVC *vc = [[LPPieceEdirVC alloc] init];
    vc.listArray = self.listArray;
    vc.currentDateString = self.currentDateString;
    [self.navigationController pushViewController:vc animated:YES];
    vc.Block = ^(void){
        if (self.listArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        [self.tableview reloadData];
    };
}


#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.listArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPPieceListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPPieceListCellID];
    if(cell == nil){
        cell = [[LPPieceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPPieceListCellID];
    }
    
    cell.row = indexPath.row;
    cell.model = self.listArray[indexPath.row];
   

    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPPieceEdirVC *vc = [[LPPieceEdirVC alloc] init];
    vc.model = self.listArray[indexPath.row];
    vc.listArray = self.listArray;
    vc.currentDateString = self.currentDateString;
    [self.navigationController pushViewController:vc animated:YES];
    vc.Block = ^(void){
        if (self.listArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        [self.tableview reloadData];
    };
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 10;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPPieceListCellID bundle:nil] forCellReuseIdentifier:LPPieceListCellID];

        _tableview.showsVerticalScrollIndicator = NO;

        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
             _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
                self.page = 1;
                [self requestQueryGetProRecordList];
            }];
            _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self requestQueryGetProRecordList];
            }];
     }
    return _tableview;
}


- (void)setModel:(LPProRecirdModel *)model{
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
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-65);
        }];
        noDataView.hidden = hidden;
    }
}


#pragma mark - request
-(void)requestQueryGetProRecordList{
    WEAK_SELF()
    NSDictionary *dic = @{@"time":self.currentDateString,
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page]
                          };
    [NetApiManager requestQueryGetProRecordList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.model = [LPProRecirdModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
