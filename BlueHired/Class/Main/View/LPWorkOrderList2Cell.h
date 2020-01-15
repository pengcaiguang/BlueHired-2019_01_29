//
//  LPWorkOrderList2Cell.h
//  BlueHired
//
//  Created by iMac on 2019/5/9.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkorderListModel.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LPWorkorderList2CellDelegate <NSObject>
- (void)buttonClick:(NSInteger)buttonIndex workId:(LPWorkorderListDataModel *)workModel;
@end

@interface LPWorkOrderList2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *TopView;


@property (weak, nonatomic) IBOutlet UIImageView *mechanismUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wageRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isWorkers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ayoutConstraint_Lend_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ayoutConstraint_Lend_Right;

 
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *interviewTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recruitAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *ShareButton;
@property (weak, nonatomic) IBOutlet UIButton *CommentButton;
@property (weak, nonatomic) IBOutlet UIButton *NavBtn;

@property (weak, nonatomic) IBOutlet UILabel *restTime;
@property (weak, nonatomic) IBOutlet UILabel *restTimeTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstrain_BG_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstrain_RestTitle_Height;

@property(nonatomic,strong)id<LPWorkorderList2CellDelegate>delegate;

@property(nonatomic,strong) LPWorkorderListDataModel *model;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标

@end

NS_ASSUME_NONNULL_END
