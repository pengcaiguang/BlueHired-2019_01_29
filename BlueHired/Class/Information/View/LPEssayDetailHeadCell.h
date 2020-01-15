//
//  LPEssayDetailHeadCell.h
//  BlueHired
//
//  Created by peng on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "LPEssayDetailModel.h"
typedef void(^LPAddRecordCellDicBlock)(CGFloat height);

@interface LPEssayDetailHeadCell : UITableViewCell
 
@property (weak, nonatomic) IBOutlet UIView *webBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_height;

@property (nonatomic,copy) LPAddRecordCellDicBlock Block;

@property(nonatomic,strong) LPEssayDetailModel *model;
@end
