# link-clickable-Label
JKTapableLabel is a subclass of UILabel. It enables you to set the text in label with urls and it allows you to open a url when you tap on a url in text.

How to use:

You can create an instance of JKTapableLabel either programmatically or in interface builder. It has a property linkTextColor  to set the text color for the link.

If you create a JKTapableLabel in interface builder, then add an outlet to it in your view controller:

@IBOutlet weak var linkLabel:JKTapableLabel! 

Then set the inputTextLinkColor property if you did not set in interface builder:

linkLabel.inputTextLinkColor = UIColor.red

To add the text string:

linkLabel.inputText = “https://google.com This is a test with the URL https://www.github.com to be detected.” 
