//
//  ViewController.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-26.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBHUDView.h"
#import <AudioToolbox/AudioSession.h>
#import "DRTools.h"


#define Top_Nav_Height  70

#define Bottom_Tool_Height   120


#define Appear_Time 0.8f

@interface ViewController ()
{
    MPMoviePlayerController * _moviePlayer;  //播放器
    
     int _fullTime;                                                //视频总秒数
     
     int  _playingTime;                                        //当前播放秒数
    
    BOOL _isPlaying;                                         //当前播放中
    
    BOOL _isPause;                                           //当前暂停或未播放
    
    BOOL _isFullScreen;                                    //是否全屏
    
    NSTimer * _timer;                                         //刷新界面的定时器
    
    UILabel * _timeLabel;                                   //显示时间的Label
    
    UISlider * _volumeSlider;                             //控制音量的Slider
    
    UISlider * _playBackSlider;                          //播放进度的Slider
        
    UIView * _topNavView;                               //导航上边的view
    
    UIView * _bottomToolView;                         //功能条下边的view
}
@end

@implementation ViewController
- (void)dealloc
{
    [self removeMovieNotificationHandlers];
    [_moviePlayer release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //添加页面Controllers
    [self addControllers];
    
    //创建全局变量
    [self doInitDataSource];
    
    //添加通知
    [self  installMovieNotificationObservers];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doInitDataSource
{
    _isPause = YES;
    _isPlaying = NO;
    _isFullScreen = YES;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlayTimes:) userInfo:nil repeats:YES];
    [_timer retain];
}
-(void)addControllers
{
    //添加播放器
    [self addPlayer];
    
    //添加上边的导航View
    [self addNavView];
    
    //添加下边的BottomView
    [self addBottomToolView];

    //添加暂停 播放  按钮
    [self addButtons];
    
    //添加时间Label
    [self addTimeLabel];
    
    //添加播放的进度 slider
    [self addPlayerBackSlider];
    
    //添加声音控制条
    [self addVolumeSlider];
    
}
#pragma 添加导航的NavView
-(void)addNavView
{
    _topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - Top_Nav_Height, _moviePlayer.view.frame.size.width, Top_Nav_Height)];
    NSLog(@"_topNavView.frame is %@",NSStringFromCGRect(_topNavView.frame));
    NSLog(@"self.view.frame is %@",NSStringFromCGRect(self.view.frame));
    UIButton * popButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popButton   setTitle:@"返回" forState:UIControlStateNormal];
    [popButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popButton addTarget:self action:@selector(dissmissSelf:) forControlEvents:UIControlEventTouchUpInside];
    popButton.frame = CGRectMake(30, 15, 50, 35);
    [_topNavView addSubview:popButton];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, self.view.frame.size.height - 2 * 200, 30)];
    titleLabel.center = _topNavView.center;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"等式的加减法则运用";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_topNavView addSubview:titleLabel];
    [titleLabel release];
    
   [_topNavView setBackgroundColor:[UIColor blackColor]];
    [_topNavView setAlpha:0.7];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_topNavView];
   [self.view addSubview:_topNavView];
}
#pragma 添加下边的BottomToolView
-(void)addBottomToolView
{
    _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, _moviePlayer.view.frame.size.height,_moviePlayer.view.frame.size.width, Bottom_Tool_Height)];
    [_bottomToolView setBackgroundColor:[UIColor blackColor]];
    [_bottomToolView setAlpha:0.7];
    [self.view addSubview:_bottomToolView];
}
#pragma 添加播放器
-(void)addPlayer
{
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"IMG_0024" ofType:@"MOV"];
//    NSURL * url = [NSURL fileURLWithPath:path];
    
    NSURL *url = [NSURL URLWithString:@"http://www.gzerodesign.com/sharksclips/video.mp4"];
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
    NSLog(@"statusHeight is %f",statusHeight);
    
	_moviePlayer = [[MPMoviePlayerController alloc]
                    initWithContentURL:url];
    [[_moviePlayer view] setFrame:CGRectMake(0, 0, self.view.frame.size.height+statusHeight, self.view.frame.size.width)];
    
    UITapGestureRecognizer *playGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playFullScreenOrNot:)];
    playGesture.delegate = self;
  _moviePlayer.view.userInteractionEnabled = YES;
    [_moviePlayer.view addGestureRecognizer:playGesture];
    [playGesture release];

    [_moviePlayer setFullscreen:YES animated:YES];
    [self.view addSubview:_moviePlayer.view];
    
	//初始化视频播放器对象，并传入被播放文件的地址
	_moviePlayer.controlStyle = MPMovieControlStyleNone ;
    [_moviePlayer prepareToPlay];
	[_moviePlayer play];
}
#pragma 自定义的按钮
-(void)addButtons
{
    UIButton * pauseButton  = [[UIButton alloc] initWithFrame:CGRectMake(350, 60,100, 50)];
    [pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pauseCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:pauseButton];
    [pauseButton release];
    
    UIButton * playButton  = [[UIButton alloc] initWithFrame:CGRectMake(500, 60,100, 50)];
     [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:playButton];
    [playButton release];
    
    UIButton * seekingBackButton  = [[UIButton alloc] initWithFrame:CGRectMake(200,60,100, 50)];
    [seekingBackButton setTitle:@"快退" forState:UIControlStateNormal];
    [seekingBackButton addTarget:self action:@selector(seekingBackCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:seekingBackButton];
    [seekingBackButton release];

    
    UIButton * seekingForwardButton  = [[UIButton alloc] initWithFrame:CGRectMake(700, 60,100, 50)];
    [seekingForwardButton setTitle:@"快进" forState:UIControlStateNormal];
    [seekingForwardButton addTarget:self action:@selector(seekingForwardCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:seekingForwardButton];
    [seekingForwardButton release];
}
-(void)addTimeLabel
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 100, 50)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = [NSString stringWithFormat:@"00:00"];
    [_bottomToolView addSubview:_timeLabel];
}
-(void)addVolumeSlider
{
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(900, 60, 100,50)];
    [_volumeSlider addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventValueChanged];
    float volume = [MPMusicPlayerController applicationMusicPlayer].volume;
    _volumeSlider.value = volume;
    [_bottomToolView   addSubview:_volumeSlider];
}
-(void)addPlayerBackSlider
{
    _playBackSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 10, 700,40)];
    [_playBackSlider addTarget:self action:@selector(changePlayRate:) forControlEvents:UIControlEventValueChanged];
    _playBackSlider.value = 0;
    [_bottomToolView   addSubview:_playBackSlider];
}
-(void)dissmissSelf:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)topNavViewAppear
{
    CGRect startFrame = CGRectMake(0, 0-Top_Nav_Height, _topNavView.frame.size.width, Top_Nav_Height);
    CGRect endFrame = CGRectMake(0, 0, _topNavView.frame.size.width, Top_Nav_Height);
    [DRTools appearViewAnimationWithView:_topNavView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
-(void)topNavViewHidden
{
    CGRect endFrame = CGRectMake(0, 0-Top_Nav_Height, _topNavView.frame.size.width, Top_Nav_Height);
    CGRect startFrame = CGRectMake(0, 0, _topNavView.frame.size.width, Top_Nav_Height);
    [DRTools appearViewAnimationWithView:_topNavView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
-(void)bottomToolViewAppear
{
     CGRect startFrame = CGRectMake(0, _moviePlayer.view.frame.size.height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    CGRect endFrame = CGRectMake(0, _moviePlayer.view.frame.size.height-Bottom_Tool_Height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    [DRTools appearViewAnimationWithView:_bottomToolView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
-(void)bottomToolViewHidden
{
    CGRect endFrame = CGRectMake(0, _moviePlayer.view.frame.size.height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    CGRect startFrame = CGRectMake(0, _moviePlayer.view.frame.size.height-Bottom_Tool_Height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    [DRTools appearViewAnimationWithView:_bottomToolView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
#pragma 按钮响应事件
-(void)playFullScreenOrNot:(id)sender
{
    if (_isFullScreen) {
        _isFullScreen = NO;
        NSLog(@"_isFullScreen is YES");
        [self topNavViewAppear];
        [self bottomToolViewAppear];
    }
    else{
        NSLog(@"_isFullScreen is NO");
        _isFullScreen = YES;
        [self topNavViewHidden];
        [self bottomToolViewHidden];
    }
}
-(void)changePlayRate:(id)sender
{
    UISlider * slider = (UISlider*)sender;
    NSLog(@"slider.value is %f",slider.value);
     _moviePlayer.currentPlaybackTime = _fullTime * slider.value;
    [_moviePlayer prepareToPlay];
    [_moviePlayer play];
}
-(void)changeVolume:(id)sender
{
    NSLog(@"音量控制");
    UISlider * slider = (UISlider*)sender;
    NSLog(@"slider.value is %f",slider.value);
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:slider.value];
}
-(void)pauseCilcked:(id)sender
{
    NSLog(@"暂停");
    [_moviePlayer pause];
}
-(void)playCilcked:(id)sender
{
    NSLog(@"播放");
    [_moviePlayer play];
}
-(void)seekingForwardCilcked:(id)sender
{
    NSLog(@"快进");
    NSLog(@"_playingTime is %d",_playingTime);
    int forwardTime = _playingTime + 5;
    _moviePlayer.currentPlaybackTime = forwardTime;
}
-(void)seekingBackCilcked:(id)sender
{
    NSLog(@"快进");
    NSLog(@"_playingTime is %d",_playingTime);
    int backTime = _playingTime - 5;
    _moviePlayer.currentPlaybackTime = backTime;
}
#pragma 添加通知

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = _moviePlayer;
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackTimeDidChange:)
                                                 name:MPMoviePlayerTimedMetadataUpdatedNotification
                                               object:player];
    
    //添加对声音大小的判断
    OSStatus s = AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                                     audioVolumeChangeListenerCallback,
                                                     self);
    if (s == kAudioSessionNoError) {
        NSLog(@"监听音量键成功");
    }
    else{
        NSLog(@"监听音量键失败");
    }
}
#pragma mark Remove Movie Notification Handlers
/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{
     MPMoviePlayerController *player = _moviePlayer;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerTimedMetadataUpdatedNotification object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerVolumeDidChangeNotification object:_volumeSlider];
}
#pragma 播放通知的响应
#pragma mark Movie Notification Handlers
void audioVolumeChangeListenerCallback (void *inUserData,
                                        AudioSessionPropertyID inPropertyID,
                                        UInt32 inPropertyValueSize,
                                        const void *inPropertyValue)
{
    if (inPropertyID != kAudioSessionProperty_CurrentHardwareOutputVolume) return;
    Float32 value = *(Float32 *)inPropertyValue;
    NSLog(@"value is %f",value);
    ViewController * viewController = (ViewController *) inUserData;
    [viewController updatePlayBackVolume:value];
}
//声音的更新
-(void)moviePlayVolumeChange:(NSNotification*)notification
{
    float  volume= [MPMusicPlayerController applicationMusicPlayer].volume;
    _volumeSlider.value = volume;
}

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController * player = notification.object;
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	switch ([reason integerValue])
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            NSLog(@"正常播完");
            _isPause = YES;
            _isPlaying = NO;
            
            NSNumber * movieTime = [NSNumber numberWithInt:player.duration];
            [self playEndUpdate:movieTime];
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
//            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"]
//                                waitUntilDone:NO];
            _isPause = YES;
            _isPlaying = NO;
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
            NSLog(@"用户退出");
            _isPause = YES;
            _isPlaying = NO;
			break;
            
		default:
			break;
	}
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
        NSLog(@"类型未知");
        _isPause = YES;
        _isPlaying = NO;
	}
	
	/* The buffer has enough data that playback can begin, but it
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
        NSLog(@"MPMovieLoadStatePlayable  可以播放 视频时间为%f 秒",player.duration);
        _isPause = NO;
        _isPlaying = YES;
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        _isPause = NO;
        _isPlaying = YES;
        [MBAlertView dismissCurrentHUD];
        // Add an overlay view on top of the movie view
        NSLog(@"MPMovieLoadStatePlaythroughOK 可以播放 视频时间为%f 秒",player.duration);
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
        _isPause = YES;
        _isPlaying = NO;
        [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:30 show:YES];
	}
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
        NSLog(@"停止按钮");
        _isPause = YES;
        _isPlaying = NO;
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
        NSLog(@"播放按钮");
        _isPause = NO;
        _isPlaying = YES;
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
       NSLog(@"暂停按钮");
        _isPause = YES;
        _isPlaying = NO;
	}
	/* Playback is temporarily interrupted, perhaps because the buffer
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
        NSLog(@"缓冲被中断");
        _isPause = NO;
        _isPlaying = YES;
	}
}
-(void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
//    [MBAlertView dismissCurrentHUD];
}

#pragma 刷新播放时间
-(void)updatePlayTimes:(id)sender
{
    if (_isPlaying && !_isPause) {
        MPMoviePlayerController *player = _moviePlayer;
        NSNumber * fullTime;
        NSNumber * playingTime;
        fullTime = [NSNumber numberWithFloat:player.duration];
        playingTime = [NSNumber numberWithFloat:player.currentPlaybackTime];
        _fullTime = [fullTime intValue];
        _playingTime = [playingTime intValue];
         
        NSString * fullTimeString = [DRTools transSecondToTime:_fullTime];
        NSString * playTimeString = [DRTools transSecondToTime:_playingTime];
        _timeLabel.text = [NSString stringWithFormat:@"%@|%@",playTimeString,fullTimeString];
        
        float rate = (float)(_playingTime)/(_fullTime);
        NSLog(@"进度 %f",(float)(_playingTime)/(_fullTime));
        [self updatePlayBackSlider:rate];
        
        NSLog(@"可以播的时间 %f",player.playableDuration);
    }
}
#pragma 刷新播放完时间的归位
-(void)playEndUpdate:(NSNumber*)playTime
{
    NSString * fullTimeString = [DRTools transSecondToTime:_fullTime];
    _timeLabel.text = [NSString stringWithFormat:@"00:00|%@",fullTimeString];
    _playBackSlider.value = 0;
}

#pragma 刷新音量控制
-(void)updatePlayBackVolume:(float)volume
{
    _volumeSlider.value = volume;
}
-(void)updatePlayBackSlider:(float)value
{
    _playBackSlider.value =value;
}
 #pragma mark - gesture delegate
// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
