//
//  LPEssayDetailVC.h
//  BlueHired
//
//  Created by peng on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPEssaylistModel.h"

@interface LPEssayDetailVC : LPBaseViewController
@property(nonatomic,strong) LPEssaylistDataModel *essaylistDataModel;

@property (nonatomic, strong) UITableView *Supertableview;
 
@end
