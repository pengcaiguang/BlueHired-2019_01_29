//
//  DSBeiAnimationLoading.h
//  DDemo
//
//  Created by deng shu on 2017/5/11.
//  Copyright © 2017年 deng shu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSBeiAnimationLoading : UIView

-(void)start;
-(void)stop;

+(void)showInView:(UIView*)view;

+(void)hideInView:(UIView*)view;

@end
