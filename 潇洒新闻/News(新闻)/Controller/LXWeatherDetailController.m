//
//  LXWeatherDetailController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/25.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXWeatherDetailController.h"
#import <UIView+SDAutoLayout.h>
#import "LXDataManager.h"
#import "LXWeatherModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface LXWeatherDetailController ()

@end

@implementation LXWeatherDetailController
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBasic];
    [self setupWeatherView];
}
#pragma mark - 设置基本内容
- (void)setupBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark -
- (void)setupWeatherView
{
    NSString *cityStr = [self.cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[LXDataManager shareManager]getWeatherDataWithCityName:cityStr suceess:^(LXWeatherModel *model) {
        //backImage
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = self.view.frame;
        [self.view insertSubview:imgView atIndex:1];
        if ([model.weather isEqualToString:@"晴"]) {
            imgView.image = [UIImage imageNamed:@"sunney"];
        }else if ([model.weather isEqualToString:@"多云"]){
            imgView.image = [UIImage imageNamed:@"cloud"];
        };
        //城市
        UILabel *cityLable = [[UILabel alloc]init];
        cityLable.font = [UIFont systemFontOfSize:30];
        [self addLableWithLable:cityLable Frame:CGRectMake(0, LXStatusHeight + LXNavigationBarHeight + 70, LXWidth, 50) titleText:@"城市" contentText:model.city];
        //date
        UILabel *dateLable = [[UILabel alloc]init];
        dateLable.font = [UIFont systemFontOfSize:30];
        [self addLableWithLable:dateLable Frame:CGRectMake(0, CGRectGetMaxY(cityLable.frame), LXWidth, 50) titleText:@"日期" contentText:model.date];
        //time
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.font = [UIFont systemFontOfSize:30];
        [self addLableWithLable:timeLable Frame:CGRectMake(0, CGRectGetMaxY(dateLable.frame), LXWidth, 50) titleText:@"发布时间" contentText:model.time];
        //weatherLable
        UILabel *weatherLable = [[UILabel alloc]init];
        weatherLable.font = [UIFont systemFontOfSize:20];
        [self addLableWithLable:weatherLable Frame:CGRectMake(0, CGRectGetMaxY(timeLable.frame), LXWidth, 50) titleText:@"天气状况" contentText:model.weather];
        //气温
        UILabel *tmpLable = [[UILabel alloc]init];
        [self addLableWithLable:tmpLable Frame:CGRectMake(0, CGRectGetMaxY(weatherLable.frame), LXWidth / 3, 50) titleText:@"气温" contentText:model.temp];
        //最高气温
        UILabel *h_tmpLable = [[UILabel alloc]init];
        [self addLableWithLable:h_tmpLable Frame:CGRectMake(CGRectGetMaxX(tmpLable.frame), CGRectGetMaxY(weatherLable.frame), LXWidth / 3, 50) titleText:@"最高气温" contentText:model.h_tmp];
        //最低气温
        UILabel *l_tmpLable = [[UILabel alloc]init];
        [self addLableWithLable:l_tmpLable Frame:CGRectMake(CGRectGetMaxX(h_tmpLable.frame), CGRectGetMaxY(weatherLable.frame), LXWidth / 3, 50) titleText:@"最低气温" contentText:model.l_tmp];
        //经度
        UILabel *longitude = [[UILabel alloc]init];
        [self addLableWithLable:longitude Frame:CGRectMake(0, CGRectGetMaxY(tmpLable.frame), LXWidth / 2, 50) titleText:@"经度" contentText:model.longitude];
        //维度
        UILabel *latitude = [[UILabel alloc]init];
        [self addLableWithLable:latitude Frame:CGRectMake(CGRectGetMaxX(longitude.frame), CGRectGetMaxY(tmpLable.frame), LXWidth / 2, 50) titleText:@"维度" contentText:model.latitude];
        //风向
        UILabel *WD = [[UILabel alloc]init];
        [self addLableWithLable:WD Frame:CGRectMake(0, CGRectGetMaxY(longitude.frame), LXWidth / 2, 50) titleText:@"风向" contentText:model.WD];
        //风力
        UILabel *WS = [[UILabel alloc]init];
        [self addLableWithLable:WS Frame:CGRectMake(CGRectGetMaxX(WD.frame), CGRectGetMaxY(longitude.frame), LXWidth / 2, 50) titleText:@"风力" contentText:model.WS];
        //日出时间
        UILabel *sunrise = [[UILabel alloc]init];
        [self addLableWithLable:sunrise Frame:CGRectMake(0, CGRectGetMaxY(WD.frame), LXWidth / 2, 50) titleText:@"日出时间" contentText:model.sunrise];
        //日落时间
        UILabel *sunset = [[UILabel alloc]init];
        [self addLableWithLable:sunset Frame:CGRectMake(CGRectGetMaxX(sunrise.frame), CGRectGetMaxY(WD.frame), LXWidth / 2, 50) titleText:@"日落时间" contentText:model.sunset];
        //分享按钮
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shareBtn.backgroundColor = [UIColor orangeColor];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
        [shareBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [shareBtn.layer setMasksToBounds:YES];
        [shareBtn.layer setCornerRadius:5.0];
        [shareBtn.layer setBorderWidth:2.0];
        [shareBtn.layer setBorderColor:[UIColor redColor].CGColor];
        [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
        shareBtn.sd_layout
        .widthIs(70)
        .heightIs(40)
        .leftSpaceToView(self.view,(LXWidth - 70) / 2)
        .topSpaceToView(self.view,LXStatusHeight + LXNavigationBarHeight);
    }];
}
#pragma mark - addLable
- (void)addLableWithLable:(UILabel *)lable Frame:(CGRect)frame titleText:(NSString *)titleText contentText:(NSString *)contentText
{
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.frame = frame;
    lable.text = [NSString stringWithFormat:@"%@:%@",titleText,contentText];
    [self.view addSubview:lable];
}
#pragma mark - 
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
@end
