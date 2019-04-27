//
//  LPSelectCityVC.h
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCityModel.h"

@protocol LPSelectCityVCDelegate<NSObject>

-(void)selectCity:(LPCityModel *)model;

@end

@interface LPSelectCityVC : LPBaseViewController

@property (nonatomic,assign)id <LPSelectCityVCDelegate>delegate;

@end
