//
//  LPCollectionVideoCell.h
//  BlueHired
//
//  Created by iMac on 2018/12/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPVideoCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN
//typedef void(^LPCollectionVideoCellBlock)(LPRecreationVideoListModel *model);

@interface LPCollectionVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *Videotittle;
@property (weak, nonatomic) IBOutlet UILabel *commentTotal;
@property (weak, nonatomic) IBOutlet UIView *TitleBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_contraint_width;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property(nonatomic,strong) LPRecreationVideoListModel *model;
//@property (nonatomic,copy) LPCollectionVideoCellBlock selectBlock;

@property(nonatomic,assign) BOOL selectStatus;
@property(nonatomic,assign) BOOL selectAll;

@end

NS_ASSUME_NONNULL_END
