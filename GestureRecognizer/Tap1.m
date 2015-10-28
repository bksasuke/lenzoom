
//  Tap.m

#import "Tap1.h"

@interface Tap1 () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) CGFloat rectAngelRadius;
@property (nonatomic) CGPoint rectAngelCenter;

@property (nonatomic, weak) CAShapeLayer *maskLayer;
@property (nonatomic, weak) CAShapeLayer *rectAngelLayer;

@property (nonatomic, weak) UIPinchGestureRecognizer *pinch;
@property (nonatomic, weak) UIPanGestureRecognizer   *pan;

@end

@implementation Tap1

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create layer mask for the image
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    self.imageView.layer.mask = maskLayer;
    self.maskLayer = maskLayer;
    
    // create shape layer for rectangel we'll draw on top of image (the boundary of the rectAngel)
    
    CAShapeLayer *rectAngelLayer = [CAShapeLayer layer];
    rectAngelLayer.lineWidth = 3.0;
    rectAngelLayer.fillColor = [[UIColor clearColor] CGColor];
    rectAngelLayer.strokeColor = [[UIColor blackColor] CGColor];
    [self.imageView.layer addSublayer:rectAngelLayer];
    self.rectAngelLayer = rectAngelLayer;
    
    // create rectAngelCenter path
    
    [self updaterectAngelPathAtLocation:CGPointMake(self.view.bounds.size.width*.5,self.view.bounds.size.height*0.5) radius:self.view.bounds.size.width * 0.30];
    
    // create pan gesture
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    [self.imageView addGestureRecognizer:pan];
    self.imageView.userInteractionEnabled = YES;
    self.pan = pan;
    
    // create pan gesture
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    self.pinch = pinch;
}

- (void)updaterectAngelPathAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    self.rectAngelCenter = location;
    self.rectAngelRadius = radius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];

  
    [path moveToPoint:CGPointMake(self.rectAngelCenter.x, self.rectAngelCenter.y-self.rectAngelRadius)]; // start at top point of square
    [path addLineToPoint:CGPointMake(self.rectAngelCenter.x+self.rectAngelRadius, self.rectAngelCenter.y)]; // draw line to right point
    [path addLineToPoint:CGPointMake(self.rectAngelCenter.x, self.rectAngelCenter.y+self.rectAngelRadius)]; // draw line to bottom point
    [path addLineToPoint:CGPointMake(self.rectAngelCenter.x-self.rectAngelRadius, self.rectAngelCenter.y)]; // draw line to left point
    [path addLineToPoint:CGPointMake(self.rectAngelCenter.x, self.rectAngelCenter.y-self.rectAngelRadius)]; // the last line is connect to starting point
    
    self.maskLayer.path = [path CGPath];
    self.rectAngelLayer.path = [path CGPath];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    static CGPoint oldCenter;
    CGPoint tranlation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        oldCenter = self.rectAngelCenter;
    }
    
    CGPoint newCenter = CGPointMake(oldCenter.x + tranlation.x, oldCenter.y + tranlation.y);
    
    [self updaterectAngelPathAtLocation:newCenter radius:self.rectAngelRadius];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    static CGFloat oldRadius;
    CGFloat scale = [gesture scale];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        oldRadius = self.rectAngelRadius;
    }
    
    CGFloat newRadius = oldRadius * scale;
    
    [self updaterectAngelPathAtLocation:self.rectAngelCenter radius:newRadius];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ((gestureRecognizer == self.pan   && otherGestureRecognizer == self.pinch) ||
        (gestureRecognizer == self.pinch && otherGestureRecognizer == self.pan))
    {
        return YES;
    }
    
    return NO;
}

@end