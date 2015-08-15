//
//  ViewController.m
//  YHSimpleWeather
//
//  Created by Chen-An Huang on 6/23/15.
//  Copyright (c) 2015 Yolk Huang. All rights reserved.
//

#import <Masonry.h>
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "ViewController.h"

@interface ViewController () <
  UITableViewDelegate,
  UITableViewDataSource,
  UIScrollViewDelegate
>

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) UITableView *tableView;

- (void)setupBackgroundAndBlurredImageView;
- (void)setupTableView;
- (void)setupTableHeaderView;

@end

static CGFloat const YHTableHeaderViewInset = 20.0f;

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupBackgroundAndBlurredImageView];
  [self setupTableView];
  [self setupTableHeaderView];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
  [self.blurredImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
}

#pragma mark - Private

- (void)setupBackgroundAndBlurredImageView {
  UIImage *backgroundImage = [UIImage imageNamed:@"bg"];
  
  self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
  self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:self.backgroundImageView];
  
  self.blurredImageView = [[UIImageView alloc] init];
  self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.blurredImageView.alpha = 0.0f;
  [self.blurredImageView setImageToBlur:backgroundImage
                             blurRadius:10.0f
                        completionBlock:nil];
  [self.view addSubview:self.blurredImageView];
}

- (void)setupTableView {
  self.tableView = [[UITableView alloc] init];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
  self.tableView.pagingEnabled = YES;
  [self.view addSubview:self.tableView];
}

- (void)setupTableHeaderView {
  CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
  UIView *headerView = [[UIView alloc] initWithFrame:mainScreenBounds];
  headerView.backgroundColor = [UIColor clearColor];
  self.tableView.tableHeaderView = headerView;
  
  // cityLabel - top
  UILabel *cityLabel = [[UILabel alloc] init];
  cityLabel.backgroundColor = [UIColor clearColor];
  cityLabel.textColor = [UIColor whiteColor];
  cityLabel.text = @"Loading...";
  cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
  cityLabel.textAlignment = NSTextAlignmentCenter;
  [headerView addSubview:cityLabel];

  CGFloat cityHeight = 30.0f;
  [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(headerView).with.offset(20.0f);
    make.centerX.equalTo(headerView);
    make.width.equalTo(headerView);
    make.height.mas_equalTo(@(cityHeight));
  }];
  
  // hiloLabel - bottom left
  UILabel *hiloLabel = [[UILabel alloc] init];
  hiloLabel.backgroundColor = [UIColor clearColor];
  hiloLabel.textColor = [UIColor whiteColor];
  hiloLabel.text = @"0° / 0°";
  hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0f];
  [headerView addSubview:hiloLabel];
  
  CGFloat hiloHeight = 40.0f;
  [hiloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(headerView).with.offset(YHTableHeaderViewInset);
    make.right.equalTo(headerView).with.offset(YHTableHeaderViewInset);
    make.bottom.equalTo(headerView);
    make.height.mas_equalTo(@(hiloHeight));
  }];
  
  // temperatureLabel - bottom left
  UILabel *temperatureLabel = [[UILabel alloc] init];
  temperatureLabel.backgroundColor = [UIColor clearColor];
  temperatureLabel.textColor = [UIColor whiteColor];
  temperatureLabel.text = @"0°";
  temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120.0f];
  [headerView addSubview:temperatureLabel];
  
  CGFloat temperatureHeight = 110.0f;
  [temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(hiloLabel);
    make.right.equalTo(hiloLabel);
    make.bottom.equalTo(hiloLabel.mas_top);
    make.height.mas_equalTo(@(temperatureHeight));
  }];

  // iconView - bottom left
  UIImageView *iconView = [[UIImageView alloc] init];
  iconView.image = [UIImage imageNamed:@"weather-clear"];
  iconView.backgroundColor = [UIColor clearColor];
  iconView.contentMode = UIViewContentModeScaleAspectFit;
  [headerView addSubview:iconView];
  
  CGFloat iconHeight = 30.0f;
  [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(hiloLabel);
    make.bottom.equalTo(temperatureLabel.mas_top);
    make.size.mas_equalTo(CGSizeMake(iconHeight, iconHeight));
  }];
  
  // conditionsLabel
  UILabel *conditionsLabel = [[UILabel alloc] init];
  conditionsLabel.text = @"Clear";
  conditionsLabel.backgroundColor = [UIColor clearColor];
  conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
  conditionsLabel.textColor = [UIColor whiteColor];
  [headerView addSubview:conditionsLabel];
  
  [conditionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(iconView.mas_right).with.offset(10.0f);
    make.top.equalTo(iconView);
    CGFloat width = CGRectGetWidth(mainScreenBounds) - iconHeight - 20.0f - YHTableHeaderViewInset;
    make.width.mas_equalTo(@(width));
    make.height.mas_equalTo(@(iconHeight));
  }];
}

#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

@end
