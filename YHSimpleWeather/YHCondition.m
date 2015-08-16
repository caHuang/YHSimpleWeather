//
//  YHCondition.m
//  YHSimpleWeather
//
//  Created by Chen-An Huang on 8/15/15.
//  Copyright (c) 2015 Yolk Huang. All rights reserved.
//

#import "YHCondition.h"

@interface YHCondition ()

+ (NSDictionary *)imageMap;

@end

@implementation YHCondition

#pragma mark - Public

- (NSString *)imageName {
  return [YHCondition imageMap][self.icon];
}

#pragma mark - Private

+ (NSDictionary *)imageMap {
  static NSDictionary *imageMap = nil;
  if (!imageMap) {
    imageMap = @{
                 @"01d": @"weather-clear",
                 @"02d": @"weather-few",
                 @"03d": @"weather-few",
                 @"04d": @"weather-broken",
                 @"09d": @"weather-shower",
                 @"10d": @"weather-rain",
                 @"11d": @"weather-tstorm",
                 @"13d": @"weather-snow",
                 @"50d": @"weather-mist",
                 @"01n": @"weather-moon",
                 @"02n": @"weather-few-night",
                 @"03n": @"weather-few-night",
                 @"04n": @"weather-broken",
                 @"09n": @"weather-shower",
                 @"10n": @"weather-rain-night",
                 @"11n": @"weather-tstorm",
                 @"13n": @"weather-snow",
                 @"50n": @"weather-mist",
                 };
  }
  return imageMap;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"date": @"dt",
           @"locationName": @"name",
           @"humidity": @"main.humidity",
           @"temperature": @"main.temp",
           @"tempHigh": @"main.temp_max",
           @"tempLow": @"main.temp_min",
           @"sunrise": @"sys.sunrise",
           @"sunset": @"sys.sunset",
           @"conditionDescription": @"weather.description",
           @"condition": @"weather.main",
           @"icon": @"weather.icon",
           @"windBearing": @"wind.deg",
           @"windSpeed": @"wind.speed"
           };
}

#pragma mark - NSValueTransformer

+ (NSValueTransformer *)dateJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
    return [NSDate dateWithTimeIntervalSince1970:string.floatValue];
  } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
    return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
  }];
}

+ (NSValueTransformer *)sunriseJSONTransformer {
  return [self dateJSONTransformer];
}

+ (NSValueTransformer *)sunsetJSONTransformer {
  return [self dateJSONTransformer];
}

+ (NSValueTransformer *)conditionDescriptionJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *values, BOOL *success, NSError *__autoreleasing *error) {
    return values.firstObject;
  } reverseBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
    return @[string];
  }];
}

+ (NSValueTransformer *)conditionJSONTransformer {
  return [self conditionDescriptionJSONTransformer];
}

+ (NSValueTransformer *)iconJSONTransformer {
  return [self conditionDescriptionJSONTransformer];
}

+ (NSValueTransformer *)windSpeedJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
    return @(number.floatValue);
  } reverseBlock:^id(NSNumber *speed, BOOL *success, NSError *__autoreleasing *error) {
    return @(speed.floatValue);
  }];
}

@end
