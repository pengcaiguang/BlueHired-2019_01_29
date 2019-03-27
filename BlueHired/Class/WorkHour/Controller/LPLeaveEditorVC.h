//
//  LPLeaveEditorVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMonthWageDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPLeaveEditorVCBlock)(NSInteger Num);

@interface LPLeaveEditorVC : LPBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *Money1;
@property (weak, nonatomic) IBOutlet UITextField *Money2;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,strong) LPMonthWageDetailsDataleaveListModel *model;
@property (nonatomic,strong) UITableView *SuperTableView;
@property (nonatomic, copy) LPLeaveEditorVCBlock block;
@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
