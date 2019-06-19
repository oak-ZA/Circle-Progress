//
//  ViewController.m
//  CircleProgressView
//
//  Created by 张奥 on 2019/6/12.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"
@interface ViewController ()
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) ProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake(100, 200, 180, 180)];
    self.progressView = progressView;
    [self.view addSubview:progressView];
    progressView.progress = 0.0;
    
    [self createSlide];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 450, 80, 80);
    [button setTitle:@"点我" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)createSlide{
    //创建滑动条对象
    UISlider *slider=[[UISlider alloc]init];
    slider.frame=CGRectMake(50,400,300,40);
    slider.maximumValue=1;
    slider.minimumValue=0;
    slider.value=0.5;
    slider.minimumTrackTintColor=[UIColor blueColor];
    slider.maximumTrackTintColor=[UIColor grayColor];
    slider.thumbTintColor=[UIColor orangeColor];
    [slider addTarget:self action:@selector(pressSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

-(void)pressSlider:(UISlider*)slider{
    CGFloat progress = slider.value;
    self.progressView.progress = progress;
}

-(void)clickButton:(UIButton*)button{
    self.progressView.progress = [self acrRandom];
}
-(float)acrRandom{
    int x = arc4random() % 100;
    float y = (float)x / 100;
    return y;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
