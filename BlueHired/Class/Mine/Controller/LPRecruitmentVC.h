//
//  LPRecruitmentVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWork_ListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRecruitmentVC : LPBaseViewController

@property (nonatomic,assign) BOOL isBack;

@property (nonatomic,strong) LPWork_ListDataModel *dataList;

@property (nonatomic,assign) NSInteger ModelID;

@end

NS_ASSUME_NONNULL_END
