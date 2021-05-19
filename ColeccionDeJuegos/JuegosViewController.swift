//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by David Alejo Apaza on 5/17/21.
//  Copyright © 2021 David Alejo Apaza. All rights reserved.
//

import UIKit

class JuegosViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    
    var juego:Juego? = nil
    
    @IBOutlet weak var JuegoImageView: UIImageView!
    
    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    
    @IBOutlet weak var eliminarBoton: UIButton!
    
    
    var categorias = ["Accion", "Aventura", "Terror", "Arcade", "Estrategia"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        
        if juego != nil {
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            juego!.categoria = categorias[pickerView.selectedRow(inComponent: 0)]
            
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = categorias[pickerView.selectedRow(inComponent: 0)]
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        JuegoImageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if juego != nil {
            JuegoImageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            
            pickerView.selectRow(categorias.firstIndex(of: juego!.categoria!)!, inComponent: 0, animated: true)
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        } else {
            eliminarBoton.isHidden = true
        }
    }
    

}

extension JuegosViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }
}
