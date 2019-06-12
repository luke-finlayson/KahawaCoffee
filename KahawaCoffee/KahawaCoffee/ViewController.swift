//
//  ViewController.swift
//  Kahawa Coffee
//
//  Created by Luke Finlayson on 10/06/19.
//  Copyright © 2019 QwertyGroup. All rights reserved.
//
//
//  A Phone ordering program for a coffee shop. User can chose between pickup and delivery, then add specified amounts and types of coffee to the order. A live feed of the current order will be outputted to a scrollable text view. Once the order is submitted, the program will output all past orders to a scrollable text view allowing the user to access all past orders. Past orders are cleared when the program is quitted.

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // Boolean to store state of the Output window
    var OutputFull: Bool = false
    
    // Float counter to check total amount of coffee ordered
    var TotalAmount: Float = 0
    
    // [String] List to store current order
    var OrderList = [String]()
    
    // [String] List for holding past orders
    var Orders = [String]()
    
    // Variable to hold total cost
    var TotalCost: Float = 0
    
    // Boolean to store state of delivery checkbox
    var Delivery: Bool = false
    
    // Reset all fields
    func ResetAll() {
        // Resetting all radio buttons. I hope efficency isn't assessed.
        ArabicaEthiopia.state = .off
        ArabicaKenyan.state = .off
        ArabicaRwandan.state = .off
        ArabicanZimbabwean.state = .off
        RobustaEthiopian.state = .off
        RobustaKenyan.state = .off
        RobustaRwandan.state = .off
        RobustaZimbabwean.state = .off
        LibericaEthiopian.state = .off
        LibericaKenyan.state = .off
        LibericaRwandan.state = .off
        LibericanZimbabwean.state = .off
        LibericanChad.state = .off
        ExcelsaEthiopian.state = .off
        ExcelsaKenyan.state = .off
        ExcelsaRwandan.state = .off
        
        // Resetting everything else
        CoffeeAmountOutlet.stringValue = ""
        CoffeeGroundedOutlet.state = .off
        CoffeeStrengthOutlet.intValue = 1
        
        DeliveryOutlet.state = .off
        NameTextField.stringValue = ""
        PhoneNumberTextField.stringValue = ""
        AddressNumberTextField.stringValue = ""
        AddressTextField.stringValue = ""
        AddressPostCodeTextField.stringValue = ""
        
        // Disabling unrequired fields
        PhoneNumberTextField.isEnabled = false
        
        AddressNumberTextField.isEnabled = false
        AddressTextField.isEnabled = false
        AddressPostCodeTextField.isEnabled = false
        
        // Adding placeholder text
        PhoneNumberTextField.placeholderString = "Only when order is for delivery"
        
        AddressNumberTextField.placeholderString = "-----"
        AddressTextField.placeholderString = "Only when order is for delivery"
        AddressPostCodeTextField.placeholderString = "-----"
        
        Delivery = false
        
        OrderList = []
        
        TotalAmount = 0
        
        TotalCost = 0
        
        // Printing past orders to Output
        Output.string = "Past Orders: \n\n"
        for x in Orders {
            Output.string += x + "\n\n"
        }
        
        // Store that the output window is full
        OutputFull = true
    }
    
    // Function to add a specified amount and type of coffee to the order
    @IBAction func AddCoffee(_ sender: Any) {
        
        // String to store Coffee Type selected from radio butons
        var CoffeeType: String = ""
        // String to store whether coffee is grounded or not
        var CoffeeGrounded = String()
        // Float to store cost of selected coffee
        var Cost = Float()
        
        // Function to simplify checking radio button values
        func CheckCoffeeType(type: NSButton) -> String {
            // Check if a radio button is checked
            if type.state == .on {
                CoffeeType = type.title // Set the coffee type to the checked radio button
            }
            
            return CoffeeType
        }
        
        // Running the CheckCoffeeType function with all the radio buttons
        _=CheckCoffeeType(type: ArabicaEthiopia)
        _=CheckCoffeeType(type: ArabicaKenyan)
        _=CheckCoffeeType(type: ArabicaRwandan)
        _=CheckCoffeeType(type: ArabicanZimbabwean)
        _=CheckCoffeeType(type: RobustaEthiopian)
        _=CheckCoffeeType(type: RobustaKenyan)
        _=CheckCoffeeType(type: RobustaRwandan)
        _=CheckCoffeeType(type: RobustaZimbabwean)
        _=CheckCoffeeType(type: LibericaEthiopian)
        _=CheckCoffeeType(type: LibericaKenyan)
        _=CheckCoffeeType(type: LibericaRwandan)
        _=CheckCoffeeType(type: LibericanZimbabwean)
        _=CheckCoffeeType(type: LibericanChad)
        _=CheckCoffeeType(type: ExcelsaEthiopian)
        _=CheckCoffeeType(type: ExcelsaKenyan)
        _=CheckCoffeeType(type: ExcelsaRwandan)
        
        // Getting the various other coffee specifications
        let CoffeeStrength = Int(CoffeeStrengthOutlet.intValue)
        
        // If the 'Grounded:' checkbox is ticked, set CoffeeGrounded to true
        if CoffeeGroundedOutlet.state == .on {
            CoffeeGrounded = "Yes"
        } else {
            CoffeeGrounded = "No" // If not, set CoffeeGrounded to false
        }
        
        // Checking the CoffeeAmount last, as this is what will need to be error checked.
        let CoffeeAmount = Float(CoffeeAmountOutlet.stringValue)
        // NOTE: A rather odd part of swift, if a string cannot be converted to a Float(or int etc..) then the value will just be set as 'nil' instead of throwing an exception erorr.
        
        // For some reason I have to do this to make it work
        let zero: Float = 0
        
        // Checking for invalid inputs before continuing to add data to order
        if CoffeeAmount == nil || CoffeeAmount == 0 || CoffeeAmount! < zero{
            
            // Alert the user with a popup warning if CoffeeAmount is invalid
            let alert: NSAlert = NSAlert() // Create an alert variable
            alert.messageText = "'Coffee amount' must be a number and more than 0" // Set the alert message
            alert.runModal() // Run the alert
        }
        else {
            let TotalAmountChecker = TotalAmount + CoffeeAmount!
            
            // Checking if the CoffeeType has been selected
            if CoffeeType == "" {
                
                // Alert the user with a popup warning if no coffee type was selected
                let alert: NSAlert = NSAlert() // Create an alert variable
                alert.messageText = "Select the type of coffee" // Set the alert message
                alert.runModal() // Run the alert
            }
            else if TotalAmountChecker > 5 {
                
                //Alert the user with a popup warning if the total amount exceeds 5kg
                let alert: NSAlert = NSAlert() // Create an alert variable
                alert.messageText = "Amount of coffee selected exceeds maximum allowed amount: 5kg" // Set the alert message
                alert.runModal() // Run the alert
            }
            else {
                
                // Calculating the cost of the specified coffee and rounding it to 2dp
                if(CoffeeType.contains("Arabica") || CoffeeType.contains("Robusta")) {
                    Cost = round((28.5 * CoffeeAmount!) * 100) / 100
                }
                else {
                    Cost = round(((28.5 - 5) * CoffeeAmount!) * 100) / 100
                }
                
                // Add selected coffee specifications to current order
                OrderList.append("Type: \(CoffeeType) | Grounded: \(CoffeeGrounded) | Strength: \(CoffeeStrength) | Amount: \(CoffeeAmount!)kg | Cost: $\(Cost)")
                
                // Print the coffee specifications to the Output window
                Output.string = "Current Order: \n\n"
                for x in OrderList {
                    Output.string += x + "\n"
                }
                
                // Add the amount to the TotalAmount
                TotalAmount += CoffeeAmount!
                // Add the cost to the total cost
                TotalCost += Cost
                
                // Resetting Cost
                Cost = 0
            }
        }
        
    }
    
    
    @IBAction func DeliveryClick(_ sender: Any) {
        // Checking if checkbox is checked
        if DeliveryOutlet.state == .on {
            // Set delivery bool as true
            Delivery = true
            
            // Enable required fields
            PhoneNumberTextField.isEnabled = true
            
            AddressNumberTextField.isEnabled = true
            AddressTextField.isEnabled = true
            AddressPostCodeTextField.isEnabled = true
            
            // Clearing placeholder texts
            PhoneNumberTextField.placeholderString = ""
            
            AddressNumberTextField.placeholderString = "Street Number"
            AddressTextField.placeholderString = "Street Name"
            AddressPostCodeTextField.placeholderString = "Post Code"
        }
        else {
            // Set delivery bool as false
            Delivery = false
            
            // Disabling unrequired fields
            PhoneNumberTextField.isEnabled = false
            
            AddressNumberTextField.isEnabled = false
            AddressTextField.isEnabled = false
            AddressPostCodeTextField.isEnabled = false
            
            // Adding placeholder text
            PhoneNumberTextField.placeholderString = "Only when order is for delivery"
            
            AddressNumberTextField.placeholderString = "-----"
            AddressTextField.placeholderString = "Only when order is for delivery"
            AddressPostCodeTextField.placeholderString = "-----"
        }
        
    }
    
    // Function to save the order and present it in the output window
    @IBAction func SubmitOrder(_ sender: Any) {
        
        // String used when combining order into single string
        var Ordered = String()
        
        // Getting the user inputted values
        var NameString: String = NameTextField.stringValue
        var PhoneNumberString: String = PhoneNumberTextField.stringValue
        
        var AddressNumberString: String = AddressNumberTextField.stringValue
        var AddressString: String = AddressTextField.stringValue
        var AddressPostCodeString: String = AddressPostCodeTextField.stringValue
        
        // Function to merge coffee orders into single string
        func CollectOrderList() {
            for x in OrderList {
                Ordered += x + ",\n"
            }
        }
        
        // Checking if the order is for delivery or not
        if Delivery == true {
            // Checking if any fields haven't been filled
            if NameString.isEmpty || PhoneNumberString.isEmpty || AddressString.isEmpty || AddressNumberString.isEmpty || AddressPostCodeString.isEmpty || OrderList.isEmpty {
                // Alert the user with a popup warning if there is missing data
                let alert: NSAlert = NSAlert() // Create an alert variable
                alert.messageText = "Missing data. Check all fields are filled out and coffee has been added to the order. True" // Set the alert message
                alert.runModal() // Run the alert
            }
            // Checking the Phone Number is a number
            else if Int(PhoneNumberString) == nil {
                // Alert the user with a popup warning if the Phone number is not a number
                let alert: NSAlert = NSAlert() // Create an alert variable
                alert.messageText = "'Phone Number' must be a whole number." // Set the alert message
                alert.runModal() // Run the alert
            }
            else if Int(AddressNumberString) == nil {
                // Alert the user with a popup warning if the Address Number is not a number
                let alert: NSAlert = NSAlert() // Create an alert variable
                alert.messageText = "'Address Number' must be a whole number." // Set the alert message
                alert.runModal() // Run the alert
            }
            else if Int(AddressPostCodeString) == nil {
                // Alert the user with a popup warning if the Post code is not a number
                let alert: NSAlert = NSAlert() // Create an alert variable
                alert.messageText = "'Post Code' must be a whole number." // Set the alert message
                alert.runModal() // Run the alert
            }
            // If everything checks out, continue submitting the order
            else {
                // Adding $5 as a delivery fee
                TotalCost += 5
                
                // Calling CollectOrderList to merge Orderlist into single string
                CollectOrderList()
                
                // Submitting the order to past Orders
                Orders.append("Name: \(NameString); Phone Number: \(PhoneNumberString); \nAddress: \n\t\(AddressNumberString)\n\t\(AddressString)\n\t\(AddressPostCodeString)\nCoffee Ordered: \(Ordered) Total Cost: $\(TotalCost) | Delivery: Yes | Delivery Charge: $5")
                
                // Clearing the Output window and adding a new title
                Output.string = "Past Orders: \n\n"
                for x in Orders {
                    Output.string += x + "\n"
                }
            }
        }
        if Delivery == false {
            // Checking if any fields haven't been filled
            if NameString.isEmpty || OrderList.isEmpty {
                //Alert the user with a popup warning if there is missing data
                let alert: NSAlert = NSAlert() // Create an alert variable
                alert.messageText = "Missing data. Check all fields are filled out and coffee has been added to the order. False" // Set the alert message
                alert.runModal() // Run the alert
            }
            // If everything checks out, continue submitting the order
            else {
                // Calling CollectOrderList to merge Orderlist into single string
                CollectOrderList()
                
                // Submitting the order to past Orders
                Orders.append("Name: \(NameString); Coffee Ordered: \(Ordered) Total Cost: $\(TotalCost) | Delivery: No")
                
                // Clearing the Output window and adding a new title
                Output.string = "Past Orders: \n\n"
                for x in Orders {
                    Output.string += x + "\n"
                }
                
            }
        }
        
        // Resseting variables for another order
        ResetAll()
    }
    
    // Function to reset / cancel the order
    @IBAction func ResetOrder(_ sender: Any) {
        let alert: NSAlert = NSAlert()
        alert.messageText = "Are you sure you want to reset the order?"
        alert.addButton(withTitle: "Ok")
        alert.addButton(withTitle: "Cancel")
        let result = alert.runModal()
        
        switch result {
        case NSApplication.ModalResponse.alertFirstButtonReturn: ResetAll()
        case NSApplication.ModalResponse.alertSecondButtonReturn: break
        default: break
        }
        
    }
    
    // Function to quit the program.
    @IBAction func Quit(_ sender: Any) {
        // Shut down the program
        NSApplication.shared.terminate(self)
    }
    
    // Connecting ALL radio buttons in GUI to the controller
    @IBOutlet weak var ArabicaEthiopia: NSButton!
    @IBOutlet weak var ArabicaKenyan: NSButton!
    @IBOutlet weak var ArabicaRwandan: NSButton!
    @IBOutlet weak var ArabicanZimbabwean: NSButton!
    @IBOutlet weak var RobustaEthiopian: NSButton!
    @IBOutlet weak var RobustaKenyan: NSButton!
    @IBOutlet weak var RobustaRwandan: NSButton!
    @IBOutlet weak var RobustaZimbabwean: NSButton!
    @IBOutlet weak var LibericaEthiopian: NSButton!
    @IBOutlet weak var LibericaKenyan: NSButton!
    @IBOutlet weak var LibericaRwandan: NSButton!
    @IBOutlet weak var LibericanZimbabwean: NSButton!
    @IBOutlet weak var LibericanChad: NSButton!
    @IBOutlet weak var ExcelsaEthiopian: NSButton!
    @IBOutlet weak var ExcelsaKenyan: NSButton!
    @IBOutlet weak var ExcelsaRwandan: NSButton!
    
    // Radio button action method
    @IBAction func radioButtonChanged(_sender: Any) {
    
    }
    
    // Connecting various other coffee order specifications for use in the AddCoffee() function
    @IBOutlet weak var CoffeeStrengthOutlet: NSSlider!
    @IBOutlet weak var CoffeeGroundedOutlet: NSButton!
    @IBOutlet weak var CoffeeAmountOutlet: NSTextField!
    
    // Connection User inputs for customer data to controller
    @IBOutlet weak var DeliveryOutlet: NSButton!
    @IBOutlet weak var NameTextField: NSTextField!
    @IBOutlet weak var PhoneNumberTextField: NSTextField!
    @IBOutlet weak var AddressNumberTextField: NSTextField!
    @IBOutlet weak var AddressTextField: NSTextField!
    @IBOutlet weak var AddressPostCodeTextField: NSTextField!
    
    // Connecting the Output window to the controller
    @IBOutlet var Output: NSTextView!
    
}

