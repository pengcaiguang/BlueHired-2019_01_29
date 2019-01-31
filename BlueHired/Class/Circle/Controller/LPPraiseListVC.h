//
//  LPPraiseListVC.h
//  BlueHired
//
//  Created by iMac on 2018/12/21.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMoodListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPPraiseListVC : LPBaseViewController
@property(nonatomic,strong) LPMoodListDataModel *Moodmodel;
@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*SupermoodListArray;
@property(nonatomic,strong) UITableView *SuperTableView;
@end

NS_ASSUME_NONNULL_END
