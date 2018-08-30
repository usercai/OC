//
//  CAVDefine.h
//  AVPlayerDemo
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 thc. All rights reserved.
//

#ifndef CAVDefine_h
#define CAVDefine_h

#ifdef DEBUG

#define CAVLog( s, ... ) NSLog( @"Debug----CAV<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define CAVLog( s, ... )

#endif


#define kIs_iPhoneX (kSCREEN_WIDTH == 375.f && kSCREEN_HEIGHT == 812.f)

#define kSCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)

#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kTopState (kIs_iPhoneX ? 34.f : 0)

#endif /* CAVDefine_h */
