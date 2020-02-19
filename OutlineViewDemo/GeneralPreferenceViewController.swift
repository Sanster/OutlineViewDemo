import Cocoa
import Preferences

protocol GeneralPaneDelegate {
    func relunchPreference()
}

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    var delegate: GeneralPaneDelegate?

    override var nibName: NSNib.Name? { "GeneralPreferenceViewController" }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup stuff here
    }
    
    @IBAction func switchClicked(_ sender: Any?) {
        print("click")
        delegate?.relunchPreference()
    }
}
