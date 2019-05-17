//
//  QFDatePickerView.h
//  dateDemo
//
//  Created by 情风 on 2017/1/12.
//  Copyright © 2017年 情风. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFDatePickerView : UIView


/**
 初始化方法，只带年月的日期选择
 CurrentDate 默认时间
 minDate 最小时间
 maxDate 最大时间
 @param block 返回选中的日期
 @return QFDatePickerView对象
 */
- (instancetype)initDatePackerWith:(NSDate *)CurrentDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate Response:(void(^)(NSString*))block;


/**
 初始化方法，只带年月的日期选择
 
 @param superView picker的载体View
 @param block 返回选中的日期
 @return QFDatePickerView对象
 */
- (instancetype)initDatePackerWithSUperView:(UIView *)superView response:(void(^)(NSString*))block;


/**
 初始化方法，只带年份的日期选择

 @param block 返回选中的年份
 @return QFDatePickerView对象
 */
- (instancetype)initYearPickerViewWithResponse:(void(^)(NSString*))block;

/**
 初始化方法，只带年份的日期选择
 
 @param block 返回选中的年份
 @return QFDatePickerView对象
 */
- (instancetype)initYearPickerWithView:(UIView *)superView response:(void(^)(NSString*))block;

/**
 显示方法
 */
- (void)show;

@end
