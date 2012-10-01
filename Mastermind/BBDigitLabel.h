//
//  BBDigitLabel.h
//  Mastermind
//
//  Created by Martin Volerich on 9/30/12.
//  Copyright (c) 2012 Bill Bear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBDigitLabel : UILabel

@property (assign, nonatomic) NSInteger digit;
@property (assign, nonatomic) BOOL isValidDigit;

- (void)bumpUp;
- (void)bumpDown;

@end
