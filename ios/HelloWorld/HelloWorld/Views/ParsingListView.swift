/*
 * This is the sample of Dynamsoft Code Parser.
 *
 * Copyright © Dynamsoft Corporation.  All rights reserved.
 */


import UIKit

let kParsedType = "Type"

let kParsedValue = "Value"

enum ParsedType: String {
    case MRTD_TD1_ID = "MRTD_TD1_ID"
    case MRTD_TD2_ID = "MRTD_TD2_ID"
    case MRTD_TD2_VISA = "MRTD_TD2_VISA"
    case MRTD_TD3_PASSPORT = "MRTD_TD3_PASSPORT"
    case MRTD_TD3_VISA = "MRTD_TD3_VISA"
    case AAMVA_DL_ID = "AAMVA_DL_ID"
    case AAMVA_DL_ID_WITH_MAG_STRIPE = "AAMVA_DL_ID_WITH_MAG_STRIPE"
    case SOUTH_AFRICA_DL = "SOUTH_AFRICA_DL"
    case AADHAAR = "AADHAAR"
    case VIN = "VIN"
}

enum ParsedValue: String {
    case MRTD_TD1_ID = "IDCANPC2979X0H4<<<<<<<<<<<<<<<6812171F1312171CAN<<<<<<<<QC<0LAPOINTE<<ANNE<MARIE<<<<<<<<<<"
    case MRTD_TD2_ID = "IDD<<ADENAUER<<KONRAD<HERMANN<JOSEPH1234567897D<<7601059M6704115<<<<<<<2"
    case MRTD_TD2_VISA = "V<UTOERIKSSON<<JOHN<ARTHUR<<<<<<<<<<L8989O1C<6XXX4009072M9612109<<<<<<<<"
    case MRTD_TD3_PASSPORT = "P<D<<ADENAUER<<KONRAD<HERMANN<JOSEPH<<<<<<<<1234567897D<<7601059M6704115<<<<<<<<<<<<<<<2"
    case MRTD_TD3_VISA = "V<UTOERIKSSON<<JOHN<ARTHUR<<<<<<<<<<<<<<<<<<L8988901C0XXX4009072M96121096ZE184226B<<<<<<"
    case AAMVA_DL_ID = "@\n\\u001e\rANSI 636014090002DL00410276ZC03170024DLDAQC7179775\nDCSHARBART\nDDEN\nDACPEGGY\nDDFN\nDADANN\nDDGN\nDCAC\nDCB01\nDCDNONE\nDBD08132018\nDBB08231947\nDBA08232023\nDBC2\nDAU062 IN\nDAYBLU\nDAG4235 MONHEGAN WAY\nDAIMATHER\nDAJCA\nDAK956550000  \nDCF08/13/201867337/DDFD/23\nDCGUSA\nDAW117\nDAZBRO\nDCK18225C71797750401\nDDAF\nDDB08292017\nDDK1\rZCZCABLU\nZCBBRN\nZCC\nZCD\r "
    case AAMVA_DL_ID_WITH_MAG_STRIPE = "BCVICTORIA^Smith,$John Fred^28 Atol Av$Suite 2$^?;6360281234567=207719981224=?%0AABC12345678                M183069BROBLO1002008888                3*\"$X75VZIR?"
    case SOUTH_AFRICA_DL = "1,155,9,69,0,0,55,37,105,1,179,160,122,187,69,131,54,103,89,13,31,89,194,231,124,35,238,118,233,118,90,15,100,15,210,209,18,156,126,248,221,205,252,160,156,21,167,102,51,203,228,185,139,187,81,84,96,55,70,34,32,237,65,126,145,235,188,242,24,125,182,198,90,4,183,9,133,219,40,239,83,65,22,111,103,103,37,184,133,145,110,211,38,78,158,207,183,208,26,155,143,65,25,60,210,37,75,15,131,192,121,252,33,234,22,88,98,38,64,125,84,181,47,243,164,22,236,170,176,125,20,244,136,17,19,236,110,173,63,43,134,59,74,109,253,166,92,216,40,113,38,70,79,187,61,117,54,37,169,181,145,131,22,229,211,69,37,200,148,59,4,227,46,162,196,57,162,11,11,108,161,154,237,84,242,128,80,156,240,146,45,72,33,118,73,247,138,1,112,25,63,78,110,253,139,19,71,245,83,164,104,245,235,188,32,176,67,119,142,3,55,39,210,74,204,33,89,211,40,43,145,5,40,35,84,6,152,83,60,213,5,223,145,81,45,182,226,51,203,251,106,67,121,191,184,98,225,95,65,213,114,183,201,38,108,143,17,134,57,174,15,111,241,55,25,46,196,252,14,213,144,134,104,103,47,11,231,39,14,20,65,209,102,111,119,75,209,219,115,59,251,69,13,149,236,103,198,167,211,160,8,199,86,109,79,148,233,3,114,51,170,230,18,167,113,11,112,58,203,37,61,141,70,33,27,203,67,221,174,227,85,182,64,28,228,34,194,156,176,79,131,42,222,121,137,125,59,158,122,91,95,206,101,147,178,23,79,19,115,162,199,60,207,233,243,129,75,232,104,159,155,246,223,138,20,95,18,116,7,21,72,36,234,229,45,213,146,191,92,34,111,47,16,181,78,122,197,24,12,145,150,149,134,250,186,182,116,194,206,119,113,170,191,73,95,49,84,91,252,94,52,146,63,199,143,110,39,34,13,248,66,68,108,228,204,88,27,142,146,117,1,40,156,34,101,201,103,22,203,100,163,238,5,18,48,148,79,222,80,20,156,92,69,193,32,245,144,252,79,92,90,254,228,137,211,177,35,20,225,67,47,55,153,83,56,89,243,194,76,8,206,161,4,42,249,64,1,93,47,213,244,93,174,55,223,211,32,222,48,188,71,146,183,64,1,250,222,120,17,166,46,241,59,166,95,197,189,113,234,158,63,169,239,157,179,156,154,145,188,168,56,137,79,211,182,188,93,254,115,127,22,76,120,120,47,162,178,28,161,238,163,199,23,7,179,244,30,226,78,48,129,206,244,1,120,17,82,80,124,250,116,196,124,108,123,227,150,95,136,119,191,39,227,127,50,57,239,125,205,197,248,67,25,79,249,231,123,110,49,233,53,253,190,193,227,154,69,25,184,246,229,10,49,136,5,105,200,48,247,184,234,89,104,192,227,63,62,201,152,200,198,245,155,202,38,14,103,110,62,56,117,77,139,194,231,35,241,61,153,244,73,250,171,132,233,100,239,191,63,96,160,191,155,182,216,233,73,199,42,48,78,74,241,138,39,169,252,253,191,245,88,45,206,223,253,223,95,86,64,255,128,222,184,24,173,184,52,8,55,190"
    case AADHAAR = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<PrintLetterBarcodeData uid=\"833365948461\" name=\"Salaudin Ansari\" gender=\"M\" yob=\"2000\" co=\"S/O: Mustkim Ansari\" loc=\"rajapur\" vtc=\"Rajapur\" po=\"Chakia\" dist=\"Siwan\" subdist=\"Bhagwanpur Hat\" state=\"Bihar\" pc=\"841507\" dob=\"10/03/2000\"/>"
    case VIN = "1NXBU40E19Z159787"
}

typealias DidSelectParsingCompletion = (_ parsedContent: String, _ parsedData: Data) -> Void

class ParsingListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var dcpListDataArray: [[String : String]] = []
    
    private let headerHeight = 20.0
    
    private let headerTitleFont = kFont_Regular(12.0)
    
    private let cellHeight = 25.0
    
    private let cellTitleFont = kFont_Regular(14.0)
    
    var didSelectParsingCompletion: DidSelectParsingCompletion?
    
    lazy var listTableView: UITableView = {
        let tableView = UITableView.init(frame:self.bounds, style: .grouped)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.tableHeaderView = UIView(frame: CGRectZero)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        handleData()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func handleData() -> Void {
        dcpListDataArray = [[kParsedType: ParsedType.MRTD_TD1_ID.rawValue,
                            kParsedValue: ParsedValue.MRTD_TD1_ID.rawValue],
                            [kParsedType: ParsedType.MRTD_TD2_ID.rawValue,
                            kParsedValue: ParsedValue.MRTD_TD2_ID.rawValue],
                            [kParsedType: ParsedType.MRTD_TD2_VISA.rawValue,
                            kParsedValue: ParsedValue.MRTD_TD2_VISA.rawValue],
                            [kParsedType: ParsedType.MRTD_TD3_PASSPORT.rawValue,
                            kParsedValue: ParsedValue.MRTD_TD3_PASSPORT.rawValue],
                            [kParsedType: ParsedType.MRTD_TD3_VISA.rawValue,
                            kParsedValue: ParsedValue.MRTD_TD3_VISA.rawValue],
                            [kParsedType: ParsedType.AAMVA_DL_ID.rawValue,
                            kParsedValue: ParsedValue.AAMVA_DL_ID.rawValue],
                            [kParsedType: ParsedType.AAMVA_DL_ID_WITH_MAG_STRIPE.rawValue,
                            kParsedValue: ParsedValue.AAMVA_DL_ID_WITH_MAG_STRIPE.rawValue],
                            [kParsedType: ParsedType.SOUTH_AFRICA_DL.rawValue,
                            kParsedValue: ParsedValue.SOUTH_AFRICA_DL.rawValue],
                            [kParsedType: ParsedType.AADHAAR.rawValue,
                            kParsedValue: ParsedValue.AADHAAR.rawValue],
                            [kParsedType: ParsedType.VIN.rawValue,
                            kParsedValue: ParsedValue.VIN.rawValue],
        ]
    }
    
    func setupUI() -> Void {
        self.addSubview(listTableView)
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView(frame: CGRectMake(0, 0, self.width, headerHeight))
        let titleLabel = UILabel(frame: CGRectMake(2.0, 2.0, sectionHeader.width - 4.0, headerHeight - 4.0))
        titleLabel.backgroundColor = .lightGray
        titleLabel.text = "You can also select a preset code string to parse"
        titleLabel.textAlignment = .center
        titleLabel.font = headerTitleFont
        titleLabel.layer.cornerRadius = 5.0
        titleLabel.layer.masksToBounds = true
        sectionHeader.addSubview(titleLabel)
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dcpListDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexDic = dcpListDataArray[indexPath.row]
        let type = indexDic[kParsedType]!
        let content = indexDic[kParsedValue]!
        
        let identifier = UITableViewCell.className
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.textLabel?.lineBreakMode = .byTruncatingTail
            cell?.textLabel?.font = cellTitleFont
        }

        cell?.textLabel?.text = String(format: "%@:%@", type, content)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexDic = dcpListDataArray[indexPath.row]
        let type = indexDic[kParsedType]!
        let content = indexDic[kParsedValue]!
        var parsedData: Data?
        if type == ParsedType.SOUTH_AFRICA_DL.rawValue {
            let separatedArr = content.components(separatedBy: [","])
            var bytesArr = [UInt8]()
            for singleBytes in separatedArr {
                bytesArr.append(UInt8(singleBytes)!)
            }
            parsedData = Data(bytesArr)
        } else {
            parsedData = content.data(using: String.Encoding(rawValue: NSUTF8StringEncoding))
        }
        didSelectParsingCompletion?(content, parsedData!)
    }

}
