//
//  TextWithCoverCell.swift
//  Grapher
//
//  Created by Amy While on 28/10/2020.
//

import UIKit

class TextWithCoverCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBInspectable weak var minHeight: NSNumber! = 50
        
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeight else { return size }
        return CGSize(width: size.width, height: max(size.height, (minHeight as! CGFloat)))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.label.adjustsFontSizeToFitWidth = true
    }    
}
