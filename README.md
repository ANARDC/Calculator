# Calculator
iOS Calculator App
## Архитектура
Архитектурой является улучшенный мною VIPER с помощью использования наследования протоколов, 
а также паттерна "Фабричный метод".
![Alt text](https://psv4.userapi.com/c856332/u90917369/docs/d13/0cdee5b6553e/Group_1.png?extra=om8n-lhsqxe7R9ImY1KOF8pwE57Rj7hd3h3mG1geakwQNDY7dKQbdsW3KPE2fSPFAQ4B-jsMEgFlRWW416z8mNnSmy1z_Y-wTO9-8-BJrkGUO6P3rolqjk1tllQ2yYyY8PS01NsRoBTMBjJw3alBuQ "Architecture")

### View
В данном приложении имеется несколько элементов View: 
* Главный View, содержащий калькулятор, а также кнопки
* UICollectionView's калькулятора
* View, отображающееся при нажатии на кнопку Info
* View, отображающееся при нажатии на кнопку Operations

Поскольку создавать отдельные Presenter's для каждого такого элемента было бы слишком затруднительно из-за большого 
количества зависимостей между множеством классов, то я решил оставить концепцию одного Presenter-элемента. 
Однако, каким-то образом необходимо предоставлять разным элементам View разные интерфейсы взаимодействия с элементом Presenter 
причем так чтобы методы одного интерфейса не имели место в другом.

Чтобы реализовать такой подход я создаю протоколы для разбиения Presenter'а, по каждому на каждый элемент View, а также еще
общий протокол, наследуемый от всех вышеупомянутых протоколов, который нам понадобится в дальнейшем в конфигураторе и для того 
чтобы задавать Presenter'у какие-либо общие свойства и методы, которые будут доступны для всех протоколов. Каждый элемент View при этом имеет сильную ссылку на соответствующий ему Presenter-протокол.

```swift
final class CalculatorViewController: UIViewController, CalculatorViewProtocol {
  var presenter: CalculatorPresenterProtocol!
  ...
}
 
final class InfoViewController: UIViewController, InfoViewProtocol {
  var presenter: CalculatorInfoViewPresenterProtocol!
  ...
}

final class OperationsViewController: UIViewController, OperationsViewProtocol {
  var presenter: CalculatorOperationsViewPresenterProtocol!
  ...
}

final class CalculatorCollectionViewCell: UICollectionViewCell, CalculatorCollectionViewCellProtocol {
  var presenter: CalculatorCollectionViewCellPresenterProtocol!
  ...
}
```
### Interactor
Такая же схема применяется и для элемента Interactor. Он разбивается протоколами для того чтобы предоставить интерфейсы для 
каждого Presenter-протокола (кроме Presenter'ов для UICollectionViewCell's так как в данном случае это не понадобилось). 
Каждый Presenter-протокол имеет сильную ссылку на соответствующий ему Interactor-протокол, а каждый Interactor-протокол имеет 
слабую ссылку на соответствующий ему Presenter-протокол.

```swift
final class CalculatorPresenter: CalculatorPresenterGeneralProtocol {
  var calculatorViewInteractor : CalculatorInteractorProtocol!
  var infoViewInteractor       : CalculatorInfoViewInteractorProtocol!
  var operationsViewInteractor : CalculatorOperationsViewInteractorProtocol!
  ...
}

final class CalculatorInteractor: CalculatorInteractorGeneralProtocol {
  weak var calculatorViewPresenter : CalculatorPresenterProtocol!
  weak var infoViewPresenter       : CalculatorInfoViewPresenterProtocol!
  weak var operationsViewPresenter : CalculatorOperationsViewPresenterProtocol!
  ...
}
```
### Presenter
Presenter-протокол главного View имеет сильную ссылку на ComputingFactoryProtocol для осуществления всех расчетов. 
ComputingFactoryProtocol в свою очередь держит слабую ссылку на Presenter.

```swift
final class CalculatorPresenter: CalculatorPresenterGeneralProtocol {
  var computingFactory: ComputingFactoryProtocol!
  ...
}

final class ComputingFactory: ComputingFactoryProtocol {
  weak var presenter: CalculatorPresenterGeneralProtocol! // По-хорошему такого делать не стоит, нужно выделить отдельный протокол
  ...
}
```

### Configurator
CalculatorConfigurator представляет собой класс, который производит всю инициализацию, присвоение свойств и отвечает за 
создание необходимых взаимосвязей между классами. Он держит слабую ссылку на главный View посколько последний имеет сильную 
ссылку на конфигуратор, а также хранит сильные ссылки на остальные View-элементы (кроме UICollectionViewCell's так как эти 
элементы будут присваиваться в соответствующий Presenter-протокол с помощью метода), ComputingFactoryProtocol и 
общие протоколы элементов Presenter и Interactor.

```swift
final class CalculatorConfigurator: CalculatorConfiguratorProtocol {
  weak var calculatorView : CalculatorViewProtocol!
  let infoView            : InfoViewProtocol!
  let operationsView      : OperationsViewProtocol!
  
  let presenter        : CalculatorPresenterGeneralProtocol!
  let interactor       : CalculatorInteractorGeneralProtocol!
  let computingFactory : ComputingFactoryProtocol!
  ...
}
```
### Router
Router-элемент из архитектуры VIPER в данном приложении не пригодился из-за наличия всего одного экрана и отсутствия навигации.

### Заключение
Такая схема с протоколами обеспечивает гибкость и имеет преимущество в том что может неограниченно масштабироваться 
для любого количества View-элементов на экране, сохраняя при этом целостность какого-либо элемента (Presenter, Interactor, etc) 
и предоставляя только необходимые части для определенных других элементов архитектуры. 
Необходимо лишь создавать соответствующие интерфейсы для View-элементов и добавлять эти 
интерфейсы как протоколы-родители для общего протокола.
