//
//  LPVideoPlayCell.h
//  BlueHired
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPVideoListModel.h"
#import "GKDYVideoPlayer.h"
#import "LPInformationVC.h"
#import "LPInformationSearchVC.h"
#import "LPVideoTypeModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPVideoPlayCellDicBlock)(void);
typedef void(^LPVideoCollectionBlock)(void);


@interface LPVideoPlayCell : UICollectionViewCell
@property(nonatomic,assign) LPInformationVC *superVC;
@property(nonatomic,assign) LPInformationSearchVC *KeySuperVC;
@property(nonatomic,assign) NSInteger Type;

@property (nonatomic,strong) LPVideoListDataModel *model;
@property (nonatomic,assign) BOOL  isPlay;
@property (nonatomic,assign) NSInteger Row;
@property (nonatomic,copy) LPVideoPlayCellDicBlock BlockMessage;

@property (nonatomic,strong) GKDYVideoPlayer *player;
@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UIImageView *PlayImage;
@property (nonatomic,strong) LPVideoTypeModel *TypeModel;
@property (nonatomic,strong) LPVideoCollectionBlock CollectionBlock;

-(void)ReloadComment:(LPVideoListDataModel *) model;

@end

NS_ASSUME_NONNULL_END
