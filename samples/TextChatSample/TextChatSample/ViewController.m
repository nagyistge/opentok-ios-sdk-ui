//
//  ViewController.m
//  ChatTest
//
//  Created by Cesar Guirao on 3/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import "ViewController.h"
#import <OpenTok/OpenTok.h>

@interface ViewController ()
<OTSessionDelegate>

@end

// *** Fill the following variables using your own Project info  ***
// ***          https://dashboard.tokbox.com/projects            ***
// Replace with your OpenTok API key
static NSString* const kApiKey = @"";
// Replace with your generated session ID
static NSString* const kSessionId = @"";
// Replace with your generated token
static NSString* const kToken = @"";

static NSString* const kTextChatType = @"TextChat";

@implementation ViewController {
    OTSession* _session;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _session = [[OTSession alloc] initWithApiKey:kApiKey
                                       sessionId:kSessionId
                                        delegate:self];
    
    OTError *error = nil;
    [_session connectWithToken:kToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
        CGRect r = self.view.bounds;
        r.origin.y += 20;
        r.size.height -= 20 + kbSize.height;
        _textChat.view.frame = r;
    }];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
        CGRect r = self.view.bounds;
        r.origin.y += 20;
        r.size.height -= 20;
        _textChat.view.frame = r;
        
    }];
}

- (BOOL)onMessageReadyToSend:(OTKChatMessage *)message {
    OTError *error = nil;
    [_session signalWithType:kTextChatType string:message.text connection:nil error:&error];
    if (error) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark OTSessionDelegate methods

- (void)sessionDidConnect:(OTSession*)session {
    
    // When we've connected to the session, we can create the chat component.
    _textChat = [[OTKTextChatComponent alloc] init];
    
    _textChat.delegate = self;
    
    [_textChat setMaxLength:1005];
    [_textChat setSenderId:session.connection.connectionId alias:session.connection.data];
    
    CGRect r = self.view.bounds;
    r.origin.y += 20;
    r.size.height -= 20;
    [_textChat.view setFrame:r];
    [self.view addSubview:_textChat.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // fade in
    _textChat.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^() {
        _connectingLabel.alpha = 0;
        _textChat.view.alpha = 1;
    }];

}

- (void)sessionDidDisconnect:(OTSession*)session {
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"didFailWithError: (%@)", error);
    [self showAlert:[error localizedDescription]];
}

- (void)session:(OTSession*)session streamCreated:(OTStream*)stream {
}

- (void)session:(OTSession*)session streamDestroyed:(OTStream*)stream {
}

- (void)session:(OTSession *)session connectionCreated:(OTConnection *)connection {
    NSLog(@"session connectionCreated (%@)", connection.connectionId);
}

- (void)session:(OTSession *)session connectionDestroyed:(OTConnection *)connection {
    NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
}

- (void)session:(OTSession*)session receivedSignalType:(NSString*)type
 fromConnection:(OTConnection*)connection
     withString:(NSString*)string {
    if (![connection.connectionId isEqualToString:_session.connection.connectionId]) {
        OTKChatMessage *msg = [[OTKChatMessage alloc]init];
        msg.senderAlias = connection.data;
        msg.senderId = connection.connectionId;
        msg.text = string;
        [self.textChat sendMessage:msg];
    }
}

@end
