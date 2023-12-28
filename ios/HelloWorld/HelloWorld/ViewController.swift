/*
 * This is the sample of Dynamsoft Code Parser.
 *
 * Copyright © Dynamsoft Corporation.  All rights reserved.
 */


import UIKit
import DynamsoftCodeParser

typealias ConfirmCompletion = () -> Void

class ViewController: UIViewController {

    let coderParser = CodeParser()
    
    private var parsedContent = ""
    
    private var presetParsedData: Data? = nil
    
    lazy var parsingTextView: DSTextView = {
        let left = 20.0
        let top = kNavigationBarFullHeight
        let width = kScreenWidth - 2 * left
        let height = 200.0
        let textView = DSTextView(frame: CGRectMake(left, top, width, height), placeHolder: "Input your source code.")
        textView.backgroundColor = .black.withAlphaComponent(0.1)
        textView.tintColor = .gray
        return textView
    }()
    
    lazy var dcpList: ParsingListView = {
        let left = parsingTextView.left
        let top = parsingTextView.bottom + 10.0
        let width = kScreenWidth - 2 * left
        let height = 300.0
        let list = ParsingListView(frame: CGRect(x: left, y: top, width: width, height: height))
        return list
    }()
    
    lazy var parsingButton: UIButton = {
        let left = 120.0
        let width = kScreenWidth - 2 * left
        let height = 50.0
        let top = kScreenHeight - kTabBarSafeAreaHeight - 50.0 - height
        let button = UIButton(frame: CGRectMake(left, top, width, height))
        button.backgroundColor = .darkGray
        button.setTitle("Parse", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6.0
        button.titleLabel?.font = kFont_Regular(20.0)
        button.addTarget(self, action: #selector(parsingAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() -> Void {
        self.view.addSubview(parsingTextView)
        self.view.addSubview(dcpList)
        self.view.addSubview(parsingButton)
        dcpList.isHidden = true
        
        self.parsingTextView.didEndEditingCompletion = {
            [unowned self] string in
            self.parsedContent = string
            self.presetParsedData = nil
        }
        
        self.parsingTextView.accessoryListStateChangedCompletion = {
            [unowned self] isHidden in
            self.dcpList.isHidden = isHidden
        }
        
        self.dcpList.didSelectParsingCompletion = {
            [unowned self] presetParsedString, presetParsedData in
            self.parsedContent = presetParsedString
            self.presetParsedData = presetParsedData
            self.parsingTextView.updateWith(text: presetParsedString)
        }
    }

    @objc private func parsingAction(_ button: UIButton) -> Void {
        // Generate a Data object from the user input or the preset string.
        // The Data will be used as the input of Dynamsoft Code Parser.
        var data: Data?
        if presetParsedData != nil {// Use the preset data.
            data = presetParsedData
        } else {// Use the customized data.
            data = parsedContent.data(using: String.Encoding(rawValue: NSUTF8StringEncoding))
        }
        guard data != nil else {return}
        // Use the parse method to parse the content.
        let dcpResultItem = try? self.coderParser.parse(data!, taskSettingName: "")
        
        if dcpResultItem != nil {
            // Property parsedFields holds the parsed content in a NSDictionary.
            // The key of the dictionary is the field name and the value is the parsed field value.
            // You can view the API references for more ways to extract the parsed content.
            // https://www.dynamsoft.com/code-parser/docs/mobile/programming/ios/api-reference/parsed-result-item.html
            guard let parsedFields = dcpResultItem?.parsedFields else { return }
            let codeType = dcpResultItem?.codeType ?? ""
            
            var tipTitle = ""
            var tipContent = ""
            switch codeType {
            case ParsedType.MRTD_TD1_ID.rawValue:
                tipTitle = "Value of document number: "
                tipContent = parsedFields["documentNumber"] ?? ""
            case ParsedType.MRTD_TD2_ID.rawValue:
                tipTitle = "Value of document number: "
                tipContent = parsedFields["documentNumber"] ?? ""
            case ParsedType.MRTD_TD2_VISA.rawValue:
                tipTitle = "Value of document number: "
                tipContent = parsedFields["documentNumber"] ?? ""
            case ParsedType.MRTD_TD3_PASSPORT.rawValue:
                tipTitle = "Value of passport number: "
                tipContent = parsedFields["passportNumber"] ?? ""
            case ParsedType.MRTD_TD3_VISA.rawValue:
                tipTitle = "Value of document number: "
                tipContent = parsedFields["documentNumber"] ?? ""
            case ParsedType.AAMVA_DL_ID.rawValue:
                tipTitle = "Value of license number: "
                tipContent = parsedFields["licenseNumber"] ?? ""
            case ParsedType.AAMVA_DL_ID_WITH_MAG_STRIPE.rawValue:
                tipTitle = "Value of ID number: "
                tipContent = parsedFields["DLorID_Number"] ?? ""
            case ParsedType.SOUTH_AFRICA_DL.rawValue:
                tipTitle = "Value of ID number: "
                tipContent = parsedFields["idNumber"] ?? ""
            case ParsedType.AADHAAR.rawValue:
                tipTitle = "Value of ID number: "
                tipContent = parsedFields["idNumber"] ?? ""
            case ParsedType.VIN.rawValue:
                tipTitle = "Value of WMI: "
                tipContent = parsedFields["WMI"] ?? ""
            default:
                tipTitle = "Unidentified type"
                tipContent = "Unknow"
            }
            displaySingleResult(tipTitle, tipContent, "OK")
        } else {
            displayError(msg: "No results")
        }
    }
    
    private func displaySingleResult(_ title: String, _ msg: String, _ acTitle: String, completion: ConfirmCompletion? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: acTitle, style: .default, handler: { _ in completion?() }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func displayError(_ title: String = "", msg: String, _ acTitle: String = "OK", completion: ConfirmCompletion? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: acTitle, style: .default, handler: { _ in completion?() }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

