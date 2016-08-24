//
//  KYCuteView.m
//  KYCuteViewDemo
//
//  Created by Kitten Yang on 2/26/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYCuteView.h"
#define mScreen [UIScreen mainScreen].bounds
@implementation KYCuteView{
    
    UIBezierPath *cutePath;
    UIColor *fillColorForCute;
    UIDynamicAnimator *animator;
    UISnapBehavior  *snap;

    UIView *backView;
    CGFloat r1;
    CGFloat r2;
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    CGRect oldBackViewFrame;
    CGPoint initialPoint;
    CGPoint oldBackViewCenter;
    CAShapeLayer *shapeLayer;
    
}

-(id)initWithPoint:(CGPoint)point superView:(UIView *)view{
    self = [super initWithFrame:CGRectMake(point.x, point.y, self.bubbleWidth, self.bubbleHeight)];
    if(self){
        initialPoint = point;
        self.containerView = view;
        [self.containerView addSubview:self];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setBubbleWidth:(CGFloat)bubbleWidth{
    if (self.bubbleWidth != bubbleWidth && self.bubbleWidth) {
        _bubbleWidth = bubbleWidth;
        self.frame = CGRectMake(initialPoint.x-bubbleWidth/2, initialPoint.y, self.bubbleWidth, self.bubbleHeight);
        [self setUp];
    }else{
         _bubbleWidth = bubbleWidth;
    }
    
}
-(void)drawRect{
    if (self.isSubview) {
       backView.center = [self.cover convertPoint:backView.center fromView:self.containerView];
    }
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }
    
    r1 = oldBackViewFrame.size.height / 3 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    
    backView.center = oldBackViewCenter;
    backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
    backView.layer.cornerRadius = r1;
    
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    
    if (backView.hidden == NO) {
        shapeLayer.path = [cutePath CGPath];
        shapeLayer.fillColor = [fillColorForCute CGColor];
        if (self.isSubview) {
            
           [self.cover.layer insertSublayer:shapeLayer below:self.frontView.layer];
        }else{
           [self.containerView.layer insertSublayer:shapeLayer below:self.frontView.layer];
        }
        
    }

}

-(void)setUp{
    if (self.cover) {
        [self.cover removeFromSuperview];
    }
    if (self.frontView) {
        [self.frontView removeFromSuperview];
    }
    if (backView) {
        [backView removeFromSuperview];
    }
    UIView *cover = [[UIView alloc] init];
    self.cover = cover;
    cover.frame = mScreen;
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    cover.hidden = YES;
    
    shapeLayer = [CAShapeLayer layer];
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat moveX = self.bubbleWidth - 18;
    self.frontView = [[UIView alloc]initWithFrame:CGRectMake(initialPoint.x-moveX,initialPoint.y, self.bubbleWidth, self.bubbleHeight)];
    
    r2 = self.frontView.bounds.size.height / 2;
    self.frontView.layer.cornerRadius = r2;
    self.frontView.layer.masksToBounds = YES;
    self.frontView.backgroundColor = self.bubbleColor;
    
    
    
    backView = [[UIView alloc]initWithFrame:self.frontView.frame];
    r1 = backView.bounds.size.height / 2;
    backView.layer.cornerRadius = r1;
    backView.backgroundColor = self.bubbleColor;
    backView.layer.masksToBounds = YES;
    self.bubbleLabel = [[UILabel alloc]init];
    self.bubbleLabel.frame = CGRectMake(0, 0, self.frontView.bounds.size.width, self.frontView.bounds.size.height);
    self.bubbleLabel.textColor = [UIColor whiteColor];
    self.bubbleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.frontView insertSubview:self.bubbleLabel atIndex:0];

    [self.containerView addSubview:backView];
    [self.containerView addSubview:self.frontView];
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    pointA = CGPointMake(x1-r1,y1+200);   // A
    pointB = CGPointMake(x1+r1, y1+200);  // B
    pointD = CGPointMake(x2-r2, y2+200);  // D
    pointC = CGPointMake(x2+r2, y2+200);  // C
    pointO = CGPointMake(x1-r1,y1+200);   // O
    pointP = CGPointMake(x2+r2, y2+200);  // P
    
    oldBackViewFrame = backView.frame;
    oldBackViewCenter = backView.center;

    backView.hidden = YES;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDragGesture:)];
    [self.frontView addGestureRecognizer:pan];
    
}
-(void)handleDragGesture:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint ;

    if (self.isSubview) {
        dragPoint = [ges locationInView:self.cover];
    }else{
        dragPoint = [ges locationInView:self.containerView];
    }
        if (ges.state == UIGestureRecognizerStateBegan) {
        if (self.isSubview) {
            //将坐标转换到相对于窗口的坐标
            self.cover.hidden = NO;
            CGRect res = self.frontView.frame;
            self.frontView.frame = [self.cover convertRect:res fromView:self.containerView];
             self.frontView.backgroundColor = self.bubbleColor;
            self.cover.backgroundColor = [UIColor clearColor];
            [self.cover addSubview:self.frontView];
            [self.frontView insertSubview:self.bubbleLabel atIndex:0];
            //        [self.cover addSubview:backView];

        }
            backView.hidden = NO;
            fillColorForCute = self.bubbleColor;
            [self RemoveAniamtionLikeGameCenterBubble];
        
    }else if (ges.state == UIGestureRecognizerStateChanged){
        self.frontView.center = dragPoint;
        if (r1 <= 3) {
            fillColorForCute = [UIColor clearColor];
            backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];
        }
        [self drawRect];
    } else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed){
        self.cover.hidden = YES;
        backView.hidden = YES;
        fillColorForCute = [UIColor clearColor];
        [shapeLayer removeFromSuperlayer];
        [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.isSubview) {
                oldBackViewFrame = [self.cover convertRect:oldBackViewFrame fromView:self.containerView];
                oldBackViewCenter = [self.cover convertPoint:oldBackViewCenter fromView:self.containerView];

            }
            CGFloat valueX = fabs(dragPoint.x - oldBackViewCenter.x);
            CGFloat valueY = fabs(dragPoint.y - oldBackViewCenter.y);
            CGFloat valueXY = valueX*valueX + valueY*valueY;
            /**
             *  设置可以拖拽的最大长度
             */
            if (valueX > 120||valueY > 120 || valueXY > 120*120) {
                self.frontView.hidden = YES;
                if (self.returnBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.returnBlock(YES);
                    });
                }
                
            }else{
                if (self.returnBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.returnBlock(YES);
                    });
                }
                if (self.isSubview) {
                   oldBackViewCenter = [self.containerView convertPoint:oldBackViewCenter fromView:self.cover];
                    [self.containerView addSubview:self.frontView];
                    [self.frontView insertSubview:self.bubbleLabel atIndex:0];
                    self.frontView.backgroundColor = self.bubbleColor;
                }
                
                self.frontView.center = oldBackViewCenter;
                
            }
        } completion:^(BOOL finished) {
            if (finished) {
                //                [self addAniamtionLikeGameCenterBubble];
            }
        }];
    }

}

//---- 类似GameCenter的气泡晃动动画 ------

-(void)addAniamtionLikeGameCenterBubble {

    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frontView.frame, self.frontView.bounds.size.width / 2 - 3, self.frontView.bounds.size.width / 2 - 3);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;

    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    

    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

-(void)RemoveAniamtionLikeGameCenterBubble {
    [self.frontView.layer removeAllAnimations];
}


@end
