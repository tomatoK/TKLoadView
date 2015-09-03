//
//  TKLoadView.h
//  loadingView
//
//  Created by qiukai on 15/9/3.
//  Copyright (c) 2015年 qiukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKLoadView;

typedef NS_ENUM(NSInteger, TKLoadViewStyle) {
    TKLoadViewStyleGreenLarge,
    TKLoadViewStyleGreen,
    TKLoadViewStyleGrayLarge,
    TKLoadViewStyleGray
};

@protocol TKLoadViewDelegate <NSObject>
@optional

- (BOOL)loadViewShouldKeepAnimating:(TKLoadView *)loadView;;
- (void)loadViewDidStopAnimating:(TKLoadView *)loadView;

@end

@interface TKLoadView : UIView

@property (assign, nonatomic) TKLoadViewStyle loadViewStyle;
@property (assign, nonatomic) BOOL hidesWhenStopped;   // 默认YES
@property (assign, nonatomic, getter=isAnimating) BOOL animating;
@property (weak, nonatomic) id<TKLoadViewDelegate> delegate;

- (void)startAnimating;
- (void)stopAnimating;

@end
