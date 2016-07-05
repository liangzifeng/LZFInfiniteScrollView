//
//  LZFInfiniteScrollView.m
//  LZFInfiniteScrollView
//
//  Created by 梁梓烽 on 16/7/5.
//  Copyright © 2016年 liangzifeng. All rights reserved.
//

#import "LZFInfiniteScrollView.h"
#import "UIImageView+WebCache.h"



/*===========LZFCell begin==============================================================*/
@interface LZFCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation LZFCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        UIImageView *imageView=[[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        self.imageView=imageView;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame=self.bounds;
    
}
@end

/*=================LZFCell end=========================================================*/


@interface LZFInfiniteScrollView  ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)NSTimer *timer;

@end

@implementation LZFInfiniteScrollView

static  NSString * const ID=@"infiniteCell";
static  NSInteger LZFImageCount =100;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //flowlayout设置
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing=0;
        
        //collectionView设置
        UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.collectionView=collectionView;
        collectionView.dataSource=self;
        collectionView.delegate=self;
        collectionView.showsHorizontalScrollIndicator=NO;
        collectionView.showsVerticalScrollIndicator=NO;
        collectionView.pagingEnabled=YES;
        [self addSubview:collectionView];
        
        //注册cell
        [collectionView registerClass:[LZFCell class] forCellWithReuseIdentifier:ID];
        
        //设置默认的占位图片
        self.placeHolderImage=[UIImage imageNamed:@"LZFInfiniteScrollView2封装版.bundle/placeholderImage"];

        
    }
    
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame=self.bounds;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize=self.bounds.size;
}


-(void)setImages:(NSArray *)images

{
    _images=images;
    //让collection一开始就滚到中间第50gecell中
    
    
    //延迟一些时间执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(LZFImageCount*self.images.count)/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
    

    
    [self startTimer];
}


#pragma mark datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return LZFImageCount*self.images.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LZFCell  *item=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    id  data =self.images[indexPath.item%self.images.count];
    
    if ([data isKindOfClass:[UIImage class]]){
        item.imageView.image=data;
    }
    else if ([data isKindOfClass:[NSURL class ]])
    {
        [item.imageView sd_setImageWithURL:data placeholderImage:self.placeHolderImage];
    }
    return item;
}

#pragma mark  collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didClickImage:)]) {
        [self.delegate infiniteScrollView:self didClickImage:indexPath.item%self.images.count];
    }
}


//结束定时器
-(void)stopTimer
{
    [self.timer invalidate];
    self.timer=nil;
}

//开始定时器
-(void)startTimer
{
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
}

//collectionView滚动
-(void)nextPage
{
    CGPoint offset =self.collectionView.contentOffset;
    offset.x+=self.collectionView.bounds.size.width;
    //self.collectionView.contentOffset=offset;  这种事没有动画的
    
    [self.collectionView setContentOffset:offset animated:YES];
}

//松开手的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //开始定时器
    [self startTimer];
    
}

//scrollview即将开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    //停止定时器
    [self stopTimer];
}


//scrollview滚动减速结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetPosition];
}


//scrollview滚动动画结束
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetPosition];
}

//重新设置collectionview
-(void)resetPosition
{
    NSInteger index = self.collectionView.contentOffset.x/self.collectionView.bounds.size.width;
    
    NSInteger newIndex =  (LZFImageCount*self.images.count)/2+index%5;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}



@end
