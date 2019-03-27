//
//  LPPieceListVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPPieceListVCBlock)(void);

@interface LPPieceListVC : LPBaseViewController
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic,strong) NSString *KQDateString;
@property (nonatomic, copy) LPPieceListVCBlock Block;

@end

NS_ASSUME_NONNULL_END
