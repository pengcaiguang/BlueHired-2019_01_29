//
//  LPEssayDetailVC.h
//  BlueHired
//
//  Created by peng on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPRecreationModel.h"

typedef void (^LPEssayCollectionBlock)(void);

@interface LPEssayDetailVC : LPBaseViewController
@property(nonatomic,strong) LPRecreationEssayListModel *essaylistDataModel;

@property (nonatomic, strong) UITableView *Supertableview;

@property (nonatomic, strong) LPEssayCollectionBlock CollectionBlock;
 
@end
