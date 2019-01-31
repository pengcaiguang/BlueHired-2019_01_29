//
//  KJMarqueeLabel.h
//  BlueHired
//
//  Created by iMac on 2018/12/17.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, KJMarqueeLabelType) {
    KJMarqueeLabelTypeLeft = 0,//向左边滚动
    KJMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};

@interface KJMarqueeLabel : UILabel
@property(nonatomic,unsafe_unretained)KJMarqueeLabelType marqueeLabelType;
@property(nonatomic,unsafe_unretained)CGFloat speed;//速度
@property(nonatomic,unsafe_unretained)CGFloat secondLabelInterval;
@property(nonatomic,unsafe_unretained)NSTimeInterval stopTime;//滚到顶的停止时间
 
@end

NS_ASSUME_NONNULL_END
