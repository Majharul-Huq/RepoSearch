//
//  RepositoryModel.m
//  RepoSearch
//
//  Created by Majharul Huq on 2021/12/14.
//

#import "Repository.h"

@implementation Repository

- (instancetype)initWithModelDictionary:(NSDictionary *)dict
{
    if (!(self = [super init])) { return self; }
    
    _name = [dict valueForKey:@"name"];
    _htmlUrl = [dict valueForKey:@"html_url"];
    
    return  self;
}
    
@end
