//
//  LPVideoVC.h
//  BlueHired
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPVideoListModel.h"
#import "LPInformationVC.h"
#import "LPInformationSearchResultVC.h"
#import "LPVideoTypeModel.h"
#import "LPInformationSearchVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^VideoCollectionBlock)(void);

@interface LPVideoVC : LPBaseViewController
@property(nonatomic,strong) NSMutableArray <LPVideoListDataModel *>*listArray;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,assign) NSInteger VideoRow;
@property(nonatomic,assign) LPInformationVC *superVC;
@property(nonatomic,assign) LPInformationSearchVC *KeySuperVC;
@property(nonatomic,strong) NSString *key;
@property(nonatomic,assign) NSInteger Type;
@property(nonatomic,assign) BOOL isReloadData;
@property(nonatomic,strong) LPVideoTypeModel *TypeModel;

@property(nonatomic,strong) VideoCollectionBlock LPCollectionBlock;

@end

NS_ASSUME_NONNULL_END
