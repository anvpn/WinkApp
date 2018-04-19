

@protocol ZWTTextboxToolbarHandlerDelegate <NSObject>

@optional
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

- (void)textboxHandlerButtonDoneTap:(UIView *)textBox;

@end

@interface ZWTTextboxToolbarHandler : NSObject

@property (nonatomic) BOOL showNextPrevious;
@property (nonatomic) BOOL showToolBar;

@property (strong, nonatomic) UIBarButtonItem *btnDone;

@property (nonatomic, strong) id<ZWTTextboxToolbarHandlerDelegate> delegate;

@property CGSize defaultContentSize;

- (instancetype)initWithTextboxs:(NSArray *)textBoxs andScroll:(UIScrollView *)scroll;

- (void)endEditing;

@end
