//
//  LPWorkDetailVC.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorklistModel.h"

typedef void (^LPWorkCollectionBlock)(void);

@interface LPWorkDetailVC : LPBaseViewController

@property(nonatomic,strong) LPWorklistDataWorkListModel *workListModel;
@property(nonatomic,strong) LPWorkCollectionBlock CollectionBlock;
@property(nonatomic,assign) BOOL isWorkOrder;

@end
