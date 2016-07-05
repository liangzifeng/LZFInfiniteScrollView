//
//  LZFInfiniteScrollView.h
//  LZFInfiniteScrollView
//
//  Created by 梁梓烽 on 16/7/5.
//  Copyright © 2016年 liangzifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZFInfiniteScrollView;
@protocol LZFInfiniteScrollViewDelegate <NSObject>

-(void)infiniteScrollView:(LZFInfiniteScrollView * )infiniteScrollView didClickImage:(NSInteger)index;

@end

@interface LZFInfiniteScrollView : UIView
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)UIImage *placeHolderImage;
@property(nonatomic,weak)id delegate;
@end
