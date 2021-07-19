//
//  CustomButton.swift
//  Memory-Game
//
//  Created by user196689 on 7/19/21.
//

import UIKit

class CustomButton: UIButton {

    //frist loading func
      override init(frame: CGRect) {
          super.init(frame: frame)
          defaultSetUp()
      }
      
      //first required loading func
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          defaultSetUp()
      }
      
      //customize the button to orange background
      func defaultSetUp(){
          layer.cornerRadius = layer.frame.height/2
          layer.masksToBounds = true
          //login spacing
          let spacing = 3
          let buttonAttributedString = NSMutableAttributedString(string: (titleLabel?.text)!)
          buttonAttributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, buttonAttributedString.length))
          self.setAttributedTitle(buttonAttributedString, for: .normal)
      }
      

}
