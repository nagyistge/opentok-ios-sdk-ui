//
//  OTKTextChatComponent.h
//
//  Created by Cesar Guirao on 2/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OTKChatMessage : NSObject

@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *dateTime;

@end

@protocol OTKTextChatDelegate <NSObject>

- (BOOL)onMessageReadyToSend:(OTKChatMessage *)message;

@end

@interface OTKTextChatComponent : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView * view;

@property (nonatomic, weak) id<OTKTextChatDelegate> delegate;

- (BOOL)sendMessage:(OTKChatMessage *)message;

- (void)setMaxLength:(int) length;

@end
