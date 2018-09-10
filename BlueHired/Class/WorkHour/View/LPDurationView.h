//
//  LPDurationView.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/10.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LPDurationViewBlock)(NSString *string);

@interface LPDurationView : UIView

@property (nonatomic,copy) LPDurationViewBlock block;
@end
