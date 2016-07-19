//
//  ViewController.m
//  MyBanner
//
//  Created by 小二 on 16/7/19.
//  Copyright © 2016年 小二. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"

@interface ViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic , strong)NSTimer *autoScrollTimer;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [NSMutableArray array];
    for (int i = 0; i < 4; i++)
    {
        [_items addObject:@(i)];
    }
    self.view.backgroundColor = [UIColor grayColor];
    self.carousel = [[iCarousel  alloc]initWithFrame:CGRectMake(0,20, [[UIScreen mainScreen] bounds].size.width, 150)];
    self.carousel.pagingEnabled = YES;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.carousel];
    _carousel.type = iCarouselTypeCylinder;

    // Do any additional setup after loading the view, typically from a nib.
}
//自动循环
- (void)autoScroll{
    NSInteger nextPageIndex = self.carousel.currentItemIndex + 1;
    if (self.carousel.currentItemIndex == self.carousel.numberOfItems - 1) {
        nextPageIndex = 0;
    }
    [self.carousel scrollToItemAtIndex:nextPageIndex duration:0.5];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {

        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 150.0f)];
        view.contentMode = UIViewContentModeCenter;
        
        UIImageView *myimage = [[UIImageView alloc] init];
        myimage.bounds = view.bounds;
        myimage.center = view.center;
        [myimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"myScroll%@.jpg",_items[index]]]];
        [view addSubview:myimage];
        
        if (self.autoScrollTimer == nil) {
            self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        }
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }

    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.0; //这里控制了距离 enen 看出来了 ，还有就是他滑动的话我定时器写的顺序会乱掉
    }
    return value;
}
- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    //取消定时器
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
    NSLog(@"=====触碰开始====");
}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    //开启定时器
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    NSLog(@"=====触碰结束====");
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"=========%@",_items[index]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
