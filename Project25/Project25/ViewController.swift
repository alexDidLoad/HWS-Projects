//
//  ViewController.swift
//  Project25
//
//  Created by Alexander Ha on 11/11/20.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    //multipeer properties
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?
    
    //Data
    var images = [UIImage]()
    
    var toolbarButtons = [UIBarButtonItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        navigationController?.isToolbarHidden = false
        
      
        let messageButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(messageUsers))
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showUsers), for: .touchUpInside)
        let userInfo = UIBarButtonItem(customView: infoButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarButtons = [userInfo, spacer, messageButton]
        
        toolbarItems = toolbarButtons
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        //initializing MCSession with peerID and encryption option
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
    }
    
    
    //MARK: - Collection View Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    //MARK: - ImagePicker View Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        images.insert(image, at: 0)
        
        collectionView.reloadData()
        
        //check to see if there is an active session
        guard let mcSession = mcSession else { return }
        
        //check if there are any peers to send to
        if mcSession.connectedPeers.count > 0 {
            
            //convert image to Data object
            if let imageData = image.pngData() {
                
                //send it to all peers, ensuring it gets delivered
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                    
                } catch {
                    //show error message if there are problems
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    //MARK: - ButtonItem methods
    
    @objc func importPicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func showConnectionPrompt() {
        
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        
        //Host your own session
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        
        //Join a session
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func messageUsers() {
        
        let ac = UIAlertController(title: "New Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let send = UIAlertAction(title: "Send", style: .default) { [weak self, weak ac] action in
            guard let message = ac?.textFields?[0].text else { return }
            self?.convertMessage(message)
        }
        ac.addAction(send)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    @objc func showUsers() {
        
        guard let mcSession = mcSession else { return }
        let ac = UIAlertController(title: "Users Connected", message: nil, preferredStyle: .actionSheet)
        
        if mcSession.connectedPeers.count > 0 {
            var peers = [String]()
            //loops through array of MCPeerID's and appends the display names to the peers array
            for users in mcSession.connectedPeers {
                peers.append(users.displayName)
                //loops through the peers array and appends each peer to the message property in the UIAlertController
                for peer in peers {
                    ac.message = peer
                }
            }
        } else {
            ac.title = "No users are connected"
        }
        ac.addAction(UIAlertAction(title: "Done", style: .default))
        present(ac, animated: true)
    }
    
    func convertMessage(_ message: String) {
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if message != "" {
                let dataMessage = Data(message.utf8)
                //send message to all peers
                do {
                    
                    try mcSession.send(dataMessage, toPeers: mcSession.connectedPeers, with: .reliable)
                    
                } catch {
                    
                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    //MARK: - Session methods
    
    func startHosting(action: UIAlertAction) {
        
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        mcNearbyServiceAdvertiser?.delegate = self
        mcNearbyServiceAdvertiser?.startAdvertisingPeer()
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true, mcSession)
    }
    
    
    func joinSession(action: UIAlertAction) {
        
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
        
        DispatchQueue.main.async { [weak self] in
            if state == .notConnected {
                let ac = UIAlertController(title: "\(peerID.displayName) disconnected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let message = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "\(peerID.displayName) says:", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //not required
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //not required
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //not required
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    
    
    
}

