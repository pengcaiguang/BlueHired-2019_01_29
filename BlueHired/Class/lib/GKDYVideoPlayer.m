//
//  GKDYVideoPlayer.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoPlayer.h"
#import <TXLiteAVSDK_Player/TXLiveBase.h>
#import <TXLiteAVSDK_Player/TXVodPlayer.h>
#import <TXLiteAVSDK_Player/TXVodPlayListener.h>

@interface GKDYVideoPlayer()<TXVodPlayListener>

@property (nonatomic, strong) TXVodPlayer   *player;

@property (nonatomic, assign) float         duration;

@property (nonatomic, assign) BOOL          isNeedResume;

@end

@implementation GKDYVideoPlayer

- (instancetype)init {
    if (self = [super init]) {
        // 监听APP退出后台及进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Notification
// APP退出到后台
- (void)appDidEnterBackground:(NSNotification *)notify {
    if (self.status == GKDYVideoPlayerStatusLoading || self.status == GKDYVideoPlayerStatusPlaying) {
        [self pause];
        
        self.isNeedResume = YES;
    }
}

// APP进入前台
- (void)appWillEnterForeground:(NSNotification *)notify {
    if (self.isNeedResume && self.status == GKDYVideoPlayerStatusPaused) {
        self.isNeedResume = NO;
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resume];
        });
    }
}

#pragma mark - Public Methods
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url {
    // 设置播放视图
    [self.player setupVideoWidget:playView insertIndex:0];
    [self.player setRenderMode:RENDER_MODE_FILL_EDGE ];
    self.player.isAutoPlay = YES;

    // 准备播放
    [self playerStatusChanged:GKDYVideoPlayerStatusPrepared];
    TXVodPlayConfig *_config = [[TXVodPlayConfig alloc] init];
    _config.cacheFolderPath =
    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TXVodPlayConfig"];
    _player.config.playerType = PLAYER_FFPLAY;
    // 设置最多缓存多少个文件，避免缓存太多数据
    _config.maxCacheItems = 10;
    
    [_player setConfig:_config];
//    [DSBaActivityView showActiviTy];

    // 开始播放
    if ([self.player startPlay:url] == 0) {
        // 这里可加入缓冲视图
        NSLog(@"开始播放");
    }else {
        [self playerStatusChanged:GKDYVideoPlayerStatusError];
    }
}

- (void)playVideourl:(NSString *)url{
      [self.player setRenderMode:RENDER_MODE_FILL_EDGE ];
    // 准备播放
    [self playerStatusChanged:GKDYVideoPlayerStatusPaused];
    self.player.isAutoPlay = NO;
    // 开始播放
    if ([self.player startPlay:url] == 0) {
        // 这里可加入缓冲视图
       
    }else {
        [self playerStatusChanged:GKDYVideoPlayerStatusError];
    }
}

- (void)playVideoWithView:(UIView *)playView {
//     NSLog(@"开始播放");
//    NSLog(@"视频播放总时长 = %f",self.player.duration);
    [self.player setupVideoWidget:playView insertIndex:0];
 }

-(float)getPlayerDuration{
    return self.player.duration;
}

- (void)setStartTime:(CGFloat)Time{
    [self.player seek:Time];
}

- (void)removeVideo {
    // 停止播放
    [self.player stopPlay];
    
    // 移除播放视图
    [self.player removeVideoWidget];
    NSLog(@"移除播放视图");
    // 改变状态
    [self playerStatusChanged:GKDYVideoPlayerStatusUnload];
}

- (void)pause {
    [self playerStatusChanged:GKDYVideoPlayerStatusPaused];
    
    [self.player pause];
    NSLog(@"视频暂停");
}

- (void)resume {
//    NSLog(self.player.isPlaying?@"shi":@"fei");
//    if (self.status == GKDYVideoPlayerStatusPaused || self.player.isPlaying == NO|| self.isPlaying == NO) {
        [self.player resume];
    
        [self playerStatusChanged:GKDYVideoPlayerStatusPlaying];
    NSLog(@"视频播放总时长 = %f",self.player.duration);
    NSLog(@"视频播放");
//    }
}

- (BOOL)isPlaying {
    return self.player.isPlaying;
}

#pragma mark - Private Methods
- (void)playerStatusChanged:(GKDYVideoPlayerStatus)status {
    self.status = status;
    
    if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:status];
    }
}

#pragma mark - TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
 
   
    
    switch (EvtID) {
        case PLAY_EVT_PLAY_LOADING:{    // loading
            if (self.status == GKDYVideoPlayerStatusPaused) {
                [self playerStatusChanged:GKDYVideoPlayerStatusPaused];
            }else {
                [self playerStatusChanged:GKDYVideoPlayerStatusLoading];
            }
        }
            break;
        case PLAY_EVT_PLAY_BEGIN:{    // 开始播放
            [self playerStatusChanged:GKDYVideoPlayerStatusPlaying];
            [DSBaActivityView hideActiviTy];

        }
            break;
        case PLAY_EVT_PLAY_END:{    // 播放结束
            [self playerStatusChanged:GKDYVideoPlayerStatusEnded];
        }
            break;
        case PLAY_ERR_NET_DISCONNECT:{    // 失败，多次重连无效
            [self playerStatusChanged:GKDYVideoPlayerStatusError];
        }
            break;
        case PLAY_EVT_PLAY_PROGRESS:{    // 进度
            if (self.status == GKDYVideoPlayerStatusPlaying) {
                self.duration = [param[EVT_PLAY_DURATION] floatValue];
                
                float currTime = [param[EVT_PLAY_PROGRESS] floatValue];
//                NSLog(@"当前播放时间 %f",currTime);
                float progress = self.duration == 0 ? 0 : currTime / self.duration;
                
                // 处理播放结束时，进度不更新问题
                if (progress >= 0.95) progress = 1.0f;
                
                //                float buffTime = [param[EVT_PLAYABLE_DURATION] floatValue];
                //                float burrProgress = self.duration == 0 ? 0 : buffTime / self.duration;
                
                if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                    [self.delegate player:self currentTime:currTime totalTime:self.duration progress:progress];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    
}

#pragma mark - 懒加载
- (TXVodPlayer *)player {
    if (!_player) {
        [TXLiveBase setLogLevel:LOGLEVEL_NULL];
        [TXLiveBase setConsoleEnabled:NO];
        
        _player = [TXVodPlayer new];
        _player.vodDelegate = self;
        _player.loop = YES; // 开启循环播放功能

    }
    return _player;
}

@end
