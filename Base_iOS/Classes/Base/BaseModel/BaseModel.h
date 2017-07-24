//
//  BaseModel.h
//  ZhiYou
//


#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>{
    
}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData *)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

/**
 通过字典获取一个模型
 */
+ (instancetype)tl_objectWithDictionary:(NSDictionary *)dictionary;

/**
 * 数组模型转换为对象模型
 */
+ (NSMutableArray *)tl_objectArrayWithDictionaryArray:(id)dictionaryArray;

/**
 * 对属性名称进行替换，key 模型属性的名称，value去字典里取值的key
 */
+ (NSDictionary *)tl_replacedKeyFromPropertyName;

@end
