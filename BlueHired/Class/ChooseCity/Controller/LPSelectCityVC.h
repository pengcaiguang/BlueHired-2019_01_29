//
//  LPSelectCityVC.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCityModel.h"

@protocol LPSelectCityVCDelegate<NSObject>

-(void)selectCity:(LPCityModel *)model;

@end

@interface LPSelectCityVC : UIViewController

@property (nonatomic,assign)id <LPSelectCityVCDelegate>delegate;

@end
