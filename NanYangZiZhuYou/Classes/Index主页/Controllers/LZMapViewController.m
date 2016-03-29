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
/**  地理编码对象 */
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
/**
  *  每次更新到用户的位置就会调用(调用不频繁, 只有位置改变才会调用)
  *
  *  @param mapView      促发事件的控件
  *  @param userLocation 大头针模型
  */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 利用反地理编码获取位置之后设置标题
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
    // 移动地图到当前用户所在位置
    // 获取用户当前所在位置的经纬度, 并且设置为地图的中心点
    [self.customMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    // 设置地图显示的区域
    // 获取用户的位置
//    CLLocationCoordinate2D center = userLocation.location.coordinate;
//    // 指定经纬度的跨度
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
//    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
//    
//    // 设置显示区域
//    [self.customMapView setRegion:region animated:YES];
}

@end




























