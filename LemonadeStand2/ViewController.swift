//
//  ViewController.swift
//  LemonadeStand2
//
//  Created by Neel Bola on 7/12/15.
//  Copyright (c) 2015 Neel Bola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var moneySupplyCountLabel: UILabel!
    
    @IBOutlet weak var lemonSupplyCountLabel: UILabel!

    @IBOutlet weak var iceCubeSupplyCountLabel: UILabel!
    
    @IBOutlet weak var lemonsPurchaseCountLabel: UILabel!
    
    @IBOutlet weak var iceCubePurchaseCountLabel: UILabel!
    
    @IBOutlet weak var lemonMixCountLabel: UILabel!
    
    @IBOutlet weak var iceCubeMixCountLabel: UILabel!
    
    var supplies = Supplies(aMoney: 10, aLemons: 1, aIceCubes: 1)
    let price = Price()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    
    var lemonsToMix = 0
    var iceCubesToMix = 0
    
    var weatherArray:[[Int]] = [[-10, -9, -5, -7], [5, 8, 10, 9], [22, 25, 27, 23]]
    var weatherToday:[Int] = [0, 0, 0, 0]
    
    var weatherImageView: UIImageView = UIImageView(frame: CGRect(x:  20, y: 50, width: 50, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(weatherImageView)
        updateMainView()
        simulateWeatherToday()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//IBActions
    
    
    @IBAction func purchaseLemonButtonPressed(sender: UIButton) {
        if supplies.money >= price.lemon {
            lemonsToPurchase += 1
            supplies.money -= price.lemon
            supplies.lemons += 1
            
            updateMainView()
        }
        else {
            showAlertWithText(header: "OH NO!", message: "You do not have enough money")
        }
    }
    
    
    @IBAction func purchaseIceCubeButtonPressed(sender: UIButton) {
        
        if supplies.money >= price.iceCube {
            iceCubesToPurchase += 1
            supplies.money -= price.iceCube
            supplies.iceCubes += 1
            updateMainView()
        }
        
        else {
            showAlertWithText(header: "OH NO!", message: "You do not have enough money")
        }
    }
    
    
    @IBAction func unPurchaseLemonButtonPressed(sender: UIButton) {
        
        if lemonsToPurchase > 0 {
            lemonsToPurchase -= 1
            supplies.money += price.lemon
            supplies.lemons -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have anything to return")
        }
    }
    
    
    @IBAction func unPurchaseIceCubeButtonPressed(sender: UIButton) {
        
        if iceCubesToPurchase > 0 {
            iceCubesToPurchase -= 1
            supplies.money += price.iceCube
            supplies.iceCubes -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have anything to return")
        }
        
    }
    
    
    @IBAction func mixLemonButtonPressed(sender: AnyObject) {
        
        if supplies.lemons > 0 {
            lemonsToPurchase = 0
            supplies.lemons -= 1
            lemonsToMix += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough inventory")
        }
    }
    
    
    @IBAction func mixIceCubeButtonPressed(sender: UIButton) {
        if supplies.iceCubes > 0 {
            iceCubesToPurchase = 0
            supplies.iceCubes -= 1
            iceCubesToMix += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough inventory")
        }
    }
    
    
    @IBAction func unmixLemonButtonPressed(sender: UIButton) {
        
        if lemonsToMix > 0 {
            lemonsToPurchase = 0
            lemonsToMix -= 1
            supplies.lemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You have nothing to un-mix")
        }
        
    }
    
    
    @IBAction func unmixIceCubeButtonPressed(sender: UIButton) {
        if iceCubesToMix > 0 {
            iceCubesToPurchase = 0
            iceCubesToMix -= 1
            supplies.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You have nothing to un-mix")
        }
    }
    
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        let average = findAverage(weatherToday)
        
        let customers = Int(arc4random_uniform(UInt32(abs(average))))
        println("customers: \(customers)")
        
        if lemonsToMix == 0 || iceCubesToMix == 0 {
            showAlertWithText(message: "You need to add at least 1 Lemon and 1 Ice Cube")
        }
        else {
            let lemonadeRatio = Double(lemonsToMix) / Double(iceCubesToMix)
            
            for x in 0...customers{
                let preference = Double(arc4random_uniform(UInt32(101))) / 100
                
                if preference < 0.4 && lemonadeRatio > 1 {
                    supplies.money += 1
                    println("Paid")
                }
                else if preference > 0.6 && lemonadeRatio < 1 {
                    supplies.money += 1
                    println("Paid")
                }
                else if preference <= 0.6 && preference >= 0.4 && lemonadeRatio == 1 {
                    supplies.money += 1
                    println("Paid")
                }
                else {
                    println("else statement evaluating")
                }
            }
            
            lemonsToPurchase = 0
            iceCubesToPurchase = 0
            lemonsToMix = 0
            iceCubesToMix = 0
            
            
            simulateWeatherToday()
            updateMainView()
        }
    }
    
    
    //Helper Functions
    
    
    func updateMainView () {
        
        //Updating the supply labels
        moneySupplyCountLabel.text = "$\(supplies.money)"
        lemonSupplyCountLabel.text = "\(supplies.lemons) Lemons"
        iceCubeSupplyCountLabel.text = "\(supplies.iceCubes) ice cubes"
        
        //Updating Purchase amount labels
        lemonsPurchaseCountLabel.text = "\(lemonsToPurchase)"
        iceCubePurchaseCountLabel.text = "\(iceCubesToPurchase)"
        
        //Update mixture amount labels
        lemonMixCountLabel.text = "\(lemonsToMix)"
        iceCubeMixCountLabel.text = "\(iceCubesToMix)"
    
    }
    
    
    func showAlertWithText (header: String = "Warning", message : String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func simulateWeatherToday() {
        let index = Int(arc4random_uniform(UInt32(weatherArray.count)))
        weatherToday = weatherArray[index]
        
        switch index {
        case 0: weatherImageView.image = UIImage(named: "cold")
        case 1: weatherImageView.image = UIImage(named: "mild")
        case 2: weatherImageView.image = UIImage(named: "warm")
        default: weatherImageView.image = UIImage(named: "warm")
        }
        
        
    }
    
    
    func findAverage(data:[Int]) -> Int {
        var sum = 0
        for x in data {
            sum += x
        }
        var average:Double = Double(sum) / Double(data.count)
        var rounded:Int = Int(ceil(average))
        
        return rounded
    }
}









