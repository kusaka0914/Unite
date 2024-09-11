import SwiftUI
import Mantis

class CropCoordinator: NSObject, CropViewControllerDelegate{
    @Binding var image: UIImage?
    @Binding var isCropViewShowing: Bool // トリミングviewを出すかどうか
    init(image: Binding<UIImage?>, isCropViewShowing: Binding<Bool>){
        _image = image
        _isCropViewShowing = isCropViewShowing
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {
    
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        isCropViewShowing = false
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
        
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        image = cropped
        isCropViewShowing = false
    }
}

struct ImageCropper: UIViewControllerRepresentable{
    typealias Coordinator = CropCoordinator
    @Binding var image: UIImage?
    @Binding var isCropViewShowing: Bool
    @Binding var cropShapeType: Mantis.CropShapeType //　トリミングの形(丸や四角)
        
    func makeCoordinator() -> Coordinator{
        return Coordinator(image: $image, isCropViewShowing: $isCropViewShowing)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageCropper>) -> Mantis.CropViewController {
        var config = Mantis.Config()
        config.cropShapeType = cropShapeType // トリミングの形変更に必要
        let Editor = Mantis.cropViewController(image: image ?? UIImage(), config: config)
        Editor.delegate = context.coordinator
        return Editor
    }
}
