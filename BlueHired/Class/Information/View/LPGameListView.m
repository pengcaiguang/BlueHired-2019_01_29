//
//  LPGameListView.m
//  BlueHired
//
//  Created by iMac on 2019/11/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPGameListView.h"
#import "LPShanDWLIistModel.h"
#import "LPGameListViewCell.h"

static NSString *LPGameListViewCellID = @"LPGameListViewCell";

@interface LPGameListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) LPShanDWLIistModel *model;
@property (nonatomic,strong) NSMutableArray <LPShanDWLIistDataModel *>*listArray;

@end

@implementation LPGameListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)GetList{
    self.page = 1;
    [self requestShanDWGETGameList];
}



#pragma mark - TableViewDelegate & Datasource
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(80);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPGameListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LPGameListViewCellID];
    cell.model = self.listArray[indexPath.row];
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
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_tableview registerNib:[UINib nibWithNibName:LPGameListViewCellID bundle:nil] forCellReuseIdentifier:LPGameListViewCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestShanDWGETGameList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestShanDWGETGameList];
        }];
        
    }
    return _tableview;
}


- (void)setModel:(LPShanDWLIistModel *)model
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
                self.tableview.mj_footer.hidden = self.listArray.count<20?YES:NO;
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
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }

}

-(void)setNodataViewHidden{
    if (self.listArray.count == 0) {
       [self addNodataViewHidden:NO];
    }else{
       [self addNodataViewHidden:YES];
    }
}

-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableview.lx_height)];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
       
        noDataView.hidden = hidden;
    }
}



#pragma mark - request
-(void)requestShanDWGETGameList{
    
    NSString *type = @"1";
    if (self.GameStatus == 0) {
        type = @"1";
    } else if (self.GameStatus == 1) {
        type = @"2";
    } else if (self.GameStatus == 2) {
        type = @"3";
    }
    
    NSDictionary *dic = @{@"page":@(self.page),
                          @"type":type
    };
    [NetApiManager requestShanDWGETGameList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPShanDWLIistModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

 
 


@end
