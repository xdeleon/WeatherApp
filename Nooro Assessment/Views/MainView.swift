//
//  Created by Xavier De Leon on 1/28/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("SavedCity") private var savedCity = ""
    @StateObject var weatherVM: WeatherVM
    
    var body: some View {
        NavigationStack {
            VStack {
                if let weather = weatherVM.weather, weatherVM.selectedResult == false {
                    HStack() {
                        VStack(spacing: -10) {
                            Text("\(weather.location.name)")
                                .font(.custom(NooroFont.poppinsBold.rawValue, size: 20))
                                .foregroundColor(NooroColor.BlackText.color())
                                .padding(.top, 10)
                            
                            HStack {
                                Text("\(Int(weather.current.tempC))")
                                    .font(.custom(NooroFont.poppinsRegular.rawValue, size: 60))
                                    .foregroundColor(NooroColor.BlackText.color())
                                Image(.degree)
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                    .offset(y: -20)
                            }.padding(.horizontal, 30)
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: weather.icon) { image in
                            image
                                .resizable()
                                .frame(width: 123, height: 123)
                        } placeholder: {
                            // Add placeholder of activity loading indicator in future.
                        }
                    }
                    .padding(20)
                    .frame(width: 337, height: 117, alignment: .center)
                    .background((NooroColor.BackgroundGray.color()))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            weatherVM.selectedResult = true
                            savedCity = weather.location.name
                        }
                    }
                } else if let weather = weatherVM.weather, weatherVM.selectedResult == true {
                    VStack(spacing: 2) {
                        AsyncImage(url: weather.icon) { image in
                            image
                                .resizable()
                                .frame(width: 123, height: 123)
                        } placeholder: {
                            // Add placeholder of activity loading indicator in future.
                        }
                        
                        HStack {
                            Text("\(weather.location.name)")
                                .font(.custom(NooroFont.poppinsBold.rawValue, size: 30))
                                .foregroundColor(NooroColor.BlackText.color())
                            Image(.location)
                                .resizable()
                                .frame(width: 21, height: 21)
                        }
                        
                        HStack {
                            Text("\(Int(weather.current.tempC))")
                                .font(.custom(NooroFont.poppinsRegular.rawValue, size: 70))
                                .foregroundColor(NooroColor.BlackText.color())
                            Image(.degree)
                                .resizable()
                                .frame(width: 8, height: 8)
                                .offset(y: -26)
                        }
                    }.padding(.top, 20)
                    
                    VStack(spacing: 10) {
                        HStack {
                            VStack(spacing: 4) {
                                Text("Humidity")
                                    .font(.custom(NooroFont.poppinsRegular.rawValue, size: 12))
                                    .foregroundColor(NooroColor.LightGrayText.color())
                                Text("\(Int(weather.current.tempC))")
                                    .font(.custom(NooroFont.poppinsBold.rawValue, size: 15))
                                    .foregroundColor(NooroColor.DarkGrayText.color())
                            }
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text("UV")
                                    .font(.custom(NooroFont.poppinsRegular.rawValue, size: 12))
                                    .foregroundColor(NooroColor.LightGrayText.color())
                                Text("\(Int(weather.current.uv))")
                                    .font(.custom(NooroFont.poppinsBold.rawValue, size: 15))
                                    .foregroundColor(NooroColor.DarkGrayText.color())
                            }
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text("Feels Like")
                                    .font(.custom(NooroFont.poppinsRegular.rawValue, size: 8))
                                    .foregroundColor(NooroColor.LightGrayText.color())
                                Text("\(Int(weather.current.feelslikeC)) °")
                                    .font(.custom(NooroFont.poppinsBold.rawValue, size: 15))
                                    .foregroundColor(NooroColor.DarkGrayText.color())
                            }
                        }.padding(.horizontal, 20)
                    }
                    .frame(width: 274, height: 75, alignment: .center)
                    .background((NooroColor.BackgroundGray.color()))
                    .cornerRadius(10)
                }
                
                else if weatherVM.searchText.isEmpty {
                    VStack(spacing: 10) {
                        Text("No City Selected")
                            .font(.custom(NooroFont.poppinsRegular.rawValue, size: 30))
                            .foregroundColor(NooroColor.BlackText.color())
                        Text("PLEASE SEARCH FOR A CITY")
                            .font(.custom(NooroFont.poppinsRegular.rawValue, size: 15))
                            .foregroundColor(NooroColor.BlackText.color())
                    }.padding(.top, 230)
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                if !savedCity.isEmpty {
                    weatherVM.searchText = savedCity
                    weatherVM.getWeatherData()
                    weatherVM.selectedResult = true
                }
            }
            .searchable(text: $weatherVM.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Location")
            .onSubmit(of: .search) {
                guard weatherVM.searchText.isEmpty == false else { return }
                withAnimation {
                    weatherVM.getWeatherData()
                }
            }
            .alert("SearchError", isPresented: $weatherVM.displaySearchError) {
                Button("OK", role: .cancel) { }
            }
            .alert("APIKey Missing. Search for <ADD_API_KEY> and add.", isPresented: $weatherVM.apiKeyMissing) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
