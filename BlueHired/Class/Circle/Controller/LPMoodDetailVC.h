//
//  LPMoodDetailVC.h
//  BlueHired
//
//  Created by peng on 2018/9/18.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMoodListModel.h"

@interface LPMoodDetailVC : LPBaseViewController

@property(nonatomic,strong) LPMoodListDataModel *moodListDataModel;
@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;
@property(nonatomic,strong) UITableView *SuperTableView;

@property(nonatomic,strong) NSString *InfoId;
//@property(nonatomic,assign) NSInteger Type;

@end
