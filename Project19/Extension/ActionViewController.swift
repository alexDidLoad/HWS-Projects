//
//  ActionViewController.swift
//  Extension
//
//  Created by Alexander Ha on 10/22/20.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Scripts", style: .plain, target: self, action: #selector(scriptList))
        
        loadScript()
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    //sets our 2 properties | typecasts them into strings
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    //sets the title to the pagetitle. done on main queue as loadItem(forTypeIdentifier can be called on any thread and we dont want to change the UI unless we're on the main thread.
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        //MARK: - Adjusting keyboard for text
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    //MARK: - @objc functions
    
    @objc func done() {
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript" : script.text!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey : argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        saveUserDefault()
    }
    
    // #1
    @objc func adjustForKeyboard(notification: Notification) {
        
        // #2
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        // #3
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        // #4
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset
        
        // #5
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
        
    }
    
    @objc func scriptList() {
        
        let alertScript = "alert(document.title);"
        
        let ac = UIAlertController(title: "Scripts", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Alert Script", style: .default, handler: { [weak self] action in
            self?.script.text = alertScript
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func saveUserDefault() {
        defaults.set(self.pageURL, forKey: userKeys.saveURL)
        
        
        
        defaults.set(self.script.text, forKey: userKeys.saveScript)
    }
    
    func loadScript() {
        let loadedScript = defaults.value(forKey: userKeys.saveScript) as? String ?? ""
        script.text = loadedScript
    }
    
}

struct userKeys {
    
    static var saveURL = "URL"
    static var saveScript = "Script"
  
}
