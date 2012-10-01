//
//  BBDigitLabel.m
//  Mastermind
//
//  Created by Martin Volerich on 9/30/12.
//  Copyright (c) 2012 Bill Bear. All rights reserved.
//

#import "BBDigitLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface BBDigitLabel()
@end

@implementation BBDigitLabel

#define DIGIT_0     [@"1" characterAtIndex:0]

- (void)setDigit:(NSInteger)digit
{
    digit = abs( digit % 10 );
    self.text = [NSString stringWithFormat:@"%c", DIGIT_0 + digit - 1];
}

- (NSInteger)digit
{
    return [self.text characterAtIndex:0] - DIGIT_0 + 1;
}

- (void)bumpUp
{
    self.digit += 1;
}

- (void)bumpDown
{
    int digit = self.digit - 1;
    if (digit < 0) digit = 9;
    self.digit = digit;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isValidDigit = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    self.isValidDigit = YES;
}

- (UIImage *)labelBackground
{
    NSString *imageName = self.isValidDigit ? @"swipe_label_bg_green" : @"swipe_label_bg_red";
    return [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
}

- (void)drawRect:(CGRect)rect
{
    [[self labelBackground] drawInRect:self.bounds];
    
    [super drawRect:rect];
}

- (void)setIsValidDigit:(BOOL)isValidDigit
{
    _isValidDigit = isValidDigit;
    [self setNeedsDisplay];
}





@end
