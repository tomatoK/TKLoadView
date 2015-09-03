//
//  ViewController.m
//  loadingView
//
//  Created by qiukai on 15/9/3.
//  Copyright (c) 2015年 qiukai. All rights reserved.
//

#import "ViewController.h"
#import "TKLoadView.h"

@interface ViewController () <TKLoadViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TKLoadView *grayLargeLoadView = [self loadViewWithStyle:TKLoadViewStyleGrayLarge];
    grayLargeLoadView.delegate = self;
    grayLargeLoadView.transform = CGAffineTransformMakeTranslation(-50, -50);
    
    TKLoadView *grayLoadView =[self loadViewWithStyle:TKLoadViewStyleGray];
    grayLoadView.transform = CGAffineTransformMakeTranslation(50, -50);
    
    TKLoadView *greenLargeLoadView =[self loadViewWithStyle:TKLoadViewStyleGreenLarge];
    greenLargeLoadView.transform = CGAffineTransformMakeTranslation(-50, 50);
    
    TKLoadView *greenLoadView =[self loadViewWithStyle:TKLoadViewStyleGreen];
    greenLoadView.transform = CGAffineTransformMakeTranslation(50, 50);
    
    // compare with activityIndicatorView
    UIActivityIndicatorView *whiteLargeAiv = [self activityViewWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
    whiteLargeAiv.backgroundColor = [UIColor lightGrayColor];
    whiteLargeAiv.transform = CGAffineTransformMakeTranslation(-50, 0);
    
    UIActivityIndicatorView *whiteAiv = [self activityViewWithStyle:UIActivityIndicatorViewStyleWhite];
    whiteAiv.backgroundColor = [UIColor lightGrayColor];
    whiteAiv.transform = CGAffineTransformMakeTranslation(50, -20);
    
    UIActivityIndicatorView *grayAiv = [self activityViewWithStyle:UIActivityIndicatorViewStyleGray];
    grayAiv.transform = CGAffineTransformMakeTranslation(50, 20);
}

- (TKLoadView *)loadViewWithStyle:(TKLoadViewStyle)style
{
    TKLoadView *loadView = [[TKLoadView alloc] init];
    loadView.center = self.view.center;
    loadView.loadViewStyle = style;
    [self.view addSubview:loadView];
    [loadView startAnimating];
    return loadView;
}

- (UIActivityIndicatorView *)activityViewWithStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    activity.center = self.view.center;
    [self.view addSubview:activity];
    [activity startAnimating];
    return activity;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[TKLoadView class]]) {
            TKLoadView *loadView = (TKLoadView *)subview;
            if (loadView.isAnimating) {
                [loadView stopAnimating];
            } else {
                [loadView startAnimating];
            }
        }
        
        if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)subview;
            if (aiv.isAnimating) {
                [aiv stopAnimating];
            } else {
                [aiv startAnimating];
            }
        }
    }
}

- (BOOL)loadViewShouldKeepAnimating:(TKLoadView *)loadView
{
    NSLog(@"animating");
    //  你可以在这里做条件判断：
    //  当xx时，return YES; 当xxx时，return NO;
    return YES;
}

- (void)loadViewDidStopAnimating:(TKLoadView *)loadView
{
    NSLog(@"over");
}

@end
