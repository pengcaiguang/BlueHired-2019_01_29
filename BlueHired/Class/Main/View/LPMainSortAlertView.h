//
//  LPMainSortAlertView.h
//  BlueHired
//
//  Created by iMac on 2019/5/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LPMainSortAlertViewDelegate<NSObject>
-(void)touchTableView:(NSInteger)index;
@end

@interface LPMainSortAlertView : UIView
@property(nonatomic,strong) UIButton *touchButton;
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,assign) NSInteger selectTitle;

@property (nonatomic,assign)id <LPMainSortAlertViewDelegate>delegate;

- (void)close;

@end

NS_ASSUME_NONNULL_END
