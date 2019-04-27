//
//  LPUserDefaults.h
//  BlueHired
//
//  Created by peng on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPUserDefaults : NSObject

/// 存储用户偏好设置 到 NSUserDefults
+(void)saveValue:(id) value forKey:(NSString *)key;
/// 读取用户偏好设置
+(NSString *)valueWithKey:(NSString *)key;
/// 删除用户偏好设置
+(void)removeValueWithKey:(NSString *)key;
/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName;
/// 通过文件名从沙盒中找到归档的对象
+(id)getObjectByFileName:(NSString*)fileName;
/// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName;

@end
