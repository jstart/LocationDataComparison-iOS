//
//  FactualAPIRequest.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FactualAPIDelegate;

typedef enum  {
  FactualRequestType_RowQuery,
  FactualRequestType_RowUpdate,
  FactualRequestType_SchemaQuery,
  FactualRequestType_FlagBadRowRequest
} FactualRequestType;

/*!@abstract Request tracking object returned as a result of a call to the 
 Factual API
 @discussion
 The Factual API is asynchronous in nature, so every request made via the API 
 returns a FactualAPIRequest object immediately and then notifies the user of 
 completion (or error) via the associated delegate object. 
 
 The FactualAPIRequest object can be retained by the user and subsequently used 
 by the user to identify the request context within a request completion 
 callback, but it is also possible to store the request id separately and use
 this to identify requests.
*/
@interface FactualAPIRequest : NSObject

/*! @property 
 @discussion get unique request id associated with this object
*/
@property(nonatomic,readonly) NSString* requestId;

/*! @property 
 @discussion get the delegate to fire events to
*/
@property(nonatomic,readonly) id<FactualAPIDelegate> delegate;

/*! @property 
 @discussion get the request type ... 
*/
@property(nonatomic,readonly) FactualRequestType requestType;

/*! @property 
 @discussion the table id (optional) associated with this request
*/
@property (nonatomic,readonly) NSString* tableId;


@end

@interface FactualAPIRequest(FactualAPIRequestImplementation)

// cancel the request
-(void) cancel;

@end


