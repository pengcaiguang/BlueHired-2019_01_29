//
//  LPCollectionView.h
//  BlueHired
//
//  Created by iMac on 2019/11/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPCollectionView : UIView
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;
@property(nonatomic,strong) UIButton *AllButton;
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) LSPlayerView *PlayerView;

-(void)GetList;
-(void)deleteInfo;
 
@end

NS_ASSUME_NONNULL_END
