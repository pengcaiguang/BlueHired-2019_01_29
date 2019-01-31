//
//  LPFIRMlizhiViewController.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFirmDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPFIRMlizhiViewController : LPBaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *dateBt;
@property (weak, nonatomic) IBOutlet UIButton *statusBt1;
@property (weak, nonatomic) IBOutlet UIButton *statusBt2;


@property (nonatomic,strong) LPFirmDetailsModel *DetailsModel;
@end

NS_ASSUME_NONNULL_END
