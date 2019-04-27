//
//  LPIntegralDrawVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPIntegralDrawVC.h"
#import "LPActivityModel.h"
#import "LPIntegralDrawDatelis.h"
#import "LPIntegralDrawCell.h"

static NSString *LPIntegralDrawCellID = @"LPIntegralDrawCell";

@interface LPIntegralDrawVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) LPActivityModel *Model;
@property(nonatomic,strong) NSMutableArray <LPActivityDataModel *>*ListArray;

@property (nonatomic,strong) LPUserProblemModel *Pmodel;


@end

@implementation LPIntegralDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"幸运积分";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.page = 1;
    [self requestActivityList];
//    [self requestQueryGetUserProdlemList];

}


#pragma mark - TableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return SCREEN_WIDTH/320 * 111.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPIntegralDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:LPIntegralDrawCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = self.ListArray[indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:self.ListArray[indexPath.row].activityUrl]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    LPIntegralDrawDatelis *vc = [[LPIntegralDrawDatelis alloc]init];
    vc.Integralmodel = self.ListArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = YES;
        //        _tableview.tableFooterView = [[UIView alloc]init];
        //        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0.0;
//        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //        _tableview.tableHeaderView = self.tableHeaderView;
        _tableview.separatorStyle = UITableViewCellEditingStyleNone;
        _tableview.estimatedSectionHeaderHeight = 0;
        [_tableview registerNib:[UINib nibWithNibName:LPIntegralDrawCellID bundle:nil] forCellReuseIdentifier:LPIntegralDrawCellID];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestActivityList];
        }];
    }
    return _tableview;
}

-(void)setModel:(LPActivityModel *)Model{
    _Model = Model;
    if ([Model.code integerValue] == 0) {
        if (self.page == 1) {
            self.ListArray = [NSMutableArray array];
        }
        if (Model.data.count > 0) {
            self.page += 1;
            [self.ListArray addObjectsFromArray:Model.data];
            [self.tableview reloadData];
            if(Model.data.count<20){
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (Model.data.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
        
    }else{
        [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
            make.top.mas_equalTo(98);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}



#pragma mark - request
-(void)requestActivityList{
    NSDictionary *dic = @{@"page":@(self.page),
                          @"type":@(1)
                          };
    [NetApiManager requestQueryActivityList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.Model = [LPActivityModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


- (void)setPmodel:(LPUserProblemModel *)Pmodel{
    _Pmodel = Pmodel;
    if (Pmodel.data.count == 0) {
        NSString *str1 = @"为了您的账号安全，请先设置密保问题。";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
        WEAK_SELF()
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"去设置"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                LPChangePhoneVC *vc = [[LPChangePhoneVC alloc]init];
                vc.type = 1;
                //                [self.navigationController pushViewController:vc animated:YES];
                NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
                for (UIViewController *vc in naviVCsArr) {
                    if ([vc isKindOfClass:[weakSelf class]]) {
                        [naviVCsArr removeObject:vc];
                        break;
                    }
                }
                [naviVCsArr addObject:vc];
                vc.hidesBottomBarWhenPushed = YES;
                
                [weakSelf.navigationController  setViewControllers:naviVCsArr animated:YES];
                
            }
        }];
        [alert show];
    }
}


-(void)requestQueryGetUserProdlemList{
    
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetUserProdlemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.Pmodel = [LPUserProblemModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
