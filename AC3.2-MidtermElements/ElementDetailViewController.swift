//
//  ElementDetailViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Madushani Lekam Wasam Liyanage on 12/8/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit

class ElementDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var meltingPointLabel: UILabel!
    @IBOutlet weak var boilingPointLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    
    @IBOutlet weak var discoveryYearLabel: UILabel!
    
    @IBOutlet weak var elementImageView: UIImageView!
    
    var element: Element?
    let notAvailbale = "Not Available"
    let postEndPOint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let validElement = element{
            
            self.title = validElement.name
            nameLabel.text = validElement.name
            weightLabel.text = String(validElement.weight)
            numberLabel.text = String(validElement.number)
            symbolLabel.text = validElement.symbol
            discoveryYearLabel.text = validElement.discoveryYear
            
            if validElement.meltingPoint != " " {
                meltingPointLabel.text = String(describing: validElement.meltingPoint)
            }
            else {
                meltingPointLabel.text = notAvailbale
            }
            if validElement.boilingPoint != " " {
                boilingPointLabel.text = String(validElement.boilingPoint)
            }
            else {
                boilingPointLabel.text = notAvailbale
            }
            
            let imageString = "https://s3.amazonaws.com/ac3.2-elements/\(validElement.symbol).png"
            
            APIRequestManager.manager.getData(endPoint: imageString ) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        self.elementImageView.image = validImage
                        
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        //"my_name" and "favorite_element"
        var favoriteDict = [String:Any]()
        favoriteDict["my_name"] = "Madushani"
        favoriteDict["favorite_element"] = element?.name
        print(favoriteDict)
        
        APIRequestManager.manager.postRequest(from: postEndPOint, data: favoriteDict)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
