//
//  YHDailyForecast.m
//  YHSimpleWeather
//
//  Created by Chen-An Huang on 8/16/15.
//  Copyright (c) 2015 Yolk Huang. All rights reserved.
//

#import "YHDailyForecast.h"

@implementation YHDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
  
  paths[@"tempHigh"] = @"temp.max";
  paths[@"tempLow"] = @"temp.min";
  
  return paths;
}

@end
