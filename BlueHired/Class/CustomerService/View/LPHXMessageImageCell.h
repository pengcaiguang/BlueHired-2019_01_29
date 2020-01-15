//
//  LPHXMessageImageCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDIMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPHXMessageImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftUserImage;
@property (weak, nonatomic) IBOutlet UILabel *leftUserName;
@property (weak, nonatomic) IBOutlet UIImageView *leftMessageImage;

@property (weak, nonatomic) IBOutlet UIImageView *RightUserImage;
@property (weak, nonatomic) IBOutlet UILabel *RightUserName;
@property (weak, nonatomic) IBOutlet UIImageView *RightMessageImage;

@property (nonatomic, assign) id<HDIMessageModel> model;

 

@end

NS_ASSUME_NONNULL_END
