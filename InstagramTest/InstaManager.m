//
//  InstaManager.m
//  InstagramTest
//
//  Created by renanvs on 7/15/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "InstaManager.h"
#import "AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation InstaManager

@synthesize assetArray;

SynthensizeSingleTon(InstaManager)

-(id)init{
    self = [super init];
    
    if (self) {
        ctx = [NSManagedObjectContext MR_contextForCurrentThread];
        [PublicationModel MR_truncateAllInContext:ctx];
    }
    
    return self;
}

-(void)createInstaModelWithCode:(NSString*)code{
    NSDictionary *pars = @{@"client_id" : @"a2bd1d093fc44292918eb03475eed3c8",
                           @"client_secret" : @"e339849bd95942f9bc847dd57e5c7249",
                           @"grant_type" : @"authorization_code",
                           @"redirect_uri" : @"http://www.macwingo.com/",
                           @"code" : code};
    
    
    mainCode = [[NSString alloc] initWithString:code];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationManager POST:@"https://api.instagram.com/oauth/access_token" parameters:pars success:^(AFHTTPRequestOperation *operation, id json){
        [self parseJsonToInstaModel:json];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

-(void)parseJsonToInstaModel:(NSDictionary *)dicJson{
    
    ConnectedUserModel *connectedModel = [ConnectedUserModel MR_findFirst];
    
    if (!connectedModel) {
        connectedModel = [ConnectedUserModel MR_createInContext:ctx];
    }

    connectedModel.code = mainCode;
    connectedModel.token = [dicJson objectForKey:@"access_token"];
    
    NSDictionary *userDic = [dicJson objectForKey:@"user"];
    
    connectedModel.fullname = [userDic objectForKey:@"full_name"];
    connectedModel.user_id = [userDic objectForKey:@"id"];
    connectedModel.username = [userDic objectForKey:@"username"];
    connectedModel.profile_picture = [userDic objectForKey:@"profile_picture"];
    
    [ctx MR_saveOnlySelfAndWait];
    [self getUserData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InstaModelSaved" object:nil];
}

static NSString *tag = @"renanvs";

-(void)getUserData{
    ConnectedUserModel *connectedModel = [ConnectedUserModel MR_findFirst];
    if (!connectedModel) {
        NSLog(@"Erro no getUserData");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent", tag];
    NSDictionary *parms = @{@"access_token" : connectedModel.token};
    AFHTTPRequestOperationManager *op = [AFHTTPRequestOperationManager manager];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op GET:url parameters:parms success:^(AFHTTPRequestOperation *op, id json){
        NSDictionary *headerDic = op.response.allHeaderFields;
        [self refreshRequestWithHeader:headerDic];
        
        [self parseJsonToPublicationModel:[json objectForKey:@"data"]];
    }failure:^(AFHTTPRequestOperation *op, NSError *error){
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

-(void)parseJsonToPublicationModel:(NSDictionary*)dicArray{
    NSLog(@"break");
    for (NSDictionary *publication in dicArray) {
        
        BOOL containsCorrectTag = [self existTagInThisPublication:publication];
        
        if ([[publication objectForKey:@"type"] isEqualToString:@"image"] && containsCorrectTag) {
            
            PublicationModel *publicationModel = [PublicationModel MR_createInContext:ctx];
            publicationModel.createdTime = [publication objectForKey:@"created_time"];
            publicationModel.link = [publication objectForKey:@"link"];
            publicationModel.identifier = [publication objectForKey:@"id"];
            
            
            NSDictionary *caption = [publication objectForKey:@"caption"];
            if (![caption isKindOfClass:[NSNull class]]) {
                CaptionModel *captionModel = [CaptionModel MR_createInContext:ctx];
                captionModel.createdTime = [caption objectForKey:@"created_time"];
                captionModel.text = [caption objectForKey:@"text"];
                UserModel *userCaptionModel = [UserModel MR_createInContext:ctx];
                NSDictionary *userFromCaption = [caption objectForKey:@"from"];
                userCaptionModel.identier = [userFromCaption objectForKey:@"id"];
                userCaptionModel.fullName = [userFromCaption objectForKey:@"full_name"];
                userCaptionModel.profilePicture = [userFromCaption objectForKey:@"profile_picture"];
                userCaptionModel.userName = [userFromCaption objectForKey:@"user_name"];
                captionModel.user = userCaptionModel;
                publicationModel.caption = captionModel;
            }
            
            NSDictionary *likes = [publication objectForKey:@"likes"];
            if (![likes isKindOfClass:[NSNull class]]) {
                publicationModel.likesCount = [likes objectForKey:@"count"];
            }
            
            NSDictionary *commentsData = [publication objectForKey:@"comments"];
            if (![commentsData isKindOfClass:[NSNull class]]) {
                CommentsModel *commentsModel = [CommentsModel MR_createInContext:ctx];
                
                commentsModel.count = [commentsData objectForKey:@"count"];
                
                NSArray *comments = [commentsData objectForKey:@"data"];
                for (NSDictionary *comment in comments) {
                    CommentModel *commentModel = [CommentModel MR_createInContext:ctx];
                    commentModel.createdTime = [comment objectForKey:@"created_time"];
                    commentModel.text = [comment objectForKey:@"text"];
                    
                    UserModel *userCommentModel = [UserModel MR_createInContext:ctx];
                    NSDictionary *userFromComment = [comment objectForKey:@"from"];
                    userCommentModel.fullName = [userFromComment objectForKey:@"full_name"];
                    userCommentModel.profilePicture = [userFromComment objectForKey:@"profile_picture"];
                    userCommentModel.userName = [userFromComment objectForKey:@"user_name"];
                    userCommentModel.identier = [userFromComment objectForKey:@"id"];
                    commentModel.user = userCommentModel;
                    [commentsModel addListObject:commentModel];
                }
                publicationModel.comments = commentsModel;
            }
            
            ImageModel *imageModel = [ImageModel MR_createInContext:ctx];
            NSDictionary *images = [publication objectForKey:@"images"];
            NSDictionary *lowRes = [images objectForKey:@"low_resolution"];
            imageModel.lowResUrl = [lowRes objectForKey:@"url"];
            imageModel.lowWidth = [lowRes objectForKey:@"width"];
            imageModel.lowHeight = [lowRes objectForKey:@"height"];
            NSDictionary *thumbnail = [images objectForKey:@"thumbnail"];
            imageModel.thumbnailUrl = [thumbnail objectForKey:@"url"];
            imageModel.thumbnailWidth = [thumbnail objectForKey:@"width"];
            imageModel.thumbnailHeight = [thumbnail objectForKey:@"height"];
            NSDictionary *standardResolution = [images objectForKey:@"standard_resolution"];
            imageModel.standardResolutionUrl = [standardResolution objectForKey:@"url"];
            imageModel.standardResolutionWidth = [standardResolution objectForKey:@"width"];
            imageModel.standardResolutionHeight = [standardResolution objectForKey:@"height"];
            publicationModel.image = imageModel;
            
        }else{
            NSLog(@"debug: type -> %@", [publication objectForKey:@"type"]);
        }
    }
    [ctx save:nil];
}

-(BOOL)existTagInThisPublication:(NSDictionary*)publication{
    NSArray *tags = [publication objectForKey:@"tags"];
    for (NSString *currentTag in tags) {
        if ([currentTag isEqualToString:tag]) {
            return YES;
        }
    }
    
    NSLog(@"debug: tags desejada não encontrada na publicação: %@, essa são as tagas: %@", [publication objectForKey:@"id"], tags);
    
    return NO;
}

-(void)refreshRequestWithHeader:(NSDictionary*)headerDic{
    RequestModel *model = [RequestModel MR_findFirst];
    if (!model) {
        model = [RequestModel MR_createInContext:ctx];
    }
    
    model.total = [headerDic objectForKey:@"X-Ratelimit-Limit"];
    model.remain = [headerDic objectForKey:@"X-Ratelimit-Remaining"];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

-(void)asset{
    assetArray = [[NSArray alloc] init];
    NSMutableArray *tmpAssent = [[NSMutableArray alloc] init];
    
    ALAssetsLibrary *assetLibrary = [InstaManager defaultAssetsLibrary];
    
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result) {
                [tmpAssent addObject:result];
            }
        }];
        
        assetArray = [[NSArray alloc] initWithArray:tmpAssent];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAsset" object:nil];
    }failureBlock:^(NSError *error){
        NSLog(@"error asset %@", error);
    }];
}

@end
