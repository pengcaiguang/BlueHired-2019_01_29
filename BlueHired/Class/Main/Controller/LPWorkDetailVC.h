//
//  LPWorkDetailVC.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorklistModel.h"

typedef void(^LPWorkDetailVCBlock)(BOOL isApply);

@interface LPWorkDetailVC : UIViewController

@property(nonatomic,strong) LPWorklistDataWorkListModel *workListModel;

@property(nonatomic,copy) LPWorkDetailVCBlock block;
@end
