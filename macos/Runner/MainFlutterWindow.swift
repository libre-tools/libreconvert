import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.setIsVisible(false) // Hide the window initially
    self.backgroundColor = NSColor.white // White background

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
