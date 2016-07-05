//
//  ViewController.m
//  LZFInfiniteScrollView
//
//  Created by 梁梓烽 on 16/7/5.
//  Copyright © 2016年 liangzifeng. All rights reserved.
//

#import "ViewController.h"

#import "LZFInfiniteScrollView.h"

@interface ViewController ()<LZFInfiniteScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LZFInfiniteScrollView *view=[[LZFInfiniteScrollView alloc]init];
    
    
    view.images=@[[UIImage imageNamed:@"img_00"],
                  [UIImage imageNamed:@"img_01"],
                  [NSURL URLWithString:@"http://tupian.enterdesk.com/2013/mxy/12/10/15/3.jpg"],
                  [UIImage imageNamed:@"img_03"],
                  [UIImage imageNamed:@"img_03"],
                  [NSURL URLWithString:@"http://pic4.nipic.com/20091215/2396136_140959028451_2.jpg"]
                  ];
    view.delegate=self;
    
    
    view.frame=CGRectMake(0, 0, 375, 200);
    [self.view addSubview:view];
    
}

-(void)infiniteScrollView:(LZFInfiniteScrollView *)infiniteScrollView didClickImage:(NSInteger)index
{
    NSLog(@"%ld",index);
}
@end
