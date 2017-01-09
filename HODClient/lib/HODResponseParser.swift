//
//  HODResponseParser.swift
//  Parse HOD API Responses
//
//  Created by MAC_USER on 9/25/15.
//  Copyright (c) 2015 PhongVu. All rights reserved.
//

import Foundation

public struct HODErrorCode {
    static let IN_PROGRESS = 1610
    static let QUEUED = 1620
    static let NONSTANDARD_RESPONSE = 1630
    static let INVALID_PARAM = 1640
    static let INVALID_HOD_RESPONSE = 1650
    static let UNKNOWN_ERROR = 1660
}

class HODResponseParser
{
    var hodErrors : NSMutableArray = []
    
    func GetLastError() -> NSMutableArray
    {
        return hodErrors
    }
    fileprivate func resetErrors()
    {
        hodErrors.removeAllObjects()
    }
    fileprivate func addError(_ error : HODErrorObject)
    {
        hodErrors.add(error)
    }
    
    func ParseJobID(_ jsonStr:String) -> String?
    {
        var jobID : String?
        
        if (jsonStr.characters.count != 0) {
            let resStr = jsonStr.trimmingCharacters(in: CharacterSet.whitespaces)
            let data = (resStr as NSString).data(using: String.Encoding.utf8.rawValue)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                guard let _ :NSDictionary = json as? NSDictionary else {
                    return jobID
                }
                jobID = (json as AnyObject).value(forKey: "jobID") as? String
            }
            catch {
                return jobID
            }
        }
        return jobID
    }

    fileprivate func getResult(_ jsonStr:inout String) -> String?
    {
        resetErrors()
        var result = jsonStr
        if (jsonStr.characters.count == 0) {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Empty response.\"}"])
            let errData = (err as NSString).data(using: String.Encoding.utf8.rawValue)
            let jsonObj = (try! JSONSerialization.jsonObject(with: errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: jsonObj)
            addError(hodError)
            return nil
        }
        let resStr = jsonStr.trimmingCharacters(in: CharacterSet.whitespaces)
        let data = (resStr as NSString).data(using: String.Encoding.utf8.rawValue)
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary

            if let actions = jsonObj["actions"] as? NSArray {
                let status = (actions[0] as AnyObject).value(forKey: "status") as? String
                if status == "finished" || status == "FINISHED" {
                    let jsonData: Data?
                    do {
                        jsonData = try JSONSerialization.data(withJSONObject: ((actions[0] as AnyObject).value(forKey: "result") as? NSDictionary)!, options: [])
                        result = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
                        
                    } catch let error as NSError {
                        
                        let err = String(format: "%@%d%@%@%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"", error.localizedDescription, "\"}"])
                        let errData = (err as NSString).data(using: String.Encoding.utf8.rawValue)
                        let errorObj = (try! JSONSerialization.jsonObject(with: errData!, options: [])) as! NSDictionary
                        let hodError = HODErrorObject(json: errorObj)
                        addError(hodError)
                        return nil
                    }
                } else if status == "failed" {
                    let errors = (actions[0] as AnyObject).value(forKey: "errors") as! NSArray
                    for item in errors {
                        let hodError = HODErrorObject(json: item as! NSDictionary)
                        addError(hodError)
                    }
                    return nil
                } else if status == "queued" {
                    var jobID = (jsonObj as AnyObject).value(forKey: "jobID") as? String
                    jobID = jobID!.trimmingCharacters(in: CharacterSet.whitespaces)
                    let err = String(format: "%@%d%@%@%@", "{\"error\":", HODErrorCode.QUEUED,",\"reason\":\"Task is in queue\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).data(using: String.Encoding.utf8.rawValue)
                    let errorObj = (try! JSONSerialization.jsonObject(with: errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else if status == "in progress" {
                    var jobID = (jsonObj as AnyObject).value(forKey: "jobID") as? String
                    jobID = jobID!.trimmingCharacters(in: CharacterSet.whitespaces)
                    let err = String(format: "%@%d%@%@%@", "{\"error\":",HODErrorCode.IN_PROGRESS,",\"reason\":\"Task is in progress\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).data(using: String.Encoding.utf8.rawValue)
                    let errorObj = (try! JSONSerialization.jsonObject(with: errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else {
                    let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.UNKNOWN_ERROR,",\"reason\":\"", status!, "\"}")
                    let errData = (err as NSString).data(using: String.Encoding.utf8.rawValue)
                    let errorObj = (try! JSONSerialization.jsonObject(with: errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                }
            } else {
                // handle error for sync mode
                var isError = false
                for (key, _) in jsonObj as NSDictionary {
                    if key as! String == "error" {
                        let hodError = HODErrorObject(json: jsonObj as NSDictionary)
                        addError(hodError)
                        isError = true
                    }
                }
                if isError == true {
                    return nil
                }
            }
        }
        catch {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response\"}"])
            let errData = (err as NSString).data(using: String.Encoding.utf8.rawValue)
            let errorObj = (try! JSONSerialization.jsonObject(with: errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: errorObj)
            addError(hodError)
            return nil
        }
        return result
    }
    fileprivate func logParserError(_ error:NSError) {
        let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.INVALID_HOD_RESPONSE,",\"reason\":\"", error.localizedDescription, "\"}")
        let errData = (err as NSString).data(using: String.Encoding.utf8.rawValue)
        let errorObj = (try! JSONSerialization.jsonObject(with: errData!, options: [])) as! NSDictionary
        let hodError = HODErrorObject(json: errorObj)
        addError(hodError)
    }
    func ParseSpeechRecognitionResponse(_ jsonStr:inout String) -> SpeechRecognitionResponse?
    {
        var obj : SpeechRecognitionResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = SpeechRecognitionResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseDetectSceneChangesResponse(_ jsonStr:inout String) -> DetectSceneChangesResponse?
    {
        var obj : DetectSceneChangesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = DetectSceneChangesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseLicensePlateRecognitionResponse(_ jsonStr:inout String) -> LicensePlateRecognitionResponse?
    {
        var obj : LicensePlateRecognitionResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = LicensePlateRecognitionResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseCancelConnectorScheduleResponse(_ jsonStr:inout String) -> CancelConnectorScheduleResponse?
    {
        var obj : CancelConnectorScheduleResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = CancelConnectorScheduleResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseConnectorHistoryResponse(_ jsonStr:inout String) -> ConnectorHistoryResponse?
    {
        var obj : ConnectorHistoryResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = ConnectorHistoryResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseConnectorStatusResponse(_ jsonStr:inout String) -> ConnectorStatusResponse?
    {
        var obj : ConnectorStatusResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = ConnectorStatusResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseCreateConnectorResponse(_ jsonStr:inout String) -> CreateConnectorResponse?
    {
        var obj : CreateConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = CreateConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseDeleteConnectorResponse(_ jsonStr:inout String) -> DeleteConnectorResponse?
    {
        var obj : DeleteConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = DeleteConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRetrieveConnectorConfigurationAttrResponse(_ jsonStr:inout String) -> RetrieveConnectorConfigurationAttrResponse?
    {
        var obj : RetrieveConnectorConfigurationAttrResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RetrieveConnectorConfigurationAttrResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRetrieveConnectorConfigurationFileResponse(_ jsonStr:inout String) -> RetrieveConnectorConfigurationFileResponse?
    {
        var obj : RetrieveConnectorConfigurationFileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RetrieveConnectorConfigurationFileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseStartConnectorResponse(_ jsonStr:inout String) -> StartConnectorResponse?
    {
        var obj : StartConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = StartConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseStopConnectorResponse(_ jsonStr:inout String) -> StopConnectorResponse?
    {
        var obj : StopConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = StopConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseUpdateConnectorResponse(_ jsonStr:inout String) -> UpdateConnectorResponse?
    {
        var obj : UpdateConnectorResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = UpdateConnectorResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseExpandContainerResponse(_ jsonStr:inout String) -> ExpandContainerResponse?
    {
        var obj : ExpandContainerResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = ExpandContainerResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseStoreObjectResponse(_ jsonStr:inout String) -> StoreObjectResponse?
    {
        var obj : StoreObjectResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = StoreObjectResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseViewDocumentResponse(_ jsonStr:inout String) -> ViewDocumentResponse?
    {
        var obj : ViewDocumentResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = ViewDocumentResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseGetCommonNeighborsResponse(_ jsonStr:inout String) -> GetCommonNeighborsResponse?
    {
        var obj : GetCommonNeighborsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = GetCommonNeighborsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseGetNeighborsResponse(_ jsonStr:inout String) -> GetNeighborsResponse?
    {
        var obj : GetNeighborsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = GetNeighborsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseGetNodesResponse(_ jsonStr:inout String) -> GetNodesResponse?
    {
        var obj : GetNodesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = GetNodesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseGetShortestPathResponse(_ jsonStr:inout String) -> GetShortestPathResponse?
    {
        var obj : GetShortestPathResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = GetShortestPathResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseGetSubgraphResponse(_ jsonStr:inout String) -> GetSubgraphResponse?
    {
        var obj : GetSubgraphResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = GetSubgraphResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseSuggestLinksResponse(_ jsonStr:inout String) -> SuggestLinksResponse?
    {
        var obj : SuggestLinksResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = SuggestLinksResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseSummarizeGraphResponse(_ jsonStr:inout String) -> SummarizeGraphResponse?
    {
        var obj : SummarizeGraphResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = SummarizeGraphResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseOCRDocumentResponse(_ jsonStr:inout String) -> OCRDocumentResponse?
    {
        var obj : OCRDocumentResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = OCRDocumentResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRecognizeBarcodesResponse(_ jsonStr:inout String) -> RecognizeBarcodesResponse?
    {
        var obj : RecognizeBarcodesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RecognizeBarcodesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseDetectFacesResponse(_ jsonStr:inout String) -> DetectFacesResponse?
    {
        var obj : DetectFacesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = DetectFacesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRecognizeImagesResponse(_ jsonStr:inout String) -> RecognizeImagesResponse?
    {
        var obj : RecognizeImagesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RecognizeImagesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParsePredictResponse(_ jsonStr:inout String) -> PredictResponse?
    {
        var obj : PredictResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = PredictResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParsePredictV2Response(_ jsonStr:inout String) -> PredictV2Response?
    {
        var obj : PredictV2Response!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = PredictV2Response(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRecommendResponse(_ jsonStr:inout String) -> RecommendResponse?
    {
        var obj : RecommendResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RecommendResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRecommendV2Response(_ jsonStr:inout String) -> RecommendV2Response?
    {
        var obj : RecommendV2Response!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RecommendV2Response(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseTrainPredictionResponse(_ jsonStr:inout String) -> TrainPredictionResponse?
    {
        var obj : TrainPredictionResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = TrainPredictionResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseTrainPredictionV2Response(_ jsonStr:inout String) -> TrainPredictionV2Response?
    {
        var obj : TrainPredictionV2Response!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = TrainPredictionV2Response(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseGetPredictionModelDetailsResponse(_ jsonStr:inout String) -> GetPredictionModelDetailsResponse?
    {
        var obj : GetPredictionModelDetailsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = GetPredictionModelDetailsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseDeletePredictionModelResponse(_ jsonStr:inout String) -> DeletePredictionModelResponse?
    {
        var obj : DeletePredictionModelResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = DeletePredictionModelResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseCreateQueryProfileResponse(_ jsonStr:inout String) -> CreateQueryProfileResponse?
    {
        var obj : CreateQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = CreateQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseDeleteQueryProfileResponse(_ jsonStr:inout String) -> DeleteQueryProfileResponse?
    {
        var obj : DeleteQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = DeleteQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRetrieveQueryProfileResponse(_ jsonStr:inout String) -> RetrieveQueryProfileResponse?
    {
        var obj : RetrieveQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RetrieveQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseUpdateQueryProfileResponse(_ jsonStr:inout String) -> UpdateQueryProfileResponse?
    {
        var obj : UpdateQueryProfileResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = UpdateQueryProfileResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseFindRelatedConceptsResponse(_ jsonStr:inout String) -> FindRelatedConceptsResponse?
    {
        var obj : FindRelatedConceptsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = FindRelatedConceptsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseAutoCompleteResponse(_ jsonStr:inout String) -> AutoCompleteResponse?
    {
        var obj : AutoCompleteResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = AutoCompleteResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseExtractConceptsResponse(_ jsonStr:inout String) -> ExtractConceptsResponse?
    {
        var obj : ExtractConceptsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = ExtractConceptsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseEntityExtractionResponse(_ jsonStr:inout String) -> EntityExtractionResponse?
    {
        var obj : EntityExtractionResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = EntityExtractionResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseEntityExtractionV2Response(_ jsonStr:inout String) -> EntityExtractionV2Response?
    {
        var obj : EntityExtractionV2Response!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = EntityExtractionV2Response(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseExpandTermsResponse(_ jsonStr:inout String) -> ExpandTermsResponse?
    {
        var obj : ExpandTermsResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = ExpandTermsResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseHighlightTextResponse(_ jsonStr:inout String) -> HighlightTextResponse?
    {
        var obj : HighlightTextResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = HighlightTextResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseIdentifyLanguageResponse(_ jsonStr:inout String) -> IdentifyLanguageResponse?
    {
        var obj : IdentifyLanguageResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = IdentifyLanguageResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseSentimentAnalysisResponse(_ jsonStr:inout String) -> SentimentAnalysisResponse?
    {
        var obj : SentimentAnalysisResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = SentimentAnalysisResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseSentimentAnalysisV2Response(_ jsonStr:inout String) -> SentimentAnalysisV2Response?
    {
        var obj : SentimentAnalysisV2Response!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = SentimentAnalysisV2Response(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseTokenizeTextResponse(_ jsonStr:inout String) -> TokenizeTextResponse?
    {
        var obj : TokenizeTextResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = TokenizeTextResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseAddToTextIndexResponse(_ jsonStr:inout String) -> AddToTextIndexResponse?
    {
        var obj : AddToTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = AddToTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseCreateTextIndexResponse(_ jsonStr:inout String) -> CreateTextIndexResponse?
    {
        var obj : CreateTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = CreateTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseDeleteTextIndexResponse(_ jsonStr:inout String) -> DeleteTextIndexResponse?
    {
        var obj : DeleteTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = DeleteTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseDeleteFromTextIndexResponse(_ jsonStr:inout String) -> DeleteFromTextIndexResponse?
    {
        var obj : DeleteFromTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = DeleteFromTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseIndexStatusResponse(_ jsonStr:inout String) -> IndexStatusResponse?
    {
        var obj : IndexStatusResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = IndexStatusResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseListResourcesResponse(_ jsonStr:inout String) -> ListResourcesResponse?
    {
        var obj : ListResourcesResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = ListResourcesResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseRestoreTextIndexResponse(_ jsonStr:inout String) -> RestoreTextIndexResponse?
    {
        var obj : RestoreTextIndexResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = RestoreTextIndexResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseAnomalyDetectionResponse(_ jsonStr:inout String) -> AnomalyDetectionResponse?
    {
        var obj : AnomalyDetectionResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = AnomalyDetectionResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    func ParseTrendAnalysisResponse(_ jsonStr:inout String) -> TrendAnalysisResponse?
    {
        var obj : TrendAnalysisResponse!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                let dic = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary
                obj = TrendAnalysisResponse(json:dic)
            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
    
    func ParseCustomResponse(_ jsonStr:inout String) -> NSDictionary?
    {
        resetErrors()
        var obj : NSDictionary!
        if let result = getResult(&jsonStr) {
            do {
                let data1 = (result as NSString).data(using: String.Encoding.utf8.rawValue)
                obj = try JSONSerialization.jsonObject(with: data1!, options: []) as! NSDictionary

            } catch let error as NSError {
                logParserError(error)
            }
        }
        return obj
    }
}
