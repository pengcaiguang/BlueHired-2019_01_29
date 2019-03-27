//
//  LPPieceEdirVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPProRecirdModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPPieceEdirVCBlock)(void);

@interface LPPieceEdirVC : LPBaseViewController
@property(nonatomic,strong)LPProRecirdDataModel *model;
@property(nonatomic,strong) NSMutableArray <LPProRecirdDataModel *>*listArray;
@property (nonatomic, copy) LPPieceEdirVCBlock Block;
@property (nonatomic, strong) NSString *currentDateString;

@end

NS_ASSUME_NONNULL_END
