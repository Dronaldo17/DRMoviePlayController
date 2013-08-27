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

@interface ViewController ()
{
    MPMoviePlayerController * _moviePlayer;  //播放器
    
     int _fullTime;                                                //视频总秒数
     
     int  _playingTime;                                        //当前播放秒数
    
    BOOL _isPlaying;                                         //当前播放中
    
    BOOL _isPause;                                           //当前暂停或未播放
    
    NSTimer * _timer;                                         //刷新界面的定时器
    
    UILabel * _timeLabel;                                   //显示时间的Label
    
    UISlider * _volumeSlider;                                          //控制音量的按钮
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
    
    //添加播放器
    [self addPlayer];
    
    //添加暂停 播放  按钮
    [self addButtons];
    
    //添加时间Label
    [self addTimeLabel];
    
    //添加进度条
    [self addVolumeSlider];
    
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
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlayTimes:) userInfo:nil repeats:YES];
    [_timer retain];
}
#pragma 添加播放器
-(void)addPlayer
{
    NSURL *url = [NSURL URLWithString:@"http://www.gzerodesign.com/sharksclips/video.mp4"];
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
    NSLog(@"statusHeight is %f",statusHeight);
    
	_moviePlayer = [[MPMoviePlayerController alloc]
                    initWithContentURL:url];
    [[_moviePlayer view] setFrame:CGRectMake(0, 0, self.view.frame.size.height+statusHeight, self.view.frame.size.width)];
    
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
    UIButton * pauseButton  = [[UIButton alloc] initWithFrame:CGRectMake(350, _moviePlayer.view.frame.size.height - 100,100, 100)];
    [pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pauseCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    [pauseButton release];
    
    UIButton * playButton  = [[UIButton alloc] initWithFrame:CGRectMake(500, _moviePlayer.view.frame.size.height - 100,100, 100)];
     [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    [playButton release];
    
    UIButton * seekingBackButton  = [[UIButton alloc] initWithFrame:CGRectMake(200, _moviePlayer.view.frame.size.height - 100,100, 100)];
    [seekingBackButton setTitle:@"快退" forState:UIControlStateNormal];
    [seekingBackButton addTarget:self action:@selector(seekingBackCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seekingBackButton];
    [seekingBackButton release];

    
    UIButton * seekingForwardButton  = [[UIButton alloc] initWithFrame:CGRectMake(700, _moviePlayer.view.frame.size.height - 100,100, 100)];
    [seekingForwardButton setTitle:@"快进" forState:UIControlStateNormal];
    [seekingForwardButton addTarget:self action:@selector(seekingForwardCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seekingForwardButton];
    [seekingForwardButton release];
}
-(void)addTimeLabel
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, _moviePlayer.view.frame.size.height -100, 100, 100)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = [NSString stringWithFormat:@"00|00"];
    [self.view addSubview:_timeLabel];
}
-(void)addVolumeSlider
{
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(900, _moviePlayer.view.frame.size.height -80, 100,50)];
    [_volumeSlider setBackgroundColor:[UIColor whiteColor]];
    [_volumeSlider addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventValueChanged];
    float volume = [MPMusicPlayerController applicationMusicPlayer].volume;
    _volumeSlider.value = volume;
    [self.view   addSubview:_volumeSlider];
}
#pragma 按钮响应事件
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
                                                     _volumeSlider);
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
    UISlider * volumeSlider = ( UISlider *) inUserData;
    volumeSlider.value = value;
}
//声音的更新
-(void)moviePlayVolumeChange:(NSNotification*)notification
{
    float  volume= [MPMusicPlayerController applicationMusicPlayer].volume;
    _volumeSlider.value = volume;
}

//时间的更新
-(void)moviePlayBackTimeDidChange:(NSNotification*)notification
{
   
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
            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"]
                                waitUntilDone:NO];
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
        [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
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
        NSLog(@"_fullTime is %d,_playingTime is %d",_fullTime,_playingTime);
        _timeLabel.text = [NSString stringWithFormat:@"%d|%d",_playingTime,_fullTime];
        NSLog(@"进度 %f",(float)(_playingTime)/(_fullTime));
        
        NSLog(@"可以播的时间 %f",player.playableDuration);
    }
}
#pragma 刷新播放完时间的归位
-(void)playEndUpdate:(NSNumber*)playTime
{
    _timeLabel.text = @"00|00";
}

#pragma 刷新音量控制
-(void)updatePlayBackVolume:(float)volume
{
    
}


@end
