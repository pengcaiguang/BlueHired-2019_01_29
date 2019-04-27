//
//  LPUserDefaults.m
//  BlueHired
//
//  Created by peng on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPUserDefaults.h"

@implementation LPUserDefaults

/// 存储用户偏好设置 到 NSUserDefults
+(void)saveValue:(id)value forKey:(NSString *)key{
    NSLog(@"value: %@ key:%@",value,key);
    if (!value || !key) {
        NSLog(@"value OR key 为空");
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/// 读取用户偏好设置
+(NSString *)valueWithKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key?:@""];
}
/// 删除用户偏好设置
+(void)removeValueWithKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key?:@""];
}
/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    
    BOOL flag = [NSKeyedArchiver archiveRootObject:object toFile:path];
    
}
/// 通过文件名从沙盒中找到归档的对象
+(id)getObjectByFileName:(NSString*)fileName
{
    
    NSString *path  = [self appendFilePath:fileName];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/// 拼接文件路径
+(NSString*)appendFilePath:(NSString*)fileName
{
    
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *file = [NSString stringWithFormat:@"%@/%@.archiver",documentsPath,fileName];
    
    return file;
}
@end
