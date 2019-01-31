//
//  LPRecruitReqiuerCollectionViewCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWork_ListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddRecordCellDicBlockSuper)(NSString *textView,NSInteger row);

@interface LPRecruitReqiuerCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) LPAddRecordCellDicBlockSuper BlockSuper;

//@property(nonatomic,strong) LPWork_ListDataModel *model;

@property(nonatomic,strong) NSString *content;
@property(nonatomic,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
