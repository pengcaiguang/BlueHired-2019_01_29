//
//  LPSortAlertView.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LPSortAlertViewDelegate<NSObject>

-(void)touchTableView:(NSInteger)index;

@end

@interface LPSortAlertView : UIView

@property(nonatomic,strong) UIButton *touchButton;
@property(nonatomic,strong) NSArray *titleArray;

@property (nonatomic,assign)id <LPSortAlertViewDelegate>delegate;


@end
