//
//  BLCAwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Joseph Blanco on 5/25/15.
//  Copyright (c) 2015 Blancode. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"



@interface BLCAwesomeFloatingToolbar () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *forwardButton;
@property(nonatomic, strong) UIButton *stopButton;
@property(nonatomic, strong) UIButton *refreshButton;

@end

@implementation BLCAwesomeFloatingToolbar


-(instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        self.buttons = @[self.backButton, self.forwardButton, self.stopButton, self.refreshButton];
        
        self.buttonsArray = [self.buttons mutableCopy];
        
        // Make the 4 Buttons
        for (UIButton *thisButton in self.buttons) {
            NSUInteger buttonIndex = [self.buttons indexOfObject:thisButton]; // 0 through 3
            UIColor *buttonColor = [self.colors objectAtIndex:buttonIndex];
            [[self.buttonsArray objectAtIndex:buttonIndex] setBackgroundColor:buttonColor];
            [[self.buttonsArray objectAtIndex:buttonIndex] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[self.buttonsArray objectAtIndex:buttonIndex] setTitle:[self.currentTitles objectAtIndex:buttonIndex] forState: UIControlStateNormal];
            [[self.buttonsArray objectAtIndex:buttonIndex] setBackgroundColor:buttonColor];
            [[self.buttonsArray objectAtIndex:buttonIndex] setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
            [[self.buttonsArray objectAtIndex:buttonIndex] addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [[self.buttonsArray objectAtIndex:buttonIndex] setAlpha:0.25];
            
        }
        self.buttons = self.buttonsArray;

        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
//        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPress:)];
//        [self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    
    return self;
}


- (void) layoutSubviews {
    
        CGFloat buttonHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        if (currentButtonIndex < 2) {
            buttonY = 0;
        } else {
            buttonY = CGRectGetHeight(self.bounds) / 2;
        }
        if (currentButtonIndex % 2 == 0) {
            buttonX = 0;
        } else {
            buttonX = CGRectGetWidth(self.bounds) / 2;
        }
        thisButton.frame = CGRectMake(buttonX * 1.01 , buttonY *1.05, buttonWidth, buttonHeight);
    }
}

#pragma mark - Touch Handling


//- (UIButton *) buttonFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//        UITouch *touch = [touches anyObject];
//        CGPoint location = [touch locationInView:self];
//        UIView *subview = [self hitTest:location withEvent:event];
//
//        return (UIButton *)subview;
//    
//}


//- (void) tapFired:(UITapGestureRecognizer *)recognizer {
//    if (recognizer.state == UIGestureRecognizerStateRecognized) {
//        CGPoint location = [recognizer locationInView:self];
//        UIView *tappedView = [self hitTest:location withEvent:nil];
//        UIButton *test = [self.buttonsArray objectAtIndex:1];
//          NSLog(@"%@",test.currentTitle);
//            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
//            }
//        }
//    }



- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = [recognizer scale];
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]){
            [self.delegate floatingToolbar:self didTryToPinchWithScale:scale];
        }
        
    }
}

- (void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded){ //keeps it from firing twice
        NSMutableArray *colorArray = [self.colors mutableCopy]; //temporary array
        [colorArray removeObject:colorArray[0]];
        [colorArray addObject:self.colors[0]];
        self.colors = colorArray; //reassign color array
    
        for (int i=0; i < self.buttons.count; i++) { // for loop for each label
            UIColor *color = [self.colors objectAtIndex:i]; //grab color for item
            [[self.buttonsArray objectAtIndex:i] setBackgroundColor:color]; //reassign color to mutable label array
        }
        self.buttons = self.buttonsArray; // reassign label array
        
    }
    
}

#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}

- (void)buttonPressed:(UIButton *)sender {
    UIButton *pressedButton = sender;
    
    if ([self.delegate
         respondsToSelector:@selector(floatingToolbar:didSelectButton:)]) {
        [self.delegate floatingToolbar:self didSelectButton:(UIButton *)pressedButton];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
*/
@end

