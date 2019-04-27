//
//  UIImage+Image.h
//  RedPacket
//
//  Created by peng on 2018/6/6.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
+ (UIImage*)imageWithColor:(UIColor*)color;
+(UIImage *)imageNamed:(NSString *)name WithRenderingMode:(UIImageRenderingMode)model;
+ (CGSize)getImageSizeWithURL:(id)URL;
@end
