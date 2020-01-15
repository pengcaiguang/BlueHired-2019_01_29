//
//  LPMessageToServiceCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCustomMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPMessageToServiceBlock)(void);
typedef void(^LPMessageToServiceCommentBlock)(void);

@interface LPMessageToServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftUserImage;
@property (weak, nonatomic) IBOutlet UILabel *leftUserName;
@property (weak, nonatomic) IBOutlet UIView *leftTxtView;
@property (weak, nonatomic) IBOutlet UILabel *leftTxtLabel;

@property (weak, nonatomic) IBOutlet UIButton *ToPhone;
@property (weak, nonatomic) IBOutlet UIButton *ToIm;
@property (weak, nonatomic) IBOutlet UIButton *ToComment;

@property (nonatomic, strong) LPCustomMessageModel *model;
@property (nonatomic, strong) LPMessageToServiceBlock block;
@property (nonatomic, strong) LPMessageToServiceCommentBlock CommentBlock;

@end

NS_ASSUME_NONNULL_END
