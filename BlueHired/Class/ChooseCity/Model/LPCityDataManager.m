//
//  LPCityDataManager.m
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCityDataManager.h"
#import "FMDB.h"


@interface LPCityDataManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation LPCityDataManager


static LPCityDataManager *manager = nil;
+ (LPCityDataManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)areaSqliteDBData {
    // copy"area.sqlite"到Documents中
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *txtPath =[documentsDirectory stringByAppendingPathComponent:@"china_cities_v2.db"];
    if([fileManager fileExistsAtPath:txtPath] == NO){
        NSString *resourcePath =[[NSBundle mainBundle] pathForResource:@"china_cities_v2" ofType:@"db"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    // 新建数据库并打开
    NSString *path  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"china_cities_v2.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.db = db;
    BOOL success = [db open];
    if (success) {
        // 数据库创建成功!
        NSLog(@"数据库创建成功!");
        NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS cities ('id' integer not null primary key autoincrement ,c_name TEXT ,c_pinyin TEXT ,c_code INTEGER ,c_province TEXT);";
        BOOL successT = [self.db executeUpdate:sqlStr];
        if (successT) {
            // 创建表成功!
            
            NSLog(@"创建表成功!");
        }else{
            // 创建表失败!
            NSLog(@"创建表失败!");
            [self.db close];
        }
    }else{
        // 数据库创建失败!
        NSLog(@"数据库创建失败!");
        [self.db close];
    }
}

- (NSArray*)getCity{
    NSString*sql = @"select * from cities";
    FMResultSet *rs = [self.db executeQuery:sql];
    NSMutableArray*array = [[NSMutableArray alloc]init];
    while ([rs next]) {
        NSDictionary*dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [rs stringForColumn:@"id"],@"id",
                            [rs stringForColumn:@"c_name"],@"c_name",
                            [rs stringForColumn:@"c_pinyin"],@"c_pinyin",
                            [rs stringForColumn:@"c_code"],@"c_code",
                            [rs stringForColumn:@"c_province"],@"c_province",nil];
        [array addObject:dic];
    }
    return array;
}

-(NSArray *)query:(NSString *)string{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM cities WHERE c_name LIKE '%%%@%%' or c_pinyin LIKE '%%%@%%' or c_province LIKE '%%%@%%';",string,string,string];
    
    FMResultSet *rs = [self.db executeQuery:sql];
    NSMutableArray*array = [[NSMutableArray alloc]init];
    while ([rs next]) {
        NSDictionary*dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [rs stringForColumn:@"id"],@"id",
                            [rs stringForColumn:@"c_name"],@"c_name",
                            [rs stringForColumn:@"c_pinyin"],@"c_pinyin",
                            [rs stringForColumn:@"c_code"],@"c_code",
                            [rs stringForColumn:@"c_province"],@"c_province",nil];
        [array addObject:dic];
    }
    return array;
}
@end
