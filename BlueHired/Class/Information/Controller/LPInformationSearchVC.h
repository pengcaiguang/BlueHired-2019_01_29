//
//  LPInformationSearchVC.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPInformationSearchVC : LPBaseViewController

// 1 = 资讯。2= 视频。 3=圈子 4=企业点评
@property (nonatomic,assign) NSInteger Type;

@property (nonatomic,strong) UICollectionView *videocollectionView;


@end
