//
//  LPWorkorderListVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkorderListVC.h"
#import "LPWorkorderListCell.h"
#import "LPWorkorderListModel.h"

static NSString *LPWorkorderListCellID = @"LPWorkorderListCell";

@interface LPWorkorderListVC ()<UITableViewDelegate,UITableViewDataSource,LPWorkorderListCellDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPWorkorderListModel *model;
@property(nonatomic,strong) NSMutableArray <LPWorkorderListDataModel *>*listArray;
@property(nonatomic,assign) NSInteger selectWorkId;

@end

@implementation LPWorkorderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"面试预约列表";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestWorkorderlist];
}

-(void)setModel:(LPWorkorderListModel *)model{
    _model = model;
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        self.listArray = [NSMutableArray array];
        if (self.model.data.count > 0) {
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
        }else{
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
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorkorderListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkorderListCellID];
    cell.model = self.listArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LPWorkorderListCellDelegate
-(void)buttonClick:(NSInteger)buttonIndex workId:(NSInteger)workId{
    self.selectWorkId = workId;
    if (buttonIndex == 0) {
        [self requestDelWorkorder];
    }else{
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否取消报名" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self requestCancleApply];
            }
        }];
        [alert show];
    }
}
#pragma mark - request
-(void)requestWorkorderlist{
    [NetApiManager requestWorkorderlistWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPWorkorderListModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestCancleApply{
    NSString *string = [NSString stringWithFormat:@"work/cancleApply?workId=%ld",self.selectWorkId];
    [NetApiManager requestCancleApplyWithUrl:string withParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"code"])) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    [self requestWorkorderlist];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestDelWorkorder{
    NSDictionary *dic = @{
                          @"workOrderId":@(self.selectWorkId)
                          };
    [NetApiManager requestDelWorkorderWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"code"])) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    [self requestWorkorderlist];
                }
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
        [_tableview registerNib:[UINib nibWithNibName:LPWorkorderListCellID bundle:nil] forCellReuseIdentifier:LPWorkorderListCellID];
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
