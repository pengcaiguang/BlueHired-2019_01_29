//
//  LPWorkHourScrollView.m
//  BlueHired
//
//  Created by iMac on 2019/2/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourScrollView.h"
#import "LPWorkHourTypeRedactVC.h"

#import "LPWorkHourDetailPieChartCell.h"
#import "LPTypeWorkHourCell.h"
#import "LPAccountPriceCell.h"

#import "LPHoursWorkListModel.h"
#import "LPAccountPriceModel.h"

#import "LPLeaveDetailsVC.h"
#import "LPMonthWageDetailsModel.h"
#import "LPAddSubsidiesVC.h"
#import "LPLeaveListVC.h"
#import "LPLeaveEditorVC.h"
#import "LPOtherEditorVC.h"
#import "LPByThePieceCell.h"


static NSString *LPWorkHourDetailPieChartCellID = @"LPWorkHourDetailPieChartCell";
static NSString *LPTypeWorkHourCellID = @"LPTypeWorkHourCell";
static NSString *LPAccountPriceCellID = @"LPAccountPriceCell";
static NSString *LPByThePieceCellID = @"LPByThePieceCell";

@interface LPWorkHourScrollView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)LPHoursWorkListModel *HoursWorkListModel;
@property (nonatomic, strong)LPAccountPriceModel *AccountPriceModel;
@property (nonatomic, strong)LPMonthWageDetailsModel *WageDetailsModel;

@end

@implementation LPWorkHourScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        [self addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(0);
        }];
        self.tableview.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setPage:(NSInteger)page{
    _page = page;
    if (self.page == 0) {
        [self requestQueryGetMonthWageDetail];
    }else if (page == 1) {
//        if (self.HoursWorkListModel == nil) {
            [self requestQueryGetHoursWorkList];
//        }
    }else if (page == 2){
//        if (self.AccountPriceModel == nil) {
            [self requestQueryGetAccountPrice];
//        }
    }
}

- (void)setKQDateString:(NSString *)KQDateString{
    _KQDateString = KQDateString;
//    if (self.page == 0) {
//        [self requestQueryGetMonthWageDetail];
//    }else if (self.page == 1) {
//        [self requestQueryGetHoursWorkList];
//    }else if (self.page == 2){
//        [self requestQueryGetAccountPrice];
//    }
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.page == 0) {
        if (self.WorkHourType == 3 || self.WorkHourType == 4) {
            return 5;
        }
        return 6;
    }else if (self.page == 1){
        if (self.WorkHourType == 3) {
            return 2;
        }else if (self.WorkHourType == 4){
            return 1;
        }
        return 3;
    }else{
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
    //    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//手动计算高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (self.page == 0) {            //工资详情
       if (self.WorkHourType == 3) {            //小时工
           if (indexPath.section == 0) {
               return 227.0+6;
           }else if (indexPath.section == 1){
               if (self.WageDetailsModel.data.IsShow1) {
                   return 48+48*1+6;
               }else{
                   return 48+6;
               }
           }else if (indexPath.section == 2){
               if (self.WageDetailsModel.data.IsShow2) {
                   NSArray *arr =@[];
                   if (self.WageDetailsModel.data.monthWage.subsidy.length>0) {
                       arr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
                   }
                   return 48+48*arr.count+48+6;
               }else{
                   return 48+6;
               }
           }else if (indexPath.section == 3){
               if (self.WageDetailsModel.data.IsShow3) {
                   NSArray *arr =@[];
                   if (self.WageDetailsModel.data.monthWage.deductContent.length>0) {
                       arr =  [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
                   }
                   return 48+48*arr.count+48+6;
               }else{
                   return 48+6;
               }
           }else if (indexPath.section == 4){
               if (self.WageDetailsModel.data.IsShow4) {
//                   NSArray *arr =@[];
//                   if (self.WageDetailsModel.data.monthWage.otherContent.length>0) {
//                       arr =  [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                   }
                   return 48+48*3+6;
               }else{
                   return 48+6;
               }
           }
       }else if (self.WorkHourType == 4){           //计件
           if (indexPath.section == 0) {
               return 227.0+6;
           }else if (indexPath.section == 1){
               if (self.WageDetailsModel.data.IsShow1) {
                   return 48+48*2+6;
               }else{
                   return 48+6;
               }
           }else if (indexPath.section == 2){
               if (self.WageDetailsModel.data.IsShow2) {
                   NSArray *arr =@[];
                   if (self.WageDetailsModel.data.monthWage.subsidy.length>0) {
                       arr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
                   }
                   return 48+48*arr.count+48+6;
               }else{
                   return 48+6;
               }
           }else if (indexPath.section == 3){
               if (self.WageDetailsModel.data.IsShow3) {
                   NSArray *arr =@[];
                   if (self.WageDetailsModel.data.monthWage.deductContent.length>0) {
                       arr =  [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
                   }
                   return 48+48*arr.count+48+6;
               }else{
                   return 48+6;
               }
           }else if (indexPath.section == 4){
               if (self.WageDetailsModel.data.IsShow4) {
//                   NSArray *arr =@[];
//                   if (self.WageDetailsModel.data.monthWage.otherContent.length>0) {
//                       arr =  [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                   }
                   return 48+48*3+6;
               }else{
                   return 48+6;
               }
           }
       }
       
       if (indexPath.section == 0) {
           return 227.0+6;
       }else if (indexPath.section == 1){
           if (self.WageDetailsModel.data.IsShow1) {
               return 48+48*2+6;
           }else{
               return 48+6;
           }
           
       }else if (indexPath.section == 2){
           if (self.WageDetailsModel.data.IsShow2) {
               NSInteger Count = self.WageDetailsModel.data.leaveList.count>3?3:self.WageDetailsModel.data.leaveList.count;
               if (self.WageDetailsModel.data.leaveList.count<=3 && self.WageDetailsModel.data.leaveList.count>0) {
                   return 48+48*Count+6;
               }
               return 48+48*Count+48+6;
           }else{
               return 48+6;
           }
       }else if (indexPath.section == 3){
           if (self.WageDetailsModel.data.IsShow3) {
               NSArray *arr =@[];
               if (self.WageDetailsModel.data.monthWage.subsidy.length>0) {
                   arr = [self.WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
               }
               return 48+48*arr.count+48+6;
           }else{
               return 48+6;
           }

       }else if (indexPath.section == 4){
           if (self.WageDetailsModel.data.IsShow4) {
               NSArray *arr =@[];
               if (self.WageDetailsModel.data.monthWage.deductContent.length>0) {
                   arr =  [self.WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
               }
               return 48+48*arr.count+48+6;
           }else{
               return 48+6;
           }

       }else{
           if (self.WageDetailsModel.data.IsShow5) {
//               NSArray *arr =@[];
//               if (self.WageDetailsModel.data.monthWage.otherContent.length>0) {
//                   arr =  [self.WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//               }
               return 48+48*3+6;
           }else{
               return 48+6;
           }
       }
       return 73+48*self.AccountPriceModel.data.count;
   }else if (self.page == 1){
       if (self.WorkHourType == 3) {
            if (indexPath.section == 0){
               NSInteger Count = self.HoursWorkListModel.data.leaveList.count+1;
               return 48+48*Count+6;
           }else {
//               return 48+48*self.HoursWorkListModel.data.shiftList.count+6;
               return 48+48*6+6;
           }
       }else if (self.WorkHourType == 4){
           return 86+40*self.HoursWorkListModel.data.leaveList.count+6;
       }else if (self.WorkHourType == 2){
           if (indexPath.section == 0) {
               NSInteger Count = self.HoursWorkListModel.data.overtimeList.count+1;
               return 48+48*Count+6;
           }else if (indexPath.section == 1){
               NSInteger Count = self.HoursWorkListModel.data.leaveList.count>5?5:self.HoursWorkListModel.data.leaveList.count;
               return 48+48*Count+6;
           }else {
               //               return 48+48*self.HoursWorkListModel.data.shiftList.count+6;
               return 48+48*6+6;
           }
       } else{
           if (indexPath.section == 0) {
               return 48+48*self.HoursWorkListModel.data.overtimeList.count+6;
           }else if (indexPath.section == 1){
               NSInteger Count = self.HoursWorkListModel.data.leaveList.count>5?5:self.HoursWorkListModel.data.leaveList.count;
               return 48+48*Count+6;
           }else {
//               return 48+48*self.HoursWorkListModel.data.shiftList.count+6;
               return 48+48*6+6;
           }
       }
       
   }else{
       return 73+48*self.AccountPriceModel.data.count+6;
   }
 
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF()
    if (self.page == 0) {
        if (self.WorkHourType == 3) {
            if (indexPath.section == 0) {
                LPWorkHourDetailPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailPieChartCellID];
                cell.index = indexPath.row;
                NSLog(@"index = %ld",(long)indexPath.row);
                cell.WorkHourType = self.WorkHourType;
                cell.MoneyList = self.WageDetailsModel.data.MoneyList;
                cell.MoneyNum = self.WageDetailsModel.data.MoneyNum;
                return cell;
            }else if (indexPath.section == 1){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"基础项目";
                cell.typeImageLabel.image = [UIImage imageNamed:@"钱 (2)"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"+%.2f",[self.WageDetailsModel.data.MoneyList[0] floatValue]];
                cell.typeMoneyLabel.textColor = [UIColor baseColor];
                cell.WorkHourType = self.WorkHourType;
                cell.basicsArray = @[reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary)];
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                        LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                        vc.ClassType = 6;
                        vc.KQDateString = self.KQDateString;
                        vc.WageDetailsModel = self.WageDetailsModel;
                        vc.WorkHourType = self.WorkHourType;
                        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                        vc.block = ^(void){
                            [self setWageDetailsModel:self.WageDetailsModel];
                        };
                };
                return cell;
            }   else if (indexPath.section == 2){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"补贴总计";
                cell.typeImageLabel.image = [UIImage imageNamed:@"补贴"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"+%@",self.WageDetailsModel.data.MoneyList[1]];
                cell.typeMoneyLabel.textColor = [UIColor baseColor];
                
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.WageSubSidy = self.WageDetailsModel.data.monthWage.subsidy;
                
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.row = [NSString stringWithFormat:@"%ld",(long)row];
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.SuperTableView = self.tableview;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 0;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                cell.AllBlock = ^(void){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.SuperTableView = self.tableview;
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 0;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                return cell;
            }else if (indexPath.section == 3){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"扣款总计";
                cell.typeImageLabel.image = [UIImage imageNamed:@"扣款记录"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"-%@",self.WageDetailsModel.data.MoneyList[2]];
                cell.typeMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.WageDuduct = self.WageDetailsModel.data.monthWage.deductContent;
                
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.row = [NSString stringWithFormat:@"%ld",(long)row];
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.SuperTableView = self.tableview;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 1;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                cell.AllBlock = ^(void){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.SuperTableView = self.tableview;
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 1;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                return cell;
            }else if (indexPath.section == 4){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"其他总计";
                cell.typeImageLabel.image = [UIImage imageNamed:@"其他"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"-%@",self.WageDetailsModel.data.MoneyList[3]];
                cell.typeMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];
                
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.WageOther = @[reviseString( self.WageDetailsModel.data.monthWage.socialInsurance),
                                   reviseString(self.WageDetailsModel.data.monthWage.reserve),
                                   reviseString(self.WageDetailsModel.data.monthWage.ShowpersonalTax)];
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                    LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                    if (row == 1) {
                        vc.ClassType = 3;
                    }else if (row == 0){
                        vc.ClassType = 4;
                    }else if (row == 2){
                        vc.ClassType = 5;
                    }
                    
                    vc.WageDetailsModel = self.WageDetailsModel;
                    
                    vc.row = row;
                    vc.KQDateString = self.KQDateString;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                return cell;
            }
        }else if (self.WorkHourType == 4){
            //////////////////4//////////
            if (indexPath.section == 0) {
                LPWorkHourDetailPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailPieChartCellID];
                cell.index = indexPath.row;
                NSLog(@"index = %ld",(long)indexPath.row);
                cell.WorkHourType = self.WorkHourType;
                cell.MoneyList = self.WageDetailsModel.data.MoneyList;
                cell.MoneyNum = self.WageDetailsModel.data.MoneyNum;
                return cell;
            }else if (indexPath.section == 1){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"基础项目";
                cell.typeImageLabel.image = [UIImage imageNamed:@"钱 (2)"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"+%.2f",[self.WageDetailsModel.data.MoneyList[0] floatValue]+[self.WageDetailsModel.data.MoneyList[1] floatValue]];
                cell.typeMoneyLabel.textColor = [UIColor baseColor];
                cell.WorkHourType = self.WorkHourType;
                cell.basicsArray = @[reviseString(self.WageDetailsModel.data.monthWage.salary),
                                     reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary)];
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                    if (row == 0) {
                        LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                        vc.ClassType = 1;
                        vc.KQDateString = self.KQDateString;
                        vc.WageDetailsModel = self.WageDetailsModel;
                        vc.WorkHourType = self.WorkHourType;
                        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                        vc.block = ^(void){
                            [self setWageDetailsModel:self.WageDetailsModel];
                        };
                    }else if (row == 1){
                        LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                        vc.ClassType = 7;
                        vc.KQDateString = self.KQDateString;
                        vc.WageDetailsModel = self.WageDetailsModel;
                        vc.WorkHourType = self.WorkHourType;
                        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                        vc.block = ^(void){
                            [self setWageDetailsModel:self.WageDetailsModel];
                        };
                    }
                };
                return cell;
            }   else if (indexPath.section == 2){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"补贴总计";
                cell.typeImageLabel.image = [UIImage imageNamed:@"补贴"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"+%@",self.WageDetailsModel.data.MoneyList[2]];
                cell.typeMoneyLabel.textColor = [UIColor baseColor];
                
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.WageSubSidy = self.WageDetailsModel.data.monthWage.subsidy;
                
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.row = [NSString stringWithFormat:@"%ld",(long)row];
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.SuperTableView = self.tableview;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 0;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                cell.AllBlock = ^(void){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.SuperTableView = self.tableview;
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 0;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                return cell;
            }else if (indexPath.section == 3){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"扣款总计";
                cell.typeImageLabel.image = [UIImage imageNamed:@"扣款记录"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"-%@",self.WageDetailsModel.data.MoneyList[3]];
                cell.typeMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.WageDuduct = self.WageDetailsModel.data.monthWage.deductContent;
                
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.row = [NSString stringWithFormat:@"%ld",(long)row];
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.SuperTableView = self.tableview;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 1;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                cell.AllBlock = ^(void){
                    LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                    vc.SuperTableView = self.tableview;
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.KQDateString = self.KQDateString;
                    vc.ClassType = 1;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                return cell;
            }else if (indexPath.section == 4){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"其他总计";
                cell.typeImageLabel.image = [UIImage imageNamed:@"其他"];
                cell.typeMoneyLabel.text = [NSString stringWithFormat:@"-%@",self.WageDetailsModel.data.MoneyList[4]];
                cell.typeMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];
                
                cell.SuperWageDetailsModel = self.WageDetailsModel;
                cell.section = indexPath.section;
                cell.sectionType = self.page;
                cell.WageOther = @[reviseString( self.WageDetailsModel.data.monthWage.socialInsurance),
                                   reviseString(self.WageDetailsModel.data.monthWage.reserve),
                                   reviseString(self.WageDetailsModel.data.monthWage.ShowpersonalTax)];
                cell.Rowblock = ^(BOOL IsSelect){
                    [weakSelf.tableview reloadData];
                };
                cell.block = ^(NSInteger row){
                    LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                    if (row == 1) {
                        vc.ClassType = 3;
                    }else if (row == 0){
                        vc.ClassType = 4;
                    }else if (row == 2){
                        vc.ClassType = 5;
                    }
                    
                    vc.WageDetailsModel = self.WageDetailsModel;
                    
                    vc.row = row;
                    vc.KQDateString = self.KQDateString;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                };
                return cell;
            }
        }
        
        
        if (indexPath.section == 0) {
            LPWorkHourDetailPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailPieChartCellID];
            cell.index = indexPath.row;
            NSLog(@"index = %ld",(long)indexPath.row);
            cell.WorkHourType = self.WorkHourType;
            cell.MoneyList = self.WageDetailsModel.data.MoneyList;
            cell.MoneyNum = self.WageDetailsModel.data.MoneyNum;
            return cell;
        }else if (indexPath.section == 1){
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"基础项目";
            cell.typeImageLabel.image = [UIImage imageNamed:@"钱 (2)"];
            cell.typeMoneyLabel.text = [NSString stringWithFormat:@"+%.2f",[self.WageDetailsModel.data.MoneyList[0] floatValue]+[self.WageDetailsModel.data.MoneyList[1] floatValue]];
            cell.typeMoneyLabel.textColor = [UIColor baseColor];
            cell.basicsArray = @[reviseString(self.WageDetailsModel.data.monthWage.salary),reviseString(self.WageDetailsModel.data.monthWage.overtimeSalary)];
            cell.SuperWageDetailsModel = self.WageDetailsModel;
            cell.section = indexPath.section;
            cell.sectionType = self.page;
            cell.Rowblock = ^(BOOL IsSelect){
                [weakSelf.tableview reloadData];
            };
            cell.block = ^(NSInteger row){
                if (row == 0) {
                    LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                    vc.ClassType = 1;
                    vc.KQDateString = self.KQDateString;
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                }else if (row == 1){
                    LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                    vc.ClassType = 2;
                    vc.KQDateString = self.KQDateString;
                    vc.WageDetailsModel = self.WageDetailsModel;
                    vc.WorkHourType = self.WorkHourType;
                    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                    vc.block = ^(void){
                        [self setWageDetailsModel:self.WageDetailsModel];
                    };
                }
            };
            return cell;
        }else if (indexPath.section == 2){
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"请假总计";
            cell.typeImageLabel.image = [UIImage imageNamed:@"请假 (2)"];
            cell.typeMoneyLabel.text = [NSString stringWithFormat:@"-%@",self.WageDetailsModel.data.MoneyList[2]];
            cell.typeMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];

            cell.SuperWageDetailsModel = self.WageDetailsModel;
            cell.section = indexPath.section;
            cell.sectionType = self.page;
            cell.WageLeaveModel = self.WageDetailsModel.data.leaveList;
            
            cell.Rowblock = ^(BOOL IsSelect){
                [weakSelf.tableview reloadData];
            };
            cell.block = ^(NSInteger row){
                
                LPLeaveEditorVC *vc = [[LPLeaveEditorVC alloc] init];
//                NSLog(@"%@",self.WageDetailsModel.data.leaveList[indexPath.row].time);
                vc.model = self.WageDetailsModel.data.leaveList[row];
//                vc.SuperTableView = self.tableview;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//                WEAK_SELF()
                vc.block  = ^(NSInteger num){
                    if (num == 2) {
                        [self setWageDetailsModel:self.WageDetailsModel];
                    }else if (num == 1){
                        NSMutableArray *Array =[[NSMutableArray alloc] initWithArray:self.WageDetailsModel.data.leaveList];
                        [Array removeObjectAtIndex:row];
                        self.WageDetailsModel.data.leaveList = [Array copy];
                        [self setWageDetailsModel:self.WageDetailsModel];
                    }
                };
            };
            
            cell.AllBlock = ^(void){
                LPLeaveListVC *vc = [[LPLeaveListVC alloc] init];
                vc.WageDetailsModel = self.WageDetailsModel;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                vc.Toblock = ^(void){
                    [self setWageDetailsModel:self.WageDetailsModel];
                };
            };
            
            return cell;
        }else if (indexPath.section == 3){
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"补贴总计";
            cell.typeImageLabel.image = [UIImage imageNamed:@"补贴"];
            cell.typeMoneyLabel.text = [NSString stringWithFormat:@"+%@",self.WageDetailsModel.data.MoneyList[3]];
            cell.typeMoneyLabel.textColor = [UIColor baseColor];

            cell.SuperWageDetailsModel = self.WageDetailsModel;
            cell.section = indexPath.section;
            cell.sectionType = self.page;
            cell.WageSubSidy = self.WageDetailsModel.data.monthWage.subsidy;
            
            cell.Rowblock = ^(BOOL IsSelect){
                [weakSelf.tableview reloadData];
            };
            cell.block = ^(NSInteger row){
                LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                vc.row = [NSString stringWithFormat:@"%ld",(long)row];
                vc.WageDetailsModel = self.WageDetailsModel;
                vc.SuperTableView = self.tableview;
                vc.KQDateString = self.KQDateString;
                vc.ClassType = 0;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                vc.block = ^(void){
                    [self setWageDetailsModel:self.WageDetailsModel];
                };
            };
            cell.AllBlock = ^(void){
                LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                vc.SuperTableView = self.tableview;
                vc.WageDetailsModel = self.WageDetailsModel;
                vc.KQDateString = self.KQDateString;
                vc.ClassType = 0;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                vc.block = ^(void){
                    [self setWageDetailsModel:self.WageDetailsModel];
                };
            };
            return cell;
        }else if (indexPath.section == 4){
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"扣款总计";
            cell.typeImageLabel.image = [UIImage imageNamed:@"扣款记录"];
            cell.typeMoneyLabel.text = [NSString stringWithFormat:@"-%@",self.WageDetailsModel.data.MoneyList[4]];
            cell.typeMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];
            cell.SuperWageDetailsModel = self.WageDetailsModel;
            cell.section = indexPath.section;
            cell.sectionType = self.page;
            cell.WageDuduct = self.WageDetailsModel.data.monthWage.deductContent;
            
            cell.Rowblock = ^(BOOL IsSelect){
                [weakSelf.tableview reloadData];
            };
            cell.block = ^(NSInteger row){
                LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                vc.row = [NSString stringWithFormat:@"%ld",(long)row];
                vc.WageDetailsModel = self.WageDetailsModel;
                vc.SuperTableView = self.tableview;
                vc.KQDateString = self.KQDateString;
                vc.ClassType = 1;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                vc.block = ^(void){
                    [self setWageDetailsModel:self.WageDetailsModel];
                };
            };
            cell.AllBlock = ^(void){
                LPAddSubsidiesVC *vc = [[LPAddSubsidiesVC alloc] init];
                vc.SuperTableView = self.tableview;
                vc.WageDetailsModel = self.WageDetailsModel;
                vc.KQDateString = self.KQDateString;
                vc.ClassType = 1;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                vc.block = ^(void){
                    [self setWageDetailsModel:self.WageDetailsModel];
                };
            };
            return cell;
        }else{
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"其他总计";
            cell.typeImageLabel.image = [UIImage imageNamed:@"其他"];
            cell.typeMoneyLabel.text = [NSString stringWithFormat:@"-%@",self.WageDetailsModel.data.MoneyList[5]];
            cell.typeMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];

            cell.SuperWageDetailsModel = self.WageDetailsModel;
            cell.section = indexPath.section;
            cell.sectionType = self.page;
 
            cell.WageOther = @[reviseString( self.WageDetailsModel.data.monthWage.socialInsurance),
                               reviseString(self.WageDetailsModel.data.monthWage.reserve),
                               reviseString(self.WageDetailsModel.data.monthWage.ShowpersonalTax)];
            cell.Rowblock = ^(BOOL IsSelect){
                [weakSelf.tableview reloadData];
            };
            cell.block = ^(NSInteger row){
                LPOtherEditorVC *vc = [[LPOtherEditorVC alloc] init];
                if (row == 1) {
                    vc.ClassType = 3;
                }else if (row == 0){
                    vc.ClassType = 4;
                }else if (row == 2){
                    vc.ClassType = 5;
                }
                vc.WageDetailsModel = self.WageDetailsModel;

                vc.row = row;
                vc.KQDateString = self.KQDateString;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                vc.block = ^(void){
                    [self setWageDetailsModel:self.WageDetailsModel];
                };
            };
            return cell;
        }
    }else if (self.page ==1){
        if (self.WorkHourType == 3) {
            if (indexPath.section == 0){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"工作时间";
                cell.typeImageLabel.image = [UIImage imageNamed:@"WorkHourDate_Icon"];
                cell.typeMoneyLabel.text = @"查看详情";
                cell.typeMoneyLabel.textColor = [UIColor blackColor];
                [cell.ArrowsBt setImage:[UIImage imageNamed:@"WorkHourBackImage_icon"] forState:UIControlStateNormal];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                cell.WorkHourType = self.WorkHourType;
                cell.leaveeModel = self.HoursWorkListModel.data.leaveList;
                cell.sectionType = self.page;
                //            cell.Rowblock = ^(BOOL IsSelect){
                //                [weakSelf.tableview reloadData];
                //            };
                return cell;
            }else{
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"各个班次时间";
                cell.typeImageLabel.image = [UIImage imageNamed:@"classesDate_icon"];
                cell.typeMoneyLabel.text = @"";
                cell.typeMoneyLabel.textColor = [UIColor blackColor];
                [cell.ArrowsBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.WorkHourType = self.WorkHourType;

                cell.shiftModel = self.HoursWorkListModel.data.shiftList;
                cell.sectionType = self.page;
                //            cell.Rowblock = ^(BOOL IsSelect){
                //                [weakSelf.tableview reloadData];
                //            };
                return cell;
            }
        }else if (self.WorkHourType == 4){
            LPByThePieceCell *cell = [tableView dequeueReusableCellWithIdentifier:LPByThePieceCellID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.model = self.HoursWorkListModel.data.leaveList;
            return cell;
        }else if (self.WorkHourType == 2){
            if (indexPath.section == 0) {
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"工作时间";
                cell.typeImageLabel.image = [UIImage imageNamed:@"WorkHourDate_Icon"];
                cell.typeMoneyLabel.text = @"查看详情";
                cell.typeMoneyLabel.textColor = [UIColor blackColor];
                [cell.ArrowsBt setImage:[UIImage imageNamed:@"WorkHourBackImage_icon"] forState:UIControlStateNormal];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.WorkHourType = self.WorkHourType;
                
                cell.overtimeModel = self.HoursWorkListModel.data.overtimeList;
                cell.sectionType = self.page;
                return cell;
            }else if (indexPath.section == 1){
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"请假时间";
                cell.typeImageLabel.image = [UIImage imageNamed:@"leaveDate_icon"];
                cell.typeMoneyLabel.text = @"查看详情";
                cell.typeMoneyLabel.textColor = [UIColor blackColor];
                [cell.ArrowsBt setImage:[UIImage imageNamed:@"WorkHourBackImage_icon"] forState:UIControlStateNormal];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.WorkHourType = self.WorkHourType;
                
                cell.leaveeModel = self.HoursWorkListModel.data.leaveList;
                cell.sectionType = self.page;
                //            cell.Rowblock = ^(BOOL IsSelect){
                //                [weakSelf.tableview reloadData];
                //            };
                return cell;
            }else{
                LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
                cell.typeNameLabel.text = @"各个班次时间";
                cell.typeImageLabel.image = [UIImage imageNamed:@"classesDate_icon"];
                cell.typeMoneyLabel.text = @"";
                [cell.ArrowsBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.WorkHourType = self.WorkHourType;
                
                cell.shiftModel = self.HoursWorkListModel.data.shiftList;
                cell.sectionType = self.page;
                //            cell.Rowblock = ^(BOOL IsSelect){
                //                [weakSelf.tableview reloadData];
                //            };
                return cell;
            }
        }
        
        if (indexPath.section == 0) {
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"加班时间";
            cell.typeImageLabel.image = [UIImage imageNamed:@"WorkHourDate_Icon"];
            cell.typeMoneyLabel.text = @"查看详情";
            cell.typeMoneyLabel.textColor = [UIColor blackColor];
            [cell.ArrowsBt setImage:[UIImage imageNamed:@"WorkHourBackImage_icon"] forState:UIControlStateNormal];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.WorkHourType = self.WorkHourType;

            cell.overtimeModel = self.HoursWorkListModel.data.overtimeList;
            cell.sectionType = self.page;
//            cell.Rowblock = ^(BOOL IsSelect){
//                [weakSelf.tableview reloadData];
//            };
            return cell;
        }else if (indexPath.section == 1){
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"请假时间";
            cell.typeImageLabel.image = [UIImage imageNamed:@"leaveDate_icon"];
            cell.typeMoneyLabel.text = @"查看详情";
            cell.typeMoneyLabel.textColor = [UIColor blackColor];
            [cell.ArrowsBt setImage:[UIImage imageNamed:@"WorkHourBackImage_icon"] forState:UIControlStateNormal];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.WorkHourType = self.WorkHourType;

            cell.leaveeModel = self.HoursWorkListModel.data.leaveList;
            cell.sectionType = self.page;
//            cell.Rowblock = ^(BOOL IsSelect){
//                [weakSelf.tableview reloadData];
//            };
            return cell;
        }else{
            LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
            cell.typeNameLabel.text = @"各个班次时间";
            cell.typeImageLabel.image = [UIImage imageNamed:@"classesDate_icon"];
            cell.typeMoneyLabel.text = @"";
            [cell.ArrowsBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.WorkHourType = self.WorkHourType;

            cell.shiftModel = self.HoursWorkListModel.data.shiftList;
            cell.sectionType = self.page;
//            cell.Rowblock = ^(BOOL IsSelect){
//                [weakSelf.tableview reloadData];
//            };
            return cell;
        }
    }else{
        LPAccountPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:LPAccountPriceCellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.AccountPriceModel = self.AccountPriceModel.data;
        return cell;
    }
    
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.page == 1) {
        if (self.WorkHourType == 3) {
            if (indexPath.section == 0) {
                LPLeaveDetailsVC *vc = [[LPLeaveDetailsVC alloc] init];
                vc.KQDateString = self.KQDateString;
                vc.Type = 2;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
        }else if (self.WorkHourType == 4){
            return;
        } else{
            if (indexPath.section == 0) {
                LPLeaveDetailsVC *vc = [[LPLeaveDetailsVC alloc] init];
                vc.KQDateString = self.KQDateString;
                vc.Type = 1;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }else if (indexPath.section == 1){
                LPLeaveDetailsVC *vc = [[LPLeaveDetailsVC alloc] init];
                vc.KQDateString = self.KQDateString;
                vc.Type = 2;
                vc.WorkHourType = self.WorkHourType;
                [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            }
        }
        
    }else if (self.page == 2){
        LPLeaveDetailsVC *vc = [[LPLeaveDetailsVC alloc] init];
        vc.KQDateString = self.KQDateString;
        vc.Type = 3;
        vc.WorkHourType = self.WorkHourType;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.separatorColor = [UIColor whiteColor];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourDetailPieChartCellID bundle:nil] forCellReuseIdentifier:LPWorkHourDetailPieChartCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPTypeWorkHourCellID bundle:nil] forCellReuseIdentifier:LPTypeWorkHourCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPAccountPriceCellID bundle:nil] forCellReuseIdentifier:LPAccountPriceCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPByThePieceCellID bundle:nil] forCellReuseIdentifier:LPByThePieceCellID];


        //        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourCalendarCellID bundle:nil] forCellReuseIdentifier:LPWorkHourCalendarCellID];
        //        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourTallyBookCellID bundle:nil] forCellReuseIdentifier:LPWorkHourTallyBookCellID];
        _tableview.showsVerticalScrollIndicator = NO;
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        //        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
        //            [self requestUserMaterial];
        //            [self requestSelectCurIsSign];
        //        }];
    }
    return _tableview;
}


- (void)setHoursWorkListModel:(LPHoursWorkListModel *)HoursWorkListModel{
    _HoursWorkListModel = HoursWorkListModel;
    [self.tableview reloadData];
}

- (void)setAccountPriceModel:(LPAccountPriceModel *)AccountPriceModel{
    _AccountPriceModel = AccountPriceModel;
    [self.tableview reloadData];
}

-(void)setWageDetailsModel:(LPMonthWageDetailsModel *)WageDetailsModel{
    _WageDetailsModel = WageDetailsModel;
    if (WageDetailsModel.data) {
        
        if (self.WorkHourType == 3) {

            //补贴
            CGFloat NumSubSidy = 0.0;
            if (WageDetailsModel.data.monthWage.subsidy.length>0) {
                NSArray *SubSidyArr = [WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
                for (NSString *SidyStr in SubSidyArr) {
                    //        NSString *SidyName = [SidyStr componentsSeparatedByString:@"-"][0];
                    NSString *SidyMoney = [SidyStr componentsSeparatedByString:@"-"][1];
                    NumSubSidy +=SidyMoney.floatValue;
                }
            }
            
            //扣款项
            CGFloat Numdeduct = 0.0;
            if (WageDetailsModel.data.monthWage.deductContent.length > 0) {
                NSArray *deductArr = [WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
                for (NSString *deductStr in deductArr) {
                    //        NSString *deductName = [deductStr componentsSeparatedByString:@"-"][0];
                    NSString *deductMoney = [deductStr componentsSeparatedByString:@"-"][1];
                    Numdeduct +=deductMoney.floatValue;
                }
            }
            
            //其他
            CGFloat Numother = 0.0;
//            if (WageDetailsModel.data.monthWage.otherContent.length>0) {
//                NSArray *otherArr = [WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                for (NSString *otherStr in otherArr) {
//                    //        NSString *otherName = [otherStr componentsSeparatedByString:@"-"][0];
//                    NSString *otherMoney = [otherStr componentsSeparatedByString:@"-"][1];
//                    Numother +=otherMoney.floatValue;
//                }
//            }
            
            CGFloat Taxmoney = [self calculatepersonalTax:WageDetailsModel.data.monthWage.overtimeSalary.floatValue +
                                NumSubSidy -
                                Numdeduct -
                                WageDetailsModel.data.monthWage.reserve.floatValue -
                                WageDetailsModel.data.monthWage.socialInsurance.floatValue];
            WageDetailsModel.data.monthWage.autoPersonalTax = [NSString stringWithFormat:@"%.2f",Taxmoney];
            if (WageDetailsModel.data.monthWage.taxStatus.integerValue == 0) {           //计算个人所得税
                WageDetailsModel.data.monthWage.ShowpersonalTax  = [NSString stringWithFormat:@"%.2f",Taxmoney];
            }else{
                WageDetailsModel.data.monthWage.ShowpersonalTax  = WageDetailsModel.data.monthWage.personalTax;
            }
            
            Numother = WageDetailsModel.data.monthWage.reserve.floatValue
            +WageDetailsModel.data.monthWage.ShowpersonalTax.floatValue
            +WageDetailsModel.data.monthWage.socialInsurance.floatValue;
            
            
            WageDetailsModel.data.MoneyList = @[[NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.overtimeSalary.floatValue],
                                                [NSString stringWithFormat:@"%.2f",NumSubSidy],
                                                [NSString stringWithFormat:@"%.2f",Numdeduct],
                                                [NSString stringWithFormat:@"%.2f",Numother]];
            WageDetailsModel.data.MoneyNum = [NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.overtimeSalary.floatValue+NumSubSidy-Numdeduct-Numother];
        }else if (self.WorkHourType ==4 ){
  
            //补贴
            CGFloat NumSubSidy = 0.0;
            if (WageDetailsModel.data.monthWage.subsidy.length>0) {
                NSArray *SubSidyArr = [WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
                for (NSString *SidyStr in SubSidyArr) {
                    //        NSString *SidyName = [SidyStr componentsSeparatedByString:@"-"][0];
                    NSString *SidyMoney = [SidyStr componentsSeparatedByString:@"-"][1];
                    NumSubSidy +=SidyMoney.floatValue;
                }
            }
            
            //扣款项
            CGFloat Numdeduct = 0.0;
            if (WageDetailsModel.data.monthWage.deductContent.length > 0) {
                NSArray *deductArr = [WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
                for (NSString *deductStr in deductArr) {
                    //        NSString *deductName = [deductStr componentsSeparatedByString:@"-"][0];
                    NSString *deductMoney = [deductStr componentsSeparatedByString:@"-"][1];
                    Numdeduct +=deductMoney.floatValue;
                }
            }
            
            //其他
            CGFloat Numother = 0.0;
//            if (WageDetailsModel.data.monthWage.otherContent.length>0) {
//                NSArray *otherArr = [WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                for (NSString *otherStr in otherArr) {
//                    //        NSString *otherName = [otherStr componentsSeparatedByString:@"-"][0];
//                    NSString *otherMoney = [otherStr componentsSeparatedByString:@"-"][1];
//                    Numother +=otherMoney.floatValue;
//                }
//            }
            
            
            CGFloat Taxmoney = [self calculatepersonalTax:WageDetailsModel.data.monthWage.overtimeSalary.floatValue +
                                WageDetailsModel.data.monthWage.salary.floatValue +
                                NumSubSidy -
                                Numdeduct -
                                WageDetailsModel.data.monthWage.reserve.floatValue -
                                WageDetailsModel.data.monthWage.socialInsurance.floatValue];
            WageDetailsModel.data.monthWage.autoPersonalTax = [NSString stringWithFormat:@"%.2f",Taxmoney];
            
            if (WageDetailsModel.data.monthWage.taxStatus.integerValue == 0) {           //计算个人所得税
                WageDetailsModel.data.monthWage.ShowpersonalTax = [NSString stringWithFormat:@"%.2f",Taxmoney];
            }else{
                WageDetailsModel.data.monthWage.ShowpersonalTax = WageDetailsModel.data.monthWage.personalTax;
            }
            
            Numother = WageDetailsModel.data.monthWage.reserve.floatValue
            +WageDetailsModel.data.monthWage.ShowpersonalTax.floatValue
            +WageDetailsModel.data.monthWage.socialInsurance.floatValue;
            
            
            WageDetailsModel.data.MoneyList = @[[NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.salary.floatValue],
                                                [NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.overtimeSalary.floatValue],
                                                [NSString stringWithFormat:@"%.2f",NumSubSidy],
                                                [NSString stringWithFormat:@"%.2f",Numdeduct],
                                                [NSString stringWithFormat:@"%.2f",Numother]];
            WageDetailsModel.data.MoneyNum = [NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.salary.floatValue+WageDetailsModel.data.monthWage.overtimeSalary.floatValue+NumSubSidy-Numdeduct-Numother];
        } else{
            CGFloat Numsalary = 0.0;
            //请假
            for (LPMonthWageDetailsDataleaveListModel *Leave in WageDetailsModel.data.leaveList) {
                Numsalary += Leave.leaveMoneyTotal.floatValue;
            }
            
            //补贴
            CGFloat NumSubSidy = 0.0;
            if (WageDetailsModel.data.monthWage.subsidy.length>0) {
                NSArray *SubSidyArr = [WageDetailsModel.data.monthWage.subsidy componentsSeparatedByString:@","];
                for (NSString *SidyStr in SubSidyArr) {
                    //        NSString *SidyName = [SidyStr componentsSeparatedByString:@"-"][0];
                    NSString *SidyMoney = [SidyStr componentsSeparatedByString:@"-"][1];
                    NumSubSidy +=SidyMoney.floatValue;
                }
            }
            
            //扣款项
            CGFloat Numdeduct = 0.0;
            if (WageDetailsModel.data.monthWage.deductContent.length > 0) {
                NSArray *deductArr = [WageDetailsModel.data.monthWage.deductContent componentsSeparatedByString:@","];
                for (NSString *deductStr in deductArr) {
                    //        NSString *deductName = [deductStr componentsSeparatedByString:@"-"][0];
                    NSString *deductMoney = [deductStr componentsSeparatedByString:@"-"][1];
                    Numdeduct +=deductMoney.floatValue;
                }
            }
            
            //其他
            CGFloat Numother = 0.0;
//            if (WageDetailsModel.data.monthWage.otherContent.length>0) {
//                NSArray *otherArr = [WageDetailsModel.data.monthWage.otherContent componentsSeparatedByString:@","];
//                for (NSString *otherStr in otherArr) {
//                    //        NSString *otherName = [otherStr componentsSeparatedByString:@"-"][0];
//                    NSString *otherMoney = [otherStr componentsSeparatedByString:@"-"][1];
//                    Numother +=otherMoney.floatValue;
//                }
//            }
            
            CGFloat Taxmoney = [self calculatepersonalTax:WageDetailsModel.data.monthWage.overtimeSalary.floatValue +
                                WageDetailsModel.data.monthWage.salary.floatValue +
                                NumSubSidy -
                                Numsalary -
                                Numdeduct -
                                WageDetailsModel.data.monthWage.reserve.floatValue -
                                WageDetailsModel.data.monthWage.socialInsurance.floatValue];
            WageDetailsModel.data.monthWage.autoPersonalTax = [NSString stringWithFormat:@"%.2f",Taxmoney];
            if (WageDetailsModel.data.monthWage.taxStatus.integerValue == 0) {           //计算个人所得税
                WageDetailsModel.data.monthWage.ShowpersonalTax = [NSString stringWithFormat:@"%.2f",Taxmoney];
            }else{
                 WageDetailsModel.data.monthWage.ShowpersonalTax = WageDetailsModel.data.monthWage.personalTax;
            }
            
            Numother = WageDetailsModel.data.monthWage.reserve.floatValue
            +WageDetailsModel.data.monthWage.ShowpersonalTax.floatValue
            +WageDetailsModel.data.monthWage.socialInsurance.floatValue;
            
            
            WageDetailsModel.data.MoneyList = @[[NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.salary.floatValue],
                                                [NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.overtimeSalary.floatValue],
                                                [NSString stringWithFormat:@"%.2f",Numsalary],
                                                [NSString stringWithFormat:@"%.2f",NumSubSidy],
                                                [NSString stringWithFormat:@"%.2f",Numdeduct],
                                                [NSString stringWithFormat:@"%.2f",Numother]];
            WageDetailsModel.data.MoneyNum = [NSString stringWithFormat:@"%.2f",WageDetailsModel.data.monthWage.salary.floatValue+WageDetailsModel.data.monthWage.overtimeSalary.floatValue-Numsalary+NumSubSidy-Numdeduct-Numother];
        }
        
        
    }
   
    [self.tableview reloadData];

}

-(CGFloat)calculatepersonalTax:(CGFloat) money{
    if (money<=5000.0) {
        return 0.0;
    }
    money = money - 5000.0;
    if (money<=3000.0){
        return money * 0.03;
    }else if (money>3000.0 && money<=12000.0){
        return money * 0.10 -210;
    }else if (money>12000.0 && money<=25000.0){
        return money * 0.20 -1410;
    }else if (money>25000.0 && money<=35000.0){
        return money * 0.25 -2660;
    }else if (money>35000.0 && money<=55000.0){
        return money * 0.3 -4410;
    }else if (money>55000.0 && money<=80000.0){
        return money * 0.35 -7160;
    }else if (money>80000.0){
        return money * 0.45 -15160;
    }
    
    return 0.0;
}



#pragma mark - request
-(void)requestQueryGetHoursWorkList{
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"timeRange":[LPTools isNullToString:self.KQDateString]
                          };
    [NetApiManager requestQueryGetHoursWorkList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.HoursWorkListModel = [LPHoursWorkListModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryGetAccountPrice{
    NSDictionary *dic = @{ 
                          @"timeRange":[LPTools isNullToString:self.KQDateString]
                          };
    [NetApiManager requestQueryGetAccountPrice:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.AccountPriceModel = [LPAccountPriceModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetMonthWageDetail{
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"timeRange":[LPTools isNullToString:self.KQDateString]
                          };
    [NetApiManager requestQueryGetMonthWageDetail:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.WageDetailsModel = [LPMonthWageDetailsModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
