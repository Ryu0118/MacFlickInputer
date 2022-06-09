//
//  ViewController.swift
//  app
//
//  Created by Ryu on 2022/06/10.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var connectLabel: UILabel!
    
    let request = URLRequest(url: URL(string: "http://localhost:8765")!)
    var socket: WebSocket!
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        socket = WebSocket(request: request)
        socket.connect()
    }
    
    @IBAction func connectButtonDidPressed(_ sender: Any) {
        defer { isConnected = !isConnected }
        if isConnected {
            socket.disconnect()
            connectLabel.text = "接続していません"
        }
        else {
            socket.connect()
            connectLabel.text = "接続中"
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        guard let text = textField.text, let last = text.last else { return }
        guard isConnected else { return }
        socket.write(string: String(last))
    }
    
}
