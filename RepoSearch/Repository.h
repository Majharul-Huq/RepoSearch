//
//  RepositoryModel.h
//  RepoSearch
//
//  Created by Majharul Huq on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Repository : NSObject
{
    NSString *name;
    NSString *htmlUrl;
}

@property (nonnull, nonatomic, copy, readonly) NSString * name;
@property (nonnull, nonatomic, copy, readonly) NSString * htmlUrl;

- (instancetype)initWithModelDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
