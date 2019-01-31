//
//  LPInformationView.h
//  BlueHired
//
//  Created by iMac on 2018/12/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabelListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPInformationView : UIView 
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *> *dataSource;

@property(nonatomic,strong) LPLabelListDataModel *labelListDataModel;

@end

NS_ASSUME_NONNULL_END
