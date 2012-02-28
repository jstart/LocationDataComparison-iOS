//
//  This class handles all interactions with Facebook 
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "CTAppDelegate.h"

#define kFacebookConnectedNotificationKey @"FacebookSupportConnected"
#define kFacebookDidFailtoConnectNotificationKey @"FacebookSupportFailedToConnect"
#define kFacebookFriendsListReceivedNotificationKey @"FacebookSupportFriendsListReceived"
#define kFacebookFriendsArrayKey @"FacebookSupportFriendsKey"

@interface FacebookSupport : NSObject <FBSessionDelegate, FBRequestDelegate> {
    Facebook *facebook;
}

+ (FacebookSupport*)sharedFacebookSupport;
- (BOOL)handleOpenURL:(NSURL *)url; //  whether or not url can be handled by Facebook instance
- (BOOL)connected; //   check whether or not Facebook instance ready to work
- (void)connect;   //   authorize Facebook instance and gain app permissions
- (void)getFriendsList; //  get friends list
- (void)getFriendPhoto:(NSString*)identifier;
- (void)postText:(NSString*)textFormat;
- (void)postText:(NSString*)textFormat onFriendWall:(NSString*)userID;
- (void)postImage:(UIImage*)newImage withText:(NSString*)textFormat;

@end