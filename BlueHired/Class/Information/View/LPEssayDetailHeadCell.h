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
@property (weak, nonatomic) IBOutlet UILabel *essayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *essayAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *webBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBgView_constraint_height;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseTotalLabel;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;

@property(nonatomic,strong) LPEssayDetailModel *model;
@end
