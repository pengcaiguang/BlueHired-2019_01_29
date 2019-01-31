//
//  LPAffiliationCollectionViewCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPAffiliationCollectionViewCell : UICollectionViewCell
  @property (nonatomic,copy) NSString *workStatus;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *reType;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger page;

-(void)tableViewreloadData;

@end

NS_ASSUME_NONNULL_END
