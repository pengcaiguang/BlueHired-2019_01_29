//
//  LPReportVC.h
//  BlueHired
//
//  Created by iMac on 2018/11/8.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMoodListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPReportVC : LPBaseViewController

@property(nonatomic,strong) LPMoodListDataModel *MoodModel;
@property(nonatomic,assign) NSInteger isSenderBack;

@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*SupermoodListArray;
@property(nonatomic,strong) UITableView *SuperTableView;

@end

NS_ASSUME_NONNULL_END
