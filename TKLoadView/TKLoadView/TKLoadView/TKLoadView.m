//
//  TKLoadView.m
//  loadingView
//
//  Created by qiukai on 15/9/3.
//  Copyright (c) 2015年 qiukai. All rights reserved.
//

#import "TKLoadView.h"
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
@interface TKLoadView ()
@property (strong, nonatomic) UIImageView *rotateImageView;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TKLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounds = [self interceptRect:CGRectZero];
        _hidesWhenStopped = YES;
        
        _rotateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self rotateImageName]]];
        _rotateImageView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rotateImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [_rotateImageView setCenter:(CGPoint){ CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) }];
        [self addSubview:_rotateImageView];
    }
    return self;
}

- (NSString *)rotateImageName
{
    NSString *imageName;
    switch (_loadViewStyle) {
        case TKLoadViewStyleGreenLarge:
        case TKLoadViewStyleGreen:
            imageName = @"load_roate_green";
            break;
        case TKLoadViewStyleGrayLarge:
        case TKLoadViewStyleGray:
            imageName = @"load_roate_gray";
            break;
        default:
            break;
    }
    return imageName;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[self interceptRect:frame]];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:[self interceptRect:bounds]];
}

static const CGFloat largeWH = 37;
static const CGFloat normalWH = 20;

/**
 *   拦截Size
 */
- (CGRect)interceptRect:(CGRect)rect
{
    switch (self.loadViewStyle) {
        case TKLoadViewStyleGreenLarge:
        case TKLoadViewStyleGrayLarge:
        {
            rect.size.width = largeWH;
            rect.size.height = largeWH;
            break;
        }
        case TKLoadViewStyleGreen:
        case TKLoadViewStyleGray:
        {
            rect.size.width = normalWH;
            rect.size.height = normalWH;
            break;
        }
        default:
            break;
    }
    return rect;
}

- (void)setLoadViewStyle:(TKLoadViewStyle)loadViewStyle
{
    _loadViewStyle = loadViewStyle;
    
    [self.rotateImageView setImage:[UIImage imageNamed:[self rotateImageName]]];
    
    CGPoint origCenter = self.center;
    self.frame = CGRectZero;
    self.center = origCenter;
}

static NSString *const kAnimationKey = @"rotation";

- (void)startAnimating
{
    self.hidden = NO;
    self.animating = YES;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(Angle2Radian(0)),  @(Angle2Radian(-180)), @(Angle2Radian(-360))];
    anim.duration = 1;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [self.rotateImageView.layer addAnimation:anim forKey:kAnimationKey];
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(executeFunctionPerSecond) userInfo:nil repeats:YES];
    }
}

- (void)stopAnimating
{
    [self.rotateImageView.layer removeAnimationForKey:kAnimationKey];
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
    
    self.animating = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadViewDidStopAnimating:)]) {
        [self.delegate loadViewDidStopAnimating:self];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)executeFunctionPerSecond
{
    if (!self.isAnimating) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadViewShouldKeepAnimating:)]) {
        BOOL keepAnimating = [self.delegate loadViewShouldKeepAnimating:self];
        if (!keepAnimating) {
            [self stopAnimating];
        }
    }
}

@end
