//
//  LPMainSearchVC.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPMainSearchVC : LPBaseViewController
@property(nonatomic,strong) NSString *mechanismAddress;
@property(nonatomic,copy) NSString *searchWord;
-(void)touchSearchButton;

@end
