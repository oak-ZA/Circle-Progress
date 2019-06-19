//
//  ProgressView.h
//  CircleProgressView
//
//  Created by 张奥 on 2019/6/12.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
//轨迹宽度
@property (nonatomic,assign) CGFloat trackWidth;
//动画时间
@property (nonatomic,assign) CGFloat duration;
//进度 0~1
@property (nonatomic,assign) CGFloat progress;
//顺时针还是逆时针 yes:顺时针  NO: 逆时针
//@property (nonatomic,assign) BOOL clockwise;
//开始动画
-(void)startAnimation;
@end
