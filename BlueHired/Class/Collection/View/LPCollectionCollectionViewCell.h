//
//  LPCollectionCollectionViewCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPCollectionCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign) NSInteger index;

@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;
-(void)deleteInfo;

@end

NS_ASSUME_NONNULL_END