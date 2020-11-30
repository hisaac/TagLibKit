//
//  TaglibWrapper
//
//  Created by Ryan Francesconi on 1/2/19.
//  Copyright © 2019 Ryan Francesconi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaglibWrapper : NSObject

+ (nullable NSString *)getTitle:(NSString *)path;
+ (nullable NSString *)getComment:(NSString *)path;
+ (nullable NSMutableDictionary *)getMetadata:(NSString *)path;
+ (bool)setMetadata:(NSString *)path
         dictionary:(NSDictionary *)dictionary;

+ (bool)writeComment:(NSString *)path
             comment:(NSString *)comment;

+ (nullable NSArray *)getChapters:(NSString *)path;

+ (bool)setChapters:(NSString *)path
              array:(NSArray *)dictionary;

+ (nullable NSString *)detectFileType:(NSString *)path;
+ (nullable NSString *)detectStreamType:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
