//
//  AskViewController.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-30.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "AskViewController.h"

@interface AskViewController ()

@end

@implementation AskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
   
    //初始化信息
    [self doInitVCInfo];
    
    
    //初始化答题view
    [self addAnswerView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化页面
-(void)doInitVCInfo
{
    self.title = @"提问";
    self.view.backgroundColor = [UIColor blackColor];
}
#pragma mark 初始化导航页面
-(void)addAnswerView
{
    
    //添加提问背景
    UIView * answerView = [[UIView alloc] initWithFrame:CGRectMake(150, 20, self.view.frame.size.height - 2*150, 650)];
    [answerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:answerView];
    
    
    //添加上边导航View
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, answerView.frame.size.width, 60)];
    view.backgroundColor = [UIColor clearColor];
    [answerView addSubview:view];
    
    //添加Nav背景图片
    UIImageView * bannerImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    bannerImageView.image = [UIImage imageNamed:@"ask_nav_banner"];
    bannerImageView.backgroundColor = [UIColor clearColor];
    bannerImageView.userInteractionEnabled = YES;
    [view addSubview:bannerImageView];
    
    //添加TitleLabel 
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, view.frame.size.width-2*100,50)];
    titleLabel.text = @"提问";
    titleLabel.textColor = [UIColor whiteColor];
     [titleLabel setFont:[UIFont boldSystemFontOfSize:26.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bannerImageView addSubview:titleLabel];
    
    
    //添加返回的button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * buttonImage = [UIImage imageNamed:@"ask_pop_button"];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(popButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(20,15, 35,35);
    [bannerImageView addSubview:button];

    //释放变量
    [titleLabel release];
    [bannerImageView release];
    [view release];
    [answerView release];
}

#pragma mark 返回按钮按下
-(void)popButtonClicked:(id)sender
{
    NSLog(@"popButtonClicked");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
