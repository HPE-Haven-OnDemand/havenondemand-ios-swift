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

open class HODResponseParser
{
    var hodErrors : NSMutableArray = []
 
    public init () {
    
    }
    
    public func GetLastError() -> NSMutableArray
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
    
    public func ParseJobID(_ jsonStr:String) -> String?
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

    fileprivate func getResult(_ jsonStr: String) -> String?
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
    public func ParseSpeechRecognitionResponse(_ jsonStr: String) -> SpeechRecognitionResponse?
    {
        var obj : SpeechRecognitionResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseDetectSceneChangesResponse(_ jsonStr: String) -> DetectSceneChangesResponse?
    {
        var obj : DetectSceneChangesResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseLicensePlateRecognitionResponse(_ jsonStr: String) -> LicensePlateRecognitionResponse?
    {
        var obj : LicensePlateRecognitionResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseCancelConnectorScheduleResponse(_ jsonStr: String) -> CancelConnectorScheduleResponse?
    {
        var obj : CancelConnectorScheduleResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseConnectorHistoryResponse(_ jsonStr: String) -> ConnectorHistoryResponse?
    {
        var obj : ConnectorHistoryResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseConnectorStatusResponse(_ jsonStr: String) -> ConnectorStatusResponse?
    {
        var obj : ConnectorStatusResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseCreateConnectorResponse(_ jsonStr: String) -> CreateConnectorResponse?
    {
        var obj : CreateConnectorResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseDeleteConnectorResponse(_ jsonStr: String) -> DeleteConnectorResponse?
    {
        var obj : DeleteConnectorResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseRetrieveConnectorConfigurationAttrResponse(_ jsonStr: String) -> RetrieveConnectorConfigurationAttrResponse?
    {
        var obj : RetrieveConnectorConfigurationAttrResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseRetrieveConnectorConfigurationFileResponse(_ jsonStr: String) -> RetrieveConnectorConfigurationFileResponse?
    {
        var obj : RetrieveConnectorConfigurationFileResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseStartConnectorResponse(_ jsonStr: String) -> StartConnectorResponse?
    {
        var obj : StartConnectorResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseStopConnectorResponse(_ jsonStr: String) -> StopConnectorResponse?
    {
        var obj : StopConnectorResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseUpdateConnectorResponse(_ jsonStr: String) -> UpdateConnectorResponse?
    {
        var obj : UpdateConnectorResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseExpandContainerResponse(_ jsonStr: String) -> ExpandContainerResponse?
    {
        var obj : ExpandContainerResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseStoreObjectResponse(_ jsonStr: String) -> StoreObjectResponse?
    {
        var obj : StoreObjectResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseViewDocumentResponse(_ jsonStr: String) -> ViewDocumentResponse?
    {
        var obj : ViewDocumentResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseGetCommonNeighborsResponse(_ jsonStr: String) -> GetCommonNeighborsResponse?
    {
        var obj : GetCommonNeighborsResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseGetNeighborsResponse(_ jsonStr: String) -> GetNeighborsResponse?
    {
        var obj : GetNeighborsResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseGetNodesResponse(_ jsonStr: String) -> GetNodesResponse?
    {
        var obj : GetNodesResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseGetShortestPathResponse(_ jsonStr: String) -> GetShortestPathResponse?
    {
        var obj : GetShortestPathResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseGetSubgraphResponse(_ jsonStr: String) -> GetSubgraphResponse?
    {
        var obj : GetSubgraphResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseSuggestLinksResponse(_ jsonStr: String) -> SuggestLinksResponse?
    {
        var obj : SuggestLinksResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseSummarizeGraphResponse(_ jsonStr: String) -> SummarizeGraphResponse?
    {
        var obj : SummarizeGraphResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseOCRDocumentResponse(_ jsonStr: String) -> OCRDocumentResponse?
    {
        var obj : OCRDocumentResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseRecognizeBarcodesResponse(_ jsonStr: String) -> RecognizeBarcodesResponse?
    {
        var obj : RecognizeBarcodesResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseDetectFacesResponse(_ jsonStr: String) -> DetectFacesResponse?
    {
        var obj : DetectFacesResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseRecognizeImagesResponse(_ jsonStr: String) -> RecognizeImagesResponse?
    {
        var obj : RecognizeImagesResponse!
        if let result = getResult(jsonStr) {
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
    public func ParsePredictResponse(_ jsonStr: String) -> PredictResponse?
    {
        var obj : PredictResponse!
        if let result = getResult(jsonStr) {
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
    public func ParsePredictV2Response(_ jsonStr: String) -> PredictV2Response?
    {
        var obj : PredictV2Response!
        if let result = getResult(jsonStr) {
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
    public func ParseRecommendResponse(_ jsonStr: String) -> RecommendResponse?
    {
        var obj : RecommendResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseRecommendV2Response(_ jsonStr: String) -> RecommendV2Response?
    {
        var obj : RecommendV2Response!
        if let result = getResult(jsonStr) {
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
    public func ParseTrainPredictionResponse(_ jsonStr: String) -> TrainPredictionResponse?
    {
        var obj : TrainPredictionResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseTrainPredictionV2Response(_ jsonStr: String) -> TrainPredictionV2Response?
    {
        var obj : TrainPredictionV2Response!
        if let result = getResult(jsonStr) {
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
    public func ParseGetPredictionModelDetailsResponse(_ jsonStr: String) -> GetPredictionModelDetailsResponse?
    {
        var obj : GetPredictionModelDetailsResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseDeletePredictionModelResponse(_ jsonStr: String) -> DeletePredictionModelResponse?
    {
        var obj : DeletePredictionModelResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseCreateQueryProfileResponse(_ jsonStr: String) -> CreateQueryProfileResponse?
    {
        var obj : CreateQueryProfileResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseDeleteQueryProfileResponse(_ jsonStr: String) -> DeleteQueryProfileResponse?
    {
        var obj : DeleteQueryProfileResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseRetrieveQueryProfileResponse(_ jsonStr: String) -> RetrieveQueryProfileResponse?
    {
        var obj : RetrieveQueryProfileResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseUpdateQueryProfileResponse(_ jsonStr: String) -> UpdateQueryProfileResponse?
    {
        var obj : UpdateQueryProfileResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseFindRelatedConceptsResponse(_ jsonStr: String) -> FindRelatedConceptsResponse?
    {
        var obj : FindRelatedConceptsResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseAutoCompleteResponse(_ jsonStr: String) -> AutoCompleteResponse?
    {
        var obj : AutoCompleteResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseExtractConceptsResponse(_ jsonStr: String) -> ExtractConceptsResponse?
    {
        var obj : ExtractConceptsResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseEntityExtractionResponse(_ jsonStr: String) -> EntityExtractionResponse?
    {
        var obj : EntityExtractionResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseEntityExtractionV2Response(_ jsonStr: String) -> EntityExtractionV2Response?
    {
        var obj : EntityExtractionV2Response!
        if let result = getResult(jsonStr) {
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
    public func ParseExpandTermsResponse(_ jsonStr: String) -> ExpandTermsResponse?
    {
        var obj : ExpandTermsResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseHighlightTextResponse(_ jsonStr: String) -> HighlightTextResponse?
    {
        var obj : HighlightTextResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseIdentifyLanguageResponse(_ jsonStr: String) -> IdentifyLanguageResponse?
    {
        var obj : IdentifyLanguageResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseSentimentAnalysisResponse(_ jsonStr: String) -> SentimentAnalysisResponse?
    {
        var obj : SentimentAnalysisResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseSentimentAnalysisV2Response(_ jsonStr: String) -> SentimentAnalysisV2Response?
    {
        var obj : SentimentAnalysisV2Response!
        if let result = getResult(jsonStr) {
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
    public func ParseTokenizeTextResponse(_ jsonStr: String) -> TokenizeTextResponse?
    {
        var obj : TokenizeTextResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseAddToTextIndexResponse(_ jsonStr: String) -> AddToTextIndexResponse?
    {
        var obj : AddToTextIndexResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseCreateTextIndexResponse(_ jsonStr: String) -> CreateTextIndexResponse?
    {
        var obj : CreateTextIndexResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseDeleteTextIndexResponse(_ jsonStr: String) -> DeleteTextIndexResponse?
    {
        var obj : DeleteTextIndexResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseDeleteFromTextIndexResponse(_ jsonStr: String) -> DeleteFromTextIndexResponse?
    {
        var obj : DeleteFromTextIndexResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseIndexStatusResponse(_ jsonStr: String) -> IndexStatusResponse?
    {
        var obj : IndexStatusResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseListResourcesResponse(_ jsonStr: String) -> ListResourcesResponse?
    {
        var obj : ListResourcesResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseRestoreTextIndexResponse(_ jsonStr: String) -> RestoreTextIndexResponse?
    {
        var obj : RestoreTextIndexResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseAnomalyDetectionResponse(_ jsonStr: String) -> AnomalyDetectionResponse?
    {
        var obj : AnomalyDetectionResponse!
        if let result = getResult(jsonStr) {
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
    public func ParseTrendAnalysisResponse(_ jsonStr: String) -> TrendAnalysisResponse?
    {
        var obj : TrendAnalysisResponse!
        if let result = getResult(jsonStr) {
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
    
    public func ParseCustomResponse(_ jsonStr: String) -> NSDictionary?
    {
        resetErrors()
        var obj : NSDictionary!
        if let result = getResult(jsonStr) {
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
