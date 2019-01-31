//
//  LPFirmDetailsVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPFirmDetailsVC.h"
#import "LPLPFirmDetailsCell.h"
#import "LPFirmDetailsModel.h"
#import "LPFIRMlizhiViewController.h"

static NSString *LPTLendAuditCellID = @"LPLPFirmDetailsCell";

@interface LPFirmDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property (nonatomic,strong) NSArray *TitleArr1;
@property (nonatomic,strong) NSArray *TitleArr2;
@property (nonatomic,strong) NSArray *TitleArr3;
@property (nonatomic,strong) NSArray *ContentArr1;
@property (nonatomic,strong) NSArray *ContentArr2;


@property (nonatomic,strong) LPFirmDetailsModel *DetailsModel;

@end

@implementation LPFirmDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"员工信息登记表";
    _TitleArr1 = @[@"姓名:",@"性别:",@"身份证号:",@"入职日期:",@"联系电话:"];
     _TitleArr2 = @[@"工号",@"家庭住址",@"其他联系电话",@"入职部门",@"组长姓名",@"组长联系方式",@"宿舍楼号",@"员工来源",@"供应商电话",@"员工工价",@"填写离职信息"];
    _TitleArr3 = @[@"工号",@"家庭住址",@"其他联系电话",@"入职部门",@"组长姓名",@"组长联系方式",@"宿舍楼号",@"员工来源",@"供应商电话",@"员工工价",@"离职日期",@"离职方式",@"离职原因"];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
    
    [self requestQueryUserRegistration];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _TitleArr1.count;
    }else if (section == 1){
        if (![[LPTools isNullToString:_DetailsModel.workEndTime] isEqualToString:@""] &&
            ![[LPTools isNullToString:_DetailsModel.workEndDetails] isEqualToString:@""]) {
            return _TitleArr3.count;
        }
         return _TitleArr2.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPLPFirmDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTLendAuditCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPLPFirmDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPTLendAuditCellID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.content.hidden = YES;
    cell.content.text = @" ";
    if (indexPath.section == 0) {
        cell.name.text = _TitleArr1[indexPath.row];
        cell.contentTF.enabled = NO;
        NSString *str = @"";
        if (indexPath.row == 0) {
            str = [LPTools isNullToString:_DetailsModel.userName];
        }else if (indexPath.row == 1){
            str = [LPTools isNullToString:_DetailsModel.userName].integerValue?@"男":@"女";
        }else if (indexPath.row == 2){
            str = [LPTools isNullToString:_DetailsModel.userCardNumber];
        }else if (indexPath.row == 3){
            str = [NSString convertStringToYYYMMDD:[LPTools isNullToString:_DetailsModel.workBeginTime]];
        }else if (indexPath.row == 4){
            str = [LPTools isNullToString:_DetailsModel.userTel];
        }
        cell.contentTF.text = str;
        
    }else if (indexPath.section == 1){
        if (![[LPTools isNullToString:_DetailsModel.workEndTime] isEqualToString:@""] &&
            ![[LPTools isNullToString:_DetailsModel.workEndDetails] isEqualToString:@""]) {

            cell.name.text = [NSString stringWithFormat:@"%@:", _TitleArr3[indexPath.row]];
            cell.Row = indexPath.row;
            cell.contentTF.enabled = YES;
            cell.contentTF.placeholder = [NSString stringWithFormat:@"请输入%@",_TitleArr3[indexPath.row]];
            cell.contentTF.keyboardType = UIKeyboardTypeDefault;
            NSString *str = @"";
            
            if (indexPath.row == 0) {
                str = [LPTools isNullToString:_DetailsModel.workNum];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 1){
                str = [LPTools isNullToString:_DetailsModel.userAddress];
            }else if (indexPath.row == 2){
                str = [LPTools isNullToString:_DetailsModel.userPhone];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 3){
                str = [LPTools isNullToString:_DetailsModel.workDepartment];
            }else if (indexPath.row == 4){
                str = [LPTools isNullToString:_DetailsModel.bossName];
            }else if (indexPath.row == 5){
                str = [LPTools isNullToString:_DetailsModel.bossPhone];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 6){
                str = [LPTools isNullToString:_DetailsModel.userHostel];
            }else if (indexPath.row == 7){
                str = [LPTools isNullToString:_DetailsModel.userComeFrom];
            }else if (indexPath.row == 8){
                str = [LPTools isNullToString:_DetailsModel.comeFormTel];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 9){
                str = [LPTools isNullToString:_DetailsModel.workMoney];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 10){
                cell.contentTF.enabled  = NO;
                cell.contentTF.placeholder = @"";
                str =[LPTools isNullToString:_DetailsModel.workEndTime];
            }else if (indexPath.row == 11){
                cell.contentTF.enabled  = NO;
                cell.contentTF.placeholder = @"";
                if (_DetailsModel.workEndType.integerValue == 1) {
                    str = @"自离";
                }else if (_DetailsModel.workEndType.integerValue == 2) {
                    str = @"辞职";
                }
             }else if (indexPath.row == 12){
                 cell.content.hidden = NO;
                cell.contentTF.enabled  = NO;
                cell.contentTF.placeholder = @"";
//                str =[LPTools isNullToString:_DetailsModel.workEndDetails];
                 cell.content.text = [LPTools isNullToString:_DetailsModel.workEndDetails];
            }
            cell.contentTF.text = str;
            
        }else{
            
            if (indexPath.row == 10) {
                cell.name.text = _TitleArr2[indexPath.row];
            }
            else{
                cell.name.text = [NSString stringWithFormat:@"%@:", _TitleArr2[indexPath.row]];
            }
            
            cell.Row = indexPath.row;

            cell.contentTF.enabled = YES;
            cell.contentTF.placeholder = [NSString stringWithFormat:@"请输入%@",_TitleArr2[indexPath.row]];
            cell.contentTF.keyboardType = UIKeyboardTypeDefault;
            NSString *str = @"";
            
            if (indexPath.row == 0) {
                str = [LPTools isNullToString:_DetailsModel.workNum];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 1){
                str = [LPTools isNullToString:_DetailsModel.userAddress];
            }else if (indexPath.row == 2){
                str = [LPTools isNullToString:_DetailsModel.userPhone];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 3){
                str = [LPTools isNullToString:_DetailsModel.workDepartment];
            }else if (indexPath.row == 4){
                str = [LPTools isNullToString:_DetailsModel.bossName];
            }else if (indexPath.row == 5){
                str = [LPTools isNullToString:_DetailsModel.bossPhone];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 6){
                str = [LPTools isNullToString:_DetailsModel.userHostel];
            }else if (indexPath.row == 7){
                str = [LPTools isNullToString:_DetailsModel.userComeFrom];
            }else if (indexPath.row == 8){
                str = [LPTools isNullToString:_DetailsModel.comeFormTel];
                cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row == 9){
                str = [LPTools isNullToString:_DetailsModel.workMoney];
                cell.contentTF.keyboardType = UIKeyboardTypeDecimalPad;
            }else if (indexPath.row == 10){
                cell.contentTF.enabled  = NO;
                cell.contentTF.placeholder = @"";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.contentTF.text = str;
        }

    }
    
//    cell.model = self.model.data[indexPath.row];
        WEAK_SELF()
        cell.block = ^(NSString *string,NSInteger row) {
            if (row == 0) {
                weakSelf.DetailsModel.workNum = string;
            }else if (row == 1){
                weakSelf.DetailsModel.userAddress = string;
            }else if (row == 2){
                weakSelf.DetailsModel.userPhone = string;
            }else if (row == 3){
                weakSelf.DetailsModel.workDepartment = string;
            }else if (row == 4){
                weakSelf.DetailsModel.bossName = string;
            }else if (row == 5){
                weakSelf.DetailsModel.bossPhone = string;
            }else if (row == 6){
                weakSelf.DetailsModel.userHostel = string;
            }else if (row == 7){
                weakSelf.DetailsModel.userComeFrom = string;
            }else if (row == 8){
                weakSelf.DetailsModel.comeFormTel = string;
            }else if (row == 9){
                weakSelf.DetailsModel.workMoney = string;
            }
        };
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 10) {
        if (![[LPTools isNullToString:_DetailsModel.workEndTime] isEqualToString:@""] &&
            ![[LPTools isNullToString:_DetailsModel.workEndDetails] isEqualToString:@""]){
            return;
        }
        LPFIRMlizhiViewController *vc = [[LPFIRMlizhiViewController alloc] init];
        vc.DetailsModel =self.DetailsModel;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPTLendAuditCellID bundle:nil] forCellReuseIdentifier:LPTLendAuditCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            [self requestQueryUserRegistration];
        }];
        //        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //            [self requestGetOnWork];
        //        }];
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableview;
}
-(void)setDetailsModel:(LPFirmDetailsModel *)DetailsModel
{
    _DetailsModel =DetailsModel;
}

- (IBAction)TouchUpdate:(id)sender {
    [self requestQueryUpdateUserRegistration];
}


#pragma mark - request
-(void)requestQueryUserRegistration{
    NSDictionary *dic = @{@"experienceId":self.model.id};
    
    WEAK_SELF()
    [NetApiManager requestQueryUserRegistration:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            weakSelf.DetailsModel = [LPFirmDetailsModel mj_objectWithKeyValues:responseObject[@"data"]];
            weakSelf.DetailsModel.experienceId = self.model.id;
            weakSelf.DetailsModel.userId = self.model.userId;
            weakSelf.DetailsModel.teacherId = kUserDefaultsValue(LOGINID);

            [weakSelf.tableview reloadData];

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryUpdateUserRegistration{
    NSDictionary *dic = [self.DetailsModel mj_keyValues];

    WEAK_SELF()
    [NetApiManager requestQueryUpdateUserRegistration:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [self.view showLoadingMeg:@"操作成功" time:MESSAGE_SHOW_TIME];
                if (self.Block) {
                    self.Block();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
