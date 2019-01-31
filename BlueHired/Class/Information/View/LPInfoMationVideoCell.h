//
//  LPInfoMationVideoCell.h
//  BlueHired
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPVideoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPInfoMationVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *Videotittle;
@property (weak, nonatomic) IBOutlet UILabel *commentTotal;
@property (weak, nonatomic) IBOutlet UIView *TitleBackView;

@property (nonatomic,strong) LPVideoListDataModel *model;

@end

NS_ASSUME_NONNULL_END
