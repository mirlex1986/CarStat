import RxSwift
import RxCocoa
import UIKit

protocol PickerResult {}

extension UserMileage: PickerResult {}

enum Router {
    case addRefueling(lastRefueling: UserMileage?, isEditing: Bool = false)
    case addService
    
    case barCodeScanner
}

extension Router {
    // MARK: - Push
    func push(from navigationController: UINavigationController?, animated: Bool = true) {
        switch self {
        case .addRefueling(let lastRefueling, let isEditing):
            let vc = AddMileageViewController()
            vc.viewModel = AddMileageViewModel(lastMileage: lastRefueling, isEditing: isEditing)
            
            navigationController?.pushViewController(vc, animated: animated)
        case .addService:
            break
            
        default:
            return
        }
    }
    
    // MARK: - Present
    func present(from viewController: UIViewController?,
                 animated: Bool = true,
                 modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
                 modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {

        var presentedViewController: UIViewController?

        switch self {
        case .barCodeScanner:
            let vc = BarCodeScannerViewController()
            vc.viewModel = BarCodeScannerViewModel()
            
            presentedViewController = vc

        default: return
        }

        guard let vc = presentedViewController else { return }
        vc.modalTransitionStyle = modalTransitionStyle
        vc.modalPresentationStyle = modalPresentationStyle
        viewController?.present(vc, animated: animated)
    }
    
    // MARK: - Present with result
    @discardableResult
    func presentWithResult(from viewController: UIViewController?,
                           animated: Bool = true,
                           modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
                           modalPresentationStyle: UIModalPresentationStyle = .fullScreen) -> Observable<PickerResult?> {
        
        var presentedViewController: PickerController?
        var animated = animated
        var modalPresentationStyle = modalPresentationStyle
        
        switch self {
        case .barCodeScanner:
            let vc = BarCodeScannerViewController()
            vc.viewModel = BarCodeScannerViewModel()
            
            presentedViewController = vc
            
        default:
            return .empty()
        }
        
        switch self {
        case .barCodeScanner:
            
            animated = false
            modalPresentationStyle = .overFullScreen
        default: break
        }
        
        guard let vc = presentedViewController as? CSViewController,
              let pickerResult = presentedViewController?.result else { return .empty() }
        
        let controller = UINavigationController(rootViewController: vc)
        controller.modalTransitionStyle = modalTransitionStyle
        controller.modalPresentationStyle = modalPresentationStyle
        viewController?.present(controller, animated: animated)
        
        return pickerResult
    }
}
