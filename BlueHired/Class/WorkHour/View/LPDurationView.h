//
//  LPDurationView.h
//  BlueHired
//
//  Created by peng on 2018/9/10.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LPDurationViewBlock)(NSInteger index);


@interface LPDurationView : UIView
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *selectView;

@property(nonatomic,assign) NSInteger type; //

@property(nonatomic,strong) NSString *titleString;

@property(nonatomic,strong) NSArray *typeArray;
@property(nonatomic,strong) NSArray *timeArray;

@property (nonatomic,copy) LPDurationViewBlock block;
@end
