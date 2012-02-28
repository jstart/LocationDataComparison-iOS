#import "FacebookSupport.h"
#import "SynthesizeSingleton.h"
#import "CTLocationConstants.h"

#define kGraphBaseURL @"https://graph.facebook.com/"

@implementation FacebookSupport

SYNTHESIZE_SINGLETON_FOR_CLASS(FacebookSupport);

- (id)init {
    self = [super init];
    
    //  initiate Facebook instance
    facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    if (facebook) {
        [facebook release];
        facebook = nil;
    }
    [super dealloc];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url];
}

/**
 * This is called when the player is already connected and we want to check if the fb access token
 * is valid
 */
- (BOOL)connected {
    return [facebook isSessionValid];
}

- (void)connect {
    NSArray *permissions = [NSArray arrayWithObjects:@"offline_access", @"publish_stream", nil];
    [facebook authorize:permissions delegate:self];
}

- (void)getFriendsList {
    [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (void)getFriendPhoto:(NSString*)identifier {
    if ([facebook isSessionValid]) {
        [facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/picture", identifier] andDelegate:self];
    }
}

- (void)postText:(NSString*)textFormat {
    [self postText:textFormat onFriendWall:@"me"];
}

#pragma mark -
#pragma mark Facebook delegate methods

//  called when Facebook authorization successfull
- (void)fbDidLogin {
    //  save access token for using in future
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookConnectedNotificationKey object:nil userInfo:nil];
}

//  called when Facebook authorization fails or being canceled
- (void)fbDidNotLogin:(BOOL)cancelled {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookDidFailtoConnectNotificationKey object:nil userInfo:nil];
}

//  called when Facebook logged out (user changes password or restrict access for this app) 
- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

//  called when one of the requests successfully loaded
- (void)request:(FBRequest *)request didLoad:(id)result {
    //  check if request was friends list request
    if ([request.url hasPrefix:[NSString stringWithFormat:@"%@me/friends", kGraphBaseURL]]) {
        //  send global notification with list of friends
        [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookFriendsListReceivedNotificationKey object:nil userInfo:[NSDictionary dictionaryWithObject:[result objectForKey:@"data"] forKey:kFacebookFriendsArrayKey]];
    } else {
        NSLog(@"%@", [result description]);
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", [error description]);
}

@end
