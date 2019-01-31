//
//  LPDateSelectView.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LPDateSelectViewBlock)(NSString *string);
typedef void(^LPDateSelectpageBlock)(NSString *string);

@interface LPDateSelectView : UIView

@property(nonatomic,strong) NSArray *selectArray;
@property (nonatomic,copy) LPDateSelectViewBlock block;
@property (nonatomic,copy) LPDateSelectpageBlock pageblock;

@end
