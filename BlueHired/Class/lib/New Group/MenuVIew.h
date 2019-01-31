//
//  MenuVIew.h
//  mytest
//
//  Created by 易云时代 on 2017/7/18.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuVIew : UIView

@property (nonatomic, assign, getter = isShowing) BOOL show;
@property (nonatomic, assign) BOOL Praise;

@property (nonatomic, copy) void (^likeButtonClickedOperation)(void);
@property (nonatomic, copy) void (^commentButtonClickedOperation)(void);


@end
