//
//  ViewController.swift
//  desafioValidaUsuario
//
//  Created by Cesar A. Tavares on 9/14/20.
//  Copyright © 2020 Cesar A. Tavares. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldSenha: UITextField!
    @IBOutlet weak var buttonCadastrar: UIButton!
    var userControl = UserControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEmail.delegate = self
        textFieldSenha.delegate = self
        buttonCadastrar.isEnabled = false
    }
    
    // Função que valida se os campos estão preenchidos
    private func validateFields() -> Bool{
        if textFieldEmail.text != nil && !textFieldEmail.text!.isEmpty && textFieldSenha.text != nil && !textFieldSenha.text!.isEmpty {
            buttonCadastrar.isEnabled = true
            return true
        }
        return false
    }

    // Função limpa os campos
    private func clearFields() {
        textFieldEmail.text = nil
        textFieldSenha.text = nil
    }

    // Função Botão Cadastrar - Valida usuários / Verifica se o usuário e a senha já foram cadastradas / Cadastra o usuário
    @IBAction func buttonCadastrar(_ sender: UIButton) {
        if validateFields() {
            let user = User(email: textFieldEmail.text!, password: textFieldSenha.text!)
            if userControl.userExist(user: user) {
                if userControl.passwordError! {
                    // ALERT
                    textFieldSenha.text = nil
                    textFieldSenha.becomeFirstResponder()
                } else {
                    self.view.backgroundColor = UIColor.red
                    clearFields()
                    textFieldEmail.becomeFirstResponder()
                    buttonCadastrar.isEnabled = false
                }
            } else {
                userControl.addUser(user: user)
                self.view.backgroundColor = UIColor.green
                clearFields()
                textFieldEmail.becomeFirstResponder()
                buttonCadastrar.isEnabled = false
            }
        }
    }
        
}

// Extensão da ViewController para os TextFields que valida os campos quando clicado no Retrun
extension ViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            if textFieldEmail != nil && !textFieldEmail.text!.isEmpty  {
                textFieldSenha.becomeFirstResponder()
            }
        } else {
            if validateFields() {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
}

// Classe para aramazenar as variáveis E-mail e Senha
class User {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

// Classe para adicionar o usuário / Verificar se existe o usuário e se a senha cadastrada são iguais
class UserControl {
    var arrayUsers = [User]()
    var passwordError: Bool?
    var userExist: Bool = false
    
    func addUser(user: User) {
        arrayUsers.append(user)
    }
    
    func userExist(user: User) -> Bool {
        for item in arrayUsers {
            if item.email == user.email {
                userExist = true
                if item.password == user.password {
                    passwordError = false
                    return userExist
                } else {
                    passwordError = true
                }
            } else {
                userExist = false
            }
        }
        return userExist
    }
}
