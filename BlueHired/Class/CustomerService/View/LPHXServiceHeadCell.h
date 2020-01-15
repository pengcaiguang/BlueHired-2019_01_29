//
//  LPHXServiceHeadCell.h
//  BlueHired
//
//  Created by iMac on 2019/10/31.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCustomerServiceModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPMessageToServiceBlock)(void);

@interface LPHXServiceHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *HeadView;

@property (nonatomic, strong) LPCustomerServiceModel *model;
@property (nonatomic, strong) LPMessageToServiceBlock block;

@end

NS_ASSUME_NONNULL_END
