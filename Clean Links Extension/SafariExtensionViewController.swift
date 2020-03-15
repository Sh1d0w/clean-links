//
//  SafariExtensionViewController.swift
//  Clean Links Extension
//
//  Created by Radoslav Vitanov on 13.03.20.
//  Copyright © 2020 Radoslav Vitanov. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    var items: [Event] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:350, height:300)
        return shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColors = [.clear]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CleanedLinkItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Event")
        )
        
    }

}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:NSFont { return NSFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:NSFont { return NSFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

extension SafariExtensionViewController: NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {
    private func getLabel(item: Event) -> NSMutableAttributedString {
       switch item.type {
            case EventType.linkTracker:
                return NSMutableAttributedString()
                    .normal("Prevented redirect from ")
                    .bold("\(item.domain)")
                    .normal(" to ")
                    .bold("\(item.value)")
            default:
                return NSMutableAttributedString()
                    .normal("Removed ")
                    .bold("\(item.value)")
                    .normal(" from ")
                    .bold("\(item.domain)")
        }
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let height: CGFloat = 30

        let size = CGSize(width: collectionView.frame.size.width, height: height)
        let options = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 14)]

        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Event"), for: indexPath) as! CleanedLinkItem
    
        var image: NSImage? = nil
        let label: NSMutableAttributedString = getLabel(item: items[indexPath.item])
        
        switch items[indexPath.item].type {
            case EventType.linkTracker:
                image = NSImage(named: NSImage.Name("Link"))
            default:
                image = NSImage(named: NSImage.Name("ShieldCheck"))
        }
        
        item.image.image = image
        item.label.attributedStringValue = label
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        //we are just measuring height so we add a padding constant to give the label some room to breathe!
        let padding: CGFloat = 5

        //estimate each cell's height
        let text = getLabel(item: items[indexPath.item])
        let options = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let height = text.boundingRect(with: collectionView.frame.size, options: options)

        return CGSize(width: collectionView.frame.size.width, height: height.size.height + padding)
    }
}
