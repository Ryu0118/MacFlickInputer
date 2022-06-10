//
//  ViewController.swift
//  app
//
//  Created by Ryu on 2022/06/10.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    
    @IBOutlet private weak var connectLabel: UILabel!
    @IBOutlet private weak var connectButton: UIButton!
    @IBOutlet weak var linkButton: UIButton! {
        didSet {
            linkButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet private weak var textField: CustomTextField! {
        didSet {
            textField.didDelete = {[unowned self] in
                socket.write(string: "client:delete")
            }
        }
    }
 
    let request = URLRequest(url: URL(string: "http://192.168.0.56:8765")!)
    var socket: WebSocket!
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        socket = WebSocket(request: request)
        didReceive()
    }
    
    private func didReceive() {
        socket.onEvent = {[unowned self] event in
            switch event {
            case .connected(_):
                connectLabel.text = "接続完了"
                connectButton.setTitle("接続解除", for: .normal)
                isConnected = !isConnected
            case .disconnected(_, _):
                connectLabel.text = "接続していません"
                connectButton.setTitle("接続", for: .normal)
                isConnected = !isConnected
            case .text(let received):
                let data = received.components(separatedBy: ":")
                if let device = data[safe: 0],
                   let message = data[safe: 1],
                   device == "server" {
                    textField.text = message
                }
            case .error(let error):
                guard let error = error else { return }
                print(error)
            default:
                break
            }
        }
    }
    
    @IBAction func connectButtonDidPress(_ sender: Any) {
        if isConnected {
            socket.disconnect()
            connectLabel.text = "接続解除中"
        }
        else {
            socket.connect()
            connectLabel.text = "接続中"
        }
    }
    
    @IBAction func linkButtonDidPress(_ sender: Any) {
        socket.write(string: "client:link")
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        guard let text = textField.text, let last = text.last else { return }
        guard isConnected else { return }
        socket.write(string: "client:" + String(last))
    }
    
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class CustomTextField: UITextField {
    
    var didDelete: (() -> ())?
    
    override func deleteBackward() {
        super.deleteBackward()
        didDelete?()
    }
    
}
