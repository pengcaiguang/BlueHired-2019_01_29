//
//  LPCircleCollectionViewCell.h
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPCircleCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign) NSInteger index;
-(void)touchMoodTypeSenderBack:(NSInteger )tap;
-(void)touchMoodTypeDeleteBack;

@property(nonatomic,assign) NSInteger CircleMessage;

@end
