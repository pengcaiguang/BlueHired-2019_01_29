//
//  LPInforCollectionViewCell.h
//  BlueHired
//
//  Created by peng on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPInforCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign) NSInteger type;

@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) UIButton *allButton;

-(void)deleteInfo;
@end

NS_ASSUME_NONNULL_END
