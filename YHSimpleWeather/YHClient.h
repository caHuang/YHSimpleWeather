//
//  YHClient.h
//  YHSimpleWeather
//
//  Created by Chen-An Huang on 8/16/15.
//  Copyright (c) 2015 Yolk Huang. All rights reserved.
//

#import <ReactiveCocoa.h>

@import Foundation;
@import CoreLocation;

@interface YHClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;

@end
