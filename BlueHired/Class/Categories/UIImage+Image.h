//
//  UIImage+Image.h
//  RedPacket
//
//  Created by 邢晓亮 on 2018/6/6.
//  Copyright © 2018年 邢晓亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
+ (UIImage*)imageWithColor:(UIColor*)color;
+(UIImage *)imageNamed:(NSString *)name WithRenderingMode:(UIImageRenderingMode)model;
+ (CGSize)getImageSizeWithURL:(id)URL;
@end
