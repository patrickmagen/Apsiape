//
//  BYCollectionViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BYCollectionViewCell.h"
#import "Expense.h"

#pragma mark ––– UICollectionViewCellContentView implementation

@interface BYCollectionViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *foregroundImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, readwrite) BOOL panIsElastic;
@property (nonatomic, readwrite) CGFloat panElasticityStartingPoint;
@property (nonatomic, readwrite) CGFloat lastOffset;

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGestureRecognizer;
- (void)didStartSwiping;
- (void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity;
- (void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity;
- (void)changeContentViewPositionForPanningOffset:(CGFloat)offset;
- (void)changeCellStateForCurrentOffset:(CGFloat)offset;

@end

@implementation BYCollectionViewCell

#define THRESHOLD 80

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont fontWithName:@"Miso" size:44];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        self.imageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.foregroundImageView];
        [self.contentView addSubview:self.label];
        self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        
        self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.panRecognizer];
        
        self.panIsElastic = YES;
        self.panElasticityStartingPoint = 80;
    }
    return self;
}

//determine wether the pan is horizontal or not
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if ([panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
        return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
    } else {
        return NO;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        CGFloat deltaX = (translation.x - self.lastOffset) * .5;
        self.lastOffset = translation.x;
        self.contentView.frame = CGRectOffset(self.contentView.frame, deltaX, 0);
    }
}

- (void)changeContentViewPositionForPanningOffset:(CGFloat)offset
{
    self.contentView.frame = CGRectOffset(self.contentView.bounds, offset, 0);
}

- (void)changeCellStateForCurrentOffset:(CGFloat)offset
{
    NSLog(@"Möp");
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = _title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = _image;
}

- (void)setBgIsGreen:(BOOL)bgIsGreen
{
    if (bgIsGreen) self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1]; else self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    rect.size.height = self.contentView.bounds.size.height/1.5f;
    rect.origin.x = self.frame.size.height;
    self.label.frame = CGRectInset(rect, 10, 10);
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.imageView.frame = CGRectInset(self.imageView.frame, 5, 5);
    self.imageView.layer.cornerRadius = 5;
        
    CALayer *borderLayer = [CALayer layer];
    borderLayer.borderColor = [UIColor blackColor].CGColor;
    borderLayer.borderWidth = 0.5;
    borderLayer.frame = self.bounds;
//    [self.contentView.layer addSublayer:borderLayer];
}

- (void)didMoveToSuperview
{
    
}

@end



