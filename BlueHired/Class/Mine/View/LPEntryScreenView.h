//
//  LPEntryScreenView.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPEntryVC.h"

NS_ASSUME_NONNULL_BEGIN
@protocol LPLandScreenAlertViewDelegate<NSObject>

-(void)touchTableView:(NSInteger) Row;
@end
@interface LPEntryScreenView : UIView
@property(nonatomic,strong) UIButton *touchButton;

//@property(nonatomic,strong) LPMechanismlistModel *mechanismlistModel;


@property (nonatomic,assign)id <LPLandScreenAlertViewDelegate>delegate;

@property(nonatomic,strong) NSString *typeId;
@property(nonatomic,strong) NSString *workType;
@property(nonatomic,strong) LPEntryVC *SuperView;

@end

NS_ASSUME_NONNULL_END
