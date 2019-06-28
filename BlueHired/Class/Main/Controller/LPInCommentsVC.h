//
//  LPInCommentsVC.h
//  BlueHired
//
//  Created by iMac on 2019/6/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkorderListModel.h"


NS_ASSUME_NONNULL_BEGIN

//Type 1 = 添加评价。2 = 我的评价。3 = 删除评价
@interface LPInCommentsVC : LPBaseViewController
@property (nonatomic,assign) NSInteger Type;
@property (nonatomic,assign) NSInteger workOrderId;

@property(nonatomic,strong) LPWorkorderListDataModel *model;

@end

NS_ASSUME_NONNULL_END
