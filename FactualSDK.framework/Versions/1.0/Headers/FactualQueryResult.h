//
//  FactualQueryResult.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//


#import "FactualRow.h"

/*!@abstract The return object type associated with a queryTable API call. 
 @discussion Upon successful query execution, this object information about
 the resulting record set and zero or more FactualRow objects.
 
*/ 
@interface FactualQueryResult : NSObject

/*! @property 
 @discussion The id of the table from which this result set was produced
 */ 
@property (nonatomic,readonly)    NSString* tableId;


/*! @property 
 @discussion The number of FactualRow objects in this recordset
 */ 
@property (nonatomic,readonly)    NSInteger rowCount;

/*! @property 
 @discussion The number of columns/fields in each FactualRow object
 */ 
@property (nonatomic,readonly)    NSInteger columnCount;

/*! @property 
 @discussion The total rows in the table 
 */ 
@property (nonatomic,readonly)    NSUInteger totalRows;

/*! @property 
 @discussion The array of FactualRow objects
 */ 
@property (nonatomic,readonly)    NSArray* rows;

/*! @property 
 @discussion The column names as an array of NSString objects 
 */ 
@property (nonatomic,readonly)    NSArray* columns;

@end

/*!@abstract Additional Helper methods associated with FactualQueryResult 
 objects.
 */ 
@interface FactualQueryResult(FactualQueryResultImplementation)

/*! @method 
 @discussion get the FactualRow object at the given index
*/
-(FactualRow*) rowAtIndex:(NSInteger) index;  

/*! @method 
 @discussion get the field name given index (return nil for invalid index)
 */
-(NSString*)   fieldNameAtIndex:(NSInteger) index;

/*! @method 
 @discussion get field index given name (return -1 for invalid name)
 */
-(NSInteger)   fieldIndexGivenName:(NSString*) fieldName;

@end


