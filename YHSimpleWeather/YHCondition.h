//
//  YHCondition.h
//  YHSimpleWeather
//
//  Created by Chen-An Huang on 8/15/15.
//  Copyright (c) 2015 Yolk Huang. All rights reserved.
//

#import <Mantle.h>

@interface YHCondition : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *temperature;
@property (strong, nonatomic) NSNumber *tempHigh;
@property (strong, nonatomic) NSNumber *tempLow;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSDate *sunrise;
@property (strong, nonatomic) NSDate *sunset;
@property (strong, nonatomic) NSString *conditionDescription;
@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSNumber *windBearing;
@property (strong, nonatomic) NSNumber *windSpeed;
@property (strong, nonatomic) NSString *icon;

- (NSString *)imageName;

@end
