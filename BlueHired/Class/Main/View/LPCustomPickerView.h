//
//  LPCustomPickerView.h
//  BlueHired
//
//  Created by iMac on 2019/4/16.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPCustomPickerViewBlock)(NSInteger index);

@interface LPCustomPickerView : UIView
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *selectView;


@property(nonatomic,strong) NSString *titleString;

@property(nonatomic,strong) NSArray *typeArray;

@property(nonatomic,assign) CGFloat ViewHeight;

@property (nonatomic,copy) LPCustomPickerViewBlock block;

@end

NS_ASSUME_NONNULL_END
