### Instalation
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'MyApp' do
  pod 'Kingfisher', :git => "https://github.com/sonhd92/HolidayCheckSDK.git"
end
```

### Usage
For example, you're creating a date picker for picking a date, month, and year to check:

```swift
import SwiftUI
import HolidaySDK

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var selectedMode: HolidayMode = .any
    @State private var result: String = "Result go here"
    @State private var isRequesting: Bool = false
    
    let holidayChecker = HolidayChecker()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Holiday Check")
                .font(.largeTitle)
                .bold()
                .padding()
            
            DatePicker("Select a Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Picker("Validation Mode", selection: $selectedMode) {
                Text("Any").tag(HolidayMode.any)
                Text("All").tag(HolidayMode.all)
                Text("Consensus").tag(HolidayMode.consensus)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button(action: checkHoliday) {
                Text("Check holiday")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Text(result)
                .font(.headline)
                .foregroundColor(.black)
                .padding()
        }
        .padding()
    }
    
    private func checkHoliday() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let day = calendar.component(.day, from: selectedDate)
        
        holidayChecker.isHoliday(year: year, month: month, day: day, mode: selectedMode) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let isHoliday):
                    result = isHoliday ? "It's a holiday" : "It's not a holiday"
                case .failure(let error):
                    result = "Error: \(error)"
                }
            }
        }
    }
}

```
