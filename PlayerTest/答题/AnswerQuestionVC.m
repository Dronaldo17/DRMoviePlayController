//
//  AnswerQuestionVC.m
//  PlayerTest
//
//  Created by doujingxuan on 13-9-1.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "AnswerQuestionVC.h"

@interface AnswerQuestionVC ()
{
    UIView * _questionView;
}

@end

@implementation AnswerQuestionVC

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
	// Do any additional setup after loading the view.
    
    //添加导航view
    [self addNavView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 添加导航
-(void)addNavView
{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(150, 81, self.view.frame.size.height - 2*150, 678)];
//    [_tableView setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:_tableView];
    
    
    //添加上边导航View
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.height, 60)];
    
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    UIImageView * topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 77, view.frame.size.width, 5)];
    topLineView.image = [UIImage imageNamed:@"ask_line"];
    [self.view addSubview:topLineView];
    
    //添加Nav背景图片
    UIImageView * bannerImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    bannerImageView.image = [UIImage imageNamed:@"ask_nav_banner"];
    bannerImageView.backgroundColor = [UIColor clearColor];
    bannerImageView.userInteractionEnabled = YES;
    [view addSubview:bannerImageView];
    
    //添加TitleLabel
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, view.frame.size.width-2*100,50)];
    titleLabel.text = @"全部32个答案";
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
}
#pragma mark 返回按钮按下
-(void)popButtonClicked:(id)sender
{
    NSLog(@"popButtonClicked");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
