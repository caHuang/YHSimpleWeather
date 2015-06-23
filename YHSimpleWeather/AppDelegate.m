//
//  AppDelegate.m
//  YHSimpleWeather
//
//  Created by Chen-An Huang on 6/23/15.
//  Copyright (c) 2015 Yolk Huang. All rights reserved.
//

#import <TSMessage.h>
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

#pragma makr - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
  self.window = [[UIWindow alloc] initWithFrame:mainScreenBounds];
  ViewController *viewController = [[ViewController alloc] init];
  viewController.view.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
  
  [TSMessage setDefaultViewController:self.window.rootViewController];
  return YES;
}

@end