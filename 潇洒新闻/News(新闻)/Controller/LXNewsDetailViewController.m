//
//  LXNewsDetailViewController.m
//  My App
//
//  Created by niceforme on 16/2/21.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//

#import "LXNewsDetailViewController.h"
#import <AFNetworking.h>
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface LXNewsDetailViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,weak) UIWebView *webView;
@end

@implementation LXNewsDetailViewController
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progress;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupnjkProgress];
}
#pragma mark - setupBasic
- (void)setupBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]init];
    self.webView = webView;
    webView.frame = self.view.frame;
    webView.scalesPageToFit = NO;
    [self.view addSubview:webView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
}
- (void)share
{
    //1.创建分享参数
    NSArray *imageArray = @[[UIImage imageNamed:@"Default-Portrait-ns"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:nil images:imageArray url:nil title:@"分享标题" type:SSDKContentTypeAuto];
        //2.分享
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}
#pragma mark - njkProgress
- (void)setupnjkProgress
{
    _progress = [[NJKWebViewProgress alloc]init];
    self.webView.delegate = _progress;
    _progress.webViewProxyDelegate = self;
    _progress.progressDelegate = self;
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navBounds.size.height, navBounds.size.width, 2);
    _progressView = [[NJKWebViewProgressView alloc]init];
    _progressView.frame = barFrame;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_progressView];
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
- (void)useWebViewWithURLString:(NSString *)URLString
{
    NSString *urlStr = [[NSString alloc]initWithFormat:@"http://apis.baidu.com/showapi_open_bus/extract/extract?url=%@",URLString];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:0];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"093b458afaea17211d2eb6be9871e60c" forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dict2 = dict[@"showapi_res_body"][@"content"];
            NSString *dicStr = [NSString stringWithFormat:@"%@",dict2];
            [self.webView loadHTMLString:dicStr baseURL:[NSURL URLWithString:urlStr]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
