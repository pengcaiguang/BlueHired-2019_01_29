//
//  LPStoreShareDetailsVC.h
//  BlueHired
//
//  Created by iMac on 2019/10/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPStoreShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPStoreShareDetailsVC : LPBaseViewController
@property (nonatomic,strong) LPStoreShareDataModel *model;
@property (nonatomic,strong) UITableView *SupreTableView;

@end

NS_ASSUME_NONNULL_END
