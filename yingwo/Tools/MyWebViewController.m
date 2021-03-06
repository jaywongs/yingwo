//
//  YWWebViewController.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyWebViewController.h"
#import "NJKWebViewProgressView.h"

@interface MyWebViewController ()

@property (nonatomic, strong) UIWebView                     *webView;
@property (nonatomic, strong) NJKWebViewProgressView        *progressView;
@property (nonatomic, strong) NJKWebViewProgress            *progressProxy;
@property (nonatomic, assign) CGFloat                       navgationBarHeight;

@property (nonatomic, strong) UIBarButtonItem               *backItem;
@property (nonatomic, strong) UIBarButtonItem               *closeItem;

@end

@implementation MyWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [self init];
    if (self) {
        _url = url;
    }
    return self;
}

-(UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               SCREEN_WIDTH,
                                                               SCREEN_HEIGHT - self.navgationBarHeight)];
        _webView.delegate = self;
        //网页自适应
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加载中···";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18 weight:1]}];

    //初始化返回和关闭按钮
    self.backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nva_con"]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(backToLastView)];
    
    self.closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(CloseTheView)];
    
    [self setLeftBarItems];
    
    self.progressProxy                          = [[NJKWebViewProgress alloc] init];
    self.webView.delegate                       = self.progressProxy;
    self.progressProxy.webViewProxyDelegate     = self;
    self.progressProxy.progressDelegate         = self;
    
    [self.view addSubview:self.webView];
    

    CGFloat progressBarHeight                   = 3.f;
    CGRect navigationBarBounds                  = self.navigationController.navigationBar.bounds;
    CGRect barFrame                             = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView                           = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask          = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self loadPage];
}
//返回上一个页面
- (void)backToLastView {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self CloseTheView];
    }
}
//关闭
- (void)CloseTheView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadPage {

    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
    [self.webView loadRequest:req];
}

//设置左上角item
- (void)setLeftBarItems {
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backItem,self.closeItem];
    }else {
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}

- (CGFloat)navgationBarHeight {
    //导航栏＋状态栏高度
    return  self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 移除progress视图
    [self.progressView removeFromSuperview];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self setLeftBarItems];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self setLeftBarItems];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}



@end
