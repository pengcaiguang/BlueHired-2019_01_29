//
//  LPStoreBillDetailsCell.h
//  BlueHired
//
//  Created by iMac on 2019/10/9.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPStotrBillDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPStoreBillDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityName;
@property (weak, nonatomic) IBOutlet UILabel *commoditySize;
@property (weak, nonatomic) IBOutlet UILabel *commodityUnit;
@property (weak, nonatomic) IBOutlet UILabel *SumUnit;

@property (nonatomic,strong) LPOrderGenerateDataItemModel *model;

@end

NS_ASSUME_NONNULL_END
