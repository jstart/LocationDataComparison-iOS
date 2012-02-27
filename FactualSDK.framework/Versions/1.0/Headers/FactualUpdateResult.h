//
//  FactualUpdateResult.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//

/*!@abstract The return object type associated with a submitRowData request. 
 @discussion
 
 An successful update request (via the submitRowData) returns two pieces of 
 information. 
 
 First, it returns an AffectedRowId, which is either the row 
 identifier for an existing row that was updated, or the row identifier of a 
 new row that was generated as a result of the update. 
 
 Second, it returns a boolean flag that specifies if the update request resulted
 in either an update (exists == True) or an insert (exists == Falase).
 
 */

@interface FactualUpdateResult : NSObject {
  NSString* _affectedRowId;
  BOOL _exists;
  NSString* _tableId;
}

/*! @property 
 @discussion The id of the table related to the orignal request
 */ 
@property (nonatomic,readonly)    NSString* tableId;

/*! @property 
 @discussion The Factual Row Id of the updated/inserted row.
 */ 
@property (nonatomic,readonly) NSString* affectedRowId;

/*! @property 
 @discussion A boolean that is True if the submit call updated an existing row.
 False if the call resulted in a new row.
 */ 
@property (nonatomic,readonly) BOOL exists;

-(id) initWithRowId:(NSString*) rowId 
             exists:(BOOL) exists
            tableId:(NSString*) tableId;

@end
