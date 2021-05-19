import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var juegos:[Juego] = []
    
    @IBOutlet weak var botonEditar: UIBarButtonItem!
    
    @IBAction func edicion(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        if tableView.isEditing == true {
            botonEditar.title = "Guardar"
        } else {
            botonEditar.title = "Editar"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.detailTextLabel?.text = "Categoria:  \(juego.categoria!)"
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juegos[indexPath.row])
            juegos.remove(at: indexPath.row)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let objetoMovido = self.juegos[fromIndexPath.row]
        juegos.remove(at: fromIndexPath.row)
        juegos.insert(objetoMovido, at: to.row)
    }
    
}
