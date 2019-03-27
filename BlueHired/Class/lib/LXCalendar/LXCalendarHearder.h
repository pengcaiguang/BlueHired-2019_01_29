//
//  LXCalendarHearder.h
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^leftClickBlock) (void);

typedef void (^rightClickBlock) (void);

@interface LXCalendarHearder : UIView

@property(nonatomic,copy)leftClickBlock leftClickBlock;
@property(nonatomic,copy)rightClickBlock rightClickBlock;

+(LXCalendarHearder *)showView;

@property(nonatomic,assign)BOOL isShowLeftAndRightBtn; //是否显示左右两侧按钮

@property(nonatomic,strong)NSString *dateStr;

@property (weak, nonatomic) IBOutlet UILabel *BasicMoney;
@property (weak, nonatomic) IBOutlet UILabel *WorkMoney;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraintTop;

@end
