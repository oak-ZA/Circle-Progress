//
//  ProgressView.m
//  CircleProgressView
//
//  Created by 张奥 on 2019/6/12.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import "ProgressView.h"
#define ViewWidth self.bounds.size.width
#define ViewHeight self.bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
@interface ProgressView()<CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView *pointImage;
//半径
@property (nonatomic,assign) CGFloat radius;
//火焰色宽度
@property (nonatomic, assign) CGFloat pointWidth;
//上一次的进度
@property (nonatomic,assign) CGFloat lastProgress;
@property (nonatomic,assign) CGFloat currentAngle;
@property (nonatomic,assign) CGFloat lastAngle;
@end
@implementation ProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor redColor];
        self.trackWidth = 5.f;
        self.pointWidth = 20.f;
        self.duration = 1.f;
        self.lastProgress = 0.0;
        self.lastAngle = 1.5f*M_PI;
        self.progress = 0.0;
//        self.clockwise = NO;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    [self initSubViews];
    
}
//背景圆环
-(CAShapeLayer *)backLayer{
    if (!_backLayer) {
        //背景圆环
        _backLayer = [CAShapeLayer layer];
        _backLayer.frame = self.bounds;
        _backLayer.fillColor =  [[UIColor clearColor] CGColor];
        _backLayer.strokeColor  = [UIColor blueColor].CGColor;
        _backLayer.lineWidth = self.trackWidth;
        _backLayer.path = [self getBezierPath].CGPath;
        _backLayer.strokeEnd = 1;
        [self.layer addSublayer:_backLayer];
    }
    return _backLayer;
}
//轨迹
-(CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        //进度layer
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        _progressLayer.strokeColor  = [UIColor yellowColor].CGColor;
        _progressLayer.lineWidth = self.trackWidth;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.path = [self getBezierPath].CGPath;
        _progressLayer.strokeEnd = 0.0;
    }
    return _progressLayer;
}
//渐变色
-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        //设置渐变颜色
        _gradientLayer =  [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        [_gradientLayer setColors:@[(id)[UIColorFromRGB(0XFD5B98) CGColor],(id)[UIColorFromRGB(0XF678F8) CGColor]]];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        [_gradientLayer setMask:self.progressLayer]; //用progressLayer来截取渐变层
    }
    return _gradientLayer;
}
//火焰图片
-(UIImageView *)pointImage{
    if (!_pointImage) {
        _pointImage = [[UIImageView alloc] init];
        _pointImage.image = [UIImage imageNamed:@"heat_icon"];
        _pointImage.frame = CGRectMake(0, 0, self.pointWidth, self.pointWidth);
    }
    return _pointImage;
}
-(void)initSubViews{
    [self.layer addSublayer:self.backLayer];
    [self.layer addSublayer:self.gradientLayer];
    [self addSubview:self.pointImage];
}
-(void)updatePointPosition:(CGFloat)currentAngle{
//    [self.pointImage.layer removeAllAnimations];
    self.pointImage.center = CGPointMake(ViewWidth/2.0+_radius*cosf(currentAngle), ViewWidth/2.0+_radius*sinf(currentAngle));
}
-(UIBezierPath *)getBezierPath{
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(ViewWidth/2, ViewHeight/2) radius:self.radius startAngle:(1.5f*M_PI) endAngle:-0.5f*M_PI clockwise:NO];
}
-(CAAnimation *)pathAnimation{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = _duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:self.lastProgress];
    pathAnimation.toValue = [NSNumber numberWithFloat:self.progress];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    return pathAnimation;
}
-(CAAnimation *)pointAnimation{
    CAKeyframeAnimation *pointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pointAnimation.repeatCount = 1;
    pointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pointAnimation.removedOnCompletion = NO;
    pointAnimation.fillMode = kCAFillModeForwards;
    pointAnimation.duration = self.duration;
    pointAnimation.delegate = self;
    
    BOOL clockWise = NO;
    if (_progress<_lastProgress) {
        clockWise = YES;
    }
    UIBezierPath *imagePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(ViewWidth/2.f, ViewWidth/2.f) radius:self.radius startAngle:self.lastAngle endAngle:self.currentAngle clockwise:clockWise];
    pointAnimation.path = imagePath.CGPath;
    self.lastAngle = self.currentAngle;
    //移动到最前
    [self bringSubviewToFront:self.pointImage];
    return pointAnimation;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self updatePointPosition:1.5f*M_PI];
}

-(void)startAnimation{
    [self.progressLayer addAnimation:[self pathAnimation] forKey:@"strokeEndAnimation"];
    [self.pointImage.layer addAnimation:[self pointAnimation] forKey:@"pointAnimation"];
}
-(void)setTrackWidth:(CGFloat)trackWidth{
    _trackWidth = trackWidth;
    self.radius = (self.bounds.size.width - self.trackWidth)/2.f;
}
-(void)setDuration:(CGFloat)duration{
    _duration = duration;
}
-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    //计算单前弧度
    self.currentAngle = 1.5f*M_PI - M_PI*2*progress;
    [self startAnimation];
    [self updatePointPosition:self.currentAngle];
    self.lastProgress = progress;
}
//-(void)setClockwise:(BOOL)clockwise{
//    _clockwise = clockwise;
//}
@end
