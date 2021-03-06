//
//  BYPullScrollView.m
//  Apsiape
//
//  Created by Dario Lass on 02.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BYPullScrollView.h"

@interface BYPullScrollView () <UIScrollViewDelegate>

@property (nonatomic, readwrite) BYEdgeType currentPullingEdge;

- (void)handleVerticalPullWithOffset:(CGFloat)offset;
- (void)handleHorizontalPullWithOffset:(CGFloat)offset;
- (void)pullingDetectedForEdge:(BYEdgeType)edge;

@end

@implementation BYPullScrollView

#define NUMBER_OF_PAGES 2.0f
#define MIN_PULL_VALUE 80

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.currentPullingEdge = 0;
    
    if (!self.childScrollView) self.childScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    
    self.delegate = self;
    self.childScrollView.delegate = self;
    
    self.contentSize = self.frame.size;
    self.childScrollView.frame = self.bounds;
    self.childScrollView.pagingEnabled = YES;
    self.childScrollView.contentSize = CGSizeMake(self.frame.size.width * NUMBER_OF_PAGES, self.frame.size.height);
    self.childScrollView.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceVertical = YES;
    [self addSubview:self.childScrollView];
    self.layer.masksToBounds = YES;
    
    UIColor *lightGreen = [UIColor colorWithRed:0.4 green:0.9 blue:0.4 alpha:.5];
    UIColor *lightRed = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:.5];
    
    CGFloat pullViewHeight = 800;
    UIView *topPullView = [[UIView alloc]initWithFrame:CGRectMake(0, - pullViewHeight, self.frame.size.width, pullViewHeight)];
    topPullView.backgroundColor = lightGreen;
    CALayer *checkmarkLayer = [CALayer layer];
    checkmarkLayer.frame = CGRectMake(130, 720, 60, 60);
//    checkmarkLayer.contents = (__bridge id)([[UIImage imageNamed:@"add.png"] CGImage]);
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [checkmarkLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [topPullView.layer addSublayer:checkmarkLayer];
    [self addSubview:topPullView];
    UIView *bottomPullView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, pullViewHeight)];
    bottomPullView.backgroundColor = lightRed;
    [self addSubview:bottomPullView];
    UIView *rightPullView = [[UIView alloc]initWithFrame:CGRectMake(self.childScrollView.contentSize.width, 0, pullViewHeight, self.childScrollView.contentSize.height)];
    rightPullView.backgroundColor = lightGreen;
    [self.childScrollView addSubview:rightPullView];
    UIView *leftPullView = [[UIView alloc]initWithFrame:CGRectMake(- pullViewHeight, 0, pullViewHeight, self.childScrollView.contentSize.height)];
    leftPullView.backgroundColor = lightRed;
    [self.childScrollView addSubview:leftPullView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self) {
        [self handleVerticalPullWithOffset:scrollView.contentOffset.y];
    } else if (scrollView == self.childScrollView) {
        [self handleHorizontalPullWithOffset:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.currentPullingEdge != BYEdgeTypeNone) {
        [self pullingDetectedForEdge:self.currentPullingEdge];
    }
}

#pragma mark - Pull gesture handling

- (void)handleVerticalPullWithOffset:(CGFloat)offset
{
    if (offset < - MIN_PULL_VALUE) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeTop;
        }
    } else if (offset > MIN_PULL_VALUE) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeBottom;
        }
    } else if ((offset < - MIN_PULL_VALUE || offset < MIN_PULL_VALUE)){
        self.currentPullingEdge = BYEdgeTypeNone;
    }
}

- (void)handleHorizontalPullWithOffset:(CGFloat)offset
{
    CGFloat lastPageOffset = self.childScrollView.contentSize.width * ((NUMBER_OF_PAGES - 1)/(NUMBER_OF_PAGES));
    
    if (offset < - MIN_PULL_VALUE) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeLeft;
        }
    } else if (offset > MIN_PULL_VALUE + lastPageOffset) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeRight;
        }
    } else if (offset < -MIN_PULL_VALUE || offset < (MIN_PULL_VALUE + lastPageOffset)){
        self.currentPullingEdge = BYEdgeTypeNone;
    }
}

- (void)pullingDetectedForEdge:(BYEdgeType)edge
{
    if ([self.pullScrollViewDelegate respondsToSelector:@selector(pullScrollView:didDetectPullingAtEdge:)]) {
        [self.pullScrollViewDelegate pullScrollView:self didDetectPullingAtEdge:self.currentPullingEdge];
    }
}

@end
