//
//  LPInformationSearchVC.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLPEmployeeModel.h"

@interface LPInformationSearchVC : LPBaseViewController

// 1 = 资讯。2= 视频。 3=圈子 4=企业点评 5=员工归属管理 6=在招企业列表
@property (nonatomic,assign) NSInteger Type;

@property (nonatomic,strong) UICollectionView *videocollectionView;
//6=在招企业列表model
@property(nonatomic,strong) LPLPEmployeeDataModel *Empmodel;

@property(nonatomic,strong) NSString *mechanismAddress;

@end
