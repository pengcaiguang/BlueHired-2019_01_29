//
//  LPInCommentsVC.m
//  BlueHired
//
//  Created by iMac on 2019/6/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPInCommentsVC.h"
#import "YYTextView.h"

#import <WebKit/WebKit.h>

@interface LPInCommentsVC ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>
{
    WKWebView *webview;
}

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_TopTextView_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_BottomTextView_Height;

@property (weak, nonatomic) IBOutlet IQTextView *TextView1;
@property (weak, nonatomic) IBOutlet IQTextView *TextView2;
@property (weak, nonatomic) IBOutlet IQTextView *TextView3;
@property (weak, nonatomic) IBOutlet IQTextView *TextView4;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *FinishBt;


@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic,weak) CALayer *progressLayer;
@property (nonatomic,assign) BOOL isfirst;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic, assign) NSInteger IsBack;


@end

@implementation LPInCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LPTools deleteWebCache];
    
    self.navigationItem.title = @"入职评价";
 
    self.TextView1.layer.cornerRadius = 2;
    self.TextView1.layer.borderWidth = 1;
    self.TextView1.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.TextView1.placeholder = @"非常抱歉给您带来不好的感受，请告诉我们原因，我们会做的更好~";
    
    self.TextView2.layer.cornerRadius = 2;
    self.TextView2.layer.borderWidth = 1;
    self.TextView2.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.TextView2.placeholder = @"非常抱歉给您带来不好的感受，请告诉我们原因，我们会做的更好~";

    self.TextView3.layer.cornerRadius = 2;
    self.TextView3.layer.borderWidth = 1;
    self.TextView3.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.TextView3.placeholder = @"您的需要就是蓝聘的追求~";

    self.TextView4.layer.cornerRadius = 2;
    self.TextView4.layer.borderWidth = 1;
    self.TextView4.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.TextView4.placeholder = @"您的需要就是蓝聘的追求~";

    [self WebKit];
    self.navigationItem.hidesBackButton = true;
    [self addLeftButton];
}
#pragma mark - 添加关闭按钮

- (void)addLeftButton
{
    self.navigationItem.leftBarButtonItem = self.backItem;
}

- (void)WebKit {
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    config.userContentController = userController;
 
    [userController addScriptMessageHandler:self name:@"submitSuccess"];

    
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
    
    NSURL *url;
    if (self.Type == 1) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@entryevaluate?evaluateId=%ld&id=%@",BaseRequestWeiXiURLTWO,(long)self.workOrderId,kUserDefaultsValue(LOGINID)]];
    }else if (self.Type == 2){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@entryevaluateedit?evaluateId=%ld&id=%@",BaseRequestWeiXiURLTWO,(long)self.workOrderId,kUserDefaultsValue(LOGINID)]];
    }else if (self.Type == 3){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@delevaluate",BaseRequestWeiXiURLTWO]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self setupProgress];
    
//    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    
//    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    
//    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
//    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
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
    }else if ([keyPath isEqualToString:@"title"])
    {
        if (object == webview)
        {
            self.navigationItem.title = webview.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}
- (void)dealloc {
    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [webview removeObserver:self forKeyPath:@"title"];
}

//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"submitSuccess"]) {
        NSString *cookiesStr = message.body[@"body"];
        NSLog(@"当前的cookie为： %@", cookiesStr);
        if (cookiesStr.integerValue == 3 ) {        //已经评论
            self.IsBack = 3;
            self.model.remarkStatus = cookiesStr;
        }else if (cookiesStr.integerValue == 4){    //删除
            self.model.remarkStatus = cookiesStr;
        }else if (cookiesStr.integerValue == 5){
            self.IsBack = 5;
        }
        
    }
}





#pragma mark - init

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
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
    if (self.IsBack == 5 ) {
        //如果有则返回
        [webview goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        //        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        self.IsBack = 0;
    } else {
        [self closeNative];
    }
}


- (IBAction)TouchTopBt:(UIButton *)sender {
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *bt = [self.ScrollView viewWithTag:i+1000];
        bt.selected = NO;
    }
    sender.selected = YES;

    self.LayoutConstraint_TopTextView_Height.constant = sender.tag == 1003? LENGTH_SIZE(115):0;
    UIButton *Selectbt = [self.ScrollView viewWithTag:1004];
    if (![Selectbt.currentTitle isEqualToString:@"请选择驻厂"]) {
        self.FinishBt.enabled = YES;
    }

}


- (IBAction)TouchBottomBt:(UIButton *)sender {
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *bt = [self.ScrollView viewWithTag:i+2000];
        bt.selected = NO;
    }
    sender.selected = YES;
    self.LayoutConstraint_BottomTextView_Height.constant = sender.tag == 2003? LENGTH_SIZE(115):0;
    UIButton *Selectbt = [self.ScrollView viewWithTag:2004];
    if (![Selectbt.currentTitle isEqualToString:@"请选择客服"]) {
        self.FinishBt.enabled = YES;
    }
}

- (IBAction)TouchFinishBt:(UIButton *)sender {
    
}

@end
