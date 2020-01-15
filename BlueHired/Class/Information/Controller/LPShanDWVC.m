//
//  LPTsetShanDWVC.m
//  BlueHired
//
//  Created by iMac on 2019/11/11.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPShanDWVC.h"

#import <WebKit/WebKit.h>


@interface LPShanDWVC ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>
{
    WKWebView *webview;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic,weak) CALayer *progressLayer;
@property (nonatomic,assign) BOOL isfirst;

//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;



@end

@implementation LPShanDWVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LPTools deleteWebCache];
//    [self WebKit];
    [self requestShanDWGETAuth];
    
    self.navigationItem.title = @"闪电玩";
    self.navigationItem.hidesBackButton = true;

    [self addLeftButton];
}
// 这个方法返回支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

// 这个返回是否自动旋转
- (BOOL)shouldAutorotate{
  return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 添加关闭按钮

- (void)addLeftButton
{
    self.navigationItem.leftBarButtonItem = self.backItem;
}



 
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    NSLog(@"%@",[webview canGoBack]?@"1":@"0");
    
}

- (void)WebKit:(NSString *)url{
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    config.userContentController = userController;
    [userController addScriptMessageHandler:self name:@"JSToHistoryVC"];
    [userController addScriptMessageHandler:self name:@"JSToRecordVC"];
    [userController addScriptMessageHandler:self name:@"killMyself"];

    
    webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:webview];
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
//    NSURL *url;
 
//    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%ld",self.Integralmodel.activityImage,(long)[kUserDefaultsValue(LOGINID) integerValue]]];

    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webview loadRequest:request];
    
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self setupProgress];
    
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];

    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
}


- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (webview.canGoBack) {
            [webview goBack];
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (webview.canGoForward) {
            [webview goForward];
        }
    }
}
-(void)setupProgress{
    UIView *progress = [[UIView alloc]init];
    progress.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    progress.backgroundColor = [UIColor  clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 1);
    layer.backgroundColor = [UIColor baseColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
}

//设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}







#pragma mark - KVO回馈
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        if ([change[@"new"] floatValue] <[change[@"old"] floatValue]) {
            return;
        }
        self.progressLayer.frame = CGRectMake(0, 0, self.view.frame.size.width*[change[@"new"] floatValue], 1);
        if ([change[@"new"]floatValue] == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
                self.progressLayer.frame = CGRectMake(0, 0, 0, 1);
            });
        }
    }else if ([keyPath isEqualToString:@"title"]){
        if (object == webview)
        {
            self.navigationItem.title = webview.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}
- (void)dealloc {
    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [webview removeObserver:self forKeyPath:@"title"];
}

//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"JSToHistoryVC"]) {
        NSString *cookiesStr = message.body;
        NSLog(@"当前的cookie为： %@", cookiesStr);
        
    }else if ([message.name isEqualToString:@"JSToRecordVC"]){
        NSString *cookiesStr = message.body;
        NSLog(@"当前的cookie为： %@", cookiesStr);
        
    }else if ([message.name isEqualToString:@"killMyself"]){
        
    }
}


 


/** 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // ------  对alipays:相关的scheme处理 -------
    // 若遇到支付宝相关scheme，则跳转到本地支付宝App
    NSString *reqUrl = navigationAction.request.URL.absoluteString;

    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        // 跳转支付宝App
//        BOOL bSucc = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
       BOOL bSucc =  [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 如果跳转失败，则跳转itune下载支付宝Ap p
        if (!bSucc) {
            NSLog(@"跳转失败");

//            [self alertControllerWithMessage:@"未检测到支付宝客户端，请您安装后重试。"];

        }
    }else if ([reqUrl hasPrefix:@"weixin://"]) {
//         BOOL bSucc = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        BOOL bSucc =  [[UIApplication sharedApplication] openURL:navigationAction.request.URL];

            // 如果跳转失败，则跳转itune下载支付宝Ap p
            if (!bSucc) {
                NSLog(@"跳转失败");

//                [self alertControllerWithMessage:@"未检测到支付宝客户端，请您安装后重试。"];
            }
    }

    // 确认可以跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}



#pragma mark - init

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这是一张“<”的图片，可以让美工给切一张
        UIImage *image = [UIImage imageNamed:@"BackBttonImage"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@" 返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
 
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
    }
    return _closeItem;
}
//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([webview canGoBack]) {
        //如果有则返回
        [webview goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
//        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self closeNative];
    }
}
#pragma mark - request
-(void)requestShanDWGETAuth{
    NSDictionary *dic = @{ };

    [NetApiManager requestShanDWGETAuth:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSString *url = [NSString stringWithFormat:@"%@&gid=%@",responseObject[@"data"],self.model.gameId];
                [self WebKit:url];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
            
        }
        [DSBaActivityView hideActiviTy];
    }];
}
@end
