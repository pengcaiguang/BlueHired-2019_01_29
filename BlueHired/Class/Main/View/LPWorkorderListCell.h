//
//  LPWorkorderListCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWorkorderListModel.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>

@protocol LPWorkorderListCellDelegate <NSObject>
- (void)buttonClick:(NSInteger)buttonIndex workId:(NSInteger)workId;
@end

@interface LPWorkorderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *mechanismNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UILabel *interviewTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *recruitAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherNameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherNameViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherTelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherTelViewHeight;

@property(nonatomic,strong) LPWorkorderListDataModel *model;

@property(nonatomic,strong)id<LPWorkorderListCellDelegate>delegate;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标

@end
