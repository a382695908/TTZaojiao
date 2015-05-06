//
//  TTCityMngTool.m
//  TTzaojiao
//
//  Created by hegf on 15-4-22.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "TTCityMngTool.h"
#import "AFAppDotNetAPIClient.h"
#import "FileManagerHelper.h"
#import "Constants.h"

#define kCityCodeListFile @"cityCodeList.data"

static TTCityMngTool* tool;

@implementation TTCityMngTool

+(instancetype)sharedCityMngTool{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        tool = [[TTCityMngTool alloc]init];
    });
    return tool;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}

-(NSArray *)cityCodeList{
    NSString* filepath = [NSString stringWithFormat:@"%@/%@",pathDocuments,kCityCodeListFile];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filepath]) {
        NSArray* codeList = [NSArray arrayWithContentsOfFile:filepath];
        if (codeList !=nil && codeList.count>1) {
            _cityCodeList =  codeList;
        }else{
            [manager removeItemAtPath:filepath error:nil];
        }
    }else{
        NSDictionary* parameters = @{
                                     @"p_1": @"1",
                                     @"p_2": @"99999"
                                     };
        [[AFAppDotNetAPIClient sharedClient]apiGet:LOCATION_INFO Parameters:parameters Result:^(id result_data, ApiStatus result_status, NSString *api) {
            if ([result_data isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray* array = (NSMutableArray*)result_data;
                if (array != nil && array.count!=0) {
                    NSLog(@"%@ %ld",array, array.count);
                    [array writeToFile:filepath atomically:YES];
                }
                _cityCodeList = array;
            }
            
        }];
    }
    return _cityCodeList;
}

-(NSString *)citytoCode:(NSString *)cityName{
    NSArray* cityList = self.cityCodeList;
    __block NSString* cityCode = @"";
    if (cityList.count!=0) {
        [cityList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dict = (NSDictionary*)obj;
                if ([[dict objectForKey:@"CityName"]isEqualToString:cityName]) {
                    cityCode = [dict objectForKey:@"CityPostCode"];
                    *stop = YES;
                }
            }
        }];
    }
    return cityCode;
}

-(NSString *)codetoCity:(NSString *)cityCode{
    NSArray* cityList = self.cityCodeList;
    __block NSString* cityName = @"";
    if (cityList.count!=0) {
        [cityList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dict = (NSDictionary*)obj;
                if ([[dict objectForKey:@"CityPostCode"]isEqualToString:cityCode]) {
                    cityName = [dict objectForKey:@"CityName"];
                    *stop = YES;
                }
            }
        }];
    }
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    return cityName;
}

-(NSString *)provinceofCity:(NSString *)cityName{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"ProvincesAndCities.plist" ofType:nil];
    NSArray* rootList = [NSArray arrayWithContentsOfFile:path];
    __block NSString* retpro = nil;
    [rootList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* dict = (NSDictionary*)obj;
        __block NSString* province = dict[@"State"];
        NSArray* citys = dict[@"Cities"];
        [citys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* city = (NSDictionary*)obj;
            if ([city[@"city"] isEqualToString:cityName]) {
                *stop = YES;
                retpro = province;
            }
        }];
    }];
    return retpro;
}

//开始定位
-(void)startLocation:(actionLocationBlock)locationBlock{
    _locationBlock = locationBlock;
    if ([CLLocationManager locationServicesEnabled])
    {
        
        if (!self.locationManager)
        {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter=1.0;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization]; // 永久授权
            [self.locationManager requestWhenInUseAuthorization]; //使用中授权
        }
        
        [self.locationManager startUpdatingLocation];//开启位置更新
    }
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    
    CLLocation *newLocation = [locations lastObject];
    _locationBlock(newLocation, nil);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [_locationManager stopUpdatingLocation];
  
    _locationBlock(nil, error);
}

@end
