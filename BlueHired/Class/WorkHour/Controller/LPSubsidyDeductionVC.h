//
//  LPSubsidyDeductionVC.h
//  BlueHired
//
//  Created by peng on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LPSubsidyDeductionVCBlock)(NSString *SelectType);

@interface LPSubsidyDeductionVC : LPBaseViewController

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSArray *selectArray;

@property(nonatomic,strong) NSArray *TypeArray;

@property(nonatomic,strong) NSString *TypeName;


@property (nonatomic,copy) LPSubsidyDeductionVCBlock block;
@end
