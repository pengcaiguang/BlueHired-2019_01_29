//
//  LPWorkHourHeadCell.h
//  BlueHired
//
//  Created by iMac on 2019/2/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMonthWageModel.h"
#import "LPOverTimeAccountModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPWorkHourTypeBlock)(NSInteger date);

@interface LPWorkHourHeadCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *HeadVIew;
@property (weak, nonatomic) IBOutlet UIImageView *BackImageView;
@property (weak, nonatomic) IBOutlet UIView *KQView;
@property (weak, nonatomic) IBOutlet UIButton *setMoneyBt;
@property (weak, nonatomic) IBOutlet UIButton *setDateBt;
@property (weak, nonatomic) IBOutlet UIView *WorkHourView;
@property (weak, nonatomic) IBOutlet UIView *FullTimeView;
@property (weak, nonatomic) IBOutlet UIView *PieceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Piece;
@property (weak, nonatomic) IBOutlet UIButton *DeleteBt;
@property (weak, nonatomic) IBOutlet UIButton *LeftButton;
@property(nonatomic,assign) BOOL isPush;

@property (weak, nonatomic) IBOutlet UIImageView *NoRecordView;
@property (weak, nonatomic) IBOutlet UILabel *BaseTitleyLabel;

@property (weak, nonatomic) IBOutlet UILabel *wageLabel;
@property (weak, nonatomic) IBOutlet UILabel *BaseSalaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *MoneysLabel;
@property (weak, nonatomic) IBOutlet UILabel *MoneysLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@property (weak, nonatomic) IBOutlet UILabel *overLabel1;
@property (weak, nonatomic) IBOutlet UILabel *overLabel2;
@property (weak, nonatomic) IBOutlet UILabel *overLabel3;
@property (weak, nonatomic) IBOutlet UILabel *overLabelTitle1;
@property (weak, nonatomic) IBOutlet UILabel *overLabelTitle2;
@property (weak, nonatomic) IBOutlet UILabel *overLabelTitle3;

@property (weak, nonatomic) IBOutlet UILabel *leaveLabel1;
@property (weak, nonatomic) IBOutlet UILabel *leaveLabel2;
@property (weak, nonatomic) IBOutlet UILabel *leaveLabel3;

@property (weak, nonatomic) IBOutlet UILabel *FullTimeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *FullTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *FullTimeLabel3;

@property (weak, nonatomic) IBOutlet UILabel *FullTimeTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeadVIew_Layout_bottom;

@property (nonatomic,assign) NSInteger Type;
@property (nonatomic,copy) LPWorkHourTypeBlock BlockDate;

@property (nonatomic, strong)LPMonthWageDataModel *Model;
@property (nonatomic, strong)NSArray <LPOverTimeAccountDataRecordListModel *> *RecordModelList;
@property (nonatomic, strong) NSString *monthWorkHours;

@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
