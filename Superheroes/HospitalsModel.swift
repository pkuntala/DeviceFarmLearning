//
//  HospitalsModel.swift
//  Superheroes
//
//  Created by Chris Davis J on 15/12/21.
//

import Foundation

// MARK: - Hospital
class Hospital: Codable {
    let name, address, desc: String
    let image: String
    let doctors, location: String

    init(name: String, address: String, desc: String, image: String, doctors: String, location: String) {
        self.name = name
        self.address = address
        self.desc = desc
        self.image = image
        self.doctors = doctors
        self.location = location
    }
}

typealias Hospitals = [Hospital]

func getHospitals(jsonData:String)->Hospitals{
    guard let hospitals = try? JSONDecoder().decode(Hospitals.self, from: (jsonData.data(using: .utf8) ?? "".data(using: .utf8)!))else{return []}
    return hospitals
}
func getHospitalJson(completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://mocki.io/v1/88b8209b-44b3-4bed-9b65-deba3c1c761e")else{return}
        
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil {
                print("\(error!)")
                AppInternalStates.networkAvailability=false
                completion(String("Network Error"))
                return
            }
            let res = response as! HTTPURLResponse
            guard let data = data else {return}
            //print("Status code : \(res.statusCode)")
            
            if res.statusCode == 200 {
                AppInternalStates.networkAvailability=true
                completion(String(decoding: data, as: UTF8.self))
            }else{
                print("Response code : \(res.statusCode)")
            }
        }
        task.resume()
}
