//
//  LPScoreStoreCell.h
//  BlueHired
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPProductListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LPScoreStoreCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityName;
@property (weak, nonatomic) IBOutlet UILabel *commodityUnit;

@property (nonatomic,strong) LPProductListDataModel *model;

@end

NS_ASSUME_NONNULL_END
