//
//  LPLeaveListVC.m
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLeaveListVC.h"
#import "LPLeaveListCell.h"
#import "LPLeaveEditorVC.h"

static NSString *LPLeaveListCellID = @"LPLeaveListCell";

@interface LPLeaveListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation LPLeaveListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请假总计";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.tableview.backgroundColor =[UIColor whiteColor];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.Toblock) {
        self.Toblock();
    }
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.WageDetailsModel.data.leaveList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPLeaveListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPLeaveListCellID];
    if(cell == nil){
        cell = [[LPLeaveListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPLeaveListCellID];
    }
    cell.model = self.WageDetailsModel.data.leaveList[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPLeaveEditorVC *vc = [[LPLeaveEditorVC alloc] init];
    vc.model = self.WageDetailsModel.data.leaveList[indexPath.row];
    vc.SuperTableView = self.tableview;
    vc.WorkHourType = self.WorkHourType;
    [self.navigationController pushViewController:vc animated:YES];
    WEAK_SELF()
    vc.block = ^(NSInteger num){
        if (num == 1) {
            NSMutableArray *Array =[[NSMutableArray alloc] initWithArray:self.WageDetailsModel.data.leaveList];
            [Array removeObjectAtIndex:indexPath.row];
            self.WageDetailsModel.data.leaveList = [Array copy];
            [self.tableview reloadData];
         }
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
        [_tableview registerNib:[UINib nibWithNibName:LPLeaveListCellID bundle:nil] forCellReuseIdentifier:LPLeaveListCellID];
        
        _tableview.showsVerticalScrollIndicator = NO;
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            self.page = 1;
//            [self requestQueryGetOvertimeGetDetails];
//        }];
//        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self requestQueryGetOvertimeGetDetails];
//        }];
    }
    return _tableview;
}


@end
