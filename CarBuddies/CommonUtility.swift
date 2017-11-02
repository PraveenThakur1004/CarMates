//
//  CommonUtility.swift
//  CarBuddies
//
//  Created by MAC on 20/09/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
let sharedUtils : CommonUtility = CommonUtility()
class CommonUtility: NSObject {
    //MARK:-Initialization
    override init()
    {
        super.init();
    }
    class var sharedInstance : CommonUtility {
        return sharedUtils
    }
    
    //String encoding UTF8
    class func encodeString(_ str: String) -> String
    {
        let parsedStr = CFURLCreateStringByAddingPercentEscapes(
            nil,
            str as CFString!,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString!, //you can add another special characters
            CFStringBuiltInEncodings.UTF8.rawValue
        );
        return parsedStr as! String;
    }
    //MARK:- Validations
    //Check email vaildity
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //Check username validation
 class   func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w{7,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    // Compare two timeStamp
  class    func dateformatter(str: String) -> String {
    
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let date2:Date = dateFormatter.date(from: str)!
        let date1:Date = Date() // Same you did before with timeNow variable
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2, to: date1)
        print(components)
        var returnString:String = ""
    if components.second!  < 60 {
        returnString = "now"
    }
    if components.minute! >= 1{
       returnString =  String(describing: components.minute!) + " minutes ago"}
    if components.hour! >= 1{
        returnString =  String(describing: components.hour!) + " hour ago"
   }
    if components.day! >= 1{
       returnString =   String(describing: components.day!) + " day ago" }
   if components.month! >= 1{
     returnString =  String(describing: components.month!) + " month ago"}
    if components.year! >= 1  {
          returnString =  String(describing: components.year!) + " year ago"
    }
        return returnString
    }
    // Compare two timeStamp
    class func changeDateFormat(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date2:Date = date
        let date1:Date = Date() // Same you did before with timeNow variable
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2, to: date1)
        print(components)
        var returnString:String = ""
       
        if components.second! < 60  {
            returnString = "today" + " \(getHHMMDate(date: date))"
        }
        if components.minute! >= 1{
            returnString = "today" + " \(getHHMMDate(date: date))"}
        if components.hour! >= 1{
            returnString = "today" +  " \(getHHMMDate(date: date))"
        }
        if components.day! >= 1{
            returnString = "yesterday" + " \(getHHMMDate(date: date))" }
        if components.day! >= 2{
            returnString = getEEEDate(date: date) }
        if components.day! >= 7{
            returnString = getMMMDate(date: date) }
        if components.month! >= 1{
            returnString =  getMMMDate(date: date)
        }
        if components.year! >= 1{
            returnString =  getMMMDate(date: date)
        }
        return returnString
    }
    class func getEEEDate(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE HH:mm"
        let result = formatter.string(from: date)
        return result
        
    }
    
    class func getHHMMDate(date:Date) -> String{
       
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let result = formatter.string(from: date)
        return result
    }
    class func getMMMDate(date:Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM HH:mm"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getCurrentDate(_ str:String) -> Date{
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //Your date format
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: str) //according to date format your date string
        return (date)!
    }
    class    func dateformatterZ(str: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date2:Date = dateFormatter.date(from: str)!
        let date1:Date = Date() // Same you did before with timeNow variable
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2, to: date1)
        print(components)
        var returnString:String = ""
        if components.second!  < 60 {
            returnString = "now"
        }
        if components.minute! >= 1{
            returnString =  String(describing: components.minute!) + " minutes ago"}
        if components.hour! >= 1{
            returnString =  String(describing: components.hour!) + " hour ago"
        }
        if components.day! >= 1{
            returnString =   String(describing: components.day!) + " day ago" }
        if components.month! >= 1{
            returnString =  String(describing: components.month!) + " month ago"}
        if components.year! >= 1  {
            returnString =  String(describing: components.year!) + " year ago"
        }
        return returnString
    }
    
    class func changeDateFormatZ(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date2:Date = date
        let date1:Date = Date() // Same you did before with timeNow variable
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2, to: date1)
        print(components)
        var returnString:String = ""
        
        if components.second! < 60  {
            returnString = "today" + " \(getHHMMDate(date: date))"
        }
        if components.minute! >= 1{
            returnString = "today" + " \(getHHMMDate(date: date))"}
        if components.hour! >= 1{
            returnString = "today" +  " \(getHHMMDate(date: date))"
        }
        if components.day! >= 1{
            returnString = "yesterday" + " \(getHHMMDate(date: date))" }
        if components.day! >= 2{
            returnString = getEEEDate(date: date) }
        if components.day! >= 7{
            returnString = getMMMDate(date: date) }
        if components.month! >= 1{
            returnString =  getMMMDate(date: date)
        }
        if components.year! >= 1{
            returnString =  getMMMDate(date: date)
        }
        return returnString
    }
//  class  func blurImage(image:UIImage) -> UIImage? {
//        let context = CIContext(options: nil)
//        let inputImage = CIImage(image: image)
//        let originalOrientation = image.imageOrientation
//        let originalScale = image.scale
//        let filter = CIFilter(name: "CIGaussianBlur")
//        filter?.setValue(inputImage, forKey: kCIInputImageKey)
//        filter?.setValue(15, forKey: kCIInputRadiusKey)
//        let outputImage = filter?.outputImage
//        var cgImage:CGImage?
//        if let asd = outputImage
//        {
//            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
//        }
//        if let cgImageA = cgImage
//        {
//            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
//        }
//        return nil
//    }

    
}
//var returnString:String = ""
//if components.minute! >= 1{
//    returnString = "Get order in " + String(describing: components.minute!) + " minutes"}
//if components.hour! >= 1{
//    returnString = "Get order in " + String(describing: components.hour!) + " hour " + String(describing: components.minute!) + " minutes"
//}
//if components.day! >= 1{
//    returnString =  "Get order in" + String(describing: components.day!) + "day" }
//if components.month! >= 1{
//    returnString = "Get order in" + String(describing: components.month!) + "month"
extension UIImageView{
    
func addBlurEffect()
    {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
    }
}
extension UIImage{
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let scale = newSize.height / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width : newWidth, height : newSize.height))
        self.draw(in: CGRect(x:0,y: 0, width:newWidth,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

