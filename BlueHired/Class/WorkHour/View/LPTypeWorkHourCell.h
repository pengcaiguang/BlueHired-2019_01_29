//
//  LPTypeWorkHourCell.h
//  BlueHired
//
//  Created by iMac on 2019/2/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPHoursWorkListModel.h"
#import "LPAccountPriceModel.h"
#import "LPMonthWageDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPTypeWorkHourCellBlock)(NSInteger index);
typedef void(^LPTypeWorkHourCellAllBlock)(void);
typedef void(^LPTypeWorkHourCellSelectBlock)(BOOL IsSelect);

@interface LPTypeWorkHourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BackBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_constrait_height;
@property (weak, nonatomic) IBOutlet UIView *SubBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Subview_constrait_height;

@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageLabel;
@property (weak, nonatomic) IBOutlet UIButton *ArrowsBt;
@property (weak, nonatomic) IBOutlet UIButton *AllArrowsBt;

@property (nonatomic,copy) LPTypeWorkHourCellBlock block;
@property (nonatomic,copy) LPTypeWorkHourCellAllBlock AllBlock;
@property (nonatomic,copy) LPTypeWorkHourCellSelectBlock Rowblock;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) NSInteger sectionType;

@property (nonatomic,strong) NSArray <LPHoursWorkListOverTimeModel *> *overtimeModel;
@property (nonatomic,strong) NSArray <LPHoursWorkListLeaveModel *> *leaveeModel;
@property (nonatomic,strong) NSArray <LPHoursWorkListShiftModel *> *shiftModel;

@property (nonatomic,strong) NSArray <LPAccountPriceDataModel *> *AccountPriceModel;

@property (nonatomic,strong) NSArray *basicsArray;      //基础项目
@property (nonatomic,strong) NSArray <LPMonthWageDetailsDataleaveListModel *> *WageLeaveModel;      //请假总计
@property (nonatomic,strong) NSString *WageSubSidy;      //补贴
@property (nonatomic,strong) NSString *WageDuduct;      //扣款
@property (nonatomic,strong) NSArray *WageOther;      //其他

@property (nonatomic, strong)LPMonthWageDetailsModel *SuperWageDetailsModel;

@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
