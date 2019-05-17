//
//  LPSalaryDetailVC.h
//  BlueHired
//
//  Created by peng on 2018/9/12.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPQuerySalarylistModel.h"

@interface LPSalaryDetailVC : LPBaseViewController

@property(nonatomic,strong) LPQuerySalarylistDataModel *model;
@property(nonatomic,strong) NSString *currentDateString;

@end
