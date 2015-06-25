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

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupBackgroundAndBlurredImageView];
  [self setupTableView];
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
