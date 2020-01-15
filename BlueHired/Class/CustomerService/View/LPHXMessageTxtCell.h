//
//  LPHXMessageTxtCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDIMessageModel.h"
#import "LPCustomMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPHXMessageTxtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftUserImage;
@property (weak, nonatomic) IBOutlet UILabel *leftUserName;
@property (weak, nonatomic) IBOutlet UIView *leftTxtView;
@property (weak, nonatomic) IBOutlet UILabel *leftTxtLabel;

@property (weak, nonatomic) IBOutlet UIImageView *RightUserImage;
@property (weak, nonatomic) IBOutlet UILabel *RightUserName;
@property (weak, nonatomic) IBOutlet UIView *RightTxtView;
@property (weak, nonatomic) IBOutlet UILabel *RightTxtLabel;

@property (nonatomic, assign) id<HDIMessageModel> model;
@property (nonatomic, strong) LPCustomMessageModel *CustonModel;


@end

NS_ASSUME_NONNULL_END
