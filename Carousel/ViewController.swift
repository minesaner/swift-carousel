import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var carouselView: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.carouselImages(["0.jpg", "1.jpg", "2.jpg"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
