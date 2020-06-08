
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    lazy private var imageViews: [UIImageView] = {
        let imageViews = [
            UIImageView(frame: .zero),
            UIImageView(frame: .zero),
            UIImageView(frame: .zero)
        ]
        imageViews.forEach({ imageView in
            imageView.contentMode = .scaleAspectFit
        })
        return imageViews
    }()
    
    private var scrollViewSize: CGSize = .zero
    
    private var images: [UIImage] = [UIImage(named: "flag1")!,
                                     UIImage(named: "flag2")!,
                                     UIImage(named: "flag3")!,
                                     UIImage(named: "flag4")!,
                                     UIImage(named: "flag5")!,
                                     UIImage(named: "flag6")!]
    
    private var currentPage: Int = 0
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareImagesAndViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: scrollViewSize.width * CGFloat(imageViews.count), height: scrollViewSize.height)
        scrollView.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
        layoutImages()
    }
    
    // MARK: - private methods
    
    private func layoutImages() {
        
        let imageNums = [numberLooping(num: currentPage - 2),
                         numberLooping(num: currentPage - 1),
                         numberLooping(num: currentPage)]
        
        
        imageViews.enumerated().forEach { (index: Int, imageView: UIImageView) in
            imageView.image = images[imageNums[index]]
            imageView.frame = CGRect(x: scrollViewSize.width * CGFloat(index),
                                     y: 0,
                                     width: scrollViewSize.width,
                                     height: scrollViewSize.height)
        }
    }
    
    private func prepareImagesAndViews() {
        guard !images.isEmpty else { return }

        (0..<3).forEach { index in
            imageViews[index].image = images[numberLooping(num: currentPage)]
            scrollView.addSubview(imageViews[index])
            paging(amount: 1)
        }
        
        paging(amount: -2)
    }
    
    private func paging(amount: Int){
        currentPage += amount
        
        currentPage = numberLooping(num: currentPage)
    }
    
    private func numberLooping(num: Int) -> Int {
        
        if num < 0 {
            return numberLooping(num: num + images.count)
        }
        
        if num >= images.count {
            return numberLooping(num: num - images.count)
        }
        
        return num
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5) {
            paging(amount: 1)
            layoutImages()
            scrollView.contentOffset.x -= scrollViewSize.width
        }
        
        if (offsetX < scrollView.frame.size.width * 0.5) {
            paging(amount: -1)
            layoutImages()
            scrollView.contentOffset.x += scrollViewSize.width
        }
        
    }
    
}
