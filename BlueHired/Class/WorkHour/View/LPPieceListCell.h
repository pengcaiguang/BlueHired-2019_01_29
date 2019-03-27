//
//  LPPieceListCell.h
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPProRecirdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPPieceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Unit;
@property (weak, nonatomic) IBOutlet UILabel *Number;
@property (weak, nonatomic) IBOutlet UILabel *Money;
@property(nonatomic,assign)NSInteger row;

@property(nonatomic,strong)LPProRecirdDataModel *model;

@end

NS_ASSUME_NONNULL_END
