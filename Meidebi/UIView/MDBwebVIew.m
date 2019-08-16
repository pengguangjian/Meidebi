//
//  MDBwebVIew.m
//  Meidebi
//
//  Created by 杜非 on 15/1/22.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MDBwebVIew.h"
#import "Constants.h"
#import "ImageScrollView.h"

#import "PGGMoviePlayer.h"
#import "MDB_UserDefault.h"

@implementation MDBwebVIew{
    
    BOOL isLoadHtmlStr;
    NSInteger webViewLoads;
    UIImageView *noNetWorkImageView;
    
    UIProgressView *progressView;
    
    int icount;
    
    BOOL isChangeFount;
    
    BOOL isfinallied;
}
@synthesize delegate=_delegate;
@synthesize webView=_webView;

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _isInteriorSkip = NO;
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
//        _webView.scrollView.delegate = self;
        _webView.scrollView.scrollEnabled=NO;
        _webView.opaque = NO;
//        if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP) settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        
        
        
        _webView.backgroundColor= [UIColor whiteColor];
        [self addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self loadimageview];
        
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        icount = 0;
        
    }
    return self;
}

-(void)loadimageview
{
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    imageView.image = [UIImage imageNamed:@"ic_no_network"];
    noNetWorkImageView = imageView;
    [noNetWorkImageView setHidden:YES];
}

- (void)refreshHtml:(NSString *)description{
    if(isfinallied)return;
    _webView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    NSString *str_bigfont=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigfont" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    
    NSString *description_bigfont=[NSString stringWithFormat:@"<html>%@%@</html>",str_bigfont,description];
    
    description_bigfont = [headerString stringByAppendingString:description_bigfont];
    [_webView loadHTMLString:description_bigfont baseURL:nil];
    
}

- (void)refreshYQHYGZHtml:(NSString *)description{
    if(isfinallied)return;
    _webView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    NSString *str_bigfont=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigfont" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    
    NSString *description_bigfont=[NSString stringWithFormat:@"<html>%@<div style='color:#FFFFFF'>%@</div></html>",str_bigfont,description];
    
    description_bigfont = [headerString stringByAppendingString:description_bigfont];
    [_webView loadHTMLString:description_bigfont baseURL:nil];
    
}

// 请求网页
- (void)loadWebByURL:(NSString *)paramUrl{
    if(isfinallied)return;
    _webView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    NSString *webUrl=[NSString stringWithFormat:@"%@%@",URL_HR,paramUrl];
    if([[paramUrl substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"])
    {
        paramUrl = [paramUrl substringFromIndex:1];
        webUrl=[NSString stringWithFormat:@"%@%@",URL_HR,paramUrl];
    }
    NSURL *localUrl = [NSURL URLWithString:webUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:localUrl];
    [_webView loadRequest:request];
    
//    [_webView loadHTMLString:@"" baseURL:localUrl];
//
//    NSError *error;
//
//    NSURLResponse *response = nil;
//
//    NSData *datat = [NSURLConnection sendSynchronousRequest:request
//
//                                          returningResponse:&response
//
//                                                      error:&error];
//    NSString *strtemp = [[NSString alloc] initWithData:datat encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
//    if(strtemp == nil)
//    {
//        strtemp = [[NSString alloc] initWithData:datat encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//    }
//     [_webView loadHTMLString:strtemp baseURL:localUrl];
    
}

///页面消失时调用该方法
-(void)finalyLoadWKWebView
{
    if(_webView!=nil)
    {
        [_webView stopLoading];
        [_webView setNavigationDelegate:nil];
        [_webView removeFromSuperview];
        
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        _webView = nil;
        
    }
    
    isfinallied = YES;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if(isfinallied)return;
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0){
            ///加载完成后设置图片点击
            [self obtainImage];
        }
        //加载后获取webview的高度
        NSString *js = @"document.body.scrollHeight";
        [_webView evaluateJavaScript:js completionHandler:^(id _Nullable height, NSError * _Nullable error) {
            
            CGFloat h = [height floatValue];
//            h-=20;
            [self webviewContSize:h];
        }];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}


-(void)webviewContSize:(float)fh
{
    if(isfinallied)return;
    [_webView setHeight:fh];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, fh)];
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:webview:)]) {
        [self.delegate webViewDidFinishLoad:fh webview:self];
    }
    [_webView setNeedsDisplay];
}


- (void)obtainImage{
    if(isfinallied)return;
    if(isChangeFount)
    {
//        [_webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'" completionHandler:nil];
//
//        [ _webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'"completionHandler:nil];
//
//
//        isChangeFount = NO;
    }
    else
    {
        NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
        [_webView evaluateJavaScript:str completionHandler:nil];

    }
    //js方法遍历图片添加点击事件 返回所有图片
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var srcs = [];\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    srcs[i] = objs[i].src;\
    };\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+srcs+','+this.src;\
    };\
    };\
    return objs.length;\
    };";
    [_webView evaluateJavaScript:jsGetImages completionHandler:nil];
    [_webView evaluateJavaScript:@"getImages()" completionHandler:nil];
    
    
    
    
    
}

#pragma mark - WKWebView
//在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if(isfinallied)return;
    
    NSString *str = navigationAction.request.URL.absoluteString;
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:"
                                             withString:@""];
        NSArray *imageUrlArr = [str componentsSeparatedByString:@","];
        
        
        [ImageScrollView showImageWithImageArr:imageUrlArr];
        
        
//        NSLog(@"%@",imageUrlArr);
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (navigationAction.navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        if (_isInteriorSkip) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(webViewDidPreseeUrlWithLink:webview:)]) {
            
            
            [self.delegate webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",navigationAction.request.URL] webview:self];
            
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    
    }
    
    
    if (navigationAction.targetFrame ==nil) {
        
        [webView loadRequest:navigationAction.request];
        
    }
    // 没有这一句页面就不会显示
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

/// 2 页面开始加载

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    webViewLoads++;

}

/// 4 开始获取到网页内容时返回

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    if(isfinallied)return;
    noNetWorkImageView.hidden = YES;
    
}

/// 5 页面加载完成之后调用

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if(isfinallied)return;
    webViewLoads--;
    // 隐藏加载状态
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no\"", self.frame.size.width];
//    [webView evaluateJavaScript:meta completionHandler:nil];
    noNetWorkImageView.hidden = YES;
//    if (webViewLoads==0) {
//        noNetWorkImageView.hidden = YES;
//    }

}

/// 页面加载失败时调用

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    if(isfinallied)return;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    webViewLoads--;
    noNetWorkImageView.hidden = YES;

}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    if(isfinallied)return;
    if(webView.title.length<1)
    {
        [webView reload];
    }
    
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    
//     NSLog(@"%lf",scrollView.contentSize.height);
//}
//#pragma mark- UIWebViewDelegate 方法
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//
//    
//    
//    NSString *str = request.URL.absoluteString;
//    if ([str hasPrefix:@"myweb:imageClick:"]) {
//        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:"
//                                             withString:@""];
//        NSArray *imageUrlArr = [str componentsSeparatedByString:@","];
//        
//        
//        [ImageScrollView showImageWithImageArr:imageUrlArr];
//        
//        return NO;
//    }
//    
//    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//        if (_isInteriorSkip) {
//            return _isInteriorSkip;
//        }
//        if ([self.delegate respondsToSelector:@selector(webViewDidPreseeUrlWithLink:webview:)]) {
//            [self.delegate webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",request.URL] webview:self];
//        }
//         return NO;
//    }
//    return YES;
//}
//
//// 当网页视图开始加载内容时将调用这个方法
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    webViewLoads++;
//}
//
//// 当网页视图完成加载时将调用这个方法
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//
//    webViewLoads--;
//    // 隐藏加载状态
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no\"", self.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
//    CGRect webFrame = _webView.frame;
//    CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
//    webFrame.size.height = fittingSize.height;
//    _webView.frame = webFrame;
//    NSString *h= [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//    CGFloat height = _webView.frame.size.height;
//    if (self.tag == 1111) {
//        height = [h floatValue];
//    }
////    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
////    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:webview:)]) {
////        [self.delegate webViewDidFinishLoad:height webview:self];
////    }
//    [self obtainImage];
//    if (webViewLoads==0) {
//        noNetWorkImageView.hidden = YES;
//    }
//    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
//    BOOL complete = [readyState isEqualToString:@"complete"];
//    if(complete)
//    {
//        NSLog(@"加载完成");
//
//    }
//    else
//    {
////        [self webViewDidFinishLoadCompletely];
//    }
//
//
//}
//
//- (void)onload {
//    [self webViewDidFinishLoadCompletely];
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)documentReadyStateComplete {
//    [self webViewDidFinishLoadCompletely];
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)webViewDidFinishLoadCompletely {
//    [_webView reload];
//}
//
//- (void)fitContentForWebviewResize {
//    [_webView stringByEvaluatingJavaScriptFromString:
//     [NSString stringWithFormat:
//      @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
//      (int)_webView.frame.size.width]];
//}
//
//- (void)obtainImage{
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
//    [_webView stringByEvaluatingJavaScriptFromString:str];
//    
//    //js方法遍历图片添加点击事件 返回所有图片
//    static  NSString * const jsGetImages =
//    @"function getImages(){\
//    var srcs = [];\
//    var objs = document.getElementsByTagName(\"img\");\
//    for(var i=0;i<objs.length;i++){\
//    srcs[i] = objs[i].src;\
//    };\
//    for(var i=0;i<objs.length;i++){\
//    objs[i].onclick=function(){\
//    document.location=\"myweb:imageClick:\"+srcs+','+this.src;\
//    };\
//    };\
//    return objs.length;\
//    };";
//    
//    [_webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
//    [_webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
//    
//    
//    
//    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
//
//    NSString *strhtml = [_webView stringByEvaluatingJavaScriptFromString:lJs];
//
//    NSLog(@"%@",strhtml);
//
//    
//    
////    //js方法遍历图片添加点击事件 返回所有图片
////    static  NSString * const jsGetImages1 =
////    @"function getImages1(){\
////    var srcs1 = [];\
////    var objs1 = document.getElementsByTagName(\"video\");\
////    for(var i=0;i<objs1.length;i++){\
////    var ps=objs1[i].previousSibling;\
////    srcs1[i] = objs1[i].src;\
////    };\
////    for(var i=0;i<objs1.length;i++){\
////    objs1[i].previousSibling.onclick=function(){\
////    document.location=\"myweb1:videoClick:\"+srcs1+','+i;\
////    };\
////    };\
////    return objs1.length;\
////    };";
////    [_webView stringByEvaluatingJavaScriptFromString:jsGetImages1];//注入js方法
////    [_webView stringByEvaluatingJavaScriptFromString:@"getImages1()"];
//    
//    
////    NSString *strfile = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
////    
////    NSString *jsGetImages2 = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:strfile] encoding:NSUTF8StringEncoding];
////    [_webView stringByEvaluatingJavaScriptFromString:jsGetImages2];//注入js方法
////    [_webView stringByEvaluatingJavaScriptFromString:@"fun()"];
//    
//    
////    //js方法遍历图片添加点击事件 返回所有图片
////    static  NSString * const jsGetVideos =
////    @"function getVideos(){\
////    var srcs = [];\
////    var objs = document.getElementsByTagName(\"video\");\
////    for(var i=0;i<objs.length;i++){\
////    srcs[i] = objs[i].src;\
////    };\
////    for(var i=0;i<objs.length;i++){\
////    objs[i].onclick=function(){\
////    document.location=\"myweb:videoClick:\"+srcs+','+this.src;\
////    };\
////    };\
////    return objs.length;\
////    };";
////    
////    [_webView stringByEvaluatingJavaScriptFromString:jsGetVideos];//注入js方法
////    [_webView stringByEvaluatingJavaScriptFromString:@"getVideos()"];
//    
//    
////    <a href="javascript:void(0);" class="trans-btn trans-btn-zh icon-transbtn" id="translate-button" target="_self"></a>
////
////    //js方法遍历图片添加点击事件 返回所有图片
////    static  NSString * const jsGetImages1 =
////    @"function getviedos(){\
////    var srcs = [];\
////    var objs = document.getElementsByTagName(\"video\");\
////    for(var i=0;i<objs.length;i++){\
////    srcs[i] = objs[i].src;\
////    };\
////    for(var i=0;i<objs.length;i++){\
////    objs[i].onclick=function(){\
////    document.location=\"myweb:imageClick:\"+srcs+','+this.src;\
////    };\
////    };\
////    return objs.length;\
////    };";
//    
//    
////    NSString *html = str;
////    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\ssrc[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
////    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
//    
//}
//
//// 当因加载出错(例如:因网络问题而断开可连接)而导致停止加载时将调用这方法
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    webViewLoads--;
//    noNetWorkImageView.hidden = YES;
//}

#pragma mark - setters and getters
- (void)setWebDescription:(NSString *)webDescription{
    if(isfinallied)return;
    if ([webDescription isEqualToString:@""]) return;
    _webDescription = webDescription;
    [self loadWebByURL:webDescription];
    
}

- (void)setHtmlStr:(NSString *)htmlStr{
    if(isfinallied)return;
    if ([htmlStr isEqualToString:@""]) return;
    _htmlStr = htmlStr;
    isLoadHtmlStr = YES;
    [self refreshHtml:htmlStr];
}

-(void)dealloc
{
    


    NSHTTPCookie *cookie;

    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (cookie in [storage cookies])

    {

        [storage deleteCookie:cookie];

    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    if(_webView!=nil)
    {
        if(_webView.isLoading)
        {
            [_webView stopLoading];
        }
        
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView setNavigationDelegate:nil];
        [_webView removeFromSuperview];
        _webView = nil;
    }
    
}

@end
