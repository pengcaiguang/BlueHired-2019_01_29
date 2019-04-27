//
//  LPInformationMoreCell.h
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPEssaylistModel.h"

@interface LPInformationMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *essayNameLabel;

@property (weak, nonatomic) IBOutlet UIView *imgeBgView;

@property (weak, nonatomic) IBOutlet UIImageView *essayUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *essayAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseTotalLabel;


@property(nonatomic,strong) LPEssaylistDataModel *model;

@end
