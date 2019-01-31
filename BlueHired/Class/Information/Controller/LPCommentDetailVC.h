//
//  LPCommentDetailVC.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/3.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCommentListModel.h"

@interface LPCommentDetailVC : LPBaseViewController
@property(nonatomic,strong) LPCommentListDataModel *commentListDatamodel;
@property(nonatomic,strong) UITableView *superTabelView;
@end
