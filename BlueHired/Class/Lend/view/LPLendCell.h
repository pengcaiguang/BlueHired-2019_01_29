//
//  LPLendCell.h
//  BlueHired
//
//  Created by iMac on 2018/11/13.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPQueryCheckrecordModel.h"
typedef void(^LPAddRecordCellDicBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LPLendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UILabel *text3;

@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UILabel *time3;

@property (weak, nonatomic) IBOutlet UILabel *Title3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_TimeR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Timew;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;

@property(nonatomic,strong) LPQueryCheckrecordModel *model;

@end

NS_ASSUME_NONNULL_END
