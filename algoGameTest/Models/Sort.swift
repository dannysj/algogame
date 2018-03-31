//
//  Sort.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/27/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
// insertion sort
func insertionSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else {
        return array
    }
    
    var sorted = array
    for i in 1 ..< sorted.count {
        var y = i
        let temp = sorted[y]
        // increasing order sort
        while y > 0 && temp < sorted[y-1]{
            sorted[y] = sorted[y - 1]
            y -= 1
        }
        sorted[y] = temp
    }
    return sorted
}

// random quick sort
/* Reference: Intro to Algorithms (cormen)
 algorithm quicksort(A, lo, hi) is
    if lo < hi then
        p := partition(A, lo, hi)
        quicksort(A, lo, p - 1 )
        quicksort(A, p + 1, hi)
 
 algorithm partition(A, lo, hi) is
    pivot := A[hi]
    i := lo - 1
    for j := lo to hi - 1 do
        if A[j] < pivot then
            i := i + 1
            swap A[i] with A[j]
    swap A[i + 1] with A[hi]
    return i + 1
 */
func quickSort<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = random(min: low, max: high)
        
        // swap pivotIndex to high , to put pivot at the end
        (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])
        
        let p = partition(&a, low: low, high: high)
        quickSort(&a, low: low, high: p-1)
        quickSort(&a, low: p+1, high: high)
    }
    
}

// partition
func partition<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
    let pivot = a[high]
    
    var i = low
    for j in low ..< high {
        if a[j] <= pivot {
            (a[i], a[j]) = (a[j], a[i])
            i += 1
        }
    }
    
    // swap the pivot keke
    (a[i], a[high]) = (a[high] , a[i])
    
    // pivot!
    return i
}
