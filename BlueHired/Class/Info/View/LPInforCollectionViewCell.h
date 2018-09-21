//
//  LPInforCollectionViewCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPInforCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign) NSInteger type;

@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;

-(void)deleteInfo;
@end

NS_ASSUME_NONNULL_END
