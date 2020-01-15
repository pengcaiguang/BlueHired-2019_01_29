//
//  LPWorkorderListVC.m
//  BlueHired
//
//  Created by peng on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkorderListVC.h"
//#import "LPWorkorderListCell.h"
#import "LPWorkorderListModel.h"
#import "LPWorkOrderList2Cell.h"
#import "LPWorkDetailVC.h"

static NSString *LPWorkorderListCellID = @"LPWorkOrderList2Cell";

@interface LPWorkorderListVC ()<UITableViewDelegate,UITableViewDataSource,LPWorkorderList2CellDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPWorkorderListModel *model;
@property(nonatomic,strong) NSMutableArray <LPWorkorderListDataModel *>*listArray;
@property(nonatomic,strong) UIView *TitleV;
@property(nonatomic,strong) UILabel *TitleL;


@end

@implementation LPWorkorderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"报名记录";
    
    UIView *TitleView = [[UIView alloc] init];
    [self.view addSubview:TitleView];
    self.TitleV = TitleView;
    [TitleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.mas_offset(0);
    }];
    TitleView.backgroundColor = [UIColor colorWithHexString:@"#FFF4E0"];
    TitleView.hidden = YES;
    
    UILabel *TitleLabel = [[UILabel alloc] init];
    [TitleView addSubview:TitleLabel];
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(6));
        make.bottom.mas_offset(LENGTH_SIZE(-6));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-13));
    }];
    TitleLabel.textColor = [UIColor colorWithHexString:@"#FAAB19"];
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    TitleLabel.font = FONT_SIZE(13);
    TitleLabel.numberOfLines = 0;
    self.TitleL = TitleLabel;

    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.top.equalTo(TitleView.mas_bottom);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestWorkorderlist];
}

-(void)setModel:(LPWorkorderListModel *)model{
    _model = model;
  
    if ([self.model.code integerValue] == 0) {
        self.listArray = [NSMutableArray array];
        if (self.model.data.count > 0) {
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (model.data[0].restRemark.length>0) {
                self.TitleV.hidden = NO;
                self.TitleL.text = model.data[0].restRemark;
            }else{
                self.TitleV.hidden = YES;
                [self.TitleV mas_updateConstraints:^(MASConstraintMaker *make){
                    make.height.mas_offset(0);
                }];
            }
            
        }else{
            self.TitleV.hidden = YES;
            [self.TitleV mas_updateConstraints:^(MASConstraintMaker *make){
                make.height.mas_offset(0);
            }];
            [self addNodataView];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}
-(void)addNodataView{
    LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
    [noDataView image:nil text:@"抱歉！没有相关记录！"];
    [self.view addSubview:noDataView];
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorkOrderList2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkorderListCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.listArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    LPWorklistDataWorkListModel *m = [[LPWorklistDataWorkListModel alloc] init];
//    m.id = self.listArray[indexPath.row].workId;
//    m.isApply = self.listArray[indexPath.row].isApply;
//    
//    LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.workListModel = m;
//    vc.isWorkOrder = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    
    
}

#pragma mark - LPWorkorderListCellDelegate
- (void)buttonClick:(NSInteger)buttonIndex workId:(LPWorkorderListDataModel *)workModel{
 
    if (buttonIndex == 0) {
        [self requestDelWorkorder:workModel];
    }else if (buttonIndex == 2){
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否放弃入职？"
                                                             message:nil
                                                       textAlignment:NSTextAlignmentCenter
                                                        buttonTitles:@[@"否",@"是"]
                                                        buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]]
                                             buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                                         buttonClick:^(NSInteger buttonIndex) {
                                                             if (buttonIndex == 1) {
                                                                 [self requestDelWorkorder:workModel];
                                                             }
                                                         }];
        [alert show];
    }else{
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否取消报名"
                                                             message:nil
                                                       textAlignment:NSTextAlignmentCenter
                                                        buttonTitles:@[@"否",@"是"]
                                                        buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]]
                                             buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                                         buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self requestCancleApply:[workModel.workId stringValue]];
            }
        }];
        [alert show];
    }
}
#pragma mark - request
-(void)requestWorkorderlist{
    NSDictionary *dic = @{
                          @"versionType":@"2.4"
                          };
    
    [NetApiManager requestWorkorderlistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPWorkorderListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestCancleApply:(NSString *)WorkId{
    NSString *string = [NSString stringWithFormat:@"work/cancleApply?workId=%@",WorkId];
    [NetApiManager requestCancleApplyWithUrl:string withParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    if ([responseObject[@"data"] integerValue] > 0) {
                        [self requestWorkorderlist];
                    }else{
                        [self.view showLoadingMeg:@"取消报名失败,请稍后再试" time:MESSAGE_SHOW_TIME*2];
                    }
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME*2];
                }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestDelWorkorder:(LPWorkorderListDataModel *)WorkModel{
    NSDictionary *dic = @{@"versionType":@"2.4",
                          @"workOrderId":[WorkModel.id stringValue]
                          };
    [NetApiManager requestDelWorkorderWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue]>0) {
                    [self requestWorkorderlist];
                    
                }else{
                    [self.view showLoadingMeg:@"面试预约删除失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
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
        _tableview.estimatedRowHeight = 200;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkorderListCellID bundle:nil] forCellReuseIdentifier:LPWorkorderListCellID];
    }
    return _tableview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
