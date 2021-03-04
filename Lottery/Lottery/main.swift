//
//  main.swift
//  Lottery
//
//  Created by 郭超 on 2021/3/3.
// 研究原理  详情 support

import Foundation



/// 从 数组里随机取出数据
/// - Parameters:
///   - size: 要取出的长度
///   - dataSoure: 数据源  ， 数组
/// - Returns: 返回 取出的数据
/// - Note: 由于是自用的有所以 不会判断其他非法的情况
///         包括但不限于 数组是否为空、 元素是否重复
public func sample(size: Int, dataSoure: [Int]) -> [Int] {
        
        var sampleElements: [Int] = []
        //先复制一个新数组
        var copy = dataSoure.map { $0 }
        for _ in 0..<size {
            //当元素不能重复时，最多只能返回原数组个数的元素
            if copy.isEmpty { break }
            let randomIndex = Int(arc4random_uniform(UInt32(copy.count)))
            let element = copy[randomIndex]
            sampleElements.append(element)
            //每取出一个元素则将其从复制出来的新数组中移除
            copy.remove(at: randomIndex)
        }
    
        
        return sampleElements
}


/// 统计 1 到 33 出现的次数
/// - Parameters:
///   - key: 数组里数据 1，2，3，......
///   - dictionary: 存放 统计结果的字典
func cumulative(_ key: Int, dictionary: inout [Int : Int]) {
    let value = dictionary[key]
    if var number = value {
        number += 1
        dictionary.updateValue(number, forKey: key)
    }else{
        dictionary.updateValue(1, forKey: key)
    }
}


/// 创建数组
/// - Parameters:
///   - start: 起始值
///   - end: 结束值
/// - Returns: 返回一个包含起始值 和 结束值 的闭区间 int 数组
func generateArray(start: Int, end: Int) -> [Int] {
    var tempArray: [Int] = []
    
    for i in start ... end {
        tempArray.append(i)
    }
    
    return tempArray
}

/// 循环增加样本数量
/// - Parameters:
///   - frequency: 样本量
///   - dataSoureArray: 数据源
/// - Returns: 数组
func sampleRandomArray(frequency: Int, dataSoureArray: [Int]) -> [[Int]] {
   
    var array: [[Int]] = []
    
    var num: Int = 0
    
    repeat{
        num += 1
        array.append(sample(size: 6, dataSoure: dataSoureArray))
    }while (num < frequency)
    
    return array
}

/// 获取 统计的前部数据
/// - Parameter dictionary: 统计数据
/// - Returns:前部数据
func topData(dictionary:[Int: Int], topNumber: Int = 6) -> [Int] {
    var i: Int = 0
    var intArray = [Int]()
    
    /// value 排序
    for (key, _) in dictionary.sorted(by: {$0.1 > $1.1}){
        i += 1
        if i <= topNumber {
            intArray.append(key)
        }
    }
    
    return intArray
}

/// 统计
/// - Parameters:
///   - dictionary: 存放 统计的数组
///   - dataSoure: 随机出的数组
func statistical(dictionary: inout [Int : Int], dataSoure: [[Int]]) {
    for i in 0 ..< dataSoure.count {
        let intArray = dataSoure[i]

        for j in 0 ..< intArray.count {
            let value = intArray[j]
            // 统计 所有数字出现的次数
            cumulative(value, dictionary: &dictionary)
        }
    }
}

///存放 1 到 33
let array: [Int] = generateArray(start: 1, end: 33)
///存放 统计结果的字典
var dictionary: [Int : Int] = [:]
/// 存储 从数组里随机出的六个数
let totalResultsArray = sampleRandomArray(frequency: 7695, dataSoureArray: array)
/// 统计
statistical(dictionary: &dictionary, dataSoure: totalResultsArray)


//穷举
var tempIntArray :[[Int]] = []
var tempIntArray1 :[[Int]] = []
// 10， 50 数量越大 穷举的数越多，出来的结果越准
for i in 0 ..< 10 {
    for j in 0 ..< 50{
        
        /// 存储 从数组里随机出的六个数
        let totalResultsArray = sampleRandomArray(frequency: 7695, dataSoureArray: array)
        statistical(dictionary: &dictionary, dataSoure: totalResultsArray)
        let d = topData(dictionary: dictionary)
        tempIntArray.append(d)
        print(j)
        
    }

    statistical(dictionary: &dictionary, dataSoure: tempIntArray)
    print("----------------------------------")
    let d = topData(dictionary: dictionary)
//    print(d)
    tempIntArray1.append(d)
    print(i)
}




statistical(dictionary: &dictionary, dataSoure: tempIntArray1)
let d = topData(dictionary: dictionary)
print("+++++++++++++++++++++++++++")
print(d)


//[10, 04, 15, 12, 19, 30]
//[28, 24, 22, 27, 15, 12]
//[06, 17, 21, 02, 19, 07]
//[07, 16, 05, 04, 30, 21]
//[22, 24, 12, 16, 19, 05]
