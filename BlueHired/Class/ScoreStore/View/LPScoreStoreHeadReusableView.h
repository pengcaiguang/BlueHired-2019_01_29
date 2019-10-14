//
//  LPScoreStoreHeadReusableView.h
//  BlueHired
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPProductListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPScoreStoreHeadReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imageBgView;
@property (weak, nonatomic) IBOutlet UIButton *billBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (nonatomic,strong) LPProductListModel *model;


@end

NS_ASSUME_NONNULL_END
