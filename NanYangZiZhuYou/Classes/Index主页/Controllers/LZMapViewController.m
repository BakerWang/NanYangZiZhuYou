//
//  LZMapViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZMapViewController.h"
#import <MapKit/MapKit.h>

@interface LZMapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *customMapView;
@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic ,strong) CLGeocoder *geocoder;

@end

@implementation LZMapViewController
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.customMapView.mapType = MKMapTypeStandard;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 主动请求权限
        self.mgr = [[CLLocationManager alloc] init];
        
        [self.mgr requestAlwaysAuthorization];
    }else {
        return ;
    }
    
    // 设置不允许地图旋转
    self.customMapView.rotateEnabled = NO;
    
    // 成为mapVIew的代理
    self.customMapView.delegate = self;
    self.customMapView.userTrackingMode =  MKUserTrackingModeFollow;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        fSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
    // 移动地图到当前用户所在位置
    // 获取用户当前所在位置的经纬度, 并且设置为地图的中心点
//    [self.customMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    //112.427748
    //34.61847
    //112.428485,34.620074
    // 设置地图显示的区域
    // 获取用户的位置
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 指定经纬度的跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(6,6);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置显示区域
    [self.customMapView setRegion:region animated:YES];
    
}

@end




























