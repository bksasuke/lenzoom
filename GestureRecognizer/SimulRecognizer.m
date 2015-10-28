//
//  SimulRecognizer.m
//  GestureRecognizer
//
//  Created by Cuong Trinh on 8/25/15.
//  Copyright (c) 2015 Cuong Trinh. All rights reserved.
//

#import "SimulRecognizer.h"

@interface SimulRecognizer () <UIGestureRecognizerDelegate>
@end

@implementation SimulRecognizer
{
    UIImageView* bullEye;
    UILabel* label;
    NSTimer* timer;
    NSDate* whenBullEyeBecomeBlue;
    
    UIPanGestureRecognizer* pan;
    UISwipeGestureRecognizer* swipe;
    UITapGestureRecognizer* tap;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Explain about this app
    label = [UILabel new];
    label.numberOfLines = 3;
    label.text = @"Nếu bulleye bắt sự kiện Swipe nó sẽ xanh";
    
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    
    label.frame = CGRectMake(8, 80, self.view.bounds.size.width - 16, labelSize.height);
    [self.view addSubview:label];

    bullEye = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BullEye.png"]];
    bullEye.center = CGPointMake(100, 200);
    bullEye.multipleTouchEnabled = true;
    bullEye.userInteractionEnabled = true;
    [self.view addSubview:bullEye];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBullEye:)];
    pan.delegate = self;
    [bullEye addGestureRecognizer:pan];
    

    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBullEye:)];
    swipe.delegate = self;
    
    //Only horizontal or vertical but not both side recognize together
    swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight |
                      UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    
    
    
    [bullEye addGestureRecognizer:swipe];
    
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(tapBullEye:)];
    tap.delegate = self;
    [bullEye addGestureRecognizer:tap];
    
    //[swipe requireGestureRecognizerToFail:pan];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(loop)
                                           userInfo:nil
                                            repeats:true];
}

- (void) loop {
    if (whenBullEyeBecomeBlue != nil) {
        NSTimeInterval timeInterval = [whenBullEyeBecomeBlue timeIntervalSinceNow];
        if (-timeInterval > 0.2) {
            whenBullEyeBecomeBlue = nil;
            bullEye.image = [UIImage imageNamed:@"BullEye.png"];
        }
    }
    
}

- (void) panBullEye: (UIPanGestureRecognizer*) panRec {
    if (panRec.state == UIGestureRecognizerStateBegan || panRec.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Pan");
        bullEye.center = [pan locationInView:self.view];
        //@package: only allow code inside library to access
        //NSLog(@"%ld", pan->_lastTouchCount);
    }
}


- (void) pressBullEye: (UILongPressGestureRecognizer*) press {
    bullEye.transform = CGAffineTransformScale(bullEye.transform, 1.1, 1.1);
}

- (void) swipeBullEye: (UISwipeGestureRecognizer*) swipeRec {
    if (swipeRec.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Swipe");
        whenBullEyeBecomeBlue = [NSDate date];
        bullEye.image = [UIImage imageNamed:@"blueBullEye.png"];
    }
}

- (void) tapBullEye: (UITapGestureRecognizer*) tapRec {
    if (tapRec.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Tap");
    }
}

/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return false;
}*/

/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        return true;
    } else {
        return false;
    }
}*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        return true;
    } else {
        return false;
    }
}
@end
