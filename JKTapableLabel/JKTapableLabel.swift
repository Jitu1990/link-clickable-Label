//
//  JKTapableLabel.swift
//  JKTapableUILabel
//
//  Created by Jitendra Solanki on 8/2/17.
//  Copyright © 2017 jitendra. All rights reserved.
//

import UIKit

class JKTapableLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //to save links range in inputText
    var arr_linkRanges:[NSRange] = []
    
    //text color for a link
    @IBInspectable var inputTextLinkColor:UIColor = UIColor.green
    
    var inputText:String = "" {
        didSet{
            if let attributedString = attributedString(){
                self.attributedText = attributedString
                setupFor(attributedString:attributedString)
                layoutSubviews()
            }else{
                self.text = inputText
            }
        }
    }
    
    var layoutManager:NSLayoutManager?
    var textContainer:NSTextContainer?
    var textStorage:NSTextStorage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textContainer?.size = self.bounds.size
    }
    
    //MARK:- Action method
    func didTapOnText(sender:UITapGestureRecognizer){
        print("tap on label")
        
        guard
            let senderView  = sender.view,
            let textContainerBox = self.layoutManager?.usedRect(for: self.textContainer!)
            else{
                return
        }
        //location of touch in UILabel
        let touchLocationInView = sender.location(in: senderView)
        let lableSize = senderView.bounds.size
        
        let textContainerOffset =  CGPoint(x: (lableSize.width - textContainerBox.size.width)*0.5 - textContainerBox.origin.x, y: (lableSize.height - textContainerBox.size.height)*0.5 - textContainerBox.origin.y)
        
        //touch location in textContainer
        let locationOfTouchInTextContainer = CGPoint(x: touchLocationInView.x - textContainerOffset.x, y: touchLocationInView.y - textContainerOffset.y)
        
        //get the index of character where touch occur
        let indexOfCharacter = self.layoutManager!.characterIndex(for: locationOfTouchInTextContainer, in: self.textContainer!, fractionOfDistanceBetweenInsertionPoints: nil)
        
        /*
         here check if the indexOfCharacter comes in any saved arr_linkRanges, then get the substring from the attributedText with that range and open a url
         */
        for range in arr_linkRanges{
            if NSLocationInRange(indexOfCharacter, range){
                //get link with this range
                let link = self.attributedText!.attributedSubstring(from: range)
                if  let url = URL(string: link.string){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    
    //MARK:- Helper methods
    func setupFor(attributedString:NSAttributedString){
        //add a tap gesture
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnText(sender:)))
        self.addGestureRecognizer(tapGesture)
        
        //configure layout manager
        layoutManager = NSLayoutManager()
        textContainer =  NSTextContainer(size: CGSize.zero)
        textStorage =  NSTextStorage(attributedString: attributedString)
        
        layoutManager?.addTextContainer(textContainer!)
        textStorage?.addLayoutManager(layoutManager!)
        
        textContainer?.lineFragmentPadding = 0.0
        textContainer?.maximumNumberOfLines = numberOfLines
        textContainer?.lineBreakMode = lineBreakMode
    }
    
    
    func attributedString()-> NSMutableAttributedString?{
        
        //detect urls in a string
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        if let matches = detector?.matches(in: self.inputText, options: [], range: NSRange(location: 0, length: (inputText as NSString).length)),matches.count > 0 {
            
            //attributed string with default attribute
            let defaultAttribute:[String:Any]  = [NSForegroundColorAttributeName:textColor,NSFontAttributeName:self.font!]
            let attributedString =  NSMutableAttributedString(string: inputText, attributes: defaultAttribute)
            
            //url attribute
            let linkAttribute = [NSForegroundColorAttributeName:inputTextLinkColor]
            
            /*
             get range of url in input string and set the link attribute with that
             range in attributed string
             */
            for match in matches{
                let url = (inputText as NSString).substring(with: match.range)
                attributedString.addAttributes(linkAttribute, range: match.range)
                
                //add the ranges to array for later use
                arr_linkRanges.append(match.range)
                print(url)
            }
            
            return attributedString
            
        }
        return nil
    }

}
