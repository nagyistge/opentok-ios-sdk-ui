//
//  OTKTextChatComponent.h
//
//  Created by Cesar Guirao on 2/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OTKChatMessage : NSObject

@property (nonatomic, copy) NSString *senderAlias;
@property (nonatomic, copy) NSString *senderId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *dateTime;

@end

/**
 * An delegate for receiving events when a text chat message is ready to send.
 */
@protocol OTKTextChatDelegate <NSObject>

/**
 * Called when a message in the OTKTextChatComponent is ready to send. A message
 * is ready to send when the user clicks the Send button in the
 * OTKTextChatComponent user interface.
 */
- (BOOL)onMessageReadyToSend:(OTKChatMessage *)message;

@end

/**
 * A controller for the OpenTok iOS Text Chat UI widget.
 */
@interface OTKTextChatComponent : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

/**
 * The view containing the OTKTextChatComponent user interface.
 */
@property (nonatomic, strong) IBOutlet UIView * view;

/**
 * Set to the delegate object that receives events for this OTKTextChatComponent.
 */
@property (nonatomic, weak) id<OTKTextChatDelegate> delegate;

/**
 * Add a message to the TextChatListener received message list.
 */
- (BOOL)sendMessage:(OTKChatMessage *)message;

/**
 * Set the maximum length of a text chat message.
 */
- (void)setMaxLength:(int) length;

/**
 * Set the sender alias and the sender id of the output messages.
 */
- (void)setSenderId:(NSString *)senderId alias:(NSString *)alias;

@end
