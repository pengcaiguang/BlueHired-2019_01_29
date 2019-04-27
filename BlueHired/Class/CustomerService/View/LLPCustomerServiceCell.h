//
//  LLPCustomerServiceCell.h
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCustomerServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLPCustomerServiceCellBlock)(void);
typedef void(^LLPCustomerServiceCellTouchTextBlock)(NSString *string);

@interface LLPCustomerServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *labelURLImgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet UIView *labelBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_constraint_height;

@property (nonatomic,copy) LLPCustomerServiceCellBlock block;
@property (nonatomic,copy) LLPCustomerServiceCellTouchTextBlock touchBlock;

@property(nonatomic,strong) LPCustomerServiceDataListModel *model;

@end

NS_ASSUME_NONNULL_END
