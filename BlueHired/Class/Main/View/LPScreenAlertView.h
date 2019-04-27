//
//  LPScreenAlertView.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMechanismlistModel.h"
#import "LPMainVC.h"

@protocol LPScreenAlertViewDelegate<NSObject>

-(void)selectMechanismTypeId:(NSString *)typeId workType:(NSString *)workType;

@end

@interface LPScreenAlertView : UIView

@property(nonatomic,strong) UIButton *touchButton;

@property(nonatomic,strong) LPMechanismlistModel *mechanismlistModel;


@property (nonatomic,assign)id <LPScreenAlertViewDelegate>delegate;

@property(nonatomic,strong) NSString *typeId;
@property(nonatomic,strong) NSString *workType;
@property(nonatomic,strong) LPMainVC *SuperView;
@end
