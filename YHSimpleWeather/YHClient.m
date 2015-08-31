//
//  YHClient.m
//  YHSimpleWeather
//
//  Created by Chen-An Huang on 8/16/15.
//  Copyright (c) 2015 Yolk Huang. All rights reserved.
//

#import "YHClient.h"
#import "YHCondition.h"
#import "YHDailyForecast.h"

@interface YHClient ()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation YHClient

#pragma mark - Lifecycle

- (instancetype)init {
  self = [super init];
  if (self) {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config];
  }
  return self;
}

#pragma mark - Public

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
  NSLog(@"Fetching: %@",url.absoluteString);
  return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (!error) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (!jsonError) {
          [subscriber sendNext:json];
        } else {
          [subscriber sendError:jsonError];
        }
      } else {
        [subscriber sendError:error];
      }
      
      [subscriber sendCompleted];
    }];
    [dataTask resume];
    
    return [RACDisposable disposableWithBlock:^{
      [dataTask cancel];
    }];
  }] doError:^(NSError *error) {
    NSLog(@"%@", error);
  }];
}

- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
  NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=celsius",coordinate.latitude, coordinate.longitude];
  NSURL *url = [NSURL URLWithString:urlString];
  
  return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
    return [MTLJSONAdapter modelOfClass:[YHCondition class] fromJSONDictionary:json error:nil];
  }];
}

- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
  NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=celsius&cnt=12",coordinate.latitude, coordinate.longitude];
  NSURL *url = [NSURL URLWithString:urlString];
  
  return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
    RACSequence *list = [json[@"list"] rac_sequence];
    
    return [[list map:^(NSDictionary *item) {
      return [MTLJSONAdapter modelOfClass:[YHCondition class] fromJSONDictionary:item error:nil];
    }] array];
  }];
}

- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
  NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=celsius&cnt=7",coordinate.latitude, coordinate.longitude];
  NSURL *url = [NSURL URLWithString:urlString];
  
  return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
    RACSequence *list = [json[@"list"] rac_sequence];
    
    return [[list map:^(NSDictionary *item) {
      return [MTLJSONAdapter modelOfClass:[YHDailyForecast class] fromJSONDictionary:item error:nil];
    }] array];
  }];
}

@end
