//
//  LPInformationSearchResultVC.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPInformationSearchResultVC : LPBaseViewController

@property(nonatomic,strong) NSString *string;
// 1= 资讯。2=视频
@property(nonatomic,assign) NSInteger Type;

@property (nonatomic,strong) UICollectionView *videocollectionView;

@end
