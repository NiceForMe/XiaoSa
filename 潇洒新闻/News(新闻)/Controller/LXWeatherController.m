//
//  LXWeatherController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/24.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXWeatherController.h"
#import "LXWeatherDetailController.h"
#import "LXWeatherCityCell.h"
#import <CoreLocation/CoreLocation.h>
#import <UIView+SDAutoLayout.h>

static NSString * const collectionCityCellID = @"CityCollectionCell";
static NSString * const collectionCitySectionHeaderID = @"CityCollectionHeader";


@interface LXWeatherController ()<CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *hotCityArray;
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation LXWeatherController
#pragma mark - 懒加载
- (NSMutableArray *)hotCityArray
{
    if (!_hotCityArray) {
        _hotCityArray = [NSMutableArray arrayWithArray:@[@"北京",@"磴口",@"上海",@"新乡",@"西安",@"南京",@"武汉",@"成都",@"天津",@"重庆",@"兰州",@"呼和浩特",@"厦门",@"深圳",@"临河"]];
    }
    return _hotCityArray;
}
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBasic];
    [self setupLocation];
    [self setupCityCollectionView];
}
#pragma mark - setupBasic
- (void)setupBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - setupLocation
- (void)setupLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10000;
        [self.locationManager startUpdatingLocation];
    }else{
        NSString *title = NSLocalizedString(@"定位不成功,请确认开启定位", nil);
        NSString *other = NSLocalizedString(@"确定", nil);
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        }];
        [ac addAction:otherAction];
        [self presentViewController:ac animated:YES completion:^{
            
        }];
    }
}
#pragma mark - locationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"didUpdateLocations");
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    //获取当前所在的城市名
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //根据经纬度反向地理编译出地址信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            //获取城市
            NSString *city = placeMark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placeMark.administrativeArea;
            }
            self.cityName = [NSString stringWithFormat:@"%@",city];
            self.cityName = [self.cityName substringToIndex:self.cityName.length - 1];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }else if (error == nil && [placemarks count] == 0){
            NSLog(@"no result");
        }else if (error != nil){
            NSLog(@"%@",error);
        }
    }];
    [manager stopUpdatingLocation];
}
#pragma mark - setupCityCollectionView
- (void)setupCityCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(LXWidth, 40);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    [collectionView setNeedsLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alpha = 0.95;
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[LXWeatherCityCell class] forCellWithReuseIdentifier:collectionCityCellID];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCitySectionHeaderID];
    collectionView.sd_layout
    .heightIs(LXHeight - LXStatusHeight - LXNavigationBarHeight)
    .widthIs(LXWidth)  
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0);
}
#pragma mark - collectionview datasource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.hotCityArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXWeatherCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCityCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.lable.text = self.cityName;
    }else{
        cell.lable.text = self.hotCityArray[indexPath.row];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCitySectionHeaderID forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *lable = [[UILabel alloc]init];
    lable.frame = CGRectMake(20, 0, LXWidth - 20, headerView.frame.size.height);
    if (indexPath.section == 0) {
        lable.text = @"定位";
    }else{
        lable.text = @"热门城市";
    }
    [headerView addSubview:lable];
    return headerView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LXWeatherDetailController *detailVC = [[LXWeatherDetailController alloc]init];
    if (indexPath.section == 0) {
        detailVC.cityName = self.cityName;
    }else if (indexPath.section == 1){
        detailVC.cityName = self.hotCityArray[indexPath.row];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - flowlayout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((LXWidth - 4 * 20) / 3, 35);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
@end
