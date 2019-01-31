//
//  LPBillRecordCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPBillrecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPBillRecordCell : UITableViewCell

+ (instancetype)loadCell;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic,strong) LPBillrecordDataModel *model;

@end

NS_ASSUME_NONNULL_END
