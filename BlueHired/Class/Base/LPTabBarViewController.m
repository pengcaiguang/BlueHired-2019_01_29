//
//  LPTabBarViewController.m
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPTabBarViewController.h"
#import "LPCircleVC.h"

@interface LPTabBarViewController ()<UITabBarDelegate>

@end

@implementation LPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTabControllers];
    [[UITabBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    for(UIViewController *viewController in  self.viewControllers){
//        [viewController loadViewIfNeeded]; //ios9
//        //      __unused  UIView *view =  viewController.view;
//    }
}

-(void)createTabControllers{
    
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableArray *titleArrays = [NSMutableArray array];
    
    NSMutableArray *normalImages = [NSMutableArray array];
    NSMutableArray *selectedImages = [NSMutableArray array];
    
    controllers = [NSMutableArray arrayWithArray:@[@"LPMainVC",@"LPInformationVC",@"LPCircleVC",@"LPScoreStore",@"LPMineVC"]];
    titleArrays = [NSMutableArray arrayWithArray:@[@"招工",@"看看",@"圈子",@"商城",@"我的"]];
//    controllers = [NSMutableArray arrayWithArray:@[@"LPWorkHour2VC",@"LPInformationVC",@"LPCircleVC",@"LPMineVC"]];
//    titleArrays = [NSMutableArray arrayWithArray:@[@"工时",@"看看",@"圈子",@"我的"]];
//
    for (int index = 0; index<controllers.count; index++) {
        [normalImages addObject:[[UIImage imageNamed:[NSString stringWithFormat:@"ic_tab_normal0%d.png",index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [selectedImages addObject:[[UIImage imageNamed:[NSString stringWithFormat:@"ic_tab_selected0%d.png",index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int index = 0; index < controllers.count; index++) {
        
        RTRootNavigationController *navigationViewController;
        
        Class class = NSClassFromString(controllers[index]);
        
        UIViewController *vc = [[class alloc] init];
        vc.navigationItem.title = [titleArrays objectAtIndex:index];
        navigationViewController = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        
        UIImage *normalImage = (UIImage *)normalImages[index];
        
        UIImage *selectedImage = (UIImage *)selectedImages[index];
        
        navigationViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[titleArrays objectAtIndex:index] image:normalImage selectedImage:selectedImage];
        
        [navigationViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#3CAFFF"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [navigationViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#333333"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

        navigationViewController.tabBarItem.tag = index;
        [viewControllers addObject:navigationViewController];
        
    }
    // 首页
    [self setViewControllers:viewControllers];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
