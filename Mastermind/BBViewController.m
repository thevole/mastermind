//
//  BBViewController.m
//  Mastermind
//
//  Created by Martin Volerich on 9/30/12.
//  Copyright (c) 2012 Bill Bear. All rights reserved.
//

#import "BBViewController.h"
#import "BBDigitLabel.h"

#define NUM_DIGITS 4

@interface BBViewController ()
@property (weak, nonatomic) IBOutlet BBDigitLabel *digit1Label;
@property (weak, nonatomic) IBOutlet BBDigitLabel *digit2Label;
@property (weak, nonatomic) IBOutlet BBDigitLabel *digit3Label;
@property (weak, nonatomic) IBOutlet BBDigitLabel *digit4Label;

@property (weak, nonatomic) IBOutlet UIButton *guessButton;

@property (strong, nonatomic) NSArray *digitLabels;

@end

@implementation BBViewController

- (void)setInitialValues
{
    int ascii = [@"1" characterAtIndex:0];
    for (int i = 0; i < NUM_DIGITS; i++) {
        ((UILabel *)self.digitLabels[i]).text = [NSString stringWithFormat:@"%c", ascii + i];
    }
}

- (NSArray *)digitLabels {
    if (!_digitLabels) {
        _digitLabels = @[
            self.digit1Label,
            self.digit2Label,
            self.digit3Label,
            self.digit4Label
        ];
    }
    return _digitLabels;
}

- (void)handleDigitSwipe:(UISwipeGestureRecognizer *)recognizer
{
    BBDigitLabel *digitLabel = (BBDigitLabel *)recognizer.view;
    NSLog(@"Swiped over %@ - direction %d", digitLabel.text, recognizer.direction);
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            [digitLabel bumpUp];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [digitLabel bumpDown];
            break;
        default:
            break;
    }
    [self validateGuess];
}

- (void)showErrorForDigit:(NSInteger) digit
{
    [self.digitLabels enumerateObjectsUsingBlock:^(BBDigitLabel *digitLabel, NSUInteger idx, BOOL *stop) {
        
        digitLabel.isValidDigit = (digitLabel.digit != digit);
        
    }];
}

- (void)resetColorForDigits
{
    [self.digitLabels enumerateObjectsUsingBlock:^(BBDigitLabel *digitLabel, NSUInteger idx, BOOL *stop) {
        digitLabel.isValidDigit = YES;
    }];
}

- (void)validateGuess
{
   [self resetColorForDigits];
    NSMutableSet *digits = [NSMutableSet set];
    [self.digitLabels enumerateObjectsUsingBlock:^(BBDigitLabel *digitLabel, NSUInteger idx, BOOL *stop) {
        NSNumber *digit = @(digitLabel.digit);
        if ([digits containsObject:digit]) {
            [self showErrorForDigit:(NSInteger) digit.integerValue];
        }
        [digits addObject:digit];
    }];
    self.guessButton.enabled = ( [digits count] == 4 );
    
}


- (void)handleDigitTap:(UITapGestureRecognizer *)recognizer
{
    BBDigitLabel *digitLabel = (BBDigitLabel *)recognizer.view;
    NSLog(@"Tapped on %@ with %d", digitLabel.text, digitLabel.digit);
    [digitLabel bumpUp];
    [self validateGuess];
}

- (void)setupGestures
{
    for (BBDigitLabel *digitLabel in self.digitLabels) {
        UISwipeGestureRecognizer *swipeRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDigitSwipe:)];
        swipeRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
        
        UISwipeGestureRecognizer *swipeRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDigitSwipe:)];
        swipeRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDigitTap:)];

        [digitLabel addGestureRecognizer:swipeRecognizerUp];
        [digitLabel addGestureRecognizer:swipeRecognizerDown];
        [digitLabel addGestureRecognizer:tapRecognizer];

    }
}

- (IBAction)handleGuess:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Mastermind"
                              message:@"Processing your guess..."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setInitialValues];
    [self setupGestures];
    [self.guessButton setTitle:@"Make Guess" forState:UIControlStateNormal];
    [self.guessButton setTitle:@"Enter 4 different digits" forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
