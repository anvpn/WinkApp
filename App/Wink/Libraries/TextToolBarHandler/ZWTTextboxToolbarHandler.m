
#import "ZWTTextboxToolbarHandler.h"

@interface ZWTTextboxToolbarHandler () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) UIScrollView *scrvParent;

@property (strong, nonatomic) NSArray *textBoxes;

@property (strong, nonatomic) UIToolbar *toolBar;

@property (strong, nonatomic) UIBarButtonItem *btnPrevious;
@property (strong, nonatomic) UIBarButtonItem *btnNext;

@property (strong, nonatomic) UIBarButtonItem *fixedSpace;

@property CGFloat spaceWidth;

@property NSUInteger firstResponderIndex;

@end

@implementation ZWTTextboxToolbarHandler

@synthesize textBoxes;
@synthesize toolBar, btnDone, btnNext, btnPrevious, fixedSpace;
@synthesize scrvParent, defaultContentSize;
@synthesize firstResponderIndex, showNextPrevious, spaceWidth;
@synthesize delegate, showToolBar;

#pragma mark - Init Methods
- (instancetype)initWithTextboxs:(NSArray *)textBoxs andScroll:(UIScrollView *)scroll
{
	self = [super init];
	
	if(self)
	{
        textBoxes  = textBoxs;
        scrvParent = scroll;

        showToolBar      = YES;
        showNextPrevious = YES;
        
		defaultContentSize = scrvParent.contentSize;
		
		spaceWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 200;
		
		[self makeToolbar];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
	}
	
	return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Helper Methods
- (void)makeToolbar
{
	toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
	
    btnNext     = [[UIBarButtonItem alloc] initWithTitle:@"Next"	 style:UIBarButtonItemStylePlain target:self action:@selector(btnNextTap)];
    btnPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(btnPreviousTap)];
    btnDone     = [[UIBarButtonItem alloc] initWithTitle:@"Done"	 style:UIBarButtonItemStylePlain target:self action:@selector(btnDoneTap:)];
	
    btnNext.tintColor     = [UIColor redColor];
    btnPrevious.tintColor = [UIColor redColor];
    btnDone.tintColor     = [UIColor redColor];
    
	fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
	fixedSpace.width = spaceWidth;
	
	toolBar.items = @[btnPrevious, btnNext, fixedSpace, btnDone];
    
    toolBar.barStyle    = UIBarStyleDefault;
    toolBar.translucent = YES;
    
	for(UITextField *txtBox in textBoxes)
	{
		txtBox.delegate = self;
		txtBox.inputAccessoryView = toolBar;
	}
}

- (void)setShowNextPrevious:(BOOL)show
{
	showNextPrevious = show;
	
	if(showNextPrevious)
	{
		spaceWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 200;
		
		fixedSpace.width = spaceWidth;
		
		toolBar.items = @[btnPrevious, btnNext, fixedSpace, btnDone];
	}
	else
	{
		spaceWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 85;
		
		fixedSpace.width = spaceWidth;
		
		toolBar.items = @[fixedSpace, btnDone];
	}
}

- (void)setShowToolBar:(BOOL)show
{
    showToolBar = show;
    
    if(showToolBar)
    {
        for(UITextField *txtBox in textBoxes)
        {
            txtBox.inputAccessoryView = toolBar;
        }
    }
    else
    {
        for(UITextField *txtBox in textBoxes)
        {
            [txtBox setInputAccessoryView:nil];
        }
    }
}

- (CGRect)keyboardRect
{
    switch (WinkGlobalObject.screenSizeType)
    {
        case WinkScreenSizeTypeUndefined:
        {
            return CGRectZero;
            
            break;
        }
        case WinkScreenSizeType3_5:
        {
            return CGRectMake(0, 220, 320, 253);
            
            break;
        }
        case WinkScreenSizeType4:
        {
            return CGRectMake(0, 308, 320, 253);
            
            break;
        }
        case WinkScreenSizeType4_7:
        {
            return CGRectMake(0, 407, 375, 258);
            
            break;
        }
        case WinkScreenSizeType5_5:
        {
            return CGRectMake(0, 466, 414, 271);
            
            break;
        }
    }
}

- (void)scrollToMakeViewVisiable:(UIView *)view
{
    CGRect scrollRct    = [scrvParent.superview convertRect:scrvParent.frame toView:nil];
    CGRect keyboardRect = [self keyboardRect];
    
    keyboardRect.origin.y    -= (showToolBar) ? 44 : 0;
    keyboardRect.size.height += (showToolBar) ? 44 : 0;
    
    CGRect intersection = CGRectIntersection(scrollRct, keyboardRect);
    
    CGRect visiableRect = scrollRct;
    
    visiableRect.size.height -= intersection.size.height;
    
    CGRect controlRect = [view.superview convertRect:view.frame toView:nil];
    
    scrvParent.contentSize = CGSizeMake(defaultContentSize.width, defaultContentSize.height + keyboardRect.size.height + 44);
    
    if(!CGRectIntersectsRect(visiableRect, controlRect))
    {
        CGFloat contentOffsetY = [scrvParent convertPoint:CGPointZero fromView:view].y - (visiableRect.size.height / 2.0);
        
        [scrvParent setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
    }
}

#pragma mark - UIToolBar Methods
- (void)btnNextTap
{
	if(firstResponderIndex < (textBoxes.count - 1))
	{
		BOOL canBecome = [textBoxes[firstResponderIndex + 1] becomeFirstResponder];
		
		if(!canBecome)
		{
			firstResponderIndex++;
			
			[self btnNextTap];
		}
	}
	else
	{
		[self endEditing];
	}
}

- (void)btnPreviousTap
{
	if(firstResponderIndex > 0)
	{
		BOOL canBecome = [textBoxes[firstResponderIndex - 1] becomeFirstResponder];
		
		if(!canBecome)
		{
			firstResponderIndex--;
			
			[self btnPreviousTap];
		}
	}
	else
	{
		[self endEditing];
	}
}

- (void)endEditing
{
	[[UIApplication sharedApplication].keyWindow endEditing:YES];
	
	scrvParent.contentSize = defaultContentSize;
}

- (void)btnDoneTap:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    UIView *txtBox = textBoxes[firstResponderIndex];
    
    scrvParent.contentSize = defaultContentSize;
	
    if ([delegate respondsToSelector:@selector(textboxHandlerButtonDoneTap:)])
    {
        [delegate textboxHandlerButtonDoneTap:txtBox];
    }
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
    {
        BOOL shouldBecomeFirstResponder = [delegate textFieldShouldBeginEditing:textField];
        
        if(shouldBecomeFirstResponder)
        {
            firstResponderIndex = [textBoxes indexOfObject:textField];
            
            [self scrollToMakeViewVisiable:textField];
        }
        
        return shouldBecomeFirstResponder;
    }
    else
    {
        firstResponderIndex = [textBoxes indexOfObject:textField];
        
        [self scrollToMakeViewVisiable:textField];
        
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ([delegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [delegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
	{
		return [delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
	}
	else
	{
		return YES;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)])
    {
       return [delegate textFieldShouldReturn:textField];
    }
    else
    {
		return YES;
    }
}

#pragma mark - UITextViewDelegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	firstResponderIndex = [textBoxes indexOfObject:textView];
	
    BOOL returnvalue = YES;
    
    if([delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
	{
		returnvalue = [delegate textViewShouldBeginEditing:textView];
	}
    
	scrvParent.contentSize = CGSizeMake(defaultContentSize.width, defaultContentSize.height + 253 + 44);
	[scrvParent setContentOffset:CGPointMake(0, [scrvParent convertPoint:CGPointZero fromView:textView].y - 30) animated:YES];
	
	return returnvalue;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
	{
		return [delegate textView:textView shouldChangeTextInRange:range replacementText:text];
	}
	else
	{
		return YES;
	}
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if([delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
	{
		[delegate textViewDidBeginEditing:textView];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if([delegate respondsToSelector:@selector(textViewDidEndEditing:)])
	{
		[delegate textViewDidEndEditing:textView];
	}
}

#pragma mark - Keyboard Event Methods
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *keyboardDuration       = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *keyboardCurveAnimation = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:keyboardDuration.floatValue animations:^
    {
        [UIView setAnimationCurve:(UIViewAnimationCurve) keyboardCurveAnimation.intValue];
        
       	[self endEditing];
    }];
}

@end
