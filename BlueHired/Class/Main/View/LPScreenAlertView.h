//
//  LPScreenAlertView.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMechanismlistModel.h"

@protocol LPScreenAlertViewDelegate<NSObject>

-(void)selectMechanismTypeId:(NSString *)typeId workType:(NSString *)workType;

@end

@interface LPScreenAlertView : UIView

@property(nonatomic,strong) UIButton *touchButton;

@property(nonatomic,strong) LPMechanismlistModel *mechanismlistModel;


@property (nonatomic,assign)id <LPScreenAlertViewDelegate>delegate;

@end
