//
//  LPHongBaoVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPHongBaoVC.h"
#import "SSYRedpacketDJSView.h"
 
@interface LPHongBaoVC ()

@property (nonatomic,strong) SSYRedpacketDJSView *redView;
@end

@implementation LPHongBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _redView =[[SSYRedpacketDJSView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
     [self.view addSubview:_redView];
 }
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ( _isLogin) {
        [_redView requestQueryGetRedPacket];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
