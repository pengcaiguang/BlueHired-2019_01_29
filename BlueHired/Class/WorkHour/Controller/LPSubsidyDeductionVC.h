//
//  LPSubsidyDeductionVC.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LPSubsidyDeductionVCBlock)(NSArray *array);

@interface LPSubsidyDeductionVC : UIViewController

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSArray *selectArray;

@property (nonatomic,copy) LPSubsidyDeductionVCBlock block;
@end
